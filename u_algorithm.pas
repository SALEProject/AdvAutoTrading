unit u_algorithm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, u_dm_main, u_finance_request, DateUtils, ExtCtrls, Graphics;

const _LONG_ONLY = false;


type

{ TAlgorithm }

 TAlgorithm = class (TThread)
                       private
                         LastAlg,LastCom:double;
                         action: string;
                         indicator: string;
                         state: string;
                         force_sell: Boolean;
                         isProtectionZone: Boolean;
                         PrevPosition: TMarketPosition;
                         historyPrice, profitloss : double;

                         InTradingHours : boolean;

                         {START sync procedures}
                         str_HistoryAction:string;
                         str_HistoryState:string;
                         HistoryCPos:TMarketPosition;

                         //  added Dan 20141015
                         Connector: TExchangeConnector;

                         procedure _UpdateHistory;
                         procedure _UpdateTaskInfo_Start;
                         procedure _UpdateTaskInfo_Idle;
                         procedure _UpdateTaskInfo_NotActive;
                         procedure _UpdateTaskInfo_NoTrading;
                         {END sync procedures}

                         //-----------------------------------------------------
                         //  added Dan 20141015
                         //  replacement for sync routines
                         function ThrGetRealTime(var CPos: TMarketPosition):boolean;
                         function ThrMarketBuy(var CPos: TMarketPosition): TMarketMessage;
                         function ThrMarketSell(var CPos: TMarketPosition): TMarketMessage;
                         //-----------------------------------------------------

                         {START sync wrappers}
                         procedure UpdateHistory(str_Action, str_State:string; CPos:TMarketPosition);
                         procedure MarketUpdateCurrentPosition;
                         function  BuyAtMarket(var CPos:TMarketPosition): TMarketMessage;
                         function  SellAtMarket(var CPos:TMarketPosition): TMarketMessage;
                         procedure UpdateTaskInfo_Start;
                         procedure UpdateTaskInfo_Idle;
                         procedure UpdateTaskInfo_NotActive;
                         procedure UpdateTaskInfo_NoTrading;
                         {END sync procedures wrappers}

                         procedure UpdatePosition;
                         procedure RunAlgorithm;

                         procedure Calc_LONG_STOP_LOSS;
                         procedure Calc_SHRT_STOP_LOSS;

                       protected
                         BuyCPos, SellCPos :TMarketPosition;
                         BuyResult,SellResult:TMarketMessage;

                         NewPriceCPos: TMarketPosition;
                         NewPriceMRes: TMarketMessage;
                         NewPriceAction : string;

                         procedure Execute; override;

                       public
                         CurrentPosition, InputPositionData, OutputPositionData : TMarketPosition;

                         pnl_TaskInfo: TPanel;

                         DONE : Boolean;

                         T1_Start, T1_Stop, T2_Start,T2_Stop : TDateTime;
                         LONG_ONLY, PAUSED : boolean;
                         constructor Create(CPos: TMarketPosition);
                         destructor Destroy;
                         procedure _LONG_Run;
                         procedure _SHORT_Run;

                         procedure LONG_ForceBuy;
                         function LONG_PosOpen:boolean;
                         function LONG_PosTake:boolean;
                         function LONG_PosProtection:boolean;
                         function LONG_PosStopLoss:boolean;
                         procedure LONG_Recalc;
                         function LONG_ForceClose:boolean;

                         procedure SHORT_ForceSell;
                         function SHORT_PosOpen:boolean;
                         function SHORT_PosTake:boolean;
                         function SHORT_PosProtection:boolean;
                         function SHORT_PosStopLoss:boolean;
                         procedure SHORT_Recalc;
                         function SHORT_ForceClose:boolean;

                         function CHECK_BOUNCE : boolean;

                         procedure SetNewPrice(var CPos: TMarketPosition; mres: TMarketMessage; str_action:string='');
                         procedure _SetNewPrice;

                  end;

 type TPAlgorithm = ^TAlgorithm;

implementation

constructor TAlgorithm.Create(CPos: TMarketPosition);
begin
  //  added Dan 20141015
  Connector:= dm_Main.CreateExchangeConnector;
  DONE := False;

  CurrentPosition  := CPos;

  CurrentPosition.PosData.b_Stop_Real := False;

  CurrentPosition.PosData.b_Wait_For_Market_Close := False;


  InputPositionData.PosData.NRPOS := -1000;
  PAUSED := False;

  LONG_ONLY := _LONG_ONLY;

  action:= '';
  historyPrice:= 0;
  indicator:= '';
  state:= '';
  profitLoss:= 0;
  Inherited Create(TRUE);

  Connector.OwnerThreadID := Handle;    // Set Handle after we have a value
end;

procedure TAlgorithm._LONG_Run;
var
  i: integer;

begin

   if not CurrentPosition.PosParams.POS_ACTIVE then Exit; { exit if not active }

   { get data and update cals}
   PrevPosition := CurrentPosition;         { save previous position }

   T1_Start := Now;
   MarketUpdateCurrentPosition;   { get new position quote }
   T1_Stop := Now;

   T2_Start := Now;
   LONG_Recalc;                             { recalc indicators }
   T2_Stop := Now;
   { done get data and update cals}

      if not CurrentPosition.PosData.OPENED then
      begin
         if CurrentPosition.PosParams.FORCE_BUY then
         begin
           LONG_ForceBuy;
         end
         else
         begin
            if not LONG_PosOpen then
              UpdatePosition;
         end;
      end
      else { if opened...}
      begin
          if CHECK_BOUNCE then // bounce algorithm first
             exit;

          if CurrentPosition.PosParams.CLOSE_NOW_AT_MARKET then
          begin
            LONG_ForceClose;
            // do some post-FORCE-close action...
          end
          else
          if LONG_PosTake then { Check Take Profit and commit }
          begin
             // dome some POST take profit action
            if CurrentPosition.PosParams.RE_TAKE then
            begin
              CurrentPosition.PosParams.FORCE_BUY:=True;
              LONG_ForceBuy;
            end;
          end
          else
          if LONG_PosProtection then {Check "Protection" and commit }
          begin
             // do some POST protection close action (stock going down !)
            if not CurrentPosition.PosParams.STAND_BY_AFTER_PROT then
            begin
             if CurrentPosition.PosParams.RE_OPEN then
             begin
                force_sell := True;
                SHORT_ForceSell; // REOPEN IN REVERSE !
             end;
            end;
          end
          else
          if LONG_PosStopLoss then  {check stop loss and commit}
          begin
             // do some POST STOP LOSS close action (stock going down !)

             if NOT CurrentPosition.PosParams.STANDBY_AFTER_STOP then
             begin
               if CurrentPosition.PosParams.RE_OPEN then
               begin
                   force_sell := True;
                   SHORT_ForceSell; // REOPEN IN REVERSE !
               end;
             end;

          end
          else
           UpdatePosition ;             { ... just update position}
      end;

end;

procedure TAlgorithm._SHORT_Run;
var
  i: integer;

begin

   if not CurrentPosition.PosParams.POS_ACTIVE then Exit; { exit if not active }

   { get data and update cals}
   PrevPosition := CurrentPosition;         { save previous position }

   T1_Start := Now;
   MarketUpdateCurrentPosition;   { get new position quote }
   T1_Stop := Now;

   T2_Start := Now;
   SHORT_Recalc;                             { recalc indicators }
   T2_Stop := Now;
   { done get data and update cals}

   if not CurrentPosition.PosData.OPENED then
      begin
        if not SHORT_PosOpen then
              UpdatePosition;
      end
      else { if opened...}
      begin
         if CHECK_BOUNCE then // bounce algorithm first
             exit;

         if CurrentPosition.PosParams.CLOSE_NOW_AT_MARKET then
         begin
           SHORT_ForceClose;
           // do some post-FORCE-close action...
         end
         else
         if SHORT_PosTake then { Check Take Profit and commit }
         begin
            // dome some POST take profit action
           if CurrentPosition.PosParams.RE_TAKE then
           begin
             // if RE_TAKE then re-SHORT
             force_sell := True;
             SHORT_ForceSell;
           end;
         end
         else
         if SHORT_PosProtection then {Check "Protection" and commit }
         begin
            // do some POST protection close action (stock going UP !)
           if not CurrentPosition.PosParams.STAND_BY_AFTER_PROT then
           begin
            if CurrentPosition.PosParams.RE_OPEN then
            begin
                CurrentPosition.PosParams.FORCE_BUY := True;
                LONG_ForceBuy; // REOPEN IN REVERSE !
            end;
           end;
         end
         else
         if SHORT_PosStopLoss then  {check stop loss and commit}
         begin
            // do some POST STOP LOSS close action (stock going down !)
            if NOT CurrentPosition.PosParams.STANDBY_AFTER_STOP then
            begin
              if CurrentPosition.PosParams.RE_OPEN then
              begin
                  CurrentPosition.PosParams.FORCE_BUY := True;
                  LONG_ForceBuy; // REOPEN IN REVERSE !
              end;
            end;
         end
         else
          UpdatePosition ;             { ... just update position}
    end;

