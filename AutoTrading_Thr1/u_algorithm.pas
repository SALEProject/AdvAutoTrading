unit u_algorithm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, u_dm_main, u_finance_request, DateUtils;

const _LONG_ONLY = false;

const _ENTER_STANDBY_AFTER_STOP = true;

type

{ TAlgorithm }

 TAlgorithm = class (TThread)
                       private
                         action: string;
                         indicator: string;
                         state: string;
                         force_sell: Boolean;
                         isProtectionZone: Boolean;
                         PrevPosition: TMarketPosition;
                         historyPrice, profitloss : double;

                         //  added Dan 20141015
                         Connector: TExchangeConnector;

                         {START sync procedures}
                         str_HistoryAction:string;
                         str_HistoryState:string;
                         HistoryCPos:TMarketPosition;


                         procedure _UpdatePosition;
                         procedure _UpdateHistory;
                         procedure _GetCurrentPosition;
                         procedure  _SyncBuy;
                         procedure  _SyncSell;
                         {END sync procedures}

                         //-----------------------------------------------------
                         //  added Dan 20141015
                         //  replacement for sync routines
                         function ThrGetRealTime(var CPos: TMarketPosition):boolean;
                         function ThrMarketBuy(var CPos: TMarketPosition): TMarketMessage;
                         function ThrMarketSell(var CPos: TMarketPosition): TMarketMessage;
                         //-----------------------------------------------------

                         {START sync wrappers}
                         procedure UpdatePosition;
                         procedure UpdateHistory(str_Action, str_State:string; CPos:TMarketPosition);
                         procedure MarketUpdateCurrentPosition;
                         function  BuyAtMarket(var CPos:TMarketPosition): TMarketMessage;
                         function  SellAtMarket(var CPos:TMarketPosition): TMarketMessage;
                         {END sync procedures wrappers}

                         procedure RunAlgorithm;

                       protected
                         BuyCPos, SellCPos:TMarketPosition;
                         BuyResult,SellResult:TMarketMessage;

                         procedure Execute; override;

                       public
                         CurrentPosition : TMarketPosition;

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

                         procedure ResetAverage;

                  end;

implementation

constructor TAlgorithm.Create(CPos: TMarketPosition);
begin
  //  added Dan 20141015
  Connector:= dm_Main.CreateExchangeConnector;

  CurrentPosition  := CPos;
  PAUSED := False;

  LONG_ONLY := _LONG_ONLY;

  action:= '';
  historyPrice:= 0;
  indicator:= '';
  state:= '';
  profitLoss:= 0;
  Inherited Create(TRUE);
end;

procedure TAlgorithm._LONG_Run;
var
  i: integer;

begin

   if not CurrentPosition.ACTIVE then Exit; { exit if not active }

   { get data and update cals}
   PrevPosition := CurrentPosition;         { save previous position }

   T1_Start := Now;
   MarketUpdateCurrentPosition;   { get new position quote }
   T1_Stop := Now;

   T2_Start := Now;
   LONG_Recalc;                             { recalc indicators }
   T2_Stop := Now;
   { done get data and update cals}

      if not CurrentPosition.OPENED then
      begin
         if CurrentPosition.FORCE_BUY then
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
          if CurrentPosition.CLOSE_NOW_AT_MARKET then
          begin
            LONG_ForceClose;
            // do some post-FORCE-close action...
          end
          else
          if LONG_PosTake then { Check Take Profit and commit }
          begin
             // dome some POST take profit action
          end
          else
          if LONG_PosProtection then {Check "Protection" and commit }
          begin
             // do some POST protection close action (stock going down !)
             force_sell := True;
             if CurrentPosition.RE_OPEN then
                 SHORT_ForceSell; // REOPEN IN REVERSE !
          end
          else
          if LONG_PosStopLoss then  {check stop loss and commit}
          begin
             // do some POST STOP LOSS close action (stock going down !)

             if NOT _ENTER_STANDBY_AFTER_STOP then
             begin
               force_sell := True;
               if CurrentPosition.RE_OPEN then
                   SHORT_ForceSell; // REOPEN IN REVERSE !\
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

   if not CurrentPosition.ACTIVE then Exit; { exit if not active }

   { get data and update cals}
   PrevPosition := CurrentPosition;         { save previous position }

   T1_Start := Now;
   MarketUpdateCurrentPosition;   { get new position quote }
   T1_Stop := Now;

   T2_Start := Now;
   SHORT_Recalc;                             { recalc indicators }
   T2_Stop := Now;
   { done get data and update cals}

   if not CurrentPosition.OPENED then
      begin
        if not SHORT_PosOpen then
              UpdatePosition;
      end
      else { if opened...}
      begin
         if CurrentPosition.CLOSE_NOW_AT_MARKET then
         begin
           SHORT_ForceClose;
           // do some post-FORCE-close action...
         end
         else
         if SHORT_PosTake then { Check Take Profit and commit }
         begin
            // dome some POST take profit action
         end
         else
         if SHORT_PosProtection then {Check "Protection" and commit }
         begin
            // do some POST protection close action (stock going UP !)
            CurrentPosition.FORCE_BUY := True;
            if CurrentPosition.RE_OPEN then
                LONG_ForceBuy; // REOPEN IN REVERSE !
         end
         else
         if SHORT_PosStopLoss then  {check stop loss and commit}
         begin
            // do some POST STOP LOSS close action (stock going down !)
            if NOT _ENTER_STANDBY_AFTER_STOP then
            begin
              CurrentPosition.force_buy := True;
              if CurrentPosition.RE_OPEN then
                  LONG_ForceBuy; // REOPEN IN REVERSE !
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
   if(CurrentPosition.FORCE_BUY) then
   begin
        //send buy command
        mres:= BuyAtMarket(CurrentPosition);
        CurrentPosition.FORCE_BUY := False;
        if mres.f_price > 0 then
        begin
           CurrentPosition.TEMP_ID := Int64(TimeStampToMSecs(DateTimeToTimeStamp(Now)));
           CurrentPosition.OPENED := true;;
           CurrentPosition.isProtection := False;

           // update position status
           CurrentPosition.PREV_DIRECTION := CurrentPosition.DIRECTION;
           CurrentPosition.DIRECTION := TPositionDirection.LONG;

           // update position protection start and stop loss
           CurrentPosition.PROT_START_PRICE := CurrentPosition.Algorithm_Price *(1+(CurrentPosition.PROT_MARGIN/100)) ;
           CurrentPosition.STOP_PRICE := CurrentPosition.Algorithm_Price * (1 + (CurrentPosition.STOP_PERCENT / 100));

           //update record
           UpdatePosition;
           //update history
           UpdateHistory('LONG BUY','L_FORCE',CurrentPosition);
        end;

   end;
