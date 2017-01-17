unit TWSThread;

{$mode objfpc}{$H+}

interface

uses
 Classes, SysUtils, {LCLProc, LCLType, LCLIntf,} TWSCom, comobj, ActiveX, Forms;

 const cns_str_CannotConnectTWS = 'Cannot connect to TWS. Check if TWS is running and API settings';
       cns_str_CannotRegisterTWSContract = 'Contract for %s.%s could not be registered with TWS';

 type TTWSMessage = record
                     f_price: Double;
                     d_time: TDateTime;
                     i_volume: integer;
                     milis : longint;
                     ID: integer;
                    end;

 type TTWSThread = class(TThread)
                   protected
                    IB: TTWSCom;
                    Message: string;
                    procedure LogMessage;
                    procedure _ProcessMessages;
                   public
                    constructor Create; virtual;
                    procedure Execute; override;

                    function GetQuote(market: string; symbol: string): TTWSMessage;
                    function MarketBuy(market: string; symbol: string; volume: integer): TTWSMessage;
                    function MarketSell(market: string; symbol: string; volume: integer): TTWSMessage;
                    function CheckOrder(orderID: integer): TTWSMessage;
                   end;

 var TWSCriticalSection: TRTLCriticalSection;
     IBThread: TTWSThread;

 function GetIBThread: TTWSThread;

implementation

 uses u_Logger;

 function GetIBThread: TTWSThread;
  begin
   result:= IBThread;
   if result <> nil then Exit;

   IBThread:= TTWSThread.Create;
   result:= IBThread;
  end;

 constructor TTWSThread.Create;
  begin
//   CoUninitialize;
//   CoInitialize(nil);
//   IB:= GetIB;

   inherited Create(false);
  end;

 procedure TTWSThread.LogMessage;
  begin
   log_Logger.LogDisplayMessage(Message);
  end;

 procedure TTWSThread._ProcessMessages;
  begin
   Application.ProcessMessages;
  end;

 function TTWSThread.GetQuote(market: string; symbol: string): TTWSMessage;
  var idx: integer;
      dt_start, dt_end, dt_s, dt_e: TDateTime;
      _mil: TDateTime;
  begin
   dt_start:= Now;

   FillChar(result, sizeof(result), 0);
   result.f_price:= -9999;

   _mil:= 1 / 86400 / 1000; //  1 millisecond

   if IB = nil then Exit;
   if not IB.Connected then Exit;

   idx:= IB.FindContractbyMktSym(market, symbol);
   if idx = -1 then //  we have to add a new contract
    begin
     try
      IB.AddContract(symbol, 'STK', '', '', 'SMART', market, 'USD');
     except
      on E: Exception do
       begin
        log_Logger.LogDisplayMessage(Format(cns_str_CannotRegisterTWSContract, [market, symbol]));
        Exit;
       end;
     end;
     idx:= IB.FindContractbyMktSym(market, symbol);

{     //  wait for ticks
     dt_s:= Now;
     dt_e:= Now;
     while (not Com.Contract[idx].Active) and (Com.Contract[idx].LastTradeSize = 0) and
           (Com.Contract[idx].LastTradePrice = 0) and (Com.Contract[idx].LastTradeTime < 41000) and
           (dt_e - dt_s < 500 * _mil) do
      begin
       Sleep(50);
       //Application.ProcessMessages;
       dt_e:= Now
      end;}
    end;

   if idx = -1 then Exit;
   //  At this point we consider that the contract is correctly registered with TWS and
   //  we just read latest data

   if (IB.Contract[idx].LastTradePrice > 0) and (IB.Contract[idx].LastTradeSize > 0) and
      (IB.Contract[idx].LastTradeTime > 41000) then
    begin
     result.d_time:= IB.Contract[idx].LastTradeTime;
     result.f_price:= IB.Contract[idx].LastTradePrice;
     result.i_volume:= IB.Contract[idx].LastTradeSize;
    end;

   dt_end:= Now;
   result.milis:= round((dt_end - dt_start) * _mil);
  end;

 function TTWSThread.MarketBuy(market: string; symbol: string; volume: integer): TTWSMessage;
  var orderID: integer;
      dt_start, dt_end, dt_s, dt_e: TDateTime;
      _mil: TDateTime;
  begin
   dt_start:= Now;

   FillChar(result, sizeof(result), 0);
   result.ID:= -1;
   result.f_price:= -9999;

   _mil:= 1 / 86400 / 1000; //  1 millisecond

   if IB = nil then Exit;
   if not IB.Connected then Exit;

   orderID:= IB.LaunchOrder(market, symbol, ac_BUY, volume);
   if orderID > -1 then
    begin
     result.ID:= orderID;
     result.f_price:= IB.Order[orderID].AveragePrice;
     result.i_volume:= IB.Order[orderID].FillQuantity;
    end;

   dt_end:= Now;
   result.milis:= round((dt_end - dt_start) * _mil);
  end;

 function TTWSThread.MarketSell(market: string; symbol: string; volume: integer): TTWSMessage;
  var orderID: integer;
      dt_start, dt_end, dt_s, dt_e: TDateTime;
      _mil: TDateTime;
  begin
   dt_start:= Now;

   FillChar(result, sizeof(result), 0);
   result.ID:= -1;
   result.f_price:= -9999;

   _mil:= 1 / 86400 / 1000; //  1 millisecond

   if IB = nil then Exit;
   if not IB.Connected then Exit;

   orderID:= IB.LaunchOrder(market, symbol, ac_SELL, volume);
   if orderID > -1 then
    begin
     result.ID:= orderID;
     result.f_price:= IB.Order[orderID].AveragePrice;
     result.i_volume:= IB.Order[orderID].FillQuantity;
    end;

   dt_end:= Now;
   result.milis:= round((dt_end - dt_start) * _mil);
  end;

 function TTWSThread.CheckOrder(orderID: integer): TTWSMessage;
  var dt_start, dt_end, dt_s, dt_e: TDateTime;
      _mil: TDateTime;
  begin
   dt_start:= Now;

   FillChar(result, sizeof(result), 0);
   result.ID:= -1;
   result.f_price:= -9999;

   _mil:= 1 / 86400 / 1000; //  1 millisecond

   if IB = nil then Exit;
   if not IB.Connected then Exit;

   if IB.Order[orderID].ID = -1 then Exit
   else
    begin
     result.ID:= orderID;
     result.f_price:= IB.Order[orderID].AveragePrice;
     result.i_volume:= IB.Order[orderID].FillQuantity;
    end;

   dt_end:= Now;
   result.milis:= round((dt_end - dt_start) * _mil);
  end;

 procedure TTWSThread.Execute;
  begin
   CoUninitialize;
   CoInitializeEx(nil, COINIT_APARTMENTTHREADED);
   //CoInitializeEx(nil, COINIT_MULTITHREADED);
   IB:= GetIB;
   if IB = nil then Exit;

   while not self.Terminated do
    begin
     //  check if we have a connection with the TWS application
     if not IB.Connected and not IB.ConnectionPending then
      begin
       try
        IB.Connect;
       except
        on E: Exception do
         begin
          Message:= cns_str_CannotConnectTWS;
          Synchronize(@LogMessage);
          Exit;
         end;
       end;

       //Continue; //  there's nothing to do, somebody has to accept the connection in TWS
      end;

     //Sleep(50);
     Synchronize(@_ProcessMessages);
    end;
  end;

initialization
 InitCriticalSection(TWSCriticalSection);
finalization
 DoneCriticalsection(TWSCriticalSection);
end.