end;

procedure TAlgorithm.LONG_ForceBuy;
var
   mres: TMarketMessage;
begin
   if(CurrentPosition.PosParams.FORCE_BUY) then
   begin
        //send buy command
        CurrentPosition.PosData.OrderDirection := TPositionDirection.LONG;
        mres:= BuyAtMarket(CurrentPosition);
        CurrentPosition.PosParams.FORCE_BUY := False;
        if mres.f_price > 0 then
        begin
           CurrentPosition.PosData.TEMP_ID := Int64(TimeStampToMSecs(DateTimeToTimeStamp(Now)));
           CurrentPosition.PosData.OPENED := true;
           CurrentPosition.PosData.isProtection := False;

           // update position status
           CurrentPosition.PosData.PREV_DIRECTION := CurrentPosition.PosData.DIRECTION;
           CurrentPosition.PosData.DIRECTION := TPositionDirection.LONG;

           // update position protection start and stop loss
           CurrentPosition.PosData.PROT_START_PRICE := CurrentPosition.PosData.Algorithm_Price *(1+(CurrentPosition.PosParams.PROT_MARGIN/100)) ;
           Calc_LONG_STOP_LOSS;

           //update record
           UpdatePosition;
           //update history
           UpdateHistory('LONG BUY '+'/P@'+FormatFloat('0.00',CurrentPosition.PosData.PROT_START_PRICE),'L_FORCE',CurrentPosition);
        end;

   end;
end;

function TAlgorithm.LONG_PosOpen:boolean;
var
   mres: TMarketMessage;
   bRes:boolean;
begin
  bRes := False;
  if (CurrentPosition.PosData.OPENED) or (CurrentPosition.PosData.Algorithm_Price <=0) then
  begin
    Result := bRes;
    Exit;
  end;

  if CurrentPosition.PosData.PREV_DIRECTION <> TPositionDirection.STANDBY then
    CurrentPosition.PosData.Open_Price := CurrentPosition.PosData.START_PRICE_MIN * (1 + (CurrentPosition.PosParams.RE_OPEN_PERCENT / 100 ))
  else
    CurrentPosition.PosData.Open_Price := CurrentPosition.PosData.START_PRICE_MIN * (1 + (CurrentPosition.PosParams.OPEN_PERCENT / 100 ));

  if (CurrentPosition.PosParams.OPEN_PERCENT  > 0) then
  begin
       if(CurrentPosition.PosData.Open_Price <= CurrentPosition.PosData.Algorithm_Price) then
       begin
         //send buy command
         CurrentPosition.PosData.OrderDirection := TPositionDirection.LONG;
         LastAlg:=CurrentPosition.PosData.Algorithm_Price;
         LastCom:=CurrentPosition.PosData.Open_Price;
         mres := BuyAtMarket( CurrentPosition);
         if mres.f_price > 0 then
         begin
            CurrentPosition.PosData.TEMP_ID := Int64(TimeStampToMSecs(DateTimeToTimeStamp(Now)));
            CurrentPosition.PosData.OPENED := true;
            CurrentPosition.PosData.isProtection := False;

            // update position status
            CurrentPosition.PosData.PREV_DIRECTION := CurrentPosition.PosData.DIRECTION;
            CurrentPosition.PosData.DIRECTION := TPositionDirection.LONG;

            // update position protection start and stop loss
            CurrentPosition.PosData.PROT_START_PRICE := CurrentPosition.PosData.Algorithm_Price *(1+(CurrentPosition.PosParams.PROT_MARGIN/100)) ;
            Calc_LONG_STOP_LOSS;

            UpdatePosition;
            bRes := True;

            //update history
            UpdateHistory('L BUY @'+FormatFloat('0.00', mres.f_price)+
                          '/'+FormatFloat('0.00', LastAlg)+
                          '>='+FormatFloat('0.00', LastCom)
                          +'/P@'+FormatFloat('0.00',CurrentPosition.PosData.PROT_START_PRICE),
                          'L_OPEN',CurrentPosition);
         end;
       end;
  end
  else
  begin
       if(CurrentPosition.PosData.Open_Price >= CurrentPosition.PosData.Algorithm_Price) then
       begin
         //send buy command
         CurrentPosition.PosData.OrderDirection := TPositionDirection.LONG;
         LastAlg:=CurrentPosition.PosData.Algorithm_Price;
         LastCom:=CurrentPosition.PosData.Open_Price;
         mres := BuyAtMarket( CurrentPosition);
         if mres.f_price > 0 then
         begin
            CurrentPosition.PosData.TEMP_ID := Int64(TimeStampToMSecs(DateTimeToTimeStamp(Now)));
            CurrentPosition.PosData.OPENED := true;;
            CurrentPosition.PosData.isProtection := False;

            // update position status
            CurrentPosition.PosData.PREV_DIRECTION := CurrentPosition.PosData.DIRECTION;
            CurrentPosition.PosData.DIRECTION := TPositionDirection.LONG;

            // update position protection start and stop loss
            CurrentPosition.PosData.PROT_START_PRICE := CurrentPosition.PosData.Algorithm_Price *(1+(CurrentPosition.PosParams.PROT_MARGIN/100)) ;
            Calc_LONG_STOP_LOSS;

            UpdatePosition;
            bRes := True;

            //update history
            UpdateHistory('L BUY @'+FormatFloat('0.00', mres.f_price)+
                          '/'+FormatFloat('0.00', LastAlg)+
                          '<='+FormatFloat('0.00', LastCom),
                          'L_OPEN',CurrentPosition);
         end;
       end;
  end;

  Result := bRes;
end;

function TAlgorithm.LONG_PosTake:boolean;
var
   bRes : boolean;
   mres: TMarketMessage;

begin
  bRes := false;
  if (CurrentPosition.PosData.Algorithm_Price <=0) then
  begin
    Result := bRes;
    Exit;
  end;

  CurrentPosition.PosData.Take_Price  := CurrentPosition.PosData.LAST_BUY_PRICE * (1 + (CurrentPosition.PosParams.TAKE_PERCENT / 100));

//  if(CurrentPosition.PosData.Algorithm_Price >= CurrentPosition.PosData.Take_Price) then
  if(CurrentPosition.PosData.LAST_MARKET_PRICE >= CurrentPosition.PosData.Take_Price) then
  begin
       //send sell command
       CurrentPosition.PosData.OrderDirection := TPositionDirection.LONG;
       LastAlg:=CurrentPosition.PosData.LAST_MARKET_PRICE ;
       LastCom:=CurrentPosition.PosData.Take_Price ;
       mres := SellAtMarket(CurrentPosition);

       if mres.f_price > 0 then
       begin
          CurrentPosition.PosData.OPENED := false;
          CurrentPosition.PosData.Current_PL := CurrentPosition.PosData.LAST_SELL_PRICE*CurrentPosition.PosData.VOLUME - CurrentPosition.PosData.LAST_BUY_PRICE * CurrentPosition.PosData.VOLUME;
          CurrentPosition.PosData.TOTAL_PL := CurrentPosition.PosData.TOTAL_PL + CurrentPosition.PosData.Current_PL;

          CurrentPosition.PosData.START_PRICE_MIN := CurrentPosition.PosData.Algorithm_Price ;//CurrentPosition.PosData.LAST_SELL_PRICE ;
          CurrentPosition.PosData.START_PRICE_MAX := CurrentPosition.PosData.START_PRICE_MIN ;

          // update position status
          CurrentPosition.PosData.PREV_DIRECTION := CurrentPosition.PosData.DIRECTION;
          CurrentPosition.PosData.DIRECTION := TPositionDirection.STANDBY;

          UpdatePosition;

          //update history
          UpdateHistory('L SELL @'+FormatFloat('0.00', mres.f_price)+
                        //'/'+FormatFloat('0.00', CurrentPosition.PosData.Algorithm_Price)+
                        '/'+FormatFloat('0.00', LastAlg)+
                        '>='+FormatFloat('0.00', LastCom),
                        'L_TAKE',CurrentPosition);

          bRes := true;
       end;
  end;
  Result := bRes;
end;

