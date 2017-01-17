unit TWSCom;

{$mode objfpc}{$H+}

interface

uses
 Classes, SysUtils, Forms, TWSLib_1_0_TLB, bitABachus, DateUtils, comobj, ActiveX;

 const cns_int_MessagesCount = 100;

 //type TStringArray = array of string;

 type TTickType = (BID_SIZE = 0, BID_PRICE, ASK_PRICE, ASK_SIZE, LAST_PRICE, LAST_SIZE,
                   HIGH, LOW, VOLUME, CLOSE_PRICE, BID_OPTION_COMPUTATION, ASK_OPTION_COMPUTATION,
                   LAST_OPTION_COMPUTATION, MODEL_OPTION, OPEN_TICK, LOW_13_WEEK, HIGH_13_WEEK, LOW_26_WEEK,
                   HIGH_26_WEEK, LOW_52_WEEK, HIGH_52_WEEK, AVG_VOLUME, OPEN_INTEREST, OPTION_HISTORICAL_VOL,
                   OPTION_IMPLIED_VOL, OPTION_BID_EXCH, OPTION_ASK_EXCH, OPTION_CALL_OPEN_INTEREST, OPTION_PUT_OPEN_INTEREST, OPTION_CALL_VOLUME,
                   OPTION_PUT_VOLUME, INDEX_FUTURE_PREMIUM, BID_EXCH, ASK_EXCH, AUCTION_VOLUME, AUCTION_PRICE,
                   AUCTION_IMBALANCE, MARK_PRICE, BID_EFP_COMPUTATION, ASK_EFP_COMPUTATION, LAST_EFP_COMPUTATION, OPEN_EFP_COMPUTATION,
                   HIGH_EFP_COMPUTATION, LOW_EFP_COMPUTATION, CLOSE_EFP_COMPUTATION, LAST_TIMESTAMP, SHORTABLE, FUNDAMENTAL_RATIOS,
                   RT_VOLUME, HALTED, BID_YIELD, ASK_YIELD, LAST_YIELD, CUST_OPTION_COMPUTATION,
                   TRADE_COUNT, TRADE_RATE, VOLUME_RATE, LAST_RTH_TRADE);

      TTWSOrderAction = (ac_BUY, ac_SELL, ac_SSHORT);

 type TTWSOrder = record
                   ID: integer;
                   Order: IOrder;
                   Quantity: integer;
                   FillQuantity: integer;
                   AveragePrice: double;
                  end;

      TTWSContract = record
                      ID: integer;
                      Contract: IContract;

                      BIDPrice: double;
                      BIDSize: integer;
                      ASKPrice: double;
                      ASKSize: integer;

                      LastTradePrice: double;
                      LastTradeSize: integer;
                      LastTradeTime: TDateTime;
                      TotalVolume: double;
                      VWAP: double;

                      OpenPrice, HighPrice, LowPrice, ClosePrice: double;

                      LastTickTime: TDateTime;
                      Active: boolean;

                      Orders: array of TTWSOrder;
                     end;


 type TTWSCom = class
                private
                 FHost: shortstring;
                 FPort: integer;
                 FClientID: integer;
                 FConnectionPending: boolean;
                 FConnected: boolean;
                 FContracts: array of TTWSContract;
                 FCtrID: integer;

                 function GetContractsCount: integer;
                 function GetContract(Index: Variant): TTWSContract;
                 function GetOrder(Index: integer): TTWSOrder;
                protected
                 TWSClass: TEvsTws;
                 Messages: TStringArray;

                 CurrentOrderID: integer;

                 procedure AddMessage(s: string);
                 function TranslateTickType(TickType: integer): shortstring;

                 procedure TWSErrorMessage(Sender: TObject; id: Integer; errorCode: Integer; errorMsg: WideString);
                 procedure TWSConnectionClosed(Sender: TObject);
                 procedure TWSTickPrice(Sender: TObject; id: Integer; tickType: Integer; price: Double; canAutoExecute: LongInt);
                 procedure TWSTickSize(Sender: TObject; id: Integer; tickType: Integer; size: Integer);
                 procedure TWSTickGeneric(Sender: TObject; id: Integer; tickType: Integer; value: Double);
                 procedure TWSTickString(Sender: TObject;id:Integer;tickType:Integer;value:WideString);

                 procedure TWSNextOrderID(Sender: TObject; id: Integer);
                 procedure TWSOrderStatus(Sender: TObject; id: Integer; status: WideString; filled: Integer; remaining: Integer; avgFillPrice: Double; permId: Integer; parentId: Integer; lastFillPrice: Double; clientId: Integer; whyHeld: WideString);
                 procedure TWSOperOrderEx(Sender: TObject; orderId: Integer; contract: IContract; order: IOrder; orderState: IOrderState);
                public
                 constructor Create; virtual;
                 destructor Destroy; override;

                 procedure Connect; overload;
                 procedure Connect(Host: shortstring; Port: integer; ClientID: integer); overload;
                 procedure Disconnect;

                 function GetMessages: TStringArray;
                 function TailMessages: TStringArray;

                 function FindContractbyID(ID: integer): integer;
                 function FindContractbySymbol(Symbol: string): integer;
                 function FindContractbyMktSym(market, symbol: shortstring): integer;
                 function AddContract(Symbol, SecurityType, Expiry, Multiplier, Exchange, PrimaryExchange, Currency: string): integer;

                 function FindContractForOrder(ID: integer): integer;
                 function FindOrderbyID(ContractIndex: integer; OrderID: integer): integer;
                 function LaunchOrder(Market, Symbol: shortstring; Action: TTWSOrderAction; Quantity: integer): integer;

                 property Host: shortstring read FHost write FHost;
                 property Port: integer read FPort write FPort;
                 property ClientID: integer read FClientID write FClientID;
                 property ConnectionPending: boolean read FConnectionPending;
                 property Connected: boolean read FConnected;

                 property ContractsCount: integer read GetContractsCount;
                 property Contract[Index: Variant]: TTWSContract read GetContract;
                 property Order[Index: integer]: TTWSOrder read GetOrder;
                end;

 function GetIB: TTWSCom;