end;

function TAlgorithm.LONG_PosOpen:boolean;
var
   mres: TMarketMessage;
   bRes:boolean;
begin
  bRes := False;
  if (CurrentPosition.OPENED) or (CurrentPosition.Algorithm_Price <=0) then
  begin
    Result := bRes;
    Exit;
  end;

  if CurrentPosition.PREV_DIRECTION <> TPositionDirection.STANDBY then
    CurrentPosition.Open_Price := CurrentPosition.START_PRICE_MIN * (1 + (CurrentPosition.RE_OPEN_PERCENT / 100 ))
  else
    CurrentPosition.Open_Price := CurrentPosition.START_PRICE_MIN * (1 + (CurrentPosition.OPEN_PERCENT / 100 ));

  if (CurrentPosition.OPEN_PERCENT  > 0) then
  begin
       if(CurrentPosition.Open_Price <= CurrentPosition.Algorithm_Price) then
       begin
         //send buy command
         mres := BuyAtMarket( CurrentPosition);
         if mres.f_price > 0 then
         begin
            CurrentPosition.TEMP_ID := Int64(TimeStampToMSecs(DateTimeToTimeStamp(Now)));
            CurrentPosition.OPENED := true;
            CurrentPosition.isProtection := False;

            // update position status
            CurrentPosition.PREV_DIRECTION := CurrentPosition.DIRECTION;
            CurrentPosition.DIRECTION := TPositionDirection.LONG;

            // update position protection start and stop loss
            CurrentPosition.PROT_START_PRICE := CurrentPosition.Algorithm_Price *(1+(CurrentPosition.PROT_MARGIN/100)) ;
            CurrentPosition.STOP_PRICE := CurrentPosition.Algorithm_Price * (1 + (CurrentPosition.STOP_PERCENT / 100));

            UpdatePosition;
            bRes := True;

            //update history
            UpdateHistory('L BUY @'+FormatFloat('0.00', mres.f_price)+
                          '/'+FormatFloat('0.00', CurrentPosition.Algorithm_Price)+
                          '>='+FormatFloat('0.00', CurrentPosition.Open_Price),
                          'L_OPEN',CurrentPosition);
         end;
       end;
  end
  else
  begin
       if(CurrentPosition.Open_Price >= CurrentPosition.Algorithm_Price) then
       begin
         //send buy command
         mres := BuyAtMarket( CurrentPosition);
         if mres.f_price > 0 then
         begin
            CurrentPosition.TEMP_ID := Int64(TimeStampToMSecs(DateTimeToTimeStamp(Now)));
            CurrentPosition.OPENED := true;;
            CurrentPosition.isProtection := False;

            // update position status
            CurrentPosition.PREV_DIRECTION := CurrentPosition.DIRECTION;
            CurrentPosition.DIRECTION := TPositionDirection.LONG;

            // update position protection start and stop loss
            CurrentPosition.PROT_START_PRICE := CurrentPosition.Algorithm_Price *(1+(CurrentPosition.PROT_MARGIN/100)) ;
            CurrentPosition.STOP_PRICE := CurrentPosition.Algorithm_Price * (1 + (CurrentPosition.STOP_PERCENT / 100));

            UpdatePosition;
            bRes := True;

            //update history
            UpdateHistory('L BUY @'+FormatFloat('0.00', mres.f_price)+
                          '/'+FormatFloat('0.00', CurrentPosition.Algorithm_Price)+
                          '<='+FormatFloat('0.00', CurrentPosition.Open_Price),
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
  if (CurrentPosition.Algorithm_Price <=0) then
  begin
    Result := bRes;
    Exit;
  end;

  CurrentPosition.Take_Price  := CurrentPosition.LAST_BUY_PRICE * (1 + (CurrentPosition.TAKE_PERCENT / 100));

//  if(CurrentPosition.Algorithm_Price >= CurrentPosition.Take_Price) then
  if(CurrentPosition.LAST_MARKET_PRICE >= CurrentPosition.Take_Price) then
  begin
       //send sell command
       mres := SellAtMarket(CurrentPosition);

       if mres.f_price > 0 then
       begin
          CurrentPosition.OPENED := false;
          CurrentPosition.Current_PL := CurrentPosition.LAST_SELL_PRICE*CurrentPosition.VOLUME - CurrentPosition.LAST_BUY_PRICE * CurrentPosition.VOLUME;
          CurrentPosition.TOTAL_PL := CurrentPosition.TOTAL_PL + CurrentPosition.Current_PL;

          CurrentPosition.START_PRICE_MIN := CurrentPosition.Algorithm_Price ;//CurrentPosition.LAST_SELL_PRICE ;
          CurrentPosition.START_PRICE_MAX := CurrentPosition.START_PRICE_MIN ;

          // update position status
          CurrentPosition.PREV_DIRECTION := CurrentPosition.DIRECTION;
          CurrentPosition.DIRECTION := TPositionDirection.STANDBY;

          UpdatePosition;

          //update history
          UpdateHistory('L SELL @'+FormatFloat('0.00', mres.f_price)+
                        //'/'+FormatFloat('0.00', CurrentPosition.Algorithm_Price)+
                        '/'+FormatFloat('0.00', CurrentPosition.LAST_MARKET_PRICE)+
                        '>='+FormatFloat('0.00', CurrentPosition.Take_Price),
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
begin
  bRes:= False;
  if (CurrentPosition.Algorithm_Price <=0) then
  begin
    Result := bRes;
    Exit;
  end;

  CurrentPosition.Prot_Correction_Price := CurrentPosition.PROT_START_PRICE *  (1 + (CurrentPosition.PROT_CORECT / 100));

  if NOT CurrentPosition.isProtection then
  begin
      if CurrentPosition.Algorithm_Price >= CurrentPosition.PROT_START_PRICE  then {check if protection needed}
       begin
         CurrentPosition.isProtection := true;
         CurrentPosition.PROT_START_PRICE := CurrentPosition.Algorithm_Price;
         CurrentPosition.Prot_Correction_Price := CurrentPosition.PROT_START_PRICE *  (1 + (CurrentPosition.PROT_CORECT / 100));
         UpdateHistory('(LIP) Max='+FormatFloat('0.00', CurrentPosition.PROT_START_PRICE)+' Sell='+FormatFloat('0.00', CurrentPosition.Prot_Correction_Price),'L_PROT',CurrentPosition);
       end;
  end;

  if CurrentPosition.isProtection then
  begin
       if (CurrentPosition.Algorithm_Price > CurrentPosition.PROT_START_PRICE) then {update protection values}
        begin
          CurrentPosition.PROT_START_PRICE := CurrentPosition.Algorithm_Price;
          CurrentPosition.Prot_Correction_Price := CurrentPosition.PROT_START_PRICE *  (1 + (CurrentPosition.PROT_CORECT / 100));
          UpdateHistory('(LUP) Max='+FormatFloat('0.00', CurrentPosition.PROT_START_PRICE)+' Sell='+FormatFloat('0.00', CurrentPosition.Prot_Correction_Price),'L_PROT',CurrentPosition);
        end;
  end;


  if((CurrentPosition.Algorithm_Price <= CurrentPosition.Prot_Correction_Price) and (CurrentPosition.isProtection)) then
  begin
     //send sell command
     mres := SellAtMarket(CurrentPosition);

     if mres.f_price<> -1 then
     begin
        CurrentPosition.OPENED := false;
        CurrentPosition.Current_PL := CurrentPosition.LAST_SELL_PRICE*CurrentPosition.VOLUME - CurrentPosition.LAST_BUY_PRICE * CurrentPosition.VOLUME;;
        CurrentPosition.TOTAL_PL := CurrentPosition.TOTAL_PL + CurrentPosition.Current_PL;

        CurrentPosition.START_PRICE_MIN := CurrentPosition.Algorithm_Price;
        CurrentPosition.START_PRICE_MAX := CurrentPosition.START_PRICE_MIN ;

        // update position status
        CurrentPosition.PREV_DIRECTION := CurrentPosition.DIRECTION;
        CurrentPosition.DIRECTION := TPositionDirection.STANDBY;

        UpdatePosition;

        //update history
        UpdateHistory('L SELL @'+FormatFloat('0.00', mres.f_price)+
                      '/'+FormatFloat('0.00', CurrentPosition.Algorithm_Price)+
                      '<='+FormatFloat('0.00', CurrentPosition.Prot_Correction_Price),
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
begin
  bRes:= false;
  if (CurrentPosition.Algorithm_Price <=0) then
  begin
    Result := bRes;
    Exit;
  end;


  if(CurrentPosition.Algorithm_Price <= CurrentPosition.STOP_PRICE) then
  begin
    //send sell command
    mres := SellAtMarket(CurrentPosition);

    if mres.f_price > 0 then
    begin
       CurrentPosition.OPENED := false;
       CurrentPosition.Current_PL := CurrentPosition.LAST_SELL_PRICE*CurrentPosition.VOLUME - CurrentPosition.LAST_BUY_PRICE * CurrentPosition.VOLUME;
       CurrentPosition.TOTAL_PL := CurrentPosition.TOTAL_PL + CurrentPosition.Current_PL;

       CurrentPosition.START_PRICE_MIN := CurrentPosition.Algorithm_Price;
       CurrentPosition.START_PRICE_MAX := CurrentPosition.START_PRICE_MIN ;

       // update position status
       CurrentPosition.PREV_DIRECTION := CurrentPosition.DIRECTION;
       CurrentPosition.DIRECTION := TPositionDirection.STANDBY;

       UpdatePosition;

       //update history
       UpdateHistory('L SELL @'+FormatFloat('0.00', mres.f_price)+
                     '/'+FormatFloat('0.00', CurrentPosition.Algorithm_Price)+
                     '<='+FormatFloat('0.00', CurrentPosition.STOP_PRICE),
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
  if CurrentPosition.LAST_MARKET_PRICE <=0 then { check if some errow occured }
   begin
     UpdateHistory('ERROR','MARKET_PRICE',CurrentPosition);
     CurrentPosition.Take_Price  := CurrentPosition.LAST_BUY_PRICE * (1 + (CurrentPosition.TAKE_PERCENT / 100));
     exit;
   end;

  if CurrentPosition.START_PRICE_MIN = 0 then
   begin
     CurrentPosition.START_PRICE_MIN := CurrentPosition.Algorithm_Price; { initialize start price }
     CurrentPosition.START_PRICE_MAX := CurrentPosition.START_PRICE_MIN ;

     UpdateHistory('INIT START PRICE','L_OPEN',CurrentPosition);
   end;

  CurrentPosition.Take_Price  := CurrentPosition.LAST_BUY_PRICE * (1 + (CurrentPosition.TAKE_PERCENT / 100));
  CurrentPosition.Open_Price  := CurrentPosition.START_PRICE_MIN * (1 + (CurrentPosition.OPEN_PERCENT / 100 ));


  if CurrentPosition.OPENED then
  begin
    CurrentPosition.Open_Value := CurrentPosition.LAST_BUY_PRICE * CurrentPosition.VOLUME;
    CurrentPosition.Market_Value := CurrentPosition.LAST_MARKET_PRICE * CurrentPosition.VOLUME;
    CurrentPosition.Current_PL := CurrentPosition.Market_Value - CurrentPosition.Open_Value;
  end
  else
  begin // IF POSITION NOT OPENED >>>>
    CurrentPosition.Open_Value := 0;
    CurrentPosition.Current_PL := 0;
    CurrentPosition.isProtection := false;
    if (CurrentPosition.Algorithm_Price < CurrentPosition.START_PRICE_MIN) then {check if market below start - LONG ONLY - }
      begin
        CurrentPosition.START_PRICE_MIN := CurrentPosition.Algorithm_Price;
        CurrentPosition.Open_Price  := CurrentPosition.START_PRICE_MIN * (1 + (CurrentPosition.OPEN_PERCENT / 100 ));
        UpdateHistory('(LUO) Min='+FormatFloat('0.00', CurrentPosition.START_PRICE_MIN)+' Buy='+FormatFloat('0.00', CurrentPosition.Open_Price),'L_OPEN',CurrentPosition);
      end;
  end;
end;

function TAlgorithm.LONG_ForceClose: boolean;
var
   bRes : boolean;
   mres: TMarketMessage;

begin
  bRes := false;
  if (CurrentPosition.Algorithm_Price <=0) then
  begin
    Result := bRes;
    Exit;
  end;

  if NOT CurrentPosition.CLOSE_NOW_AT_MARKET then
   exit;


  //send sell command
  mres := SellAtMarket(CurrentPosition);

  if mres.f_price > 0 then
  begin
          CurrentPosition.OPENED := false;
          CurrentPosition.Current_PL := CurrentPosition.LAST_SELL_PRICE*CurrentPosition.VOLUME - CurrentPosition.LAST_BUY_PRICE * CurrentPosition.VOLUME;
          CurrentPosition.TOTAL_PL := CurrentPosition.TOTAL_PL + CurrentPosition.Current_PL;

          CurrentPosition.START_PRICE_MIN := CurrentPosition.LAST_SELL_PRICE ;
          CurrentPosition.START_PRICE_MAX := CurrentPosition.START_PRICE_MIN ;

          CurrentPosition.CLOSE_NOW_AT_MARKET := False;

          ResetAverage;

          // update position status
          CurrentPosition.PREV_DIRECTION := CurrentPosition.DIRECTION;
          CurrentPosition.DIRECTION := TPositionDirection.STANDBY;

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
          mres:= SellAtMarket(CurrentPosition);
          force_sell := False;
          if mres.f_price > 0 then
          begin
             CurrentPosition.TEMP_ID := Int64(TimeStampToMSecs(DateTimeToTimeStamp(Now)));
             CurrentPosition.OPENED := true;
             CurrentPosition.isProtection := False;

             // update position status
             CurrentPosition.PREV_DIRECTION := CurrentPosition.DIRECTION;
             CurrentPosition.DIRECTION := TPositionDirection.SHORT;

             // update position protection start !
             CurrentPosition.PROT_START_PRICE := CurrentPosition.Algorithm_Price *(1+(CurrentPosition.SHORT_PROT_MARGIN /100)) ;
             CurrentPosition.STOP_PRICE := CurrentPosition.Algorithm_Price * (1 + (CurrentPosition.SHORT_STOP_PERCENT / 100));

             //update record
             UpdatePosition;
             //update history
             UpdateHistory('SHORT SELL','S_FORCE',CurrentPosition);
          end;

     end;
end;

function TAlgorithm.SHORT_PosOpen: boolean;
var
   mres: TMarketMessage;
   bRes:boolean;
begin
  bRes := False;
  if (CurrentPosition.OPENED) or (CurrentPosition.Algorithm_Price <=0) then
  begin
    Result := bRes;
    Exit;
  end;

  if CurrentPosition.PREV_DIRECTION <> TPositionDirection.STANDBY then
    CurrentPosition.Open_Price := CurrentPosition.START_PRICE_MAX * (1 + (CurrentPosition.SHORT_RE_OPEN_PERCENT / 100 ))
  else
    CurrentPosition.Open_Price := CurrentPosition.START_PRICE_MAX * (1 + (CurrentPosition.SHORT_OPEN_PERCENT / 100 ));


  if(CurrentPosition.Open_Price >= CurrentPosition.Algorithm_Price) then
       begin
         //send SELL command (open SHORT position)
         mres := SellAtMarket( CurrentPosition);
         if mres.f_price > 0 then
         begin
            CurrentPosition.TEMP_ID := Int64(TimeStampToMSecs(DateTimeToTimeStamp(Now)));

            CurrentPosition.OPENED := true;
            CurrentPosition.isProtection := False;

            // update position status
            CurrentPosition.PREV_DIRECTION := CurrentPosition.DIRECTION;
            CurrentPosition.DIRECTION := TPositionDirection.SHORT;

            // update position protection start !
            CurrentPosition.PROT_START_PRICE := CurrentPosition.Algorithm_Price *(1+(CurrentPosition.SHORT_PROT_MARGIN /100)) ;
            CurrentPosition.STOP_PRICE := CurrentPosition.Algorithm_Price * (1 + (CurrentPosition.SHORT_STOP_PERCENT / 100));

            UpdatePosition;
            bRes := True;

            //update history
            UpdateHistory('S SELL @'+FormatFloat('0.00', mres.f_price)+
                          '/'+FormatFloat('0.00', CurrentPosition.Algorithm_Price)+
                          '<='+FormatFloat('0.00', CurrentPosition.Open_Price),
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
  if (CurrentPosition.Algorithm_Price <=0) then
  begin
    Result := bRes;
    Exit;
  end;

  CurrentPosition.Take_Price  := CurrentPosition.LAST_SELL_PRICE * (1 + (CurrentPosition.SHORT_TAKE_PERCENT / 100));

//  if(CurrentPosition.Algorithm_Price <= CurrentPosition.Take_Price) then
  if(CurrentPosition.LAST_MARKET_PRICE <= CurrentPosition.Take_Price) then
  begin
       //send BUY command (to close SHORT position)
       mres := BuyAtMarket(CurrentPosition);

       if mres.f_price > 0 then
       begin
          CurrentPosition.OPENED := false;
          CurrentPosition.Current_PL := CurrentPosition.LAST_SELL_PRICE*CurrentPosition.VOLUME - CurrentPosition.LAST_BUY_PRICE * CurrentPosition.VOLUME;
          CurrentPosition.TOTAL_PL := CurrentPosition.TOTAL_PL + CurrentPosition.Current_PL;

          CurrentPosition.START_PRICE_MAX := CurrentPosition.Algorithm_Price; //CurrentPosition.LAST_BUY_PRICE;
          CurrentPosition.START_PRICE_MIN := CurrentPosition.START_PRICE_MAX;

          // update position status
          CurrentPosition.PREV_DIRECTION := CurrentPosition.DIRECTION;
          CurrentPosition.DIRECTION := TPositionDirection.STANDBY;

          UpdatePosition;

          //update history
          UpdateHistory('S BUY @'+FormatFloat('0.00', mres.f_price)+
                        //'/'+FormatFloat('0.00', CurrentPosition.Algorithm_Price)+
                        '/'+FormatFloat('0.00', CurrentPosition.LAST_MARKET_PRICE)+
                        '<='+FormatFloat('0.00', CurrentPosition.Take_Price),
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
begin
  bRes:= False;
  if (CurrentPosition.Algorithm_Price <=0) then
  begin
    Result := bRes;
    Exit;
  end;

  CurrentPosition.Prot_Correction_Price := CurrentPosition.PROT_START_PRICE *  (1 + (CurrentPosition.SHORT_PROT_CORECT / 100));

  if NOT CurrentPosition.isProtection then
  begin
    if CurrentPosition.Algorithm_Price <= CurrentPosition.PROT_START_PRICE then {check if protection needed}
     begin
       CurrentPosition.isProtection := true;
       CurrentPosition.PROT_START_PRICE := CurrentPosition.Algorithm_Price;
       CurrentPosition.Prot_Correction_Price := CurrentPosition.PROT_START_PRICE *  (1 + (CurrentPosition.SHORT_PROT_CORECT / 100));
       UpdateHistory('(SIP) Min='+FormatFloat('0.00', CurrentPosition.PROT_START_PRICE)+' Buy='+FormatFloat('0.00', CurrentPosition.Prot_Correction_Price),'S_PROT',CurrentPosition);
     end;
  end;

  if CurrentPosition.isProtection then
   begin
     if (CurrentPosition.Algorithm_Price < CurrentPosition.PROT_START_PRICE) then {update protection values}
      begin
        CurrentPosition.PROT_START_PRICE := CurrentPosition.Algorithm_Price;
        CurrentPosition.Prot_Correction_Price := CurrentPosition.PROT_START_PRICE *  (1 + (CurrentPosition.SHORT_PROT_CORECT / 100));
        UpdateHistory('(SUP) Min='+FormatFloat('0.00', CurrentPosition.PROT_START_PRICE)+' Buy='+FormatFloat('0.00', CurrentPosition.Prot_Correction_Price),'S_PROT',CurrentPosition);
      end;
   end;


  if((CurrentPosition.Algorithm_Price >= CurrentPosition.Prot_Correction_Price) and (CurrentPosition.isProtection)) then
  begin
     //send BUY command to close SHORT
     mres := BuyAtMarket(CurrentPosition);

     if mres.f_price<> -1 then
     begin
        CurrentPosition.OPENED := false;
        CurrentPosition.Current_PL := CurrentPosition.LAST_SELL_PRICE*CurrentPosition.VOLUME - CurrentPosition.LAST_BUY_PRICE * CurrentPosition.VOLUME;;
        CurrentPosition.TOTAL_PL := CurrentPosition.TOTAL_PL + CurrentPosition.Current_PL;

        CurrentPosition.START_PRICE_MAX := CurrentPosition.Algorithm_Price;
        CurrentPosition.START_PRICE_MIN := CurrentPosition.START_PRICE_MAX;

        // update position status
        CurrentPosition.PREV_DIRECTION := CurrentPosition.DIRECTION;
        CurrentPosition.DIRECTION := TPositionDirection.STANDBY;

        UpdatePosition;

        //update history
        UpdateHistory('S BUY @'+FormatFloat('0.00', mres.f_price)+
                      '/'+FormatFloat('0.00', CurrentPosition.Algorithm_Price)+
                      '>='+FormatFloat('0.00', CurrentPosition.Prot_Correction_Price),
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
begin
  bRes:= false;
  if (CurrentPosition.Algorithm_Price <=0) then
  begin
    Result := bRes;
    Exit;
  end;


  if(CurrentPosition.Algorithm_Price >= CurrentPosition.STOP_PRICE) then
  begin
    //send BUY command (to close SHORT position)
    mres := BuyAtMarket(CurrentPosition);

    if mres.f_price > 0 then
    begin
       CurrentPosition.OPENED := false;
       CurrentPosition.Current_PL := CurrentPosition.LAST_SELL_PRICE*CurrentPosition.VOLUME - CurrentPosition.LAST_BUY_PRICE * CurrentPosition.VOLUME;
       CurrentPosition.TOTAL_PL := CurrentPosition.TOTAL_PL + CurrentPosition.Current_PL;

       CurrentPosition.START_PRICE_MAX := CurrentPosition.Algorithm_Price ;
       CurrentPosition.START_PRICE_MIN := CurrentPosition.START_PRICE_MAX;

       // update position status
       CurrentPosition.PREV_DIRECTION := CurrentPosition.DIRECTION;
       CurrentPosition.DIRECTION := TPositionDirection.STANDBY;

       UpdatePosition;

       //update history
       UpdateHistory('S BUY @'+FormatFloat('0.00', mres.f_price)+
                     '/'+FormatFloat('0.00', CurrentPosition.Algorithm_Price)+
                     '>='+FormatFloat('0.00', CurrentPosition.STOP_PRICE),
                     'S_STOP',CurrentPosition);

       bRes := true;
    end;
  end;
  Result := bRes;
end;

procedure TAlgorithm.SHORT_Recalc;
begin
  if CurrentPosition.LAST_MARKET_PRICE <=0 then { check if some errow occured }
   begin
     UpdateHistory('ERROR','MARKET_PRICE',CurrentPosition);
     CurrentPosition.Take_Price  := CurrentPosition.LAST_SELL_PRICE * (1 + (CurrentPosition.SHORT_TAKE_PERCENT / 100));
     exit;
   end;

  if CurrentPosition.START_PRICE_MAX = 0 then
   begin
     CurrentPosition.START_PRICE_MAX := CurrentPosition.Algorithm_Price ; { initialize start price }
     CurrentPosition.START_PRICE_MIN := CurrentPosition.START_PRICE_MAX;

     UpdateHistory('INIT START PRICE','S_OPEN',CurrentPosition);
   end;

  CurrentPosition.Take_Price  := CurrentPosition.LAST_SELL_PRICE * (1 + (CurrentPosition.SHORT_TAKE_PERCENT / 100));
  CurrentPosition.Open_Price  := CurrentPosition.START_PRICE_MAX * (1 + (CurrentPosition.SHORT_OPEN_PERCENT / 100 ));
  CurrentPosition.Prot_Correction_Price := CurrentPosition.PROT_START_PRICE *  (1 + (CurrentPosition.SHORT_PROT_CORECT / 100));


  if CurrentPosition.OPENED then
  begin
    CurrentPosition.Open_Value := CurrentPosition.LAST_SELL_PRICE * CurrentPosition.VOLUME;
    CurrentPosition.Market_Value := CurrentPosition.LAST_MARKET_PRICE * CurrentPosition.VOLUME;
    CurrentPosition.Current_PL := CurrentPosition.Open_Value - CurrentPosition.Market_Value;
  end;
end;

function TAlgorithm.SHORT_ForceClose: boolean;
var
   bRes : boolean;
   mres: TMarketMessage;
begin
  bRes := false;
  if (CurrentPosition.Algorithm_Price <=0) then
  begin
    Result := bRes;
    Exit;
  end;

  if NOT CurrentPosition.CLOSE_NOW_AT_MARKET then
   exit;

  //send BUY command
  mres := BuyAtMarket(CurrentPosition);

  if mres.f_price > 0 then
  begin
          CurrentPosition.OPENED := false;
          CurrentPosition.Current_PL := CurrentPosition.LAST_SELL_PRICE*CurrentPosition.VOLUME - CurrentPosition.LAST_BUY_PRICE * CurrentPosition.VOLUME;
          CurrentPosition.TOTAL_PL := CurrentPosition.TOTAL_PL + CurrentPosition.Current_PL;

          CurrentPosition.START_PRICE_MIN := CurrentPosition.LAST_BUY_PRICE ;
          CurrentPosition.START_PRICE_MAX := CurrentPosition.START_PRICE_MIN ;

          CurrentPosition.CLOSE_NOW_AT_MARKET := False;

          ResetAverage;

          // update position status
          CurrentPosition.PREV_DIRECTION := CurrentPosition.DIRECTION;
          CurrentPosition.DIRECTION := TPositionDirection.STANDBY;

          UpdatePosition;

          //update history
          UpdateHistory('S BUY @'+FormatFloat('0.00', mres.f_price)+
                        ' (FORCED AT MARKET)',
                        'S_FORCE',CurrentPosition);

          bRes := true;
  end;
  Result := bRes;
end;

procedure TAlgorithm.ResetAverage;
begin
  {BEGIN mobile average RESET}
  CurrentPosition.NR_REC_PRICES := 0;
  CurrentPosition.AVERAGE_PRICE := 0;

  CurrentPosition.PREV_PRICE_1 := 0;
  CurrentPosition.PREV_PRICE_2 := 0;
  CurrentPosition.PREV_PRICE_3 := 0;
  CurrentPosition.PREV_PRICE_4 := 0;
  CurrentPosition.PREV_PRICE_5 := 0;
  CurrentPosition.PREV_PRICE_6 := 0;
  CurrentPosition.PREV_PRICE_7 := 0;
  CurrentPosition.PREV_PRICE_8 := 0;
  CurrentPosition.PREV_PRICE_9 := 0;
  CurrentPosition.PREV_PRICE_10 := 0;
  CurrentPosition.PREV_PRICE_11 := 0;
  CurrentPosition.PREV_PRICE_12 := 0;
  CurrentPosition.PREV_PRICE_13 := 0;
  CurrentPosition.PREV_PRICE_14 := 0;
  CurrentPosition.PREV_PRICE_15 := 0;
  CurrentPosition.PREV_PRICE_16 := 0;
  CurrentPosition.PREV_PRICE_17 := 0;
  CurrentPosition.PREV_PRICE_18 := 0;
  CurrentPosition.PREV_PRICE_19 := 0;
  CurrentPosition.PREV_PRICE_20 := 0;
  CurrentPosition.PREV_PRICE_21 := 0;
  CurrentPosition.PREV_PRICE_22 := 0;
  CurrentPosition.PREV_PRICE_23 := 0;
  CurrentPosition.PREV_PRICE_24 := 0;
  CurrentPosition.PREV_PRICE_25 := 0;
  CurrentPosition.PREV_PRICE_26 := 0;
  CurrentPosition.PREV_PRICE_27 := 0;
  CurrentPosition.PREV_PRICE_28 := 0;
  CurrentPosition.PREV_PRICE_29 := 0;
  CurrentPosition.PREV_PRICE_30 := 0;
  CurrentPosition.PREV_PRICE_31 := 0;
  CurrentPosition.PREV_PRICE_32 := 0;
  {END mobile average 32x}

end;


procedure TAlgorithm._UpdatePosition;
begin
// synchronized code !!!
  dm_Main.ModifyPosition(CurrentPosition);
end;

procedure TAlgorithm._UpdateHistory;
begin
  // synchronized code !!!
 dm_Main.AddHistory(str_HistoryAction, str_HistoryState,HistoryCPos,HistoryCPos.LAST_MARKET_PRICE);
end;

procedure TAlgorithm._GetCurrentPosition;
begin
  dm_Main.GetRealTime(CurrentPosition); // get market information
end;

procedure TAlgorithm._SyncBuy;
begin
  BuyResult  := dm_Main.MarketBuy(BuyCPos);
end;

procedure TAlgorithm._SyncSell;
begin
  SellResult := dm_Main.MarketSell(SellCPos);
end;


//------------------------------------------------------------------------------
//  added Dan 20141015
//  replacement for _symc routines

function TAlgorithm.ThrGetRealTime(var CPos: TMarketPosition):boolean;
var mres: TMarketMessage;
begin
  if Connector = nil then Exit;
  if CPos.SYMBOL ='' then exit ;

  mres := Connector._GetQuote(CPos.MARKET,CPos.SYMBOL);

  if mres.f_price < 0 then
  begin
    Result := False;
    exit;
  end;

  CPos.Take_Price := -1;
  CPos.Prot_Correction_Price := -1;

  dm_Main.SetNewPrice(CPos,mres);

  Result := True;
end;

function TAlgorithm.ThrMarketBuy(var CPos: TMarketPosition): TMarketMessage;
var
   mres: TMarketMessage;
begin
  if Connector = nil then Exit;

  mres:= Connector.MarketBuy(CPos.MARKET,CPos.SYMBOL,CPos.VOLUME);

  if mres.f_price < 0 then
  begin
    Result := mres;
    exit;
  end;

  CPos.LAST_BUY_PRICE := mres.f_price;

  dm_Main.SetNewPrice(CPos, mres, 'BUY');

  Result:= mres;
end;

function TAlgorithm.ThrMarketSell(var CPos: TMarketPosition): TMarketMessage;
var
   mres: TMarketMessage;
begin
  if Connector = nil then Exit;

  mres:= Connector.MarketSell(CPos.MARKET,CPos.SYMBOL,CPos.VOLUME);

  if mres.f_price < 0 then
  begin
    Result := mres;
    exit;
  end;

  CPos.LAST_SELL_PRICE := mres.f_price;

  dm_Main.SetNewPrice(CPos, mres, 'SELL');


  Result:= mres;
end;

//------------------------------------------------------------------------------


procedure TAlgorithm.UpdatePosition;
begin
  Synchronize(@_UpdatePosition);
end;

procedure TAlgorithm.UpdateHistory(str_Action, str_State: string; CPos: TMarketPosition);
begin
  str_HistoryAction := str_Action ;
  str_HistoryState := str_State;
  HistoryCPos := CPos;
  Synchronize(@_UpdateHistory);
end;

procedure TAlgorithm.MarketUpdateCurrentPosition;
begin
  //Synchronize(@_GetCurrentPosition);
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

procedure TAlgorithm.Execute;
begin
 while (not Terminated) do
  begin
    if PAUSED then
     Sleep(1000)
    else
      begin
         RunAlgorithm ;
         Sleep(1000);
      end;
  end;
end;



destructor TAlgorithm.Destroy;
begin
   Inherited;
end;


procedure TAlgorithm.RunAlgorithm;
var
   tm_now:TTime;
   tm_beforemarketclose:TTime;
   tm_marketclose:TTime;
begin
  if not CurrentPosition.ACTIVE then Exit; { exit if not active }

  tm_Now:= Time;

  if dm_Main.bStartStop then
    if (tm_now>dm_Main.tm_Market_stop) or (tm_now<dm_Main.tm_Market_start) then
      exit;

  if CurrentPosition.FORCE_BUY then
  begin
    _LONG_Run;
  end;

  if CurrentPosition.OPENED then
    begin // BEGIN ACTIVE AND OPENED

      // first check if market is about to CLOSE and we NEED TO CLOSE_AT_MARKETCLOSING
      if CurrentPosition.CLOSE_AT_MARKETCLOSING then
       begin
         tm_beforemarketclose:= IncMinute( dm_Main.tm_Market_stop, -1);
         tm_marketclose := dm_Main.tm_Market_stop;
         if (tm_now < tm_marketclose) and ( tm_now > tm_beforemarketclose) then
          begin
           CurrentPosition.CLOSE_NOW_AT_MARKET := True;
           UpdateHistory('CLOSE POS '+IntToStr(CurrentPosition.NRPOS)+' AT MARKET DAILY CLOSING','FORCE',CurrentPosition);
          end;
       end;

      if CurrentPosition.DIRECTION = TPositionDirection.LONG then
        begin
          _LONG_Run;
        end
      else
      if CurrentPosition.DIRECTION = TPositionDirection.SHORT then
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

       if CurrentPosition.START_PRICE_MAX = 0 then // if first run then initialize start-price
         begin

           CurrentPosition.START_PRICE_MAX := CurrentPosition.Algorithm_Price;
           CurrentPosition.START_PRICE_MIN := CurrentPosition.START_PRICE_MAX;

           UpdatePosition;
           exit;
         end;

       // see if goes down or up
       // compare with last_price
       // if breakout open_buy/open_sell then open buy/sell
       //

       if CurrentPosition.LAST_MARKET_PRICE = CurrentPosition.Prev_Price then // nothing happened
         begin
           UpdatePosition;
           exit; // exit if price not changed
         end;

       if CurrentPosition.LAST_MARKET_PRICE < CurrentPosition.Prev_Price then
         begin // market is going DOWN
           if NOT SHORT_PosOpen then
             begin
                // update LONG START PRICE (START_PRICE_MIN)
                if CurrentPosition.START_PRICE_MIN > CurrentPosition.Algorithm_Price then
                     CurrentPosition.START_PRICE_MIN := CurrentPosition.Algorithm_Price;
                // update position
                UpdatePosition;
             end;
         end
       else
         begin // market is going UP
           if NOT LONG_PosOpen then
             begin
                // update SHORT START PRICE (START_PRICE_MAX)
                if CurrentPosition.START_PRICE_MAX < CurrentPosition.Algorithm_Price then
                     CurrentPosition.START_PRICE_MAX := CurrentPosition.Algorithm_Price;
                // update position
                UpdatePosition;
             end;
         end
     end;
   end;

end;

end.