function TAlgorithm.LONG_PosProtection: boolean;
var
   bRes : boolean;
   mres: TMarketMessage;
   f_early_prof, f_early_margin, f_early_corr: double;
   f_prf_target : double;
   f_cor_target : double;

   f_curr_price : double;
begin
  bRes:= False;
  if (CurrentPosition.PosData.Algorithm_Price <=0) then
  begin
    Result := bRes;
    Exit;
  end;

  CurrentPosition.PosData.Prot_Correction_Price := CurrentPosition.PosData.PROT_START_PRICE *  (1 + (CurrentPosition.PosParams.PROT_CORECT / 100));

  if CurrentPosition.PosParams.EARLY_PROT then
    f_curr_price := CurrentPosition.PosData.LAST_MARKET_PRICE
  else
    f_curr_price := CurrentPosition.PosData.Algorithm_Price;


  if NOT CurrentPosition.PosData.isProtection then
  begin
      if (f_curr_price >= CurrentPosition.PosData.PROT_START_PRICE) or (CurrentPosition.PosParams.PROT_MARGIN = 0)  then {check if protection needed}
       begin
         CurrentPosition.PosData.isProtection := true;
         if (f_curr_price > CurrentPosition.PosData.PROT_START_PRICE) then
                  CurrentPosition.PosData.PROT_START_PRICE := f_curr_price;
         CurrentPosition.PosData.Prot_Correction_Price := CurrentPosition.PosData.PROT_START_PRICE *  (1 + (CurrentPosition.PosParams.PROT_CORECT / 100));
         UpdateHistory('(LIP) Max='+FormatFloat('0.00', CurrentPosition.PosData.PROT_START_PRICE)+' Sell='+FormatFloat('0.00', CurrentPosition.PosData.Prot_Correction_Price),'L_PROT',CurrentPosition);
       end;
  end;

  if CurrentPosition.PosData.isProtection then
  begin
       if (f_curr_price > CurrentPosition.PosData.PROT_START_PRICE) then {update protection values}
        begin
          CurrentPosition.PosData.PROT_START_PRICE := f_curr_price;
          CurrentPosition.PosData.Prot_Correction_Price := CurrentPosition.PosData.PROT_START_PRICE *  (1 + (CurrentPosition.PosParams.PROT_CORECT / 100));
          UpdateHistory('(LUP) Max='+FormatFloat('0.00', CurrentPosition.PosData.PROT_START_PRICE)+' Sell='+FormatFloat('0.00', CurrentPosition.PosData.Prot_Correction_Price),'L_PROT',CurrentPosition);
        end;

       if (f_curr_price < CurrentPosition.PosData.PROT_START_PRICE) then
        begin
          // market going DOWN - see if you need early exit
          if CurrentPosition.PosParams.EARLY_PROT then
           begin
             f_early_prof := CurrentPosition.PosData.PROT_START_PRICE - CurrentPosition.PosData.LAST_BUY_PRICE;
             f_early_margin := CurrentPosition.PosData.LAST_BUY_PRICE * (CurrentPosition.PosParams.PROT_CORECT/100);
             f_prf_target := CurrentPosition.PosParams.Prf_Prc_Erl * f_early_margin ;
             f_cor_target := CurrentPosition.PosParams.Cor_Prc_Erl * f_early_margin;
             if ((f_early_prof)<(f_prf_target)) then
              begin
                f_early_corr := CurrentPosition.PosData.PROT_START_PRICE - f_curr_price;
                UpdateHistory('(ERL) VMax('+FormatFloat('0.00', f_early_prof)+') < '+FormatFloat('0.00', f_prf_target),'S_PROT',CurrentPosition);
                if (f_early_corr>=(f_cor_target)) then
                 begin
                   UpdateHistory('(ERL) Close! '+FormatFloat('0.00', f_early_corr)+') >= '+FormatFloat('0.00', f_cor_target),'S_PROT',CurrentPosition);
                   // generate NOW exit conditions !
                   CurrentPosition.PosData.Prot_Correction_Price := f_curr_price;
                 end;
              end;
           end;
        end;
  end;


  if((f_curr_price <= CurrentPosition.PosData.Prot_Correction_Price) and (CurrentPosition.PosData.isProtection)) then
  begin
     //send sell command
     CurrentPosition.PosData.OrderDirection := TPositionDirection.LONG;
     LastAlg:=f_curr_price;
     LastCom:=CurrentPosition.PosData.Prot_Correction_Price;
     mres := SellAtMarket(CurrentPosition);

     if mres.f_price<> -1 then
     begin
        CurrentPosition.PosData.OPENED := false;
        CurrentPosition.PosData.Current_PL := CurrentPosition.PosData.LAST_SELL_PRICE*CurrentPosition.PosData.VOLUME - CurrentPosition.PosData.LAST_BUY_PRICE * CurrentPosition.PosData.VOLUME;;
        CurrentPosition.PosData.TOTAL_PL := CurrentPosition.PosData.TOTAL_PL + CurrentPosition.PosData.Current_PL;

        CurrentPosition.PosData.START_PRICE_MIN := f_curr_price;
        CurrentPosition.PosData.START_PRICE_MAX := CurrentPosition.PosData.START_PRICE_MIN ;

        // update position status
        CurrentPosition.PosData.PREV_DIRECTION := CurrentPosition.PosData.DIRECTION;
        CurrentPosition.PosData.DIRECTION := TPositionDirection.STANDBY;

        UpdatePosition;

        //update history
        UpdateHistory('L SELL @'+FormatFloat('0.00', mres.f_price)+
                      '/'+FormatFloat('0.00', LastAlg)+
                      '<='+FormatFloat('0.00', LastCom),
                      'L_PROT',CurrentPosition);

        bRes := True
     end;
  end;
  Result := bRes;
end;

function TAlgorithm.LONG_PosStopLoss:boolean;
var
 bRes: boolean;
 mres: TMarketMessage;
 f_cur_price, f_ref_price : double;
begin
  bRes:= false;
  if (CurrentPosition.PosData.Algorithm_Price <=0) then
  begin
    Result := bRes;
    Exit;
  end;

  if NOT CurrentPosition.PosData.b_Stop_Real then
    f_cur_price := CurrentPosition.PosData.Algorithm_Price
  else
    f_cur_price := CurrentPosition.PosData.LAST_MARKET_PRICE;

  f_ref_price := CurrentPosition.PosData.STOP_PRICE;

  if( f_cur_price <= f_ref_price) then
  begin
    //send sell command
    CurrentPosition.PosData.OrderDirection := TPositionDirection.LONG;
    LastAlg:=f_cur_price;
    LastCom:=f_ref_price;
    mres := SellAtMarket(CurrentPosition);

    if mres.f_price > 0 then
    begin
       CurrentPosition.PosData.OPENED := false;
       CurrentPosition.PosData.Current_PL := CurrentPosition.PosData.LAST_SELL_PRICE*CurrentPosition.PosData.VOLUME - CurrentPosition.PosData.LAST_BUY_PRICE * CurrentPosition.PosData.VOLUME;
       CurrentPosition.PosData.TOTAL_PL := CurrentPosition.PosData.TOTAL_PL + CurrentPosition.PosData.Current_PL;

       CurrentPosition.PosData.START_PRICE_MIN := CurrentPosition.PosData.Algorithm_Price;
       CurrentPosition.PosData.START_PRICE_MAX := CurrentPosition.PosData.START_PRICE_MIN ;

       // update position status
       CurrentPosition.PosData.PREV_DIRECTION := CurrentPosition.PosData.DIRECTION;
       CurrentPosition.PosData.DIRECTION := TPositionDirection.STANDBY;

       UpdatePosition;

       //update history
       UpdateHistory('L SELL @'+FormatFloat('0.00', mres.f_price)+
                     '/'+FormatFloat('0.00', LastAlg)+
                     '<='+FormatFloat('0.00', LastCom),
                     'L_STOP',CurrentPosition);

       bRes := true;
    end;
  end;
  Result := bRes;
end;

procedure TAlgorithm.LONG_Recalc;
var
  TempProtPrice : Double;
