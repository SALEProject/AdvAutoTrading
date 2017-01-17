unit u_finance_request;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,  fphttpclient, jsonparser, fpjson, math, dialogs, DateUtils, Forms,
  TWSThread;

const USE_GOOGLE = false;

procedure _ShowMessage(msg:string);

type

 { TMarketMessage }

 TMarketMessage = record
                f_price: Double;
                d_time: TDateTime;
                i_volume: integer;
                milis : longint;
                ID: integer;
 end;

type DEBUG_RECORD = record
               SYMBOL : string;
               IDX : integer;
end;

type P_DEBUG_RECORD = ^DEBUG_RECORD;

type

{ TExchangeConnector }


 TExchangeConnector = class

                    private

                       DEBUG_LIST: TList;
                       function DEBUG_GetQuote(market: string; symbol: string): TMarketMessage;
                       function DEBUG_MarketBuy(market: string; symbol: string; volume: integer): TMarketMessage;
                       function DEBUG_MarketSell(market: string; symbol: string; volume: integer): TMarketMessage;

                       function Google_TryGetQuote(market: string; symbol: string): TMarketMessage;
                       function IB_TryGetQuote(market: string; symbol: string): TMarketMessage;
                       function Default_TryGetQuote(market: string; symbol: string): TMarketMessage;

                       function IB_TryMarketBuy(market: string; symbol: string; volume: integer): TMarketMessage;
                       function IB_TryMarketSell(market: string; symbol: string; volume: integer): TMarketMessage;
                       function IB_TryCheckOrder(orderID: integer): TMarketMessage;
                    public

                       str_Requests : string;

                       constructor Create;
                       destructor Destroy;

                       function _GetQuote(market: string; symbol: string): TMarketMessage;
                       function MarketBuy(market: string; symbol: string; volume: integer): TMarketMessage;
                       function MarketSell(market: string; symbol: string; volume: integer): TMarketMessage;

           end;

{debug}
var
  c_arr_prices: Array[0..29] of Double =(100, 100, 110, 110, 100, 100, 90, 90, 80, 80, 70, 70,  80, 80, 90, 90,  100, 100, 110, 110, 130, 130, 200, 200, 210, 210, 203, 203, 220, 220);
  arr_prices: array of Double;
  MARKET_DEBUG_MODE: boolean;
{end debug}

implementation

uses u_logger;

procedure _ShowMessage(msg: string);
begin
  ShowMessage(msg);
end;


constructor TExchangeConnector.Create;
begin
   DEBUG_LIST := TList.Create;
   str_Requests:= '';
end;

function TExchangeConnector.DEBUG_GetQuote(market: string; symbol: string): TMarketMessage;
var
  i  : integer;
  res: TMarketMessage;
  TempDebug, SymbolDebug: P_DEBUG_RECORD;
begin
   if NOT MARKET_DEBUG_MODE then exit;

   SymbolDebug := nil;
   for i:=0 to DEBUG_LIST.Count-1 do
     begin
       TempDebug := DEBUG_LIST.Items[i];
       if TempDebug^.SYMBOL  = symbol then
               SymbolDebug := TempDebug;
     end;

   if SymbolDebug = nil then
    begin
     SymbolDebug := allocmem(sizeof(DEBUG_RECORD));
     SymbolDebug^.IDX :=0;
     SymbolDebug^.SYMBOL := symbol;
     DEBUG_LIST.Add (SymbolDebug);;
    end;

   if not Length(arr_prices)>0 then
      begin
       SetLength(arr_prices,Length(c_arr_prices));
       for i := 0 to Length(c_arr_prices)-1 do
         arr_prices [i] := c_arr_prices [i];
      end;

   if (SymbolDebug^.IDX >= Length(arr_prices)) then
      SymbolDebug^.IDX := 0;

   res.f_price:= arr_prices[SymbolDebug^.IDX];
   SymbolDebug^.IDX+= 1;
   res.d_time:= Now;
   Result:= res;

end;

function TExchangeConnector.DEBUG_MarketBuy(market: string; symbol: string; volume: integer): TMarketMessage;
begin
   Result:= DEBUG_GetQuote (market,symbol);
end;

function TExchangeConnector.DEBUG_MarketSell(market: string; symbol: string; volume: integer): TMarketMessage;
begin
  Result:= DEBUG_GetQuote (market,symbol);
end;