implementation

 var _Com: TTWSCom;

 function GetIB: TTWSCom;
  begin
   result:= _Com;
   if result <> nil then Exit;

   _Com:= TTWSCom.Create;
   result:= _Com;
  end;

 constructor TTWSCom.Create;
  begin
   TWSClass:= nil;
   FConnectionPending:= false;
   FConnected:= false;
   FHost:= '127.0.0.1';
   FPort:= 7496;
   FClientID:= 0;
   SetLength(Messages, 0);
   FCtrID:= 0;

   CurrentOrderID:= 0;

   //  create ActiveX instance
   try
    TWSClass:= TEvsTws.Create(Application);
    TWSClass.OnerrMsg:= @TWSErrorMessage;
    TWSClass.OnconnectionClosed:= @TWSConnectionClosed;
    TWSClass.OntickSize:= @TWSTickSize;
    TWSClass.OntickPrice:= @TWSTickPrice;
    TWSClass.OntickGeneric:= @TWSTickGeneric;
    TWSClass.OntickString:= @TWSTickString;

    TWSClass.OnnextValidId:= @TWSNextOrderID;
    TWSClass.OnorderStatus:= @TWSOrderStatus;
    TWSClass.OnopenOrderEx:= @TWSOperOrderEx;
   except
   end;
  end;

 destructor TTWSCom.Destroy;
  begin
   try
    if FConnected then Disconnect;
   except

   end;

   FreeAndNil(TWSClass);

   inherited;
  end;


 procedure TTWSCom.Connect;
  begin
   if TWSClass = nil then Exit;

   Connect(FHost, FPort, FClientID);
  end;

 procedure TTWSCom.Connect(Host: shortstring; Port: integer; ClientID: integer);
  begin
   if TWSClass = nil then Exit;
   if FConnected then Exit;

   TWSClass.ComServer.connect(Host, Port, ClientID, 0);
   FConnectionPending:= true;
  end;

 procedure TTWSCom.Disconnect;
  begin
   if TWSClass = nil then Exit;
   if not FConnected then Exit;

   TWSClass.ComServer.disconnect;
   FConnected:= false;
  end;

 procedure TTWSCom.AddMessage(s: string);
  var k, i: integer;
      lst: TStringList;
  begin
   k:= Length(Messages);
   if k < cns_int_MessagesCount then SetLength(Messages, k + 1)
   else
    begin
     for i:= 0 to Length(Messages) - 2 do Messages[i]:= Messages[i + 1];
    end;

   Messages[k]:= s;

   lst:= TStringList.Create;
   lst.AddStrings(Messages);
   lst.SaveToFile('messages.txt');
  end;

 function TTWSCom.GetMessages: TStringArray;
  begin
   result:= Messages;
  end;

 function TTWSCom.TailMessages: TStringArray;
  begin

  end;

 function TTWSCom.TranslateTickType(TickType: integer): shortstring;
  begin
   case TTickType(TickType) of
    BID_SIZE                 : result:= 'BID_SIZE';
    BID_PRICE                : result:= 'BID_PRICE';
    ASK_PRICE                : result:= 'ASK_PRICE';
    ASK_SIZE                 : result:= 'ASK_SIZE';
    LAST_PRICE               : result:= 'LAST_PRICE';
    LAST_SIZE                : result:= 'LAST_SIZE';
    HIGH                     : result:= 'HIGH';
    LOW                      : result:= 'LOW';
    VOLUME                   : result:= 'VOLUME';
    CLOSE_PRICE              : result:= 'CLOSE_PRICE';
    BID_OPTION_COMPUTATION   : result:= 'BID_OPTION_COMPUTATION';
    ASK_OPTION_COMPUTATION   : result:= 'ASK_OPTION_COMPUTATION';
    LAST_OPTION_COMPUTATION  : result:= 'LAST_OPTION_COMPUTATION';
    MODEL_OPTION             : result:= 'MODEL_OPTION';
    OPEN_TICK                : result:= 'OPEN_TICK';
    LOW_13_WEEK              : result:= 'LOW_13_WEEK';
    HIGH_13_WEEK             : result:= 'HIGH_13_WEEK';
    LOW_26_WEEK              : result:= 'LOW_26_WEEK';
    HIGH_26_WEEK             : result:= 'HIGH_26_WEEK';
    LOW_52_WEEK              : result:= 'LOW_52_WEEK';
    HIGH_52_WEEK             : result:= 'HIGH_52_WEEK';
    AVG_VOLUME               : result:= 'AVG_VOLUME';
    OPEN_INTEREST            : result:= 'OPEN_INTEREST';
    OPTION_HISTORICAL_VOL    : result:= 'OPTION_HISTORICAL_VOL';
    OPTION_IMPLIED_VOL       : result:= 'OPTION_IMPLIED_VOL';
    OPTION_BID_EXCH          : result:= 'OPTION_BID_EXCH';
    OPTION_ASK_EXCH          : result:= 'OPTION_ASK_EXCH';
    OPTION_CALL_OPEN_INTEREST: result:= 'OPTION_CALL_OPEN_INTEREST';
    OPTION_PUT_OPEN_INTEREST : result:= 'OPTION_PUT_OPEN_INTEREST';
    OPTION_CALL_VOLUME       : result:= 'OPTION_CALL_VOLUME';
    OPTION_PUT_VOLUME        : result:= 'OPTION_PUT_VOLUME';
    INDEX_FUTURE_PREMIUM     : result:= 'INDEX_FUTURE_PREMIUM';
    BID_EXCH                 : result:= 'BID_EXCH';
    ASK_EXCH                 : result:= 'ASK_EXCH';
    AUCTION_VOLUME           : result:= 'AUCTION_VOLUME';
    AUCTION_PRICE            : result:= 'AUCTION_PRICE';
    AUCTION_IMBALANCE        : result:= 'AUCTION_IMBALANCE';
    MARK_PRICE               : result:= 'MARK_PRICE';
    BID_EFP_COMPUTATION      : result:= 'BID_EFP_COMPUTATION';
    ASK_EFP_COMPUTATION      : result:= 'ASK_EFP_COMPUTATION';
    LAST_EFP_COMPUTATION     : result:= 'LAST_EFP_COMPUTATION';
    OPEN_EFP_COMPUTATION     : result:= 'OPEN_EFP_COMPUTATION';
    HIGH_EFP_COMPUTATION     : result:= 'HIGH_EFP_COMPUTATION';
    LOW_EFP_COMPUTATION      : result:= 'LOW_EFP_COMPUTATION';
    CLOSE_EFP_COMPUTATION    : result:= 'CLOSE_EFP_COMPUTATION';
    LAST_TIMESTAMP           : result:= 'LAST_TIMESTAMP';
    SHORTABLE                : result:= 'SHORTABLE';
    FUNDAMENTAL_RATIOS       : result:= 'FUNDAMENTAL_RATIOS';
    RT_VOLUME                : result:= 'RT_VOLUME';
    HALTED                   : result:= 'HALTED';
    BID_YIELD                : result:= 'BID_YIELD';
    ASK_YIELD                : result:= 'ASK_YIELD';
    LAST_YIELD               : result:= 'LAST_YIELD';
    CUST_OPTION_COMPUTATION  : result:= 'CUST_OPTION_COMPUTATION';
    TRADE_COUNT              : result:= 'TRADE_COUNT';
    TRADE_RATE               : result:= 'TRADE_RATE';
    VOLUME_RATE              : result:= 'VOLUME_RATE';
    LAST_RTH_TRADE           : result:= 'LAST_RTH_TRAD';
   end;
  end;

 procedure TTWSCom.TWSErrorMessage(Sender: TObject; id: Integer; errorCode: Integer; errorMsg: WideString);
  begin
   if FConnectionPending and (errorCode = 2104) or (errorCode = 2106) then
    begin
     FConnected:= true;
     FConnectionPending:= false;

     TWSClass.ComServer.reqOpenOrders;
    end;

   AddMessage(IntToStr(errorCode) + ' ' + errorMsg);
  end;

 procedure TTWSCom.TWSConnectionClosed(Sender: TObject);
  begin
   FConnected:= false;
   FConnectionPending:= false;
   AddMessage('connection closed');
  end;

 procedure TTWSCom.TWSTickPrice(Sender: TObject; id: Integer; tickType: Integer; price: Double; canAutoExecute: LongInt);
  var idx: integer;
      s: shortstring;
  begin
   idx:= FindContractbyID(id);
   //s:= TranslateTickType(tickType);

   case TTickType(tickType) of
    BID_PRICE: begin FContracts[idx].BIDPrice:= price; FContracts[idx].LastTickTime:= Now; end;
    ASK_PRICE: begin FContracts[idx].ASKPrice:= price; FContracts[idx].LastTickTime:= Now; end;
    LAST_PRICE: if price <> 0 then begin FContracts[idx].LastTradePrice:= price; FContracts[idx].LastTickTime:= Now; end;
    OPEN_TICK: begin FContracts[idx].OpenPrice:= price; FContracts[idx].LastTickTime:= Now; end;
    HIGH: begin FContracts[idx].HighPrice:= price; FContracts[idx].LastTickTime:= Now; end;
    LOW: begin FContracts[idx].LowPrice:= price; FContracts[idx].LastTickTime:= Now; end;
    CLOSE_PRICE: begin FContracts[idx].ClosePrice:= price; FContracts[idx].LastTickTime:= Now; end;
   end;
  end;

 procedure TTWSCom.TWSTickSize(Sender: TObject; id: Integer; tickType: Integer; size: Integer);
  var idx: integer;
      s: shortstring;
  begin
   idx:= FindContractbyID(id);
   //s:= TranslateTickType(tickType);

   case TTickType(tickType) of
    BID_SIZE: begin FContracts[idx].BIDSize:= size; FContracts[idx].LastTickTime:= Now; end;
    ASK_SIZE: begin FContracts[idx].ASKSize:= size; FContracts[idx].LastTickTime:= Now; end;
    LAST_SIZE: if size <> 0 then begin FContracts[idx].LastTradeSize:= size; FContracts[idx].LastTickTime:= Now; end;
   end;
  end;

 procedure TTWSCom.TWSTickGeneric(Sender: TObject; id: Integer; tickType: Integer; value: Double);
  var idx: integer;
      s: shortstring;
  begin
   //AddMessage('Generic Tick ' + IntToStr(tickType) + ' (' + TranslateTickType(TickType) + ') on id ' + IntToStr(id) + ', value: ' + FloatToStr(value));
   idx:= FindContractbyID(id);
   //s:= TranslateTickType(tickType);

   case TTickType(tickType) of
    TRADE_COUNT: FContracts[idx].Active:= true;
   end;
  end;

 procedure TTWSCom.TWSTickString(Sender: TObject; id: Integer; tickType: Integer; value: WideString);
  var idx: integer;
      lst_str: TStringArray;
      str_lastprice, str_lastsize, str_lasttime, str_totalvolume, str_vwap, str_singletrade: shortstring;
      flt_lastprice, flt_vwap: double;
      int_lastsize, int_totalvolume: integer;
      int_lasttime: Int64;
      dt_lasttime: TDateTime;
      s: shortstring;
  begin
   idx:= FindContractbyID(id);
   //s:= TranslateTickType(tickType);
   if idx = -1 then Exit;
   if value = '' then Exit;

   case TTickType(TickType) of
    LAST_TIMESTAMP: begin
                     //AddMessage('Tick Type: ' + TranslateTickType(TickType) + '; Value="' + value + '"');
                     str_lasttime:= value;

                     //  convert value
                     try
                      int_lasttime:= StrToInt64(str_lasttime);
                      dt_lasttime:= UnixToDateTime(int_lasttime{ div 1000});
                     except
                     end;

                     FContracts[idx].LastTickTime:= Now;
                     FContracts[idx].Active:= true;
                     FContracts[idx].LastTradeTime:= dt_lasttime;
                    end;
    RT_VOLUME     : begin
                     //AddMessage('Tick Type: ' + TranslateTickType(TickType) + '; Value="' + value + '"');
                     lst_str:= SplitString(value, ';');

                     if Length(lst_str) = 6 then
                      begin
                       str_lastprice:= lst_str[0];
                       str_lastsize:= lst_str[1];
                       str_lasttime:= lst_str[2];
                       str_totalvolume:= lst_str[3];
                       str_vwap:= lst_str[4];
                       str_singletrade:= lst_str[5];

                       //  convert values
                       try
                        flt_lastprice:= 0;
                        int_lastsize:= 0;
                        int_lasttime:= 0;
                        int_totalvolume:= 0;
                        flt_vwap:= 0;

                        if str_lastprice <> '' then flt_lastprice:= StrToFloat(str_lastprice);
                        if str_lastsize <> '' then int_lastsize:= StrToInt(str_lastsize);
                        if str_lasttime <> '' then int_lasttime:= StrToInt64(str_lasttime);
                        if str_totalvolume <> '' then int_totalvolume:= StrToInt(str_totalvolume);
                        if str_vwap <> '' then flt_vwap:= StrToFloat(str_vwap);

                        //  decode Unix time
                        dt_lasttime:= UnixToDateTime(int_lasttime div 1000);
                       except
                       end;

                       if (flt_lastprice <> 0) and (int_lastsize <> 0) then
                        begin
                         FContracts[idx].LastTickTime:= Now;
                         FContracts[idx].Active:= true;
                         FContracts[idx].LastTradePrice:= flt_lastprice;
                         FContracts[idx].LastTradeSize:= int_lastsize;
                         FContracts[idx].LastTradeTime:= dt_lasttime;
                         FContracts[idx].TotalVolume:= int_totalvolume;
                         FContracts[idx].VWAP:= flt_vwap;
                        end;

                       //AddMessage('time: ' + str_lasttime);
                      end;
                    end;
   end;

  end;

 procedure TTWSCom.TWSNextOrderID(Sender: TObject; id: Integer);
  begin
   CurrentOrderID:= id;
  end;

 procedure TTWSCom.TWSOrderStatus(Sender: TObject; id: Integer; status: WideString; filled: Integer; remaining: Integer; avgFillPrice: Double; permId: Integer; parentId: Integer; lastFillPrice: Double; clientId: Integer; whyHeld: WideString);
  var idx_ctr, idx_ord: integer;
  begin
   AddMessage('Order ' + IntToStr(id) + ' ' + status);

   idx_ctr:= FindContractForOrder(id);
   if idx_ctr = -1 then Exit;
   idx_ord:= FindOrderbyID(idx_ctr, id);
   if idx_ord = -1 then Exit;

   FContracts[idx_ctr].Orders[idx_ord].FillQuantity:= filled;
   FContracts[idx_ctr].Orders[idx_ord].AveragePrice:= avgFillPrice;
  end;

 procedure TTWSCom.TWSOperOrderEx(Sender: TObject; orderId: Integer; contract: IContract; order: IOrder; orderState: IOrderState);
  var i, k: integer;
      b: boolean;
  begin
   if not FConnected then Exit;

   //  search the contract
   i:= FindContractbyMktSym(contract.primaryExchange, contract.symbol);
   if i = -1 then i:= AddContract(contract.symbol, contract.secType, contract.expiry, contract.multiplier, contract.exchange, contract.primaryExchange, contract.currency);
   if i = -1 then Exit;

   b:= false;
   k:= -1;
   while not b and (k < Length(FContracts[i].Orders) - 1) do
    begin
     k += 1;
     if FContracts[i].Orders[k].ID = orderId then b:= true;
    end;

   if not b then
    begin
     //  add order
     k:= Length(FContracts[i].Orders);
     SetLength(FContracts[i].Orders, k + 1);
     FContracts[i].Orders[k].ID:= orderID;
     FContracts[i].Orders[k].Order:= order;
    end;
  end;

 //-----------------------------------------------------------------------------
 //  Contracts


 function TTWSCom.GetContractsCount: integer;
  begin
   result:= Length(FContracts);
  end;

 function TTWSCom.GetContract(Index: Variant): TTWSContract;
  var idx: integer;
  begin
   FillChar(result, sizeof(result), 0);

   case TVarData(Index).vtype of
    varsmallint, varinteger, vardecimal,
    varshortint, varbyte, varword,
    varlongword, varint64: idx:= Index;
    varstring: idx:= FindContractbySymbol(string(Index));
   end;

   if (idx > -1) and (idx < Length(FContracts)) then result:= FContracts[idx];
  end;

 function TTWSCom.GetOrder(Index: integer): TTWSOrder;
  var idx_ctr, idx_ord: integer;
  begin
   FillChar(result, sizeof(result), 0);
   result.ID:= -1;

   idx_ctr:= FindContractForOrder(Index);
   if idx_ctr = -1 then Exit;
   idx_ord:= FindOrderbyID(idx_ctr, Index);
   if idx_ord = -1 then Exit;

   result:= FContracts[idx_ctr].Orders[idx_ord];
  end;

 function TTWSCom.FindContractbyID(ID: integer): integer;
  var b: boolean;
      i: integer;
  begin
   result:= -1;

   b:= false;
   i:= -1;
   while not b and (i < Length(FContracts) - 1) do
    begin
     i += 1;
    if FContracts[i].ID = ID then b:= true;
    end;

   if b then result:= i;
  end;

 function TTWSCom.FindContractbySymbol(Symbol: string): integer;
  var b: boolean;
      i: integer;
  begin
   result:= -1;

   b:= false;
   i:= -1;
   while not b and (i < Length(FContracts) - 1) do
    begin
     i += 1;
     if FContracts[i].Contract <> nil then
      if UpperCase(FContracts[i].Contract.symbol) = UpperCase(Symbol) then b:= true;
    end;

   if b then result:= i;
  end;

 function TTWSCom.FindContractbyMktSym(market, symbol: shortstring): integer;
  var b: boolean;
      i: integer;
  begin
   result:= -1;

   b:= false;
   i:= -1;
   while not b and (i < Length(FContracts) - 1) do
    begin
     i += 1;
     if FContracts[i].Contract <> nil then
      if (UpperCase(FContracts[i].Contract.primaryExchange) = UpperCase(market)) and
         (UpperCase(FContracts[i].Contract.symbol) = UpperCase(symbol)) then b:= true;
    end;

   if b then result:= i;
  end;

 function TTWSCom.AddContract(Symbol, SecurityType, Expiry, Multiplier, Exchange, PrimaryExchange, Currency: string): integer;
  var ctr: IContract;
      k: integer;
  begin
   result:= -1;
   if TWSClass = nil then Exit;
   if not FConnected then Exit;

   k:= Length(FContracts);

   ctr:= TWSClass.ComServer.createContract;
   ctr.symbol:= Symbol;
   ctr.secType:= SecurityType;
   ctr.expiry:= Expiry;
   ctr.multiplier:= Multiplier;
   ctr.exchange:= Exchange;
   ctr.primaryExchange:= PrimaryExchange;
   ctr.currency:= Currency;

   TWSClass.ComServer.reqMktDataEx(FCtrID, ctr, '100,101,104,105,106,107,165,221,225,233,236,258,293,294,295,318', 0, nil);
   //TWSClass.ComServer.reqMktDataEx(FCtrID, ctr, '', 1, nil);

   SetLength(FContracts, k + 1);
   FillChar(FContracts[k], sizeof(TTWSContract), 0);
   FContracts[k].ID:= FCtrID;
   FContracts[k].Contract:= ctr;
   result:= FCtrID;
   FCtrID += 1;
  end;

 function TTWSCom.FindContractForOrder(ID: integer): integer;
  var b: boolean;
      i, j: integer;
  begin
   result:= -1;
   i:= -1;
   b:= false;
   while not b and (i < Length(FContracts) - 1) do
    begin
     i += 1;
     j:= -1;

     while not b and (j < Length(FContracts[i].Orders) - 1) do
      begin
       j += 1;

       if FContracts[i].Orders[j].ID = ID then b:= true;
      end;
    end;

   if b then result:= i;
  end;

 function TTWSCom.FindOrderbyID(ContractIndex: integer; OrderID: integer): integer;
  var b: boolean;
      i: integer;
  begin
   result:= -1;
   if (ContractIndex < 0) or (ContractIndex >= Length(FContracts)) then Exit;

   b:= false;
   i:= -1;
   while not b and (i < Length(FContracts[ContractIndex].Orders) - 1) do
    begin
     i += 1;
     if FContracts[ContractIndex].Orders[i].ID = OrderID then b:= true;
    end;

   if b then result:= i;
  end;

 function TTWSCom.LaunchOrder(Market, Symbol: shortstring; Action: TTWSOrderAction; Quantity: integer): integer;
 var ctr: IContract;
     ord: IOrder;
     k, idx_ctr: integer;
 begin
  result:= -1;
  if TWSClass = nil then Exit;
  if not FConnected then Exit;

  idx_ctr:= FindContractbyMktSym(Market, Symbol);
  if idx_ctr = -1 then Exit;
  ctr:= FContracts[idx_ctr].Contract;

  ord:= TWSClass.ComServer.createOrder;
  ord.clientId:= FClientID;
  ord.orderId:= CurrentOrderID;
  ord.permId:= 0;

  case Action of
   ac_BUY   : ord.action:= 'BUY';
   ac_SELL  : ord.action:= 'SELL';
   ac_SSHORT: ord.action:= 'SSHORT';
  end;

  ord.auxPrice:= 0;
  ord.lmtPrice:= 0;

  ord.orderType:= 'MKT';
  ord.totalQuantity:= Quantity;

  //  add order to lists
  k:= Length(FContracts[idx_ctr].Orders);
  SetLength(FContracts[idx_ctr].Orders, k + 1);
  FContracts[idx_ctr].Orders[k].ID:= ord.orderId;
  FContracts[idx_ctr].Orders[k].Order:= ord;
  FContracts[idx_ctr].Orders[k].Quantity:= Quantity;
  FContracts[idx_ctr].Orders[k].FillQuantity:= 0;

  //TWSClass.ComServer.placeOrder();
  TWSClass.ComServer.placeOrderEx(CurrentOrderID, ctr, ord);
  result:= CurrentOrderID;

  CurrentOrderID += 1;
  TWSClass.ComServer.reqIds(1);
 end;

initialization
 _Com:= nil;
finalization
// FreeAndNil(_Com);
end.