begin
  if CurrentPosition.PosData.LAST_MARKET_PRICE <=0 then { check if some errow occured }
   begin
     UpdateHistory('ERROR','MARKET_PRICE',CurrentPosition);
     CurrentPosition.PosData.Take_Price  := CurrentPosition.PosData.LAST_BUY_PRICE * (1 + (CurrentPosition.PosParams.TAKE_PERCENT / 100));
     exit;
   end;

  if CurrentPosition.PosData.START_PRICE_MIN = 0 then
   begin
     CurrentPosition.PosData.START_PRICE_MIN := CurrentPosition.PosData.Algorithm_Price; { initialize start price }
     CurrentPosition.PosData.START_PRICE_MAX := CurrentPosition.PosData.START_PRICE_MIN ;

     UpdateHistory('INIT START PRICE','L_OPEN',CurrentPosition);
   end;

  CurrentPosition.PosData.Take_Price  := CurrentPosition.PosData.LAST_BUY_PRICE * (1 + (CurrentPosition.PosParams.TAKE_PERCENT / 100));
  CurrentPosition.PosData.Open_Price  := CurrentPosition.PosData.START_PRICE_MIN * (1 + (CurrentPosition.PosParams.OPEN_PERCENT / 100 ));


  if CurrentPosition.PosData.OPENED then
  begin
    CurrentPosition.PosData.Open_Value := CurrentPosition.PosData.LAST_BUY_PRICE * CurrentPosition.PosData.VOLUME;
    CurrentPosition.PosData.Market_Value := CurrentPosition.PosData.LAST_MARKET_PRICE * CurrentPosition.PosData.VOLUME;
    CurrentPosition.PosData.Current_PL := CurrentPosition.PosData.Market_Value - CurrentPosition.PosData.Open_Value;
  end
  else
  begin // IF POSITION NOT OPENED >>>>
    CurrentPosition.PosData.Open_Value := 0;
    CurrentPosition.PosData.Current_PL := 0;
    CurrentPosition.PosData.isProtection := false;
    if (CurrentPosition.PosData.Algorithm_Price < CurrentPosition.PosData.START_PRICE_MIN) then {check if market below start - LONG ONLY - }
      begin
        CurrentPosition.PosData.START_PRICE_MIN := CurrentPosition.PosData.Algorithm_Price;
        CurrentPosition.PosData.Open_Price  := CurrentPosition.PosData.START_PRICE_MIN * (1 + (CurrentPosition.PosParams.OPEN_PERCENT / 100 ));
        UpdateHistory('(LUO) Min='+FormatFloat('0.00', CurrentPosition.PosData.START_PRICE_MIN)+' Buy='+FormatFloat('0.00', CurrentPosition.PosData.Open_Price),'L_OPEN',CurrentPosition);
      end;
  end;
end;

function TAlgorithm.LONG_ForceClose: boolean;
var
   bRes, bTemp : boolean;
   mres: TMarketMessage;

begin
  bRes := false;
  if (CurrentPosition.PosData.Algorithm_Price <=0) then
  begin
    Result := bRes;
    Exit;
  end;

  if NOT CurrentPosition.PosParams.CLOSE_NOW_AT_MARKET then
   exit;


  //send sell command
  CurrentPosition.PosData.OrderDirection := TPositionDirection.LONG;
  bTemp := CurrentPosition.PosParams.RESET_AVERAGE;
  CurrentPosition.PosParams.RESET_AVERAGE := true;
  mres := SellAtMarket(CurrentPosition);
  CurrentPosition.PosParams.RESET_AVERAGE := bTemp;

  if mres.f_price > 0 then
  begin
          CurrentPosition.PosData.OPENED := false;
          CurrentPosition.PosData.Current_PL := CurrentPosition.PosData.LAST_SELL_PRICE*CurrentPosition.PosData.VOLUME - CurrentPosition.PosData.LAST_BUY_PRICE * CurrentPosition.PosData.VOLUME;
          CurrentPosition.PosData.TOTAL_PL := CurrentPosition.PosData.TOTAL_PL + CurrentPosition.PosData.Current_PL;

          CurrentPosition.PosData.START_PRICE_MIN := CurrentPosition.PosData.LAST_SELL_PRICE ;
          CurrentPosition.PosData.START_PRICE_MAX := CurrentPosition.PosData.START_PRICE_MIN ;

          CurrentPosition.PosParams.CLOSE_NOW_AT_MARKET := False;



          // update position status
          CurrentPosition.PosData.PREV_DIRECTION := CurrentPosition.PosData.DIRECTION;
          CurrentPosition.PosData.DIRECTION := TPositionDirection.STANDBY;

          UpdatePosition;

          //update history
          UpdateHistory('L SELL @'+FormatFloat('0.00', mres.f_price)+
                        ' (FORCED AT MARKET)',
                        'L_FORCE',CurrentPosition);

          bRes := true;
  end;
  Result := bRes;
end;


procedure TAlgorithm.SHORT_ForceSell;
  var
     mres: TMarketMessage;
begin
     if(force_sell) then
     begin
          //send sell command
          CurrentPosition.PosData.OrderDirection := TPositionDirection.SHORT ;
          mres:= SellAtMarket(CurrentPosition);
          force_sell := False;
          if mres.f_price > 0 then
          begin
             CurrentPosition.PosData.TEMP_ID := Int64(TimeStampToMSecs(DateTimeToTimeStamp(Now)));
             CurrentPosition.PosData.OPENED := true;
             CurrentPosition.PosData.isProtection := False;

             // update position status
             CurrentPosition.PosData.PREV_DIRECTION := CurrentPosition.PosData.DIRECTION;
             CurrentPosition.PosData.DIRECTION := TPositionDirection.SHORT;

             // update position protection start !
             CurrentPosition.PosData.PROT_START_PRICE := CurrentPosition.PosData.Algorithm_Price *(1+(CurrentPosition.PosParams.SHORT_PROT_MARGIN /100)) ;
             Calc_SHRT_STOP_LOSS;

             //update record
             UpdatePosition;
             //update history
             UpdateHistory('SHORT SELL '+FormatFloat('0.00',mres.f_price)+'/P@'+FormatFloat('0.00',CurrentPosition.PosData.PROT_START_PRICE)
             ,'S_FORCE',CurrentPosition);
          end;

     end;
end;

function TAlgorithm.SHORT_PosOpen: boolean;
var
   mres: TMarketMessage;
   bRes:boolean;
begin
  bRes := False;
  if (CurrentPosition.PosData.OPENED) or (CurrentPosition.PosData.Algorithm_Price <=0) then
  begin
    Result := bRes;
    Exit;
  end;

  if CurrentPosition.PosData.PREV_DIRECTION <> TPositionDirection.STANDBY then
    CurrentPosition.PosData.Open_Price := CurrentPosition.PosData.START_PRICE_MAX * (1 + (CurrentPosition.PosParams.SHORT_RE_OPEN_PERCENT / 100 ))
  else
    CurrentPosition.PosData.Open_Price := CurrentPosition.PosData.START_PRICE_MAX * (1 + (CurrentPosition.PosParams.SHORT_OPEN_PERCENT / 100 ));


  if(CurrentPosition.PosData.Open_Price >= CurrentPosition.PosData.Algorithm_Price) then
       begin
         //send SELL command (open SHORT position)
         CurrentPosition.PosData.OrderDirection := TPositionDirection.SHORT ;
         LastAlg:=CurrentPosition.PosData.Algorithm_Price;
         LastCom:=CurrentPosition.PosData.Open_Price;
         mres := SellAtMarket( CurrentPosition);
         if mres.f_price > 0 then
         begin
            CurrentPosition.PosData.TEMP_ID := Int64(TimeStampToMSecs(DateTimeToTimeStamp(Now)));

            CurrentPosition.PosData.OPENED := true;
            CurrentPosition.PosData.isProtection := False;

            // update position status
            CurrentPosition.PosData.PREV_DIRECTION := CurrentPosition.PosData.DIRECTION;
            CurrentPosition.PosData.DIRECTION := TPositionDirection.SHORT;

            // update position protection start !
            CurrentPosition.PosData.PROT_START_PRICE := CurrentPosition.PosData.Algorithm_Price *(1+(CurrentPosition.PosParams.SHORT_PROT_MARGIN /100)) ;
            Calc_SHRT_STOP_LOSS;

            UpdatePosition;
            bRes := True;

            //update history
            UpdateHistory('S SELL @'+FormatFloat('0.00', mres.f_price)+
                          '/'+FormatFloat('0.00', LastAlg)+
                          '<='+FormatFloat('0.00', LastCom)
                          +'/P@'+FormatFloat('0.00',CurrentPosition.PosData.PROT_START_PRICE),
                          'S_OPEN',CurrentPosition);
         end;
       end;

  Result := bRes;
end;

function TAlgorithm.SHORT_PosTake: boolean;
var
   bRes : boolean;
   mres: TMarketMessage;
begin
  bRes := false;
  if (CurrentPosition.PosData.Algorithm_Price <=0) then
  begin
    Result := bRes;
    Exit;
  end;

  CurrentPosition.PosData.Take_Price  := CurrentPosition.PosData.LAST_SELL_PRICE * (1 + (CurrentPosition.PosParams.SHORT_TAKE_PERCENT / 100));