function TExchangeConnector.Google_TryGetQuote(market: string; symbol: string):TMarketMessage;
var
  basicURL: string;
  response: AnsiString;
  jsonParser: TJSONParser;
  jsonData: TJSONData;
  jsonObject: TJSONObject;

  res: TMarketMessage;
  str_datetime:string;
  str_price:string;

  d_TempDate:TDate;
  d_TempTime:TTime;
  fmt_Format:TFormatSettings;
  T1_start, T1_stop : TDateTime;
  http_req : TFPHttpClient;
begin
   res.f_price:= -9999;

   if MARKET_DEBUG_MODE then
   begin
     str_Requests := str_Requests + ' DEBUG_'+symbol;
     Result := DEBUG_GetQuote (market,symbol);
     Exit;
   end;

  {finance.google.com}
  basicURL:= 'http://finance.google.com/finance/info?client=ig&q=_MARKET_%3a_SYMBOL_';
  basicURL:= StringReplace(basicURL, '_MARKET_', market, [rfReplaceAll]);
  basicURL:= StringReplace(basicURL, '_SYMBOL_', symbol, [rfReplaceAll]);
  {done}


  http_req := TFPHttpClient.Create(Application);
  try
     T1_start := now;
     str_Requests := str_Requests + ' '+symbol;
     //response:=http_req.Get(basicURL);  ///de parametrizat!
     T1_Stop := now;
  except
     on e:Exception do
     begin
        log_Logger.LogDBMessage(e.Message);
        http_req.Free;
        Result:= res;
        Exit;
     end;
  end;
  http_req.Free;

  response:=       StringReplace(response, '/', ' ', [rfReplaceAll]);
  response:=       StringReplace(response, '[', ' ', [rfReplaceAll]);
  response:=       StringReplace(response, ']', ' ', [rfReplaceAll]);
  jsonParser:= TJSONParser.Create(response);
  jsonObject:= jsonParser.Parse as TJSONObject;

  str_datetime:=jsonObject.Strings['lt_dts'];
  str_price := jsonObject.Strings['l_fix'];

  jsonParser.Free;

  str_datetime := StringReplace (str_datetime,'T',' ',[rfReplaceAll]);
  str_datetime := StringReplace (str_datetime,'Z',' ',[rfReplaceAll]);

  fmt_Format := DefaultFormatSettings;
  fmt_Format.DateSeparator := '-';
  fmt_Format.ShortDateFormat := 'YYYY-MM-DD';
  res.d_time:= StrToDateTime(str_datetime,fmt_Format);
  res.f_price:= StrToFloat(str_price);
  res.milis := MilliSecondsBetween(T1_start,T1_stop);
  Result:= res;
end;

function TExchangeConnector.IB_TryGetQuote(market: string; symbol: string): TMarketMessage;
 var res: TTWSMessage;
     Com: TTWSThread;
     idx: integer;
     dt_start, dt_end, dt_s, dt_e: TDateTime;
     _mil: TDateTime;
 begin
  dt_start:= Now;

  FillChar(result, sizeof(result), 0);
  result.f_price:= -9999;

  _mil:= 1 / 86400 / 1000; //  1 millisecond

  EnterCriticalsection(TWSCriticalSection);
  Com:= GetIBThread;
  if Com = nil then Exit;

  {res:= Com.GetQuote(market, symbol);
  result.f_price:= res.f_price;
  result.i_volume:= res.i_volume;
  result.d_time:= res.d_time;}
{
  idx:= Com.FindContractbyMktSym(market, symbol);
  if idx = -1 then //  we have to add a new contract
   begin
    try
     Com.AddContract(symbol, 'STK', '', '', 'SMART', market, 'USD');
    except
     on E: Exception do
      begin
       log_Logger.LogDisplayMessage(Format(cns_str_CannotRegisterTWSContract, [market, symbol]));
       Exit;
      end;
    end;
    idx:= Com.FindContractbyMktSym(market, symbol);

    //  wait for ticks
    dt_s:= Now;
    dt_e:= Now;
    while (not Com.Contract[idx].Active) and (Com.Contract[idx].LastTradeSize = 0) and
          (Com.Contract[idx].LastTradePrice = 0) and (Com.Contract[idx].LastTradeTime < 41000) and
          (dt_e - dt_s < 500 * _mil) do
     begin
      Sleep(50);
      //Application.ProcessMessages;
      dt_e:= Now
     end;
   end;

  if idx = -1 then Exit;
  //  At this point we consider that the contract is correctly registered with TWS and
  //  we just read latest data

  if (Com.Contract[idx].LastTradePrice > 0) and (Com.Contract[idx].LastTradeSize > 0) and
     (Com.Contract[idx].LastTradeTime > 41000) then
   begin
    result.d_time:= Com.Contract[idx].LastTradeTime;
    result.f_price:= Com.Contract[idx].LastTradePrice;
    result.i_volume:= Com.Contract[idx].LastTradeSize;
   end;
}
  LeaveCriticalsection(TWSCriticalSection);

  dt_end:= Now;
  result.milis:= round((dt_end - dt_start) * _mil);
 end;