//  if(CurrentPosition.PosData.Algorithm_Price <= CurrentPosition.PosData.Take_Price) then
  if(CurrentPosition.PosData.LAST_MARKET_PRICE <= CurrentPosition.PosData.Take_Price) then
  begin
       //send BUY command (to close SHORT position)
       CurrentPosition.PosData.OrderDirection := TPositionDirection.SHORT ;
       LastAlg:=CurrentPosition.PosData.LAST_MARKET_PRICE ;
       LastCom:=CurrentPosition.PosData.Take_Price;
       mres := BuyAtMarket(CurrentPosition);

       if mres.f_price > 0 then
       begin
          CurrentPosition.PosData.OPENED := false;
          CurrentPosition.PosData.Current_PL := CurrentPosition.PosData.LAST_SELL_PRICE*CurrentPosition.PosData.VOLUME - CurrentPosition.PosData.LAST_BUY_PRICE * CurrentPosition.PosData.VOLUME;
          CurrentPosition.PosData.TOTAL_PL := CurrentPosition.PosData.TOTAL_PL + CurrentPosition.PosData.Current_PL;

          CurrentPosition.PosData.START_PRICE_MAX := CurrentPosition.PosData.Algorithm_Price; //CurrentPosition.PosData.LAST_BUY_PRICE;
          CurrentPosition.PosData.START_PRICE_MIN := CurrentPosition.PosData.START_PRICE_MAX;

          // update position status
          CurrentPosition.PosData.PREV_DIRECTION := CurrentPosition.PosData.DIRECTION;
          CurrentPosition.PosData.DIRECTION := TPositionDirection.STANDBY;

          UpdatePosition;

          //update history
          UpdateHistory('S BUY @'+FormatFloat('0.00', mres.f_price)+
                        //'/'+FormatFloat('0.00', CurrentPosition.PosData.Algorithm_Price)+
                        '/'+FormatFloat('0.00', LastAlg)+
                        '<='+FormatFloat('0.00', LastCom),
                        'S_TAKE',CurrentPosition);

          bRes := true;
       end;
  end;
  Result := bRes;
end;

function TAlgorithm.SHORT_PosProtection: boolean;
var
   TempProtPrice : double;
   bRes : boolean;
   mres: TMarketMessage;
   f_early_prof, f_early_margin, f_early_corr: double;
   f_prf_target : double;
   f_cor_target : double;

   f_curr_price : double;

begin
  bRes:= False;
  if (CurrentPosition.PosData.Algorithm_Price <=0) then
  begin
    Result := bRes;
    Exit;
  end;

  CurrentPosition.PosData.Prot_Correction_Price := CurrentPosition.PosData.PROT_START_PRICE *  (1 + (CurrentPosition.PosParams.SHORT_PROT_CORECT / 100));

  if CurrentPosition.PosParams.EARLY_PROT then
    f_curr_price := CurrentPosition.PosData.LAST_MARKET_PRICE
  else
    f_curr_price := CurrentPosition.PosData.Algorithm_Price;

  if NOT CurrentPosition.PosData.isProtection then
  begin
    if (f_curr_price <= CurrentPosition.PosData.PROT_START_PRICE ) or (CurrentPosition.PosParams.SHORT_PROT_MARGIN = 0) then {check if protection needed}
     begin

       if (f_curr_price < CurrentPosition.PosData.PROT_START_PRICE) then
          CurrentPosition.PosData.PROT_START_PRICE := f_curr_price;

       CurrentPosition.PosData.isProtection := true;
       CurrentPosition.PosData.Prot_Correction_Price := CurrentPosition.PosData.PROT_START_PRICE *  (1 + (CurrentPosition.PosParams.SHORT_PROT_CORECT / 100));
       UpdateHistory('(SIP) Min='+FormatFloat('0.00', CurrentPosition.PosData.PROT_START_PRICE)+' Buy='+FormatFloat('0.00', CurrentPosition.PosData.Prot_Correction_Price),'S_PROT',CurrentPosition);
     end;
  end;

  if CurrentPosition.PosData.isProtection then
   begin
     if (f_curr_price < CurrentPosition.PosData.PROT_START_PRICE) then {update protection values}
      begin

        CurrentPosition.PosData.PROT_START_PRICE := f_curr_price;

        CurrentPosition.PosData.Prot_Correction_Price := CurrentPosition.PosData.PROT_START_PRICE *  (1 + (CurrentPosition.PosParams.SHORT_PROT_CORECT / 100));
        UpdateHistory('(SUP) Min='+FormatFloat('0.00', CurrentPosition.PosData.PROT_START_PRICE)+' Buy='+FormatFloat('0.00', CurrentPosition.PosData.Prot_Correction_Price),'S_PROT',CurrentPosition);
      end;

     if (f_curr_price > CurrentPosition.PosData.PROT_START_PRICE) then
      begin
        // market going up - see if you need early exit
        if CurrentPosition.PosParams.EARLY_PROT then
         begin
           f_early_prof := CurrentPosition.PosData.LAST_SELL_PRICE - CurrentPosition.PosData.PROT_START_PRICE;
           f_early_margin := CurrentPosition.PosData.LAST_SELL_PRICE * (CurrentPosition.PosParams.SHORT_PROT_CORECT/100);
           f_prf_target := CurrentPosition.PosParams.Prf_Prc_Erl * f_early_margin ;
           f_cor_target := CurrentPosition.PosParams.Cor_Prc_Erl * f_early_margin;
           if ((f_early_prof)<(f_prf_target)) then
            begin
              f_early_corr := f_curr_price - CurrentPosition.PosData.PROT_START_PRICE;
              UpdateHistory('(ERL) VMax('+FormatFloat('0.00', f_early_prof)+') < '+FormatFloat('0.00', f_prf_target),'S_PROT',CurrentPosition);
              if (f_early_corr>=(f_cor_target)) then
               begin
                 UpdateHistory('(ERL) Close! '+FormatFloat('0.00', f_early_corr)+') > '+FormatFloat('0.00', f_cor_target),'S_PROT',CurrentPosition);
                 // generate NOW exit conditions !
                 CurrentPosition.PosData.Prot_Correction_Price := f_curr_price;
               end;
            end;
         end;
      end;
   end;


  if((f_curr_price >= CurrentPosition.PosData.Prot_Correction_Price) and (CurrentPosition.PosData.isProtection)) then
  begin
     //send BUY command to close SHORT
     CurrentPosition.PosData.OrderDirection := TPositionDirection.SHORT ;
     LastAlg:=f_curr_price;
     LastCom:=CurrentPosition.PosData.Prot_Correction_Price;
     mres := BuyAtMarket(CurrentPosition);

     if mres.f_price<> -1 then
     begin
        CurrentPosition.PosData.OPENED := false;
        CurrentPosition.PosData.Current_PL := CurrentPosition.PosData.LAST_SELL_PRICE*CurrentPosition.PosData.VOLUME - CurrentPosition.PosData.LAST_BUY_PRICE * CurrentPosition.PosData.VOLUME;;
        CurrentPosition.PosData.TOTAL_PL := CurrentPosition.PosData.TOTAL_PL + CurrentPosition.PosData.Current_PL;

        CurrentPosition.PosData.START_PRICE_MAX := f_curr_price;
        CurrentPosition.PosData.START_PRICE_MIN := CurrentPosition.PosData.START_PRICE_MAX;

        // update position status
        CurrentPosition.PosData.PREV_DIRECTION := CurrentPosition.PosData.DIRECTION;
        CurrentPosition.PosData.DIRECTION := TPositionDirection.STANDBY;

        UpdatePosition;

        //update history
        UpdateHistory('S BUY @'+FormatFloat('0.00', mres.f_price)+
                      '/'+FormatFloat('0.00', LastAlg)+
                      '>='+FormatFloat('0.00', LastCom),
                      'S_PROT',CurrentPosition);

        bRes := True
     end;
  end;
  Result := bRes;


end;

function TAlgorithm.SHORT_PosStopLoss: boolean;
var
 bRes: boolean;
 mres: TMarketMessage;
 f_cur_price, f_ref_price : double;
begin
  bRes:= false;
  if (CurrentPosition.PosData.Algorithm_Price <=0) then
  begin
    Result := bRes;
    Exit;
  end;

  if NOT CurrentPosition.PosData.b_Stop_Real then
    f_cur_price := CurrentPosition.PosData.Algorithm_Price
  else
    f_cur_price := CurrentPosition.PosData.LAST_MARKET_PRICE;

  f_ref_price := CurrentPosition.PosData.STOP_PRICE;

  if( f_cur_price >= f_ref_price) then
  begin
    //send BUY command (to close SHORT position)
    CurrentPosition.PosData.OrderDirection := TPositionDirection.SHORT ;
    LastAlg:=f_cur_price;
    LastCom:=f_ref_price;
    mres := BuyAtMarket(CurrentPosition);

    if mres.f_price > 0 then
    begin
       CurrentPosition.PosData.OPENED := false;
       CurrentPosition.PosData.Current_PL := CurrentPosition.PosData.LAST_SELL_PRICE*CurrentPosition.PosData.VOLUME - CurrentPosition.PosData.LAST_BUY_PRICE * CurrentPosition.PosData.VOLUME;
       CurrentPosition.PosData.TOTAL_PL := CurrentPosition.PosData.TOTAL_PL + CurrentPosition.PosData.Current_PL;

       CurrentPosition.PosData.START_PRICE_MAX := CurrentPosition.PosData.Algorithm_Price ;
       CurrentPosition.PosData.START_PRICE_MIN := CurrentPosition.PosData.START_PRICE_MAX;

       // update position status
       CurrentPosition.PosData.PREV_DIRECTION := CurrentPosition.PosData.DIRECTION;
       CurrentPosition.PosData.DIRECTION := TPositionDirection.STANDBY;

       UpdatePosition;

       //update history
       UpdateHistory('S BUY @'+FormatFloat('0.00', mres.f_price)+
                     '/'+FormatFloat('0.00', LastAlg)+
                     '>='+FormatFloat('0.00', LastCom),
                     'S_STOP',CurrentPosition);

       bRes := true;
    end;
  end;
  Result := bRes;
end;

procedure TAlgorithm.SHORT_Recalc;
begin
  if CurrentPosition.PosData.LAST_MARKET_PRICE <=0 then { check if some errow occured }
   begin
     UpdateHistory('ERROR','MARKET_PRICE',CurrentPosition);
     CurrentPosition.PosData.Take_Price  := CurrentPosition.PosData.LAST_SELL_PRICE * (1 + (CurrentPosition.PosParams.SHORT_TAKE_PERCENT / 100));
     exit;
   end;

  if CurrentPosition.PosData.START_PRICE_MAX = 0 then
   begin
     CurrentPosition.PosData.START_PRICE_MAX := CurrentPosition.PosData.Algorithm_Price ; { initialize start price }
     CurrentPosition.PosData.START_PRICE_MIN := CurrentPosition.PosData.START_PRICE_MAX;

     UpdateHistory('INIT START PRICE','S_OPEN',CurrentPosition);
   end;

  CurrentPosition.PosData.Take_Price  := CurrentPosition.PosData.LAST_SELL_PRICE * (1 + (CurrentPosition.PosParams.SHORT_TAKE_PERCENT / 100));
  CurrentPosition.PosData.Open_Price  := CurrentPosition.PosData.START_PRICE_MAX * (1 + (CurrentPosition.PosParams.SHORT_OPEN_PERCENT / 100 ));
  CurrentPosition.PosData.Prot_Correction_Price := CurrentPosition.PosData.PROT_START_PRICE *  (1 + (CurrentPosition.PosParams.SHORT_PROT_CORECT / 100));


  if CurrentPosition.PosData.OPENED then
  begin
    CurrentPosition.PosData.Open_Value := CurrentPosition.PosData.LAST_SELL_PRICE * CurrentPosition.PosData.VOLUME;
    CurrentPosition.PosData.Market_Value := CurrentPosition.PosData.LAST_MARKET_PRICE * CurrentPosition.PosData.VOLUME;
    CurrentPosition.PosData.Current_PL := CurrentPosition.PosData.Open_Value - CurrentPosition.PosData.Market_Value;
  end;
end;

function TAlgorithm.SHORT_ForceClose: boolean;
var
   bRes, bTemp : boolean;
   mres: TMarketMessage;
begin
  bRes := false;
  if (CurrentPosition.PosData.Algorithm_Price <=0) then
  begin
    Result := bRes;
    Exit;
  end;

  if NOT CurrentPosition.PosParams.CLOSE_NOW_AT_MARKET then
   exit;

  //send BUY command
  CurrentPosition.PosData.OrderDirection := TPositionDirection.SHORT ;
  bTemp := CurrentPosition.PosParams.RESET_AVERAGE;
  CurrentPosition.PosParams.RESET_AVERAGE := true;
  mres := BuyAtMarket(CurrentPosition);
  CurrentPosition.PosParams.RESET_AVERAGE := bTemp;

  if mres.f_price > 0 then
  begin
          CurrentPosition.PosData.OPENED := false;
          CurrentPosition.PosData.Current_PL := CurrentPosition.PosData.LAST_SELL_PRICE*CurrentPosition.PosData.VOLUME - CurrentPosition.PosData.LAST_BUY_PRICE * CurrentPosition.PosData.VOLUME;
          CurrentPosition.PosData.TOTAL_PL := CurrentPosition.PosData.TOTAL_PL + CurrentPosition.PosData.Current_PL;

          CurrentPosition.PosData.START_PRICE_MIN := CurrentPosition.PosData.LAST_BUY_PRICE ;
          CurrentPosition.PosData.START_PRICE_MAX := CurrentPosition.PosData.START_PRICE_MIN ;

          CurrentPosition.PosParams.CLOSE_NOW_AT_MARKET := False;




          // update position status
          CurrentPosition.PosData.PREV_DIRECTION := CurrentPosition.PosData.DIRECTION;
          CurrentPosition.PosData.DIRECTION := TPositionDirection.STANDBY;

          UpdatePosition;

          //update history
          UpdateHistory('S BUY @'+FormatFloat('0.00', mres.f_price)+
                        ' (FORCED AT MARKET)',
                        'S_FORCE',CurrentPosition);

          bRes := true;
  end;
  Result := bRes;
end;

function TAlgorithm.CHECK_BOUNCE: boolean;
var
   bRes : boolean;
   mres: TMarketMessage;
   f_proffit, f_min_price, f_max_price, f_price : double;
begin

  bRes := false;
  if (CurrentPosition.PosData.Algorithm_Price <=0) or (NOT CurrentPosition.PosData.OPENED) then
  begin
    Result := bRes;
    Exit;
  end;

  if NOT CurrentPosition.PosParams.BOUNCE then
  begin
    Result := bRes;
    Exit;
  end;


  f_price := CurrentPosition.PosData.Algorithm_Price;

  if CurrentPosition.PosData.DIRECTION= TPositionDirection.SHORT then
  begin
    CurrentPosition.PosData.f_Open_price :=CurrentPosition.PosData.STOP_PRICE /  (1 + (CurrentPosition.PosParams.SHORT_STOP_PERCENT / 100));
    f_proffit :=  CurrentPosition.PosData.f_Open_price - f_price; // proffit calculated either on average or on real ?
  end
  else
  begin
    CurrentPosition.PosData.f_Open_price :=CurrentPosition.PosData.STOP_PRICE /  (1 + (CurrentPosition.PosParams.STOP_PERCENT / 100));
    f_proffit :=  f_price - CurrentPosition.PosData.f_Open_price; // proffit calculated either on average or on real ?
  end;

  if CurrentPosition.PosData.DIRECTION= TPositionDirection.SHORT then
  begin
    f_min_price := CurrentPosition.PosData.f_Open_Price * (1 - (CurrentPosition.PosParams.MIN_BOUNCE)/100);
    f_max_price := CurrentPosition.PosData.f_Open_Price * (1 - (CurrentPosition.PosParams.MAX_BOUNCE)/100);
  end
  else
  begin
    f_min_price := CurrentPosition.PosData.f_Open_Price * (1 + (CurrentPosition.PosParams.MIN_BOUNCE)/100);
    f_max_price := CurrentPosition.PosData.f_Open_Price * (1 + (CurrentPosition.PosParams.MAX_BOUNCE)/100);
  end;


  if CurrentPosition.PosData.BOUNCING=1 then
  begin
    // if it is already bouncing then see if current proffit is ZERO then execute close-and-reverse
    if f_proffit<0 then
    begin
      CurrentPosition.PosParams.CLOSE_NOW_AT_MARKET := true;
      if CurrentPosition.PosData.DIRECTION= TPositionDirection.SHORT then
      begin
        UpdateHistory('BOUNCE_CLOSE','BOUNCE',CurrentPosition);
        SHORT_ForceClose;
        CurrentPosition.PosParams.FORCE_BUY := true;
        UpdateHistory('BOUNCE_OPEN','BOUNCE',CurrentPosition);
        LONG_ForceBuy;
        bRes := TRUE;
      end
      else
      begin
        UpdateHistory('BOUNCE_CLOSE','BOUNCE',CurrentPosition);
        LONG_ForceClose;
        force_sell := True;
        UpdateHistory('BOUNCE_OPEN','BOUNCE',CurrentPosition);
        SHORT_ForceSell;
        bRes := TRUE;
      end;
    end
    else   // check if BOUNCING boundary has not been surpassed, and if then set BOUNCING OFF !!!!
    begin
      if CurrentPosition.PosData.DIRECTION= TPositionDirection.SHORT then
      begin
        if f_price<f_max_price then
        begin
          CurrentPosition.PosData.BOUNCING := 2; // Out of the woods !
          UpdateHistory('BOUNCE_OFF','BOUNCE',CurrentPosition);
          bRes := False;
        end;
      end
      else
      begin
        if f_price>f_max_price then
        begin
          CurrentPosition.PosData.BOUNCING := 2; // Out of the woods !
          UpdateHistory('BOUNCE_OFF','BOUNCE',CurrentPosition);
          bRes := False;
        end;
      end;

    end;
  end
  else
  if CurrentPosition.PosData.BOUNCING = 0 then
  begin
    //if NOT bouncing check if bouncing is needed !!!
    if CurrentPosition.PosData.DIRECTION= TPositionDirection.SHORT then
    begin
      if (f_price<f_min_price) and (f_price>f_max_price) then
      begin
       CurrentPosition.PosData.BOUNCING := 1;
       UpdateHistory('BOUNCE_ON','BOUNCE',CurrentPosition);
      end;
    end
    else
    begin
      if (f_price>f_min_price) and (f_price<f_max_price) then
      begin
       CurrentPosition.PosData.BOUNCING := 1;
       UpdateHistory('BOUNCE_ON','BOUNCE',CurrentPosition);
      end;
    end;
  end
  else
  if CurrentPosition.PosData.BOUNCING=2 then
  begin
     // out of the woods
  end;

  Result := bRes;