function TExchangeConnector.Default_TryGetQuote(market: string; symbol: string): TMarketMessage;
begin
 if USE_GOOGLE then
  begin
   result:= Google_TryGetQuote(market, symbol);
   Exit;
  end;

 result := IB_TryGetQuote(market, symbol);
 //if result.f_price <= 0 then result:= Google_TryGetQuote(market, symbol);
end;

function TExchangeConnector.IB_TryMarketBuy(market: string; symbol: string; volume: integer): TMarketMessage;
 var res: TMarketMessage;
     Com: TTWSThread;
     orderID: integer;
     dt_start, dt_end, dt_s, dt_e: TDateTime;
     _mil: TDateTime;
 begin
  dt_start:= Now;

  FillChar(res, sizeof(res), 0);
  res.ID:= -1;
  res.f_price:= -9999;
  result:= res;

  _mil:= 1 / 86400 / 1000; //  1 millisecond

  Com:= GetIBThread;
{  if Com = nil then Exit;
  if not Com.Connected and not Com.ConnectionPending then
   begin
    try
     Com.Connect;
    except
     on E: Exception do
      begin
       log_Logger.LogDisplayMessage(cns_str_CannotConnectTWS);
       Exit;
      end;
    end;

    Exit; //  there's nothing to do, somebody has to accept the connection in TWS
   end;

  orderID:= Com.LaunchOrder(market, symbol, ac_BUY, volume);
  if orderID > -1 then
   begin
    result.ID:= orderID;
    result.f_price:= Com.Order[orderID].AveragePrice;
    result.i_volume:= Com.Order[orderID].FillQuantity;
   end;
}

  dt_end:= Now;
  result.milis:= round((dt_end - dt_start) * _mil);
 end;

function TExchangeConnector.IB_TryMarketSell(market: string; symbol: string; volume: integer): TMarketMessage;
 var res: TMarketMessage;
     Com: TTWSThread;
     orderID: integer;
     dt_start, dt_end, dt_s, dt_e: TDateTime;
     _mil: TDateTime;
 begin
  dt_start:= Now;

  FillChar(res, sizeof(res), 0);
  res.ID:= -1;
  res.f_price:= -9999;
  result:= res;

  _mil:= 1 / 86400 / 1000; //  1 millisecond

  Com:= GetIBThread;
  if Com = nil then Exit;
{  if not Com.Connected and not Com.ConnectionPending then
   begin
    try
     Com.Connect;
    except
     on E: Exception do
      begin
       log_Logger.LogDisplayMessage(cns_str_CannotConnectTWS);
       Exit;
      end;
    end;

    Exit; //  there's nothing to do, somebody has to accept the connection in TWS
   end;

  orderID:= Com.LaunchOrder(market, symbol, ac_SELL, volume);
  if orderID > -1 then
   begin
    result.ID:= orderID;
    result.f_price:= Com.Order[orderID].AveragePrice;
    result.i_volume:= Com.Order[orderID].FillQuantity;
   end;
}

  dt_end:= Now;
  result.milis:= round((dt_end - dt_start) * _mil);
 end;