end;



procedure TAlgorithm._UpdateHistory;
begin
  // synchronized code !!!
 dm_Main.AddHistory(str_HistoryAction, str_HistoryState,HistoryCPos,HistoryCPos.PosData.LAST_MARKET_PRICE);
end;



procedure TAlgorithm._UpdateTaskInfo_Start;
begin
 pnl_TaskInfo.Color:= clGreen;
 pnl_TaskInfo.Font.Color := clRed;
 pnl_TaskInfo.Caption := CurrentPosition.PosData.SYMBOL;
end;

procedure TAlgorithm._UpdateTaskInfo_Idle;
begin
 pnl_TaskInfo.Color:= clGray;
 pnl_TaskInfo.Font.Color := clGreen;
 pnl_TaskInfo.Caption := 'IDLE';
end;

procedure TAlgorithm._UpdateTaskInfo_NotActive;
begin
 pnl_TaskInfo.Color:= clGray;
 pnl_TaskInfo.Font.Color := clBlack;
 pnl_TaskInfo.Caption := 'NA';
end;

procedure TAlgorithm._UpdateTaskInfo_NoTrading;
begin
 pnl_TaskInfo.Color:= clGray;
 pnl_TaskInfo.Font.Color := clBlack;
 pnl_TaskInfo.Caption := 'WAIT';
end;

//------------------------------------------------------------------------------
//  added Dan 20141015
//  replacement for _symc routines

function TAlgorithm.ThrGetRealTime(var CPos: TMarketPosition):boolean;
var mres: TMarketMessage;
begin
  if Connector = nil then Exit;
  if CPos.PosData.SYMBOL ='' then exit ;

  mres:= Connector._GetQuote(CPos.PosData.MARKET, CPos.PosData.SYMBOL);

  if mres.f_price <= 0 then
  begin
    Result := False;
    exit;
  end;

  CPos.PosData.Take_Price := -1;
  CPos.PosData.Prot_Correction_Price := -1;

  SetNewPrice(CPos,mres);

  Result := True;
end;

function TAlgorithm.ThrMarketBuy(var CPos: TMarketPosition): TMarketMessage;
var
   mres: TMarketMessage;
begin
  if Connector = nil then Exit;

  mres := Connector.MarketBuy(CPos.PosData.MARKET,CPos.PosData.SYMBOL,CPos.PosData.VOLUME);

  if mres.f_price < 0 then
  begin
    //mres.f_price:= -9999;
    Result := mres;
    exit;
  end;

  CPos.PosData.LAST_BUY_PRICE := mres.f_price;
  Cpos.PosData.BOUNCING := 0;

  SetNewPrice(CPos, mres, 'B');

  Result:= mres;
end;

function TAlgorithm.ThrMarketSell(var CPos: TMarketPosition): TMarketMessage;
var
   mres: TMarketMessage;
begin
  if Connector = nil then Exit;

  mres:= Connector.MarketSell(CPos.PosData.MARKET, CPos.PosData.SYMBOL, CPos.PosData.VOLUME);

  if mres.f_price < 0 then
  begin
    //mres.f_price:= -9999;
    Result := mres;
    exit;
  end;

  CPos.PosData.LAST_SELL_PRICE := mres.f_price;
  Cpos.PosData.BOUNCING := 0;

  SetNewPrice(CPos, mres, 'S');

  Result:= mres;
end;

//------------------------------------------------------------------------------

procedure TAlgorithm.UpdatePosition;
begin
  OutputPositionData := CurrentPosition;
end;

procedure TAlgorithm.UpdateHistory(str_Action, str_State: string;
  CPos: TMarketPosition);
begin
  str_HistoryAction := str_Action ;
  str_HistoryState := str_State;
  HistoryCPos := CPos;
  Synchronize(@_UpdateHistory);
end;

procedure TAlgorithm.MarketUpdateCurrentPosition;
begin
  ThrGetRealTime(CurrentPosition); //  modified Dan 20141015
end;

function TAlgorithm.BuyAtMarket(var CPos: TMarketPosition): TMarketMessage;
begin
  BuyCPos := Cpos;
  //Synchronize(@_SyncBuy);
  BuyResult:= ThrMarketBuy(BuyCPos); //  modified Dan 20141015
  Cpos := BuyCPos;
  result := BuyResult;
end;

function TAlgorithm.SellAtMarket(var CPos: TMarketPosition): TMarketMessage;
begin
 SellCPos := CPos;
 //Synchronize(@_SyncSell);
 SellResult:= ThrMarketSell(SellCPos); //  modified Dan 20141015
 CPos := SellCPos;
 Result := SellResult;
end;

procedure TAlgorithm.UpdateTaskInfo_Start;
begin
  Synchronize(@_UpdateTaskInfo_Start);
end;

procedure TAlgorithm.UpdateTaskInfo_Idle;
begin
 Synchronize(@_UpdateTaskInfo_Idle);
end;

procedure TAlgorithm.UpdateTaskInfo_NotActive;
begin
 Synchronize(@_UpdateTaskInfo_NotActive);
end;

procedure TAlgorithm.UpdateTaskInfo_NoTrading;
begin
   Synchronize(@_UpdateTaskInfo_NoTrading);
end;

procedure TAlgorithm.Execute;
var
   tm_Now: TTime;

begin
 while (not Terminated) do
  begin
    if PAUSED then
     Sleep(1000)
    else
      begin
         InTradingHours := True;

         tm_Now:= Time;

         if dm_Main.bStartStop then
          if (tm_now>dm_Main.tm_Market_stop) or (tm_now<dm_Main.tm_Market_start) then
             InTradingHours := False;

         if Not InTradingHours then
            UpdateTaskInfo_NoTrading
         else
           begin
               if CurrentPosition.PosParams.POS_ACTIVE then
                 UpdateTaskInfo_Start
               Else
                 UpdateTaskInfo_NotActive;
           end;

         Sleep(300);
         RunAlgorithm ;
         UpdateTaskInfo_Idle;
      end;
  end;

 DONE := True;
end;



destructor TAlgorithm.Destroy;
begin
   pnl_TaskInfo.Caption :='';
   Inherited;
end;


procedure TAlgorithm.RunAlgorithm;
var
   tm_now:TTime;
   tm_beforemarketclose:TTime;
   tm_marketclose:TTime;