function TExchangeConnector.IB_TryCheckOrder(orderID: integer): TMarketMessage;
 var res: TMarketMessage;
     Com: TTWSThread;
     dt_start, dt_end, dt_s, dt_e: TDateTime;
     _mil: TDateTime;
 begin
  dt_start:= Now;

  FillChar(res, sizeof(res), 0);
  res.ID:= -1;
  res.f_price:= -9999;
  result:= res;

  _mil:= 1 / 86400 / 1000; //  1 millisecond

  Com:= GetIBThread;
  if Com = nil then Exit;
{  if not Com.Connected and not Com.ConnectionPending then
   begin
    try
     Com.Connect;
    except
     on E: Exception do
      begin
       log_Logger.LogDisplayMessage(cns_str_CannotConnectTWS);
       Exit;
      end;
    end;

    Exit; //  there's nothing to do, somebody has to accept the connection in TWS
   end;

  if Com.Order[orderID].ID = -1 then Exit
  else
   begin
    result.ID:= orderID;
    result.f_price:= Com.Order[orderID].AveragePrice;
    result.i_volume:= Com.Order[orderID].FillQuantity;
   end;

}

  dt_end:= Now;
  result.milis:= round((dt_end - dt_start) * _mil);
 end;

destructor TExchangeConnector.Destroy;
begin
  DEBUG_LIST.Free ;
  Inherited;
end;

function TExchangeConnector._GetQuote(market: string; symbol: string): TMarketMessage;
const
  NR_TRY = 100;
  WAIT_TIME_MS = 2000;
var
    Res: TMarketMessage;
    int_Try:integer;
    dt_WaitStart,dt_WaitCurr:TDateTime;
begin
  res := Default_TryGetQuote(market,symbol);
  int_try := 1;
  while res.f_price <=0 do
  begin
    if (int_try>NR_TRY) then   // if more than NR_TRY tries have failed then connection error !
    begin
       //_ShowMessage('EROARE LA CONEXIUNE ! VA RUGAM REPORNITI APLICATIA !');
       //halt(-1); // STOP EXECUTION AFTER MESSAGE!!! THIS HAS TO BE MODIFIED IN SERVICES !!!
    end;

    if (int_try mod 2)= 0 then
     //log_Logger.LogDBMessage('TIMEOUT '+IntToStr(int_try*2)+'s');

    {WAIT WAIT_TIME_MS}
    dt_WaitStart :=Now;
    dt_WaitCurr := Now;
    while MilliSecondsBetween(dt_WaitStart,dt_WaitCurr)<WAIT_TIME_MS do
    begin
         //Application.ProcessMessages;
         sleep(100);
         dt_WaitCurr := now;
    end;
    {DONE WAIT_TIME}

    res := Default_TryGetQuote(market,symbol);
    inc(int_try);
  end;

  Result := res;
end;

const cns_int_max_tries = 100;
      cns_int_wait_time = 100;

function TExchangeConnector.MarketBuy(market: string; symbol: string; volume: integer): TMarketMessage;
var dt_start, dt_now: TDateTime;
    res: TMarketMessage;
    count_tries: integer;
begin
 if USE_GOOGLE then
 begin
  Result:=  _GetQuote (market, symbol);
  Exit;
 end;

 Result:= IB_TryMarketBuy(market, symbol, volume);
 if result.ID < 0 then Exit; //  no order placed, exiting

 //  order has been placed, try to wait until is filled
 count_tries:= 0;
 while (result.i_volume < volume) and (count_tries < cns_int_max_tries) do
  begin
   dt_start:=Now;
   dt_now  := Now;
   while MilliSecondsBetween(dt_start, dt_now) < cns_int_wait_time do
    begin
     Application.ProcessMessages;
     dt_now:= now;
    end;

   result:= IB_TryCheckOrder(Result.ID);
   if result.ID < 0 then Exit; //  something happened to the connection

   count_tries += 1;
  end;

end;

function TExchangeConnector.MarketSell(market: string; symbol: string; volume: integer): TMarketMessage;
var dt_start, dt_now: TDateTime;
    res: TMarketMessage;
    count_tries: integer;
begin
 if USE_GOOGLE then
 begin
  Result:=  _GetQuote (market, symbol);
  Exit;
 end;

 Result:= IB_TryMarketSell(market, symbol, volume);
 if result.ID < 0 then Exit; //  no order placed, exiting

 //  order has been placed, try to wait until is filled
 count_tries:= 0;
 while (result.i_volume < volume) and (count_tries < cns_int_max_tries) do
  begin
   dt_start:=Now;
   dt_now  := Now;
   while MilliSecondsBetween(dt_start, dt_now) < cns_int_wait_time do
    begin
     Application.ProcessMessages;
     dt_now:= now;
    end;

   result:= IB_TryCheckOrder(Result.ID);
   if result.ID < 0 then Exit; //  something happened to the connection

   count_tries += 1;
  end;
end;

end.