begin

  if InputPositionData.PosData.NRPOS >=0 then //check if valid update is available
  begin
    // register updates such as ACTIVE, CLOSE_NOW_AT_MARKET, etc
    CurrentPosition.PosParams := InputPositionData.PosParams;
    // now invalidate updates
    InputPositionData.PosData.NRPOS := -1000;
  end;

  if not CurrentPosition.PosParams.POS_ACTIVE then Exit; { exit if not active }


  if Not InTradingHours then
  begin
      // market closed
      CurrentPosition.PosData.b_Wait_For_Market_Close := False;
      exit;
  end;

  if (CurrentPosition.PosData.b_Wait_For_Market_Close) then
  begin
    exit; // assume position closed and wait for market closing
  end;

  if CurrentPosition.PosParams.FORCE_BUY then
  begin
    _LONG_Run;
  end;

  if CurrentPosition.PosData.OPENED then
    begin // BEGIN ACTIVE AND OPENED

      // first check if market is about to CLOSE and we NEED TO CLOSE_AT_MARKETCLOSING
      if CurrentPosition.PosParams.CLOSE_AT_MARKETCLOSING then
       begin
         tm_Now:= Time;
         tm_beforemarketclose:= IncMinute( dm_Main.tm_Market_stop, -1);
         tm_marketclose := dm_Main.tm_Market_stop;
         if (tm_now < tm_marketclose) and ( tm_now > tm_beforemarketclose) then
          begin
           CurrentPosition.PosParams.CLOSE_NOW_AT_MARKET := True;
           UpdateHistory('CLOSE POS '+IntToStr(CurrentPosition.PosData.NRPOS)+' AT MARKET DAILY CLOSING','FORCE',CurrentPosition);
           CurrentPosition.PosData.b_Wait_For_Market_Close := True;
          end;
       end;


      if CurrentPosition.PosData.DIRECTION = TPositionDirection.LONG then
        begin
          _LONG_Run;
        end
      else
      if CurrentPosition.PosData.DIRECTION = TPositionDirection.SHORT then
        begin
          _SHORT_Run;
        end;
    end // END ACTIVE AND OPENED
   else
   begin // if active and NOT opened

     if LONG_ONLY then // this is for the case when the algorithm is running just for LONG
       begin
         _Long_Run;
         Exit;
       end
     else
     begin

       MarketUpdateCurrentPosition; // get market information

       if CurrentPosition.PosData.START_PRICE_MAX = 0 then // if first run then initialize start-price
         begin

           CurrentPosition.PosData.START_PRICE_MAX := CurrentPosition.PosData.Algorithm_Price;
           CurrentPosition.PosData.START_PRICE_MIN := CurrentPosition.PosData.START_PRICE_MAX;

           UpdatePosition;
           exit;
         end;

       // see if goes down or up
       // compare with last_price
       // if breakout open_buy/open_sell then open buy/sell
       //

       if CurrentPosition.PosData.LAST_MARKET_PRICE = CurrentPosition.PosData.Prev_Price then // nothing happened
         begin
           UpdatePosition;
           exit; // exit if price not changed
         end;

       if CurrentPosition.PosData.LAST_MARKET_PRICE < CurrentPosition.PosData.Prev_Price then
         begin // market is going DOWN
           if NOT SHORT_PosOpen then
             begin
                // update LONG START PRICE (START_PRICE_MIN)
                if CurrentPosition.PosData.START_PRICE_MIN > CurrentPosition.PosData.Algorithm_Price then
                     CurrentPosition.PosData.START_PRICE_MIN := CurrentPosition.PosData.Algorithm_Price;
                // update position
                UpdatePosition;
             end;
         end
       else
         begin // market is going UP
           if NOT LONG_PosOpen then
             begin
                // update SHORT START PRICE (START_PRICE_MAX)
                if CurrentPosition.PosData.START_PRICE_MAX < CurrentPosition.PosData.Algorithm_Price then
                     CurrentPosition.PosData.START_PRICE_MAX := CurrentPosition.PosData.Algorithm_Price;
                // update position
                UpdatePosition;
             end;
         end
     end;
   end;

end;

procedure TAlgorithm.Calc_LONG_STOP_LOSS;
begin
  if NOT CurrentPosition.PosData.b_Stop_Real then
   CurrentPosition.PosData.STOP_PRICE := CurrentPosition.PosData.Algorithm_Price * (1 + (CurrentPosition.PosParams.STOP_PERCENT / 100))
  else
   CurrentPosition.PosData.STOP_PRICE := CurrentPosition.PosData.LAST_BUY_PRICE * (1 + (CurrentPosition.PosParams.STOP_PERCENT / 100));
end;

procedure TAlgorithm.Calc_SHRT_STOP_LOSS;
begin
  if NOT CurrentPosition.PosData.b_Stop_Real then
   CurrentPosition.PosData.STOP_PRICE := CurrentPosition.PosData.Algorithm_Price * (1 + (CurrentPosition.PosParams.SHORT_STOP_PERCENT / 100))
  else
   CurrentPosition.PosData.STOP_PRICE := CurrentPosition.PosData.LAST_SELL_PRICE * (1 + (CurrentPosition.PosParams.SHORT_STOP_PERCENT / 100));
end;

procedure TAlgorithm._SetNewPrice;
var
  i_prev_nr_prices:integer;
begin


  NewPriceCPos.PosData.Prev_Price := NewPriceCPos.PosData.LAST_MARKET_PRICE;
  NewPriceCPos.PosData.Prev_Market_Time := NewPriceCPos.PosData.MARKET_TIME;
  NewPriceCPos.PosData.MARKET_TIME := NewPriceMRes.d_time;
  NewPriceCPos.PosData.LAST_MARKET_PRICE := NewPriceMRes.f_price;
  NewPriceCPos.PosData.last_operation_milis := NewPriceMRes.milis;

  if NewPriceCPos.PosParams.RESET_AVERAGE then
    if NewPriceAction<>'' then
      begin
          dm_Main.ResetAverage(NewPriceCPos);
      end;

  if NewPriceCPos.PosData.MARKET_TIME < NewPriceCPos.PosData.Prev_Market_Time then
    begin
      NewPriceCPos.PosData.MARKET_TIME := NewPriceCPos.PosData.Prev_Market_Time;
    end;


  if NewPriceCPos.PosParams.NR_AVG = 0 then
  begin
     NewPriceCPos.PosData.Algorithm_Price := NewPriceMRes.f_price; // set algorithm price as current price by default if no average
     dm_Main.AddPriceHistory(NewPriceCPos, NewPriceAction);
     exit;   // exit algorithm if no average is needed for current position
  end
  else
     NewPriceCPos.PosData.Algorithm_Price := NewPriceCPos.PosData.AVERAGE_PRICE; // set algorithm previous AVERAGE

  ///
  //   CalsAverage is AN OPTION !!! MUST TEST IT !!!
  ///



  if NewPriceCPos.PosParams.TIME_AVERAGE  or (NewPriceCPos.PosData.LAST_MARKET_PRICE <> NewPriceCPos.PosData.Prev_Price)then
  begin

    i_prev_nr_prices:= NewPriceCPos.PosData.NR_REC_PRICES;
    if NewPriceCPos.PosData.NR_REC_PRICES < NewPriceCPos.PosParams.NR_AVG then
      NewPriceCPos.PosData.NR_REC_PRICES := NewPriceCPos.PosData.NR_REC_PRICES +1;

    dm_Main.CalcGenericAverage(NewPriceCPos,i_prev_nr_prices);
    dm_Main.CalcStand32Average(NewPriceCPos);

    if NewPriceCPos.PosParams.NR_AVG <= 32 then
     begin
       if NewPriceCPos.PosParams.USE_EMA then
        NewPriceCPos.PosData.AVERAGE_PRICE := NewPriceCPos.PosData.EMA_PRICE
       else
        NewPriceCPos.PosData.AVERAGE_PRICE := NewPriceCPos.PosData.SMA_PRICE;
     end
    else
      NewPriceCPos.PosData.AVERAGE_PRICE := NewPriceCPos.PosData.EMA_PRICE;


    NewPriceCPos.PosData.Algorithm_Price := NewPriceCPos.PosData.AVERAGE_PRICE;
    dm_Main.AddPriceHistory(NewPriceCPos,  NewPriceAction);
  end
  else    // NO MARKET CHANGE OR NO TIME AVERAGE - just add history IF NewPriceAction not empty
   if NewPriceAction <>'' then
     dm_Main.AddPriceHistory(NewPriceCPos, NewPriceAction);


end;

procedure TAlgorithm.SetNewPrice(var CPos: TMarketPosition; mres: TMarketMessage; str_action:string='');
begin
 NewPriceAction := str_action;
 NewPriceCPos := CPos;
 NewPriceMRes := mres;

 Synchronize(@_SetNewPrice);

 CPos:=NewPriceCPos;

end;



end.

