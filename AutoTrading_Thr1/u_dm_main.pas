unit u_dm_main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, BufDataset, FileUtil, u_finance_request, Forms, TypInfo, DateUtils;


type  TPD=record
    SHORT :string;
    LONG :string;
    STANDBY :string;
  end;

const TPositionDirection:TPD = (SHORT:'SHRT';LONG:'LONG';STANDBY:'STBY');


type TMarketPosition=record


  NRPOS, VOLUME,
  HISTORY_INDEX:integer; // HISTORY_INDEX = unused but recorded
  TEMP_ID: Int64; // TEMP_ID = transaction pairing
  last_operation_milis : longint;

  ACTIVE,OPENED, RE_OPEN:boolean;

  LAST_BUY_PRICE, LAST_SELL_PRICE,
  OPEN_PERCENT,  STOP_PERCENT,  TAKE_PERCENT, PROT_MARGIN,  PROT_CORECT,
  SHORT_OPEN_PERCENT,  SHORT_STOP_PERCENT,  SHORT_TAKE_PERCENT, SHORT_PROT_MARGIN,  SHORT_PROT_CORECT,
  PROT_START_PRICE, LAST_MARKET_PRICE,

  RE_OPEN_PERCENT, SHORT_RE_OPEN_PERCENT,

  STOP_PRICE: double;

  TOTAL_PL : double;

  NR_AVG : integer;
  AVERAGE_PRICE : double;
  SMA_PRICE : double;
  EMA_PRICE : double;
  NR_REC_PRICES : integer;
  OLDEST_PRICE : double;
  TIME_AVERAGE : boolean;

  USE_EMA : boolean;

  FORCE_BUY : boolean;

  CLOSE_NOW_AT_MARKET : boolean;
  CLOSE_AT_MARKETCLOSING : boolean;

  PREV_PRICE_1 : double;
  PREV_PRICE_2 : double;
  PREV_PRICE_3 : double;
  PREV_PRICE_4 : double;
  PREV_PRICE_5 : double;
  PREV_PRICE_6 : double;
  PREV_PRICE_7 : double;
  PREV_PRICE_8 : double;
  PREV_PRICE_9 : double;
  PREV_PRICE_10 : double;
  PREV_PRICE_11 : double;
  PREV_PRICE_12 : double;
  PREV_PRICE_13 : double;
  PREV_PRICE_14 : double;
  PREV_PRICE_15 : double;
  PREV_PRICE_16 : double;
  PREV_PRICE_17 : double;
  PREV_PRICE_18 : double;
  PREV_PRICE_19 : double;
  PREV_PRICE_20 : double;
  PREV_PRICE_21 : double;
  PREV_PRICE_22 : double;
  PREV_PRICE_23 : double;
  PREV_PRICE_24 : double;
  PREV_PRICE_25 : double;
  PREV_PRICE_26 : double;
  PREV_PRICE_27 : double;
  PREV_PRICE_28 : double;
  PREV_PRICE_29 : double;
  PREV_PRICE_30 : double;
  PREV_PRICE_31 : double;
  PREV_PRICE_32 : double;




  START_PRICE_MAX, START_PRICE_MIN : double;


  MARKET_TIME: TDateTime;
  Prev_Market_Time: TDateTime;

  COMPANY_NAME, MARKET, SYMBOL: string[100];

  Prev_Price  : double;
  Open_Price  : double;
  Take_Price  : double;
  Prot_Correction_Price: double;
  Algorithm_Price : double;

  Open_Value: double;
  Market_Value: double;
  Current_PL : double;

  isProtection: boolean;

  DIRECTION : string[100];
  PREV_DIRECTION : string[100];

  str_Average32Info : string[255];

end;

type

  { Tdm_Main }

  Tdm_Main = class(TDataModule)
    ds_ClonedHistory: TDatasource;
    ds_ClonedPrices: TDatasource;
    dset_Prices: TBufDataset;
    dset_ClonedPositions: TBufDataset;
    ds_Temp_Pos: TDatasource;
    dset_Temp_Positions: TBufDataset;
    ds_History: TDatasource;
    dset_History: TBufDataset;
    dset_Symbols: TBufDataset;
    ds_Positions: TDatasource;
    dset_Positions: TBufDataset;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { private declarations }
    dset_ClonedHistory: TBufDataset;
    dset_ClonedPrices: TBufDataset;
    MarketPlatform : TExchangeConnector;

    //  Added Dan 20141015
    ExchangeConnectors: array of TExchangeConnector;

    dset_ClonedPricesAverage: TBufDataset;

    procedure PrepareClonedPricesAverage(str_symbol:string);

    function  CalcStand32Average(var CPos:TMarketPosition): double;
    function  CalcGenericAverage(var CPos:TMarketPosition; i_prev_nr_prices: integer): double;




  public
    { public declarations }
    _DB_VER : String;
    _APP_VER : string;
    dt_LastDateTime : TDateTime;
    inMainTimer, bStartStop: Boolean;

    tm_Market_start, tm_Market_stop:TTime;

    //  Added Dan 20141015
    function CreateExchangeConnector: TExchangeConnector;


    function  GetQuote(market: string; symbol: string): TMarketMessage;
    function  GetCurrentPosition:TMarketPosition;
    function  GetCurrentClonedPosition:TMarketPosition;
    procedure ModifyPosition(CPos:TMarketPosition);
    function  GetMarketName(str_symbol:string):string;
    function  GetSymbolName(str_symbol:string):string;

    function  GetRealTime(var CPos: TMarketPosition):boolean;

    function MarketBuy(var CPos:TMarketPosition): TMarketMessage;
    function MarketSell(var CPos:TMarketPosition): TMarketMessage;

    procedure AddHistory(str_Action, str_State:string; CPos:TMarketPosition; f_price:double =0);

    procedure Set_MarketPlatform_str_Requests(str_s:string);
    function  Get_MarketPlatform_str_Requests:string;

    procedure LoadData;
    procedure SaveData;

    procedure CreateTempTables;
    procedure SyncClonePositions;

    procedure CloneHistory;
    procedure PrepareCloneHistory;

    function GetPositionsList : TList;

    function SortBufDataSet(DataSet: TBufDataSet;const FieldName: String; sorttype: TIndexOptions ): Boolean;
    function _SortBufDataSet(DataSet: TBufDataSet;const FieldName: String): Boolean;

    procedure AddPriceHistory(CPos : TMarketPosition; str_action:string ='');

    procedure SetNewPrice(var CPos:TMarketPosition; mres:TMarketMessage; str_action:string='' );

    function GetPosInfo(CPos: TMarketPosition):string;

    function CalcClonedPricesAverage(str_symbol:string; int_nr_prices:integer): double;

  end;

var
  dm_Main: Tdm_Main;

implementation

{$R *.lfm}

{ Tdm_Main }

function Tdm_Main._SortBufDataSet(DataSet: TBufDataSet;const FieldName: String): Boolean;
var
  i: Integer;
  IndexDefs: TIndexDefs;
  IndexName: String;
  IndexOptions: TIndexOptions;
  Field: TField;
begin
  Result := False;
  Field := DataSet.Fields.FindField(FieldName);
  //If invalid field name, exit.
  if Field = nil then Exit;
  //if invalid field type, exit.
  if {(Field is TObjectField) or} (Field is TBlobField) or
    {(Field is TAggregateField) or} (Field is TVariantField)
     or (Field is TBinaryField) then Exit;
  //Get IndexDefs and IndexName using RTTI
  if IsPublishedProp(DataSet, 'IndexDefs') then
    IndexDefs := GetObjectProp(DataSet, 'IndexDefs') as TIndexDefs
  else
    Exit;
  if IsPublishedProp(DataSet, 'IndexName') then
    IndexName := GetStrProp(DataSet, 'IndexName')
  else
    Exit;
  //Ensure IndexDefs is up-to-date
  IndexDefs.Updated:=false; {<<<<---This line is critical as IndexDefs.Update will do nothing on the next sort if it's already true}
  IndexDefs.Update;
  //If an ascending index is already in use,
  //switch to a descending index
  if IndexName = FieldName + '__IdxA'
  then
    begin
      IndexName := FieldName + '__IdxD';
      IndexOptions := [ixDescending];
    end
  else
    begin
      IndexName := FieldName + '__IdxA';
      IndexOptions := [];
    end;
  //Look for existing index
  for i := 0 to Pred(IndexDefs.Count) do
  begin
    if IndexDefs[i].Name = IndexName then
      begin
        Result := True;
        Break
      end;  //if
  end; // for
  //If existing index not found, create one
  if not Result then
      begin
        if IndexName=FieldName + '__IdxD' then
          DataSet.AddIndex(IndexName, FieldName, IndexOptions, FieldName)
        else
          DataSet.AddIndex(IndexName, FieldName, IndexOptions);
        Result := True;
      end; // if not
  //Set the index
  SetStrProp(DataSet, 'IndexName', IndexName);
  DataSet.First;
end;

procedure Tdm_Main.AddPriceHistory(CPos: TMarketPosition;  str_action:string ='');
begin
  dt_LastDateTime:= CPos.MARKET_TIME;
  if str_action<>'' then
    begin
      dset_Prices.Insert;
      dset_Prices.FieldByName('SYMBOL').AsString := CPos.SYMBOL ;
      dset_Prices.FieldByName('ACTION').AsString := str_action;
      dset_Prices.FieldByName('INFO').AsString := GetPosInfo(CPos);
      dset_Prices.FieldByName('MARKET_TIME').AsDateTime  := CPos.MARKET_TIME;
      dset_Prices.FieldByName('VALUE').AsFloat  := CPos.LAST_MARKET_PRICE;
      dset_Prices.FieldByName('NRPOS').AsInteger := CPos.NRPOS;
      dset_Prices.FieldValues['TEMP_ID'] := CPos.TEMP_ID;

      dset_Prices.FieldValues['SMA_PRICE'] := Cpos.SMA_PRICE;
      dset_Prices.FieldValues['EMA_PRICE'] := Cpos.EMA_PRICE;
      dset_Prices.FieldValues['AVERAGE_PRICE'] := Cpos.Algorithm_Price;

      dset_Prices.FieldByName('TIMEOUT').AsLongint:=CPos.last_operation_milis;

      dset_Prices.Post;
    end
  else
  begin
    if CPos.Prev_Price <> CPos.LAST_MARKET_PRICE then
      begin
        dset_Prices.Insert;
        dset_Prices.FieldByName('SYMBOL').AsString := CPos.SYMBOL ;
        dset_Prices.FieldByName('ACTION').AsString := str_action;
        dset_Prices.FieldByName('INFO').AsString := GetPosInfo(CPos);
        dset_Prices.FieldByName('MARKET_TIME').AsDateTime  := CPos.MARKET_TIME;
        dset_Prices.FieldByName('VALUE').AsFloat  := CPos.LAST_MARKET_PRICE;
        dset_Prices.FieldByName('NRPOS').AsInteger := CPos.NRPOS;
        dset_Prices.FieldValues['TEMP_ID'] := CPos.TEMP_ID;

        dset_Prices.FieldValues['SMA_PRICE'] := Cpos.SMA_PRICE;
        dset_Prices.FieldValues['EMA_PRICE'] := Cpos.EMA_PRICE;
        dset_Prices.FieldValues['AVERAGE_PRICE'] := Cpos.Algorithm_Price;

        dset_Prices.FieldByName('TIMEOUT').AsInteger :=CPos.last_operation_milis;
        dset_Prices.Post;
      end;
  end;
end;


procedure Tdm_Main.SetNewPrice(var CPos: TMarketPosition; mres: TMarketMessage; str_action:string='');
var
  i_prev_nr_prices:integer;
begin

  CPos.Prev_Price := CPos.LAST_MARKET_PRICE;
  CPos.Prev_Market_Time := CPos.MARKET_TIME;
  CPos.MARKET_TIME := mres.d_time;
  CPos.LAST_MARKET_PRICE := mres.f_price;
  CPos.last_operation_milis := mres.milis;

  if CPos.MARKET_TIME < CPos.Prev_Market_Time then
    begin
      CPos.MARKET_TIME := CPos.Prev_Market_Time;
    end;


  if CPos.NR_AVG = 0 then
  begin
     CPos.Algorithm_Price := mres.f_price; // set algorithm price as current price by default if no average
     AddPriceHistory(CPos, str_action);
     exit;   // exit algorithm if no average is needed for current position
  end
  else
     CPos.Algorithm_Price := CPos.AVERAGE_PRICE; // set algorithm previous AVERAGE

  ///
  //   CalsAverage is AN OPTION !!! MUST TEST IT !!!
  ///



  if CPos.TIME_AVERAGE  or (CPos.LAST_MARKET_PRICE <> CPos.Prev_Price)then
  begin

    i_prev_nr_prices:= CPos.NR_REC_PRICES;
    if CPos.NR_REC_PRICES < CPos.NR_AVG then
      Cpos.NR_REC_PRICES := Cpos.NR_REC_PRICES +1;

    CalcGenericAverage(CPos,i_prev_nr_prices);
    CalcStand32Average(CPos);

    if CPos.NR_AVG <= 32 then
     begin
       if CPos.USE_EMA then
        CPos.AVERAGE_PRICE := CPos.EMA_PRICE
       else
        CPos.AVERAGE_PRICE := CPos.SMA_PRICE;
     end
    else
      CPos.AVERAGE_PRICE := Cpos.EMA_PRICE;


    CPos.Algorithm_Price := CPos.AVERAGE_PRICE;
    AddPriceHistory(CPos,  str_action);
  end
  else    // NO MARKET CHANGE OR NO TIME AVERAGE - just add history IF str_action not empty
   if str_action <>'' then
     AddPriceHistory(Cpos, str_action);


end;

function Tdm_Main.GetPosInfo(CPos: TMarketPosition): string;
var str_info: string;
    f_long_open,f_short_open:double;
begin
 if CPos.OPENED then
   str_info := 'O:1 D:'+CPos.DIRECTION
 else
  begin
    if CPos.PREV_DIRECTION <> TPositionDirection.STANDBY then
      f_short_open := CPos.START_PRICE_MAX * (1 + (CPos.SHORT_RE_OPEN_PERCENT / 100 ))
    else
      f_short_open := CPos.START_PRICE_MAX * (1 + (CPos.SHORT_OPEN_PERCENT / 100 ));

    if CPos.PREV_DIRECTION <> TPositionDirection.STANDBY then
      f_long_open := CPos.START_PRICE_MIN * (1 + (CPos.RE_OPEN_PERCENT / 100 ))
    else
      f_long_open := CPos.START_PRICE_MIN * (1 + (CPos.OPEN_PERCENT / 100 ));

   str_info := 'O:0 L/S:'+FormatFloat('0.00',f_long_open)+'/'+FormatFloat('0.00',f_short_open)+' D:'+CPos.DIRECTION;
  end;

 if Cpos.TIME_AVERAGE then
   str_info := str_info +' MT:1'
 else
   str_info := str_info +' MT:0';

 if Cpos.USE_EMA then
   str_info := str_info +' EMA:1'
 else
   str_info := str_info +' EMA:0';

 str_info := str_info+' NA:' + IntToStr(Cpos.NR_AVG);
 str_info := str_info+' RA:' + IntToStr(Cpos.NR_REC_PRICES);
 (*
 str_info := str_info+' AP:' + FormatFloat('0.00', Cpos.Algorithm_Price );
 str_info := str_info+' BP:' + FormatFloat('0.00', Cpos.LAST_BUY_PRICE);
 str_info := str_info+' SP:' + FormatFloat('0.00', Cpos.LAST_SELL_PRICE);

 str_info := str_info+' LO:' + FormatFloat('0.00', Cpos.OPEN_PERCENT);
 str_info := str_info+' LS:' + FormatFloat('0.00', Cpos.STOP_PERCENT);
 str_info := str_info+' LT:' + FormatFloat('0.00', Cpos.TAKE_PERCENT);
 str_info := str_info+' LP:' + FormatFloat('0.00', Cpos.PROT_MARGIN);
 str_info := str_info+' LC:' + FormatFloat('0.00', Cpos.PROT_CORECT);

 str_info := str_info+' SO:' + FormatFloat('0.00', Cpos.SHORT_OPEN_PERCENT);
 str_info := str_info+' SS:' + FormatFloat('0.00', Cpos.SHORT_STOP_PERCENT);
 str_info := str_info+' ST:' + FormatFloat('0.00', Cpos.SHORT_TAKE_PERCENT);
 str_info := str_info+' SP:' + FormatFloat('0.00', Cpos.SHORT_PROT_MARGIN);
 str_info := str_info+' SC:' + FormatFloat('0.00', Cpos.SHORT_PROT_CORECT );
 *)

 str_Info := Str_info+' AVG('+Cpos.str_Average32Info+')';

 str_Info := Str_info+' C:'+TimeToStr(CPos.MARKET_TIME)+'/P:'+TimeToStr(CPos.Prev_Market_Time);

 Result := str_info;
end;

function Tdm_Main.CalcClonedPricesAverage(str_symbol: string; int_nr_prices: integer
  ): double;
var
  f_sum:double;
  nr_vals,i:integer;
begin
  nr_vals := int_nr_prices;
  PrepareClonedPricesAverage(str_symbol);
  if dset_ClonedPricesAverage.RecordCount < int_nr_prices then
  begin
     nr_vals:=dset_ClonedPricesAverage.RecordCount;
  end;

  dset_ClonedPricesAverage.Last;
  i:=1;
  f_sum := 0;
  while i<nr_vals do
     begin
       i:=i+1;
       f_sum := f_sum +  dset_ClonedPricesAverage.FieldByName('VALUE').AsFloat;
       dset_ClonedPricesAverage.Prior;
     end;
   f_sum := f_sum / nr_vals;
   Result := f_sum;
end;

procedure Tdm_Main.DataModuleCreate(Sender: TObject);
begin
 SetLength(ExchangeConnectors, 0);

 MarketPlatform := TExchangeConnector.Create;
 dset_ClonedPrices := nil;
 dset_ClonedHistory :=nil;
end;

procedure Tdm_Main.DataModuleDestroy(Sender: TObject);
var k: integer;
begin
 //  added Dan 20141015
 for k:= 0 to Length(ExchangeConnectors) - 1 do
  try
   FreeAndNil(ExchangeConnectors[k]);
  except
  end;
end;

//  added Dan 20141015
function Tdm_Main.CreateExchangeConnector: TExchangeConnector;
 var k: integer;
 begin
  k:= Length(ExchangeConnectors);
  SetLength(ExchangeConnectors, k + 1);
  ExchangeConnectors[k]:= TExchangeConnector.Create;

  result:= ExchangeConnectors[k];
 end;

procedure Tdm_Main.PrepareClonedPricesAverage(str_symbol:string);
var i : integer;
   vFieldDef: TFieldDef;
   str_Field:string;
begin

  if dset_ClonedPricesAverage<> nil then
  begin
    dset_ClonedPricesAverage.Free;
  end;

  dset_ClonedPrices := TBufDataset.Create (Self);
  dset_ClonedPricesAverage.MaxIndexesCount := 10;

  dset_ClonedPricesAverage.Active:= False;
  dset_ClonedPricesAverage.FieldDefs.Clear;
  for I:=0 to dset_Prices.FieldDefs.Count-1 do
  begin
     vFieldDef:=dset_ClonedPricesAverage.FieldDefs.AddFieldDef;
     with dset_Prices.FieldDefs[I] do
          begin
             vFieldDef.Name:=Name;

             if DataType <> ftAutoInc then
               vFieldDef.DataType:=DataType
             else
               vFieldDef.DataType:=ftInteger;

             vFieldDef.Size:=Size;
             vFieldDef.Required:=Required;
          end;
  end;
  dset_ClonedPricesAverage.CreateDataset;
  dset_ClonedPricesAverage.Active := True;

  dset_Prices.Filtered := False;
  dset_Prices.Filter := 'SYMBOL='+ str_symbol;
  dset_Prices.Filtered := True;

  dset_Prices.First;
  while not dset_Prices.EOF do
  begin
    dset_ClonedPricesAverage.Insert;
    for i:= 0 to dset_Prices.FieldCount - 1 do
    begin
      try
        str_Field:=dset_Prices.FieldDefs[i].Name;
        dset_ClonedPricesAverage.FieldValues[str_Field]:= dset_Prices.FieldValues[str_Field];
      Except
        _ShowMessage('CLONARE PRICES: Eroare la camp: '+str_Field);
      end;
    end;
    dset_ClonedPricesAverage.Post;
    dset_Prices.Next;
  end;

  dset_Prices.Filter := '';
  dset_Prices.Filtered := False;

  SortBufDataSet(dset_ClonedPricesAverage,'MARKET_TIME',[]);


end;

function Tdm_Main.CalcStand32Average(var CPos:TMarketPosition): double;
var i,cnt,nr_prices:integer;
      arr_prices: array[0..32] of double;
      avg_price:double;
begin

  CPos.PREV_PRICE_32 := CPos.PREV_PRICE_31;
  CPos.PREV_PRICE_31 := CPos.PREV_PRICE_30;
  CPos.PREV_PRICE_30 := CPos.PREV_PRICE_29;
  CPos.PREV_PRICE_29 := CPos.PREV_PRICE_28;
  CPos.PREV_PRICE_28 := CPos.PREV_PRICE_27;
  CPos.PREV_PRICE_27 := CPos.PREV_PRICE_26;
  CPos.PREV_PRICE_26 := CPos.PREV_PRICE_25;
  CPos.PREV_PRICE_25 := CPos.PREV_PRICE_24;
  CPos.PREV_PRICE_24 := CPos.PREV_PRICE_23;
  CPos.PREV_PRICE_23 := CPos.PREV_PRICE_22;
  CPos.PREV_PRICE_22 := CPos.PREV_PRICE_21;
  CPos.PREV_PRICE_21 := CPos.PREV_PRICE_20;
  CPos.PREV_PRICE_20 := CPos.PREV_PRICE_19;
  CPos.PREV_PRICE_19 := CPos.PREV_PRICE_18;
  CPos.PREV_PRICE_18 := CPos.PREV_PRICE_17;
  CPos.PREV_PRICE_17 := CPos.PREV_PRICE_16;
  CPos.PREV_PRICE_16 := CPos.PREV_PRICE_15;
  CPos.PREV_PRICE_15 := CPos.PREV_PRICE_14;
  CPos.PREV_PRICE_14 := CPos.PREV_PRICE_13;
  CPos.PREV_PRICE_13 := CPos.PREV_PRICE_12;
  CPos.PREV_PRICE_12 := CPos.PREV_PRICE_11;
  CPos.PREV_PRICE_11 := CPos.PREV_PRICE_10;
  CPos.PREV_PRICE_10 := CPos.PREV_PRICE_9;
  CPos.PREV_PRICE_9 := CPos.PREV_PRICE_8;
  CPos.PREV_PRICE_8 := CPos.PREV_PRICE_7;
  CPos.PREV_PRICE_7 := CPos.PREV_PRICE_6;
  CPos.PREV_PRICE_6 := CPos.PREV_PRICE_5;
  CPos.PREV_PRICE_5 := CPos.PREV_PRICE_4;
  CPos.PREV_PRICE_4 := CPos.PREV_PRICE_3;
  CPos.PREV_PRICE_3 := CPos.PREV_PRICE_2;
  CPos.PREV_PRICE_2 := CPos.PREV_PRICE_1;
  CPos.PREV_PRICE_1 := CPos.Prev_Price;    // PREV_PRICE MUST CONTAIN PREVIOUS PRICE AS LAST MUST CONTAIN CURRENT PRICE !

    arr_prices[0] := CPos.LAST_MARKET_PRICE;
    arr_prices[1] := CPos.PREV_PRICE_1;
    arr_prices[2] := CPos.PREV_PRICE_2;
    arr_prices[3] := CPos.PREV_PRICE_3;
    arr_prices[4] := CPos.PREV_PRICE_4;
    arr_prices[5] := CPos.PREV_PRICE_5;
    arr_prices[6] := CPos.PREV_PRICE_6;
    arr_prices[7] := CPos.PREV_PRICE_7;
    arr_prices[8] := CPos.PREV_PRICE_8;
    arr_prices[9] := CPos.PREV_PRICE_9;
    arr_prices[10] := CPos.PREV_PRICE_10;
    arr_prices[11] := CPos.PREV_PRICE_11;
    arr_prices[12] := CPos.PREV_PRICE_12;
    arr_prices[13] := CPos.PREV_PRICE_13;
    arr_prices[14] := CPos.PREV_PRICE_14;
    arr_prices[15] := CPos.PREV_PRICE_15;
    arr_prices[16] := CPos.PREV_PRICE_16;
    arr_prices[17] := CPos.PREV_PRICE_17;
    arr_prices[18] := CPos.PREV_PRICE_18;
    arr_prices[19] := CPos.PREV_PRICE_19;
    arr_prices[20] := CPos.PREV_PRICE_20;
    arr_prices[21] := CPos.PREV_PRICE_21;
    arr_prices[22] := CPos.PREV_PRICE_22;
    arr_prices[23] := CPos.PREV_PRICE_23;
    arr_prices[24] := CPos.PREV_PRICE_24;
    arr_prices[25] := CPos.PREV_PRICE_25;
    arr_prices[26] := CPos.PREV_PRICE_26;
    arr_prices[27] := CPos.PREV_PRICE_27;
    arr_prices[28] := CPos.PREV_PRICE_28;
    arr_prices[29] := CPos.PREV_PRICE_29;
    arr_prices[30] := CPos.PREV_PRICE_30;
    arr_prices[31] := CPos.PREV_PRICE_31;
    arr_prices[32] := CPos.PREV_PRICE_32;

    avg_price := 0;
    cnt:=0;
    CPos.str_Average32Info := '';

    if CPos.NR_AVG>32 then
      nr_prices:=32
    else
      nr_prices:=Cpos.NR_AVG;

    for i:=0 to nr_prices do
    begin
      avg_price := avg_price + arr_prices[i];
      if arr_prices[i] >0 then
      begin
        inc(cnt);
        CPos.str_Average32Info := CPos.str_Average32Info +' '+FormatFloat('0.00',arr_prices[i]);
      end;
    end;
    avg_price := avg_price / (cnt);

    CPos.SMA_PRICE := avg_price;

    Result := avg_price;
end;

function Tdm_Main.CalcGenericAverage(var CPos: TMarketPosition; i_prev_nr_prices:integer ): double;
var
  f_old_sum, f_new_average : double;
begin

  if i_prev_nr_prices < CPos.NR_AVG then
  begin
    f_old_sum := CPos.EMA_PRICE * i_prev_nr_prices;
    f_new_average := (f_old_sum  + CPos.LAST_MARKET_PRICE) / CPos.NR_REC_PRICES;
  end
  else
  begin
    CPos.OLDEST_PRICE := CPos.EMA_PRICE;
    //f_new_average := CPos.EMA_PRICE - CPos.OLDEST_PRICE / CPos.NR_AVG + CPos.LAST_MARKET_PRICE / CPos.NR_AVG ;
    f_new_average := (CPos.EMA_PRICE*(CPos.NR_AVG-1) + CPos.LAST_MARKET_PRICE) / CPos.NR_AVG;
  end;

  f_new_average := Round(f_new_average*1000)/1000;
  CPos.EMA_PRICE := f_new_average;
  Result := f_new_average;
end;


function Tdm_Main.GetQuote(market: string; symbol: string): TMarketMessage;
var  mRes: TMarketMessage;
begin
  mRes := MarketPlatform._GetQuote(Market, symbol);
  dt_LastDateTime:= mRes.d_time;
  Result := mRes;
end;

function Tdm_Main.GetCurrentPosition:TMarketPosition;
var
  CPos:TMarketPosition;
begin
  CPos.SYMBOL := '';
  CPos.LAST_MARKET_PRICE := 0;
  CPos.Current_PL := 0;
  CPos.Open_Price  := 0;
  CPos.Open_Value  := 0;
  CPos.Take_Price  := 0;
  CPos.Prot_Correction_Price  := 0;
  CPos.Prev_Price := 0;
  try
    CPos.SYMBOL := dset_Positions.FieldValues['SYMBOL'];
  except

  end;

  if (Not dset_Positions.EOF) or (CPos.Symbol<>'') then
   begin
     CPos.ACTIVE := dset_Positions.FieldValues['ACTIVE'] ;
     Cpos.NRPOS:=dset_Positions.FieldValues['NRPOS'] ;
     CPos.VOLUME :=dset_Positions.FieldValues['VOLUME'] ;
     CPos.HISTORY_INDEX:=dset_Positions.FieldValues['HISTORY_INDEX'] ;
     CPos.TEMP_ID:=dset_Positions.FieldValues['TEMP_ID'] ;
     CPos.OPENED:=dset_Positions.FieldValues['OPENED'] ;

     CPos.START_PRICE_MIN:= dset_Positions.FieldValues['START_PRICE_MIN'] ;
     CPos.START_PRICE_MAX:= dset_Positions.FieldValues['START_PRICE_MAX'] ;

     CPos.LAST_BUY_PRICE:=dset_Positions.FieldValues['LAST_BUY_PRICE'] ;
     CPos.LAST_SELL_PRICE:=dset_Positions.FieldValues['LAST_SELL_PRICE'] ;

     CPos.STOP_PRICE :=dset_Positions.FieldValues['STOP_PRICE'] ;

     {LONG PARAMETERS}
     CPos.OPEN_PERCENT:=dset_Positions.FieldValues['OPEN_PERCENT'] ;
     CPos.RE_OPEN_PERCENT:=dset_Positions.FieldValues['RE_OPEN_PERCENT'] ;
     CPos.STOP_PERCENT:=dset_Positions.FieldValues['STOP_PERCENT'] ;
     CPos.TAKE_PERCENT:=dset_Positions.FieldValues['TAKE_PERCENT'] ;
     CPos.PROT_MARGIN:= dset_Positions.FieldValues['PROT_MARGIN'] ;
     CPos.PROT_CORECT:= dset_Positions.FieldValues['PROT_CORECT'] ;
     {END LONG PARAMETERS}

     {SHORT PARAMETERS}
     CPos.SHORT_OPEN_PERCENT:=dset_Positions.FieldValues['SHORT_OPEN_PERCENT'] ;
     CPos.SHORT_RE_OPEN_PERCENT:=dset_Positions.FieldValues['SHORT_RE_OPEN_PERCENT'] ;
     CPos.SHORT_STOP_PERCENT:=dset_Positions.FieldValues['SHORT_STOP_PERCENT'] ;
     CPos.SHORT_TAKE_PERCENT:=dset_Positions.FieldValues['SHORT_TAKE_PERCENT'] ;
     CPos.SHORT_PROT_MARGIN:= dset_Positions.FieldValues['SHORT_PROT_MARGIN'] ;
     CPos.SHORT_PROT_CORECT:= dset_Positions.FieldValues['SHORT_PROT_CORECT'] ;
     {END SHORT PARAMETERS}

     CPos.PROT_START_PRICE:= dset_Positions.FieldValues['PROT_START_PRICE'];
     Cpos.isProtection := dset_Positions.FieldValues['PROTECTION_ZONE'];

     CPos.COMPANY_NAME:= dset_Positions.FieldValues['COMPANY_NAME'] ;
     CPos.MARKET:= dset_Positions.FieldValues['MARKET'] ;
     CPos.SYMBOL:= dset_Positions.FieldValues['SYMBOL'] ;
     CPos.TOTAL_PL := dset_Positions.FieldValues['TOTAL_PL'] ;

     CPos.RE_OPEN := dset_Positions.FieldValues['RE_OPEN'] ;

     Cpos.LAST_MARKET_PRICE := dset_Positions.FieldValues['LAST_MARKET_PRICE'];
     Cpos.MARKET_TIME := dset_Positions.FieldValues['MARKET_TIME'];

     Cpos.DIRECTION := dset_Positions.FieldValues['DIRECTION'];
     Cpos.PREV_DIRECTION := dset_Positions.FieldValues['PREV_DIRECTION'];

     CPos.Prev_Price := CPos.LAST_MARKET_PRICE;
     CPos.FORCE_BUY := dset_Positions.FieldValues['FORCE_BUY'];

     CPos.CLOSE_AT_MARKETCLOSING  := dset_Positions.FieldValues['CLOSE_AT_MARKETCLOSING'];
     CPos.CLOSE_NOW_AT_MARKET   := dset_Positions.FieldValues['CLOSE_NOW_AT_MARKET'];

     {BEGIN mobile average GENERIC}
     CPos.NR_AVG := dset_Positions.FieldValues['NR_AVG'];
     CPos.AVERAGE_PRICE := dset_Positions.FieldValues['AVERAGE_PRICE'];
     CPos.SMA_PRICE := dset_Positions.FieldValues['SMA_PRICE'];
     CPos.EMA_PRICE := dset_Positions.FieldValues['EMA_PRICE'];
     CPos.USE_EMA := dset_Positions.FieldValues['USE_EMA'];

     CPos.NR_REC_PRICES := dset_Positions.FieldValues['NR_REC_PRICES'];
     CPos.OLDEST_PRICE  := dset_Positions.FieldValues['OLDEST_PRICE'];
     CPos.TIME_AVERAGE :=  dset_Positions.FieldValues['TIME_AVERAGE'];
     {END mobile average 32x}

     {BEGIN mobile average GENERIC}
     CPos.PREV_PRICE_1 := dset_Positions.FieldValues['PREV_PRICE_1'];
     CPos.PREV_PRICE_2 := dset_Positions.FieldValues['PREV_PRICE_2'];
     CPos.PREV_PRICE_3 := dset_Positions.FieldValues['PREV_PRICE_3'];
     CPos.PREV_PRICE_4 := dset_Positions.FieldValues['PREV_PRICE_4'];
     CPos.PREV_PRICE_5 := dset_Positions.FieldValues['PREV_PRICE_5'];
     CPos.PREV_PRICE_6 := dset_Positions.FieldValues['PREV_PRICE_6'];
     CPos.PREV_PRICE_7 := dset_Positions.FieldValues['PREV_PRICE_7'];
     CPos.PREV_PRICE_8 := dset_Positions.FieldValues['PREV_PRICE_8'];
     CPos.PREV_PRICE_9 := dset_Positions.FieldValues['PREV_PRICE_9'];
     CPos.PREV_PRICE_10 := dset_Positions.FieldValues['PREV_PRICE_10'];
     CPos.PREV_PRICE_11 := dset_Positions.FieldValues['PREV_PRICE_11'];
     CPos.PREV_PRICE_12 := dset_Positions.FieldValues['PREV_PRICE_12'];
     CPos.PREV_PRICE_13 := dset_Positions.FieldValues['PREV_PRICE_13'];
     CPos.PREV_PRICE_14 := dset_Positions.FieldValues['PREV_PRICE_14'];
     CPos.PREV_PRICE_15 := dset_Positions.FieldValues['PREV_PRICE_15'];
     CPos.PREV_PRICE_16 := dset_Positions.FieldValues['PREV_PRICE_16'];
     CPos.PREV_PRICE_17 := dset_Positions.FieldValues['PREV_PRICE_17'];
     CPos.PREV_PRICE_18 := dset_Positions.FieldValues['PREV_PRICE_18'];
     CPos.PREV_PRICE_19 := dset_Positions.FieldValues['PREV_PRICE_19'];
     CPos.PREV_PRICE_20 := dset_Positions.FieldValues['PREV_PRICE_20'];
     CPos.PREV_PRICE_21 := dset_Positions.FieldValues['PREV_PRICE_21'];
     CPos.PREV_PRICE_22 := dset_Positions.FieldValues['PREV_PRICE_22'];
     CPos.PREV_PRICE_23 := dset_Positions.FieldValues['PREV_PRICE_23'];
     CPos.PREV_PRICE_24 := dset_Positions.FieldValues['PREV_PRICE_24'];
     CPos.PREV_PRICE_25 := dset_Positions.FieldValues['PREV_PRICE_25'];
     CPos.PREV_PRICE_26 := dset_Positions.FieldValues['PREV_PRICE_26'];
     CPos.PREV_PRICE_27 := dset_Positions.FieldValues['PREV_PRICE_27'];
     CPos.PREV_PRICE_28 := dset_Positions.FieldValues['PREV_PRICE_28'];
     CPos.PREV_PRICE_29 := dset_Positions.FieldValues['PREV_PRICE_29'];
     CPos.PREV_PRICE_30 := dset_Positions.FieldValues['PREV_PRICE_30'];
     CPos.PREV_PRICE_31 := dset_Positions.FieldValues['PREV_PRICE_31'];
     CPos.PREV_PRICE_32 := dset_Positions.FieldValues['PREV_PRICE_32'];
     {END mobile average 32x}


   end;

  Result := CPos;
end;

function Tdm_Main.GetCurrentClonedPosition: TMarketPosition;
var
  CPos:TMarketPosition;
begin
  CPos.SYMBOL := '';
  CPos.LAST_MARKET_PRICE := 0;
  CPos.Current_PL := 0;
  CPos.Open_Price  := 0;
  CPos.Open_Value  := 0;
  CPos.Take_Price  := 0;
  CPos.Prot_Correction_Price  := 0;
  CPos.Prev_Price := 0;
  try
    CPos.SYMBOL := dset_ClonedPositions.FieldValues['SYMBOL'];
  except
  end;
  if (Not dset_ClonedPositions.EOF) or (CPos.Symbol<>'') then
   begin
     CPos.ACTIVE := dset_ClonedPositions.FieldValues['ACTIVE'] ;
     Cpos.NRPOS:=dset_ClonedPositions.FieldValues['NRPOS'] ;
     CPos.VOLUME :=dset_ClonedPositions.FieldValues['VOLUME'] ;
     CPos.HISTORY_INDEX:=dset_ClonedPositions.FieldValues['HISTORY_INDEX'] ;
     CPos.TEMP_ID:=dset_ClonedPositions.FieldValues['TEMP_ID'] ;
     CPos.OPENED:=dset_ClonedPositions.FieldValues['OPENED'] ;

     CPos.STOP_PRICE :=dset_ClonedPositions.FieldValues['STOP_PRICE'] ;


     CPos.START_PRICE_MIN:= dset_ClonedPositions.FieldValues['START_PRICE_MIN'] ;
     CPos.START_PRICE_MAX:= dset_ClonedPositions.FieldValues['START_PRICE_MAX'] ;
     CPos.LAST_BUY_PRICE:=dset_ClonedPositions.FieldValues['LAST_BUY_PRICE'] ;
     CPos.LAST_SELL_PRICE:=dset_ClonedPositions.FieldValues['LAST_SELL_PRICE'] ;

     CPos.OPEN_PERCENT:=dset_ClonedPositions.FieldValues['OPEN_PERCENT'] ;
     CPos.RE_OPEN_PERCENT:=dset_ClonedPositions.FieldValues['RE_OPEN_PERCENT'] ;
     CPos.STOP_PERCENT:=dset_ClonedPositions.FieldValues['STOP_PERCENT'] ;
     CPos.TAKE_PERCENT:=dset_ClonedPositions.FieldValues['TAKE_PERCENT'] ;
     CPos.PROT_MARGIN:= dset_ClonedPositions.FieldValues['PROT_MARGIN'] ;
     CPos.PROT_CORECT:= dset_ClonedPositions.FieldValues['PROT_CORECT'] ;

     CPos.SHORT_OPEN_PERCENT:=dset_ClonedPositions.FieldValues['SHORT_OPEN_PERCENT'] ;
     CPos.SHORT_RE_OPEN_PERCENT:=dset_ClonedPositions.FieldValues['SHORT_RE_OPEN_PERCENT'] ;
     CPos.SHORT_STOP_PERCENT:=dset_ClonedPositions.FieldValues['SHORT_STOP_PERCENT'] ;
     CPos.SHORT_TAKE_PERCENT:=dset_ClonedPositions.FieldValues['SHORT_TAKE_PERCENT'] ;
     CPos.SHORT_PROT_MARGIN:= dset_ClonedPositions.FieldValues['SHORT_PROT_MARGIN'] ;
     CPos.SHORT_PROT_CORECT:= dset_ClonedPositions.FieldValues['SHORT_PROT_CORECT'] ;

     CPos.FORCE_BUY := dset_ClonedPositions.FieldValues['FORCE_BUY'];

     CPos.CLOSE_AT_MARKETCLOSING  := dset_ClonedPositions.FieldValues['CLOSE_AT_MARKETCLOSING'];
     CPos.CLOSE_NOW_AT_MARKET   := dset_ClonedPositions.FieldValues['CLOSE_NOW_AT_MARKET'];


     CPos.PROT_START_PRICE:= dset_ClonedPositions.FieldValues['PROT_START_PRICE'];
     Cpos.isProtection := dset_ClonedPositions.FieldValues['PROTECTION_ZONE'];

     CPos.COMPANY_NAME:= dset_ClonedPositions.FieldValues['COMPANY_NAME'] ;
     CPos.MARKET:= dset_ClonedPositions.FieldValues['MARKET'] ;
     CPos.SYMBOL:= dset_ClonedPositions.FieldValues['SYMBOL'] ;
     CPos.TOTAL_PL := dset_ClonedPositions.FieldValues['TOTAL_PL'] ;

     CPos.RE_OPEN := dset_ClonedPositions.FieldValues['RE_OPEN'] ;

     Cpos.LAST_MARKET_PRICE := dset_ClonedPositions.FieldValues['LAST_MARKET_PRICE'];
     Cpos.MARKET_TIME := dset_ClonedPositions.FieldValues['MARKET_TIME'];

     Cpos.DIRECTION := dset_ClonedPositions.FieldValues['DIRECTION'];
     Cpos.PREV_DIRECTION := dset_ClonedPositions.FieldValues['PREV_DIRECTION'];

     CPos.Prev_Price := CPos.LAST_MARKET_PRICE;

     {BEGIN mobile average GENERIC}

      CPos.NR_AVG := dset_ClonedPositions.FieldValues['NR_AVG'];
      CPos.AVERAGE_PRICE := dset_ClonedPositions.FieldValues['AVERAGE_PRICE'];
      CPos.SMA_PRICE := dset_ClonedPositions.FieldValues['SMA_PRICE'];
      CPos.EMA_PRICE := dset_ClonedPositions.FieldValues['EMA_PRICE'];
      CPos.USE_EMA := dset_ClonedPositions.FieldValues['USE_EMA'];


      CPos.NR_REC_PRICES := dset_ClonedPositions.FieldValues['NR_REC_PRICES'];
      CPos.OLDEST_PRICE  := dset_ClonedPositions.FieldValues['OLDEST_PRICE'];
      CPos.TIME_AVERAGE := dset_ClonedPositions.FieldValues['TIME_AVERAGE'];
      {END mobile average GENERIC}

      {BEGIN mobile average 32x}
       CPos.PREV_PRICE_1 := dset_ClonedPositions.FieldValues['PREV_PRICE_1'];
       CPos.PREV_PRICE_2 := dset_ClonedPositions.FieldValues['PREV_PRICE_2'];
       CPos.PREV_PRICE_3 := dset_ClonedPositions.FieldValues['PREV_PRICE_3'];
       CPos.PREV_PRICE_4 := dset_ClonedPositions.FieldValues['PREV_PRICE_4'];
       CPos.PREV_PRICE_5 := dset_ClonedPositions.FieldValues['PREV_PRICE_5'];
       CPos.PREV_PRICE_6 := dset_ClonedPositions.FieldValues['PREV_PRICE_6'];
       CPos.PREV_PRICE_7 := dset_ClonedPositions.FieldValues['PREV_PRICE_7'];
       CPos.PREV_PRICE_8 := dset_ClonedPositions.FieldValues['PREV_PRICE_8'];
       CPos.PREV_PRICE_9 := dset_ClonedPositions.FieldValues['PREV_PRICE_9'];
       CPos.PREV_PRICE_10 := dset_ClonedPositions.FieldValues['PREV_PRICE_10'];
       CPos.PREV_PRICE_11 := dset_ClonedPositions.FieldValues['PREV_PRICE_11'];
       CPos.PREV_PRICE_12 := dset_ClonedPositions.FieldValues['PREV_PRICE_12'];
       CPos.PREV_PRICE_13 := dset_ClonedPositions.FieldValues['PREV_PRICE_13'];
       CPos.PREV_PRICE_14 := dset_ClonedPositions.FieldValues['PREV_PRICE_14'];
       CPos.PREV_PRICE_15 := dset_ClonedPositions.FieldValues['PREV_PRICE_15'];
       CPos.PREV_PRICE_16 := dset_ClonedPositions.FieldValues['PREV_PRICE_16'];
       CPos.PREV_PRICE_17 := dset_ClonedPositions.FieldValues['PREV_PRICE_17'];
       CPos.PREV_PRICE_18 := dset_ClonedPositions.FieldValues['PREV_PRICE_18'];
       CPos.PREV_PRICE_19 := dset_ClonedPositions.FieldValues['PREV_PRICE_19'];
       CPos.PREV_PRICE_20 := dset_ClonedPositions.FieldValues['PREV_PRICE_20'];
       CPos.PREV_PRICE_21 := dset_ClonedPositions.FieldValues['PREV_PRICE_21'];
       CPos.PREV_PRICE_22 := dset_ClonedPositions.FieldValues['PREV_PRICE_22'];
       CPos.PREV_PRICE_23 := dset_ClonedPositions.FieldValues['PREV_PRICE_23'];
       CPos.PREV_PRICE_24 := dset_ClonedPositions.FieldValues['PREV_PRICE_24'];
       CPos.PREV_PRICE_25 := dset_ClonedPositions.FieldValues['PREV_PRICE_25'];
       CPos.PREV_PRICE_26 := dset_ClonedPositions.FieldValues['PREV_PRICE_26'];
       CPos.PREV_PRICE_27 := dset_ClonedPositions.FieldValues['PREV_PRICE_27'];
       CPos.PREV_PRICE_28 := dset_ClonedPositions.FieldValues['PREV_PRICE_28'];
       CPos.PREV_PRICE_29 := dset_ClonedPositions.FieldValues['PREV_PRICE_29'];
       CPos.PREV_PRICE_30 := dset_ClonedPositions.FieldValues['PREV_PRICE_30'];
       CPos.PREV_PRICE_31 := dset_ClonedPositions.FieldValues['PREV_PRICE_31'];
       CPos.PREV_PRICE_32 := dset_ClonedPositions.FieldValues['PREV_PRICE_32'];
       {END mobile average 32x}



   end;

  Result := CPos;
end;

procedure Tdm_Main.ModifyPosition(CPos: TMarketPosition);
var i_nrpos:integer;
begin

  try
      i_nrpos:=dset_Positions.FieldValues['NRPOS'];

      dset_Positions.DisableControls;

      dset_Positions.Locate('NRPOS',Cpos.NRPOS,[]);

      dset_Positions.Edit;

      dset_Positions.FieldValues['FORCE_BUY'] := CPos.FORCE_BUY;

      dset_Positions.FieldValues['ACTIVE'] := CPos.ACTIVE;
      dset_Positions.FieldValues['VOLUME'] := CPos.VOLUME;
      dset_Positions.FieldValues['HISTORY_INDEX'] := CPos.HISTORY_INDEX;
      dset_Positions.FieldValues['TEMP_ID'] := CPos.TEMP_ID;
      dset_Positions.FieldValues['OPENED'] := CPos.OPENED;

      dset_Positions.FieldValues['START_PRICE_MIN'] := CPos.START_PRICE_MIN;
      dset_Positions.FieldValues['START_PRICE_MAX'] := CPos.START_PRICE_MAX;

      dset_Positions.FieldValues['LAST_BUY_PRICE'] := CPos.LAST_BUY_PRICE;
      dset_Positions.FieldValues['LAST_SELL_PRICE'] := CPos.LAST_SELL_PRICE;

      dset_Positions.FieldValues['OPEN_PERCENT'] := CPos.OPEN_PERCENT;
      dset_Positions.FieldValues['RE_OPEN_PERCENT'] := CPos.RE_OPEN_PERCENT;
      dset_Positions.FieldValues['STOP_PERCENT'] := CPos.STOP_PERCENT;
      dset_Positions.FieldValues['TAKE_PERCENT'] := CPos.TAKE_PERCENT;
      dset_Positions.FieldValues['PROT_MARGIN'] := CPos.PROT_MARGIN;
      dset_Positions.FieldValues['PROT_CORECT'] := CPos.PROT_CORECT;

      dset_Positions.FieldValues['SHORT_OPEN_PERCENT'] := CPos.SHORT_OPEN_PERCENT;
      dset_Positions.FieldValues['SHORT_RE_OPEN_PERCENT'] := CPos.SHORT_RE_OPEN_PERCENT;
      dset_Positions.FieldValues['SHORT_STOP_PERCENT'] := CPos.SHORT_STOP_PERCENT;
      dset_Positions.FieldValues['SHORT_TAKE_PERCENT'] := CPos.SHORT_TAKE_PERCENT;
      dset_Positions.FieldValues['SHORT_PROT_MARGIN'] := CPos.SHORT_PROT_MARGIN;
      dset_Positions.FieldValues['SHORT_PROT_CORECT'] := CPos.SHORT_PROT_CORECT;

      dset_Positions.FieldValues['COMPANY_NAME'] := CPos.COMPANY_NAME;
      dset_Positions.FieldValues['MARKET'] := CPos.MARKET;
      dset_Positions.FieldValues['SYMBOL'] := CPos.SYMBOL;
      dset_Positions.FieldValues['TOTAL_PL'] := CPos.TOTAL_PL;

      dset_Positions.FieldValues['PROT_START_PRICE'] := CPos.PROT_START_PRICE;
      dset_Positions.FieldValues['PROTECTION_ZONE'] := Cpos.isProtection;

      dset_Positions.FieldValues['LAST_MARKET_PRICE'] := Cpos.LAST_MARKET_PRICE;

      dset_Positions.FieldValues['MARKET_TIME'] := Cpos.MARKET_TIME;

      dset_Positions.FieldValues['RE_OPEN'] := CPos.RE_OPEN;

      dset_Positions.FieldValues['CLOSE_NOW_AT_MARKET'] := CPos.CLOSE_NOW_AT_MARKET ;
      dset_Positions.FieldValues['CLOSE_AT_MARKETCLOSING'] := CPos.CLOSE_AT_MARKETCLOSING  ;


      dset_Positions.FieldValues['DIRECTION'] := Cpos.DIRECTION;
      dset_Positions.FieldValues['PREV_DIRECTION'] := Cpos.PREV_DIRECTION;


      dset_Positions.FieldValues['STOP_PRICE'] := CPos.STOP_PRICE;


      {BEGIN mobile average GENERIC}
      dset_Positions.FieldValues['OLDEST_PRICE'] := CPos.OLDEST_PRICE ;
      dset_Positions.FieldValues['NR_REC_PRICES'] := CPos.NR_REC_PRICES;

      dset_Positions.FieldValues['NR_AVG'] := CPos.NR_AVG;

      dset_Positions.FieldValues['AVERAGE_PRICE'] := CPos.AVERAGE_PRICE;
      dset_Positions.FieldValues['SMA_PRICE'] := CPos.SMA_PRICE;
      dset_Positions.FieldValues['EMA_PRICE'] := CPos.EMA_PRICE;
      dset_Positions.FieldValues['USE_EMA'] := CPos.USE_EMA;

      dset_Positions.FieldValues['TIME_AVERAGE'] := CPos.TIME_AVERAGE;
      {END mobile average GENERIC}

      {BEGIN mobile average 32x}
      dset_Positions.FieldValues['PREV_PRICE_1'] := CPos.PREV_PRICE_1;
      dset_Positions.FieldValues['PREV_PRICE_2'] := CPos.PREV_PRICE_2;
      dset_Positions.FieldValues['PREV_PRICE_3'] := CPos.PREV_PRICE_3;
      dset_Positions.FieldValues['PREV_PRICE_4'] := CPos.PREV_PRICE_4;
      dset_Positions.FieldValues['PREV_PRICE_5'] := CPos.PREV_PRICE_5;
      dset_Positions.FieldValues['PREV_PRICE_6'] := CPos.PREV_PRICE_6;
      dset_Positions.FieldValues['PREV_PRICE_7'] := CPos.PREV_PRICE_7;
      dset_Positions.FieldValues['PREV_PRICE_8'] := CPos.PREV_PRICE_8;
      dset_Positions.FieldValues['PREV_PRICE_9'] := CPos.PREV_PRICE_9;
      dset_Positions.FieldValues['PREV_PRICE_10'] := CPos.PREV_PRICE_10;
      dset_Positions.FieldValues['PREV_PRICE_11'] := CPos.PREV_PRICE_11;
      dset_Positions.FieldValues['PREV_PRICE_12'] := CPos.PREV_PRICE_12;
      dset_Positions.FieldValues['PREV_PRICE_13'] := CPos.PREV_PRICE_13;
      dset_Positions.FieldValues['PREV_PRICE_14'] := CPos.PREV_PRICE_14;
      dset_Positions.FieldValues['PREV_PRICE_15'] := CPos.PREV_PRICE_15;
      dset_Positions.FieldValues['PREV_PRICE_16'] := CPos.PREV_PRICE_16;

      dset_Positions.FieldValues['PREV_PRICE_17'] := CPos.PREV_PRICE_17;
      dset_Positions.FieldValues['PREV_PRICE_18'] := CPos.PREV_PRICE_18;
      dset_Positions.FieldValues['PREV_PRICE_19'] := CPos.PREV_PRICE_19;
      dset_Positions.FieldValues['PREV_PRICE_20'] := CPos.PREV_PRICE_20;
      dset_Positions.FieldValues['PREV_PRICE_21'] := CPos.PREV_PRICE_21;
      dset_Positions.FieldValues['PREV_PRICE_22'] := CPos.PREV_PRICE_22;
      dset_Positions.FieldValues['PREV_PRICE_23'] := CPos.PREV_PRICE_23;
      dset_Positions.FieldValues['PREV_PRICE_24'] := CPos.PREV_PRICE_24;
      dset_Positions.FieldValues['PREV_PRICE_25'] := CPos.PREV_PRICE_25;
      dset_Positions.FieldValues['PREV_PRICE_26'] := CPos.PREV_PRICE_26;
      dset_Positions.FieldValues['PREV_PRICE_27'] := CPos.PREV_PRICE_27;
      dset_Positions.FieldValues['PREV_PRICE_28'] := CPos.PREV_PRICE_28;
      dset_Positions.FieldValues['PREV_PRICE_29'] := CPos.PREV_PRICE_29;
      dset_Positions.FieldValues['PREV_PRICE_30'] := CPos.PREV_PRICE_30;
      dset_Positions.FieldValues['PREV_PRICE_31'] := CPos.PREV_PRICE_31;
      dset_Positions.FieldValues['PREV_PRICE_32'] := CPos.PREV_PRICE_32;
      {END mobile average 32x}




      dset_Positions.Post;

      dset_Positions.Locate('NRPOS',i_nrpos,[]);
      dset_Positions.EnableControls;

  Except
    AddHistory('UPDATE ERROR (ModPos)', 'GENERIC',CPos);
  end;

end;

function Tdm_Main.GetMarketName(str_symbol: string): string;
var
  strSymbol, market: String;
begin
  strSymbol:= '';
  market:= '';
  dset_Symbols.First;
  while not dset_Symbols.EOF do
   begin
        strSymbol:= dset_Symbols['SYMBOL'];
        if strSymbol = str_symbol then
        begin
          market:= dset_Symbols['MARKET'];
        end;
        dset_Symbols.Next;
   end;
   Result:= market;
end;

function Tdm_Main.GetSymbolName(str_symbol: string): string;
var
  strSymbol, company: String;
begin
  strSymbol:= '';
  company:= '';
  dset_Symbols.First;
  while not dm_Main.dset_Symbols.EOF do
  begin
        strSymbol:= dset_Symbols['SYMBOL'];
        if strSymbol = str_symbol then
        begin
          company:= dset_Symbols['NAME'];
        end;
        dset_Symbols.Next;
   end;
   Result:= company;
end;

function Tdm_Main.GetRealTime(var CPos: TMarketPosition):boolean;
var mres: TMarketMessage;
begin
  if CPos.SYMBOL ='' then exit ;

  mres := MarketPlatform._GetQuote(CPos.MARKET,CPos.SYMBOL);

  if mres.f_price < 0 then
  begin
    Result := False;
    exit;
  end;

  CPos.Take_Price := -1;
  CPos.Prot_Correction_Price := -1;

  SetNewPrice(CPos,mres);


  Result := True;

end;

function Tdm_Main.MarketBuy(var CPos: TMarketPosition): TMarketMessage;
var
   mres: TMarketMessage;
begin

  mres := MarketPlatform.MarketBuy(CPos.MARKET,CPos.SYMBOL,CPos.VOLUME);

  if mres.f_price < 0 then
  begin
    Result := mres;
    exit;
  end;


  CPos.LAST_BUY_PRICE := mres.f_price;

  SetNewPrice(CPos, mres, 'BUY');

  Result:= mres;
end;

function Tdm_Main.MarketSell(var CPos: TMarketPosition): TMarketMessage;
var
   mres: TMarketMessage;
begin

  mres := MarketPlatform.MarketSell(CPos.MARKET,CPos.SYMBOL,CPos.VOLUME);

  if mres.f_price < 0 then
  begin
    Result := mres;
    exit;
  end;

  CPos.LAST_SELL_PRICE := mres.f_price;

  SetNewPrice(CPos, mres, 'SELL');


  Result:= mres;
end;

procedure Tdm_Main.AddHistory(str_Action, str_State: string;
  CPos: TMarketPosition;  f_price:double=0);
begin



  if CPos.NRPOS = -1 then
  begin
    CPos.SYMBOL:= '';
    CPos.PREV_DIRECTION := TPositionDirection.STANDBY ;
    CPos.DIRECTION :=TPositionDirection.STANDBY ;
    CPos.LAST_MARKET_PRICE := -1;
    dt_LastDateTime := IncMilliSecond(dt_LastDateTime);
    CPos.MARKET_TIME := 3; // ALGORITM DATETIME FOR NRPOS -1
    CPos.Current_PL := 0;
    CPos.TEMP_ID := 0;
  end;
  dm_Main.dset_History.Insert;
  dm_Main.dset_History['NRPOS']:= CPos.NRPOS;
  dm_Main.dset_History['ACTION']:= str_Action;
  dm_Main.dset_History['SYMBOL']:= CPos.SYMBOL;
  dm_Main.dset_History['TEMP_ID']:= CPos.TEMP_ID;
  dm_Main.dset_History['STATUS']:= 'ACTIV';

  dm_Main.dset_History['PREV_DIR']:= CPos.PREV_DIRECTION;
  dm_Main.dset_History['CURR_DIR']:= CPos.DIRECTION;


  if f_price<=0 then
    dm_Main.dset_History['PRICE']:= CPos.LAST_MARKET_PRICE
  else
    dm_Main.dset_History['PRICE']:= f_price;


  dm_Main.dset_History['AVERAGE_PRICE'] := CPos.AVERAGE_PRICE;
  dm_Main.dset_History['EMA_PRICE'] := CPos.EMA_PRICE;
  dm_Main.dset_History['SMA_PRICE'] := CPos.SMA_PRICE;

  dm_Main.dset_History['STATE']:= str_State;
  dm_Main.dset_History['DATETIME']:= CPos.MARKET_TIME;

  dm_Main.dset_History['PROFIT_LOSS']:= CPos.Current_PL;

  dm_Main.dset_History['INFO'] := GetPosInfo(CPos) ;

  dm_Main.dset_History.Post;

end;

procedure Tdm_Main.Set_MarketPlatform_str_Requests(str_s: string);
begin
  MarketPlatform.str_Requests :=str_s;
end;

function Tdm_Main.Get_MarketPlatform_str_Requests: string;
begin
  Result := MarketPlatform.str_Requests;
end;

procedure Tdm_Main.LoadData;
var str_savefile:string;

begin

  try
    str_savefile := ExtractFileDir(Application.ExeName);
    str_savefile := str_savefile + '\_positions'+_DB_VER+'.ldb';
    if FileExists (str_savefile) then
      dm_Main.dset_Positions.LoadFromFile (str_savefile)
    else
      if not dm_main.dset_positions.active then
      begin
            dm_main.dset_Positions.CreateDataset;
            dm_main.dset_Positions.Open;
      end;
  except
    if not dm_main.dset_positions.active then
    begin
       dm_main.dset_Positions.CreateDataset;
       dm_main.dset_Positions.Open;
    end;
  end;

  try
    str_savefile:= '';
    str_savefile := ExtractFileDir(Application.ExeName);
    str_savefile := str_savefile + '\_history'+_DB_VER+'.ldb';
    if FileExists (str_savefile) then
      dm_Main.dset_History.LoadFromFile (str_savefile)
    else
      if not dm_main.dset_History.Active then
      begin
            dm_main.dset_History.CreateDataset;
            dm_main.dset_History.Open;
      end;
  except
    if not dm_main.dset_History.Active then
    begin
       dm_main.dset_History.CreateDataset;
       dm_main.dset_History.Open;
    end;
  end;

  try
    str_savefile:= '';
    str_savefile := ExtractFileDir(Application.ExeName);
    str_savefile := str_savefile + '\_prices'+_DB_VER+'.ldb';
    if FileExists (str_savefile) then
      dm_Main.dset_Prices.LoadFromFile (str_savefile)
    else
      if not dm_main.dset_Prices.Active then
      begin
            dm_main.dset_Prices.CreateDataset;
            dm_main.dset_Prices.Open;
      end;
  except
    if not dm_main.dset_Prices.Active then
    begin
       dm_main.dset_Prices.CreateDataset;
       dm_main.dset_Prices.Open;
    end;
  end;

  SortBufDataSet(dm_main.dset_History,'DATETIME',[ixDescending]);

  CreateTempTables;
end;

procedure Tdm_Main.SaveData;
var str_savefile:string;
begin
  try
    str_savefile := ExtractFileDir(Application.ExeName);
    str_savefile := str_savefile + '\_positions'+_DB_VER+'.ldb';
    dm_main.dset_Positions.SaveToFile(str_savefile);

    str_savefile := '';
    str_savefile := ExtractFileDir(Application.ExeName);
    str_savefile := str_savefile + '\_history'+_DB_VER+'.ldb';
    dm_main.dset_History.SaveToFile(str_savefile);

    str_savefile := '';
    str_savefile := ExtractFileDir(Application.ExeName);
    str_savefile := str_savefile + '\_prices'+_DB_VER+'.ldb';
    dm_main.dset_Prices.SaveToFile(str_savefile);
  except

  end;
end;

procedure Tdm_Main.CreateTempTables;
var i : integer;
   vFieldDef: TFieldDef;
   str_Name : string;
begin
  dset_Temp_Positions.Active:= False;
  dset_Temp_Positions.FieldDefs.Clear;
  for I:=0 to dset_Positions.FieldDefs.Count-1 do
  begin
     vFieldDef:= dset_Temp_Positions.FieldDefs.AddFieldDef;
     str_Name := dset_Positions.FieldDefs[I].Name;
     vFieldDef.Name:=str_Name;
     if dset_Positions.FieldDefs[I].DataType <> ftAutoInc then
             vFieldDef.DataType:=dset_Positions.FieldDefs[I].DataType
     else
             vFieldDef.DataType:=ftInteger;
     vFieldDef.Size:=dset_Positions.FieldDefs[I].Size;
     vFieldDef.Required:=dset_Positions.FieldDefs[I].Required;
  end;
  dset_Temp_Positions.CreateDataset;
  dset_Temp_Positions.Active := True;

  dset_ClonedPositions.Active:= False;
  dset_ClonedPositions.FieldDefs.Clear;
  for I:=0 to dset_Positions.FieldDefs.Count-1 do
  begin
     vFieldDef:=dset_ClonedPositions.FieldDefs.AddFieldDef;
     with dset_Positions.FieldDefs[I] do
          begin
             vFieldDef.Name:=Name;

             if DataType <> ftAutoInc then
               vFieldDef.DataType:=DataType
             else
               vFieldDef.DataType:=ftInteger;

             vFieldDef.Size:=Size;
             vFieldDef.Required:=Required;
          end;
  end;
  dset_ClonedPositions.CreateDataset;
  dset_ClonedPositions.Active := True;



end;

procedure EmptyMemDataSet(var DataSet:TBufDataSet);
var
  vTemporaryMemDataSet:TBufDataSet;
  vFieldDef:TFieldDef;
  I:Integer;
begin
  try
    //Create temporary MemDataSet
    vTemporaryMemDataSet:=TBufDataSet.Create(nil);
    //Store FieldDefs to Temporary MemDataSet
    for I:=0 to DataSet.FieldDefs.Count-1 do begin
      vFieldDef:=vTemporaryMemDataSet.FieldDefs.AddFieldDef;
      with DataSet.FieldDefs[I] do begin
        vFieldDef.Name:=Name;
        vFieldDef.DataType:=DataType;
        vFieldDef.Size:=Size;
        vFieldDef.Required:=Required;
      end;
    end;
    DataSet.Active := False;
    //Clear existing fielddefs
    DataSet.FieldDefs.Clear;
    //Clear indexes
    DataSet.IndexName := '';
    DataSet.IndexDefs.Clear;
    //Restore fielddefs
    DataSet.FieldDefs:=vTemporaryMemDataSet.FieldDefs;
    DataSet.Active:=True;
  finally
  vTemporaryMemDataSet.Free;
  end;
end;

procedure Tdm_Main.SyncClonePositions;
var
 NrPos,i: integer;
 str_Field:string;
begin
  EmptyMemDataSet(dset_ClonedPositions) ;

  NrPos := dset_Positions.FieldValues['NRPOS'];
  dm_Main.dset_Positions.DisableControls;
  dm_Main.dset_Positions.First;
  while not dm_Main.dset_Positions.EOF do
  begin

    dset_ClonedPositions.Insert;
    for i:= 0 to dset_Positions.FieldCount - 1 do
    begin
      try
        str_Field:=dset_Positions.FieldDefs[i].Name;
        dset_ClonedPositions.FieldValues[str_Field]:= dm_main.dset_Positions.FieldValues[str_Field];
      Except
        _ShowMessage('CLONARE: Eroare la camp: '+str_Field);
      end;
    end;
    dset_ClonedPositions.Post;


    dset_Positions.Next;
  end;
  dset_Positions.Locate('NRPOS',NrPos,[loCaseInsensitive]);
  dset_Positions.EnableControls;

end;

procedure Tdm_Main.CloneHistory;
var
 i, int_idx: integer;
 str_Field:string;
 str_NrPos : string;
begin

  PrepareCloneHistory;
  ds_ClonedHistory.DataSet := dset_ClonedHistory;
  ds_ClonedPrices.DataSet := dset_ClonedPrices;

  str_NrPos := dm_Main.dset_Positions.FieldByName('NRPOS').AsString;

  int_idx := dm_Main.dset_History.FieldByName('IDX').AsInteger;
  dset_History.Filtered := False;
  dset_History.Filter := 'NRPOS='+ str_NrPos;
  dset_History.Filtered := True;

  dset_Prices.Filtered := False;
  dset_Prices.Filter := 'NRPOS='+ str_NrPos;
  dset_Prices.Filtered := True;

  dset_Prices.First;
  dset_ClonedPrices.DisableControls;
  while not dset_Prices.EOF do
  begin
    dset_ClonedPrices.Insert;
    for i:= 0 to dset_Prices.FieldCount - 1 do
    begin
      try
        str_Field:=dset_Prices.FieldDefs[i].Name;
        dset_ClonedPrices.FieldValues[str_Field]:= dset_Prices.FieldValues[str_Field];
      Except
        _ShowMessage('CLONARE PRICES: Eroare la camp: '+str_Field);
      end;
    end;
    dset_ClonedPrices.Post;
    dset_Prices.Next;
  end;
  dset_ClonedPrices.EnableControls;

  dset_History.First;
  dset_ClonedHistory.DisableControls;
  while not dset_History.EOF do
  begin
    dset_ClonedHistory.Insert;
    for i:= 0 to dset_History.FieldCount - 1 do
    begin
      try
        str_Field:=dset_History.FieldDefs[i].Name;
        dset_ClonedHistory.FieldValues[str_Field]:= dset_History.FieldValues[str_Field];
      Except
        _ShowMessage('CLONARE PRICES: Eroare la camp: '+str_Field);
      end;
    end;
    dset_ClonedHistory.Post;
    dset_History.Next;
  end;
  dset_ClonedHistory.EnableControls;

  dset_History.Filter := '';
  dset_History.Filtered := False;
  dset_History.Locate('IDX',int_idx,[]);

  dset_Prices.Filter := '';
  dset_Prices.Filtered := False;

  SortBufDataSet(dset_ClonedHistory,'DATETIME',[ixDescending]);
  SortBufDataSet(dset_ClonedPrices,'MARKET_TIME',[]);

end;

procedure Tdm_Main.PrepareCloneHistory;
var i : integer;
   vFieldDef: TFieldDef;
begin

  if dset_ClonedHistory<> nil then
  begin
    ds_ClonedHistory.DataSet := nil;
    dset_ClonedHistory.Free;
  end;
  dset_ClonedHistory := TBufDataset.Create(Self);
  dset_ClonedHistory.MaxIndexesCount := 10;

  if dset_ClonedPrices<> nil then
  begin
    ds_ClonedPrices.DataSet := nil;
    dset_ClonedPrices.Free;
  end;
  dset_ClonedPrices := TBufDataset.Create (Self);
  dset_ClonedPrices.MaxIndexesCount := 10;

  dset_ClonedHistory.Active:= False;
  dset_ClonedHistory.FieldDefs.Clear;
  for I:=0 to dset_History.FieldDefs.Count-1 do
  begin
     vFieldDef:=dset_ClonedHistory.FieldDefs.AddFieldDef;
     with dset_History.FieldDefs[I] do
          begin
             vFieldDef.Name:=Name;

             if DataType <> ftAutoInc then
               vFieldDef.DataType:=DataType
             else
               vFieldDef.DataType:=ftInteger;

             vFieldDef.Size:=Size;
             vFieldDef.Required:=Required;
          end;
  end;
  dset_ClonedHistory.CreateDataset;
  dset_ClonedHistory.Active := True;

  dset_ClonedPrices.Active:= False;
  dset_ClonedPrices.FieldDefs.Clear;
  for I:=0 to dset_Prices.FieldDefs.Count-1 do
  begin
     vFieldDef:=dset_ClonedPrices.FieldDefs.AddFieldDef;
     with dset_Prices.FieldDefs[I] do
          begin
             vFieldDef.Name:=Name;

             if DataType <> ftAutoInc then
               vFieldDef.DataType:=DataType
             else
               vFieldDef.DataType:=ftInteger;

             vFieldDef.Size:=Size;
             vFieldDef.Required:=Required;
          end;
  end;
  dset_ClonedPrices.CreateDataset;
  dset_ClonedPrices.Active := True;


end;

function Tdm_Main.GetPositionsList: TList;
var
   pCPos: ^TMarketPosition;
   CPos: TMarketPosition;
   PositionList : TList;
   NrPos : Integer;
begin
  PositionList := TList.Create;
  NrPos := -1;

(*
  dm_Main.SyncClonePositions;
  dm_Main.dset_ClonedPositions.First;
*)
  if NOT dset_Positions.IsEmpty then
  begin
    try
      NrPos := dset_Positions.FieldValues['NRPOS'];
      dm_Main.dset_Positions.DisableControls;
      dm_Main.dset_Positions.First;
      while not dm_Main.dset_Positions.EOF do
      begin
        pCPos := AllocMem (Sizeof(TMarketPosition));
        pCPos^ := dm_Main.GetCurrentPosition;
        PositionList.Add (pCPos);
        dset_Positions.Next;
      end;
      dset_Positions.Locate('NRPOS',NrPos,[loCaseInsensitive]);
      dset_Positions.EnableControls;
    except
      CPos.MARKET_TIME := 1; //ERROR DATE TIME
      CPos.NRPOS := NrPos;
      AddHistory('ERROR GETPOSLIST: '+DateTimeToStr(dm_Main.dt_LastDateTime),'GENERIC',CPos);
    end;

  (*
    while not dm_Main.dset_ClonedPositions.EOF do
    begin
      pCPos := AllocMem (Sizeof(TMarketPosition));
      pCPos^ := dm_Main.GetCurrentClonedPosition;
      PositionList.Add (pCPos);
      dm_Main.dset_ClonedPositions.Next;
    end;
  *)
  end;
  Result := PositionList;
end;

function Tdm_Main.SortBufDataSet(DataSet: TBufDataSet; const FieldName: String;
  sorttype: TIndexOptions): Boolean;
  var
    i: Integer;
    IndexDefs: TIndexDefs;
    IndexName: String;
    IndexOptions: TIndexOptions;
    Field: TField;
begin
    Result := False;
    Field := DataSet.Fields.FindField(FieldName);
    //If invalid field name, exit.
    if Field = nil then Exit;
    //if invalid field type, exit.
    if {(Field is TObjectField) or} (Field is TBlobField) or
      {(Field is TAggregateField) or} (Field is TVariantField)
       or (Field is TBinaryField) then Exit;
    //Get IndexDefs and IndexName using RTTI
    if IsPublishedProp(DataSet, 'IndexDefs') then
      IndexDefs := GetObjectProp(DataSet, 'IndexDefs') as TIndexDefs
    else
      Exit;
    if IsPublishedProp(DataSet, 'IndexName') then
      IndexName := GetStrProp(DataSet, 'IndexName')
    else
      Exit;
    //Ensure IndexDefs is up-to-date
    IndexDefs.Updated:=false; {<<<<---This line is critical as IndexDefs.Update will do nothing on the next sort if it's already true}
    IndexDefs.Update;

    if ixDescending in sorttype then
    begin
      IndexName := FieldName + '__IdxD';
      IndexOptions := [ixDescending];
    end
    else
    begin
      IndexName := FieldName + '__IdxA';
      IndexOptions := [];
    end;

    //Look for existing index
    for i := 0 to Pred(IndexDefs.Count) do
    begin
      if IndexDefs[i].Name = IndexName then
        begin
          Result := True;
          Break
        end;  //if
    end; // for
    //If existing index not found, create one
    if not Result then
        begin
          if IndexName=FieldName + '__IdxD' then
            DataSet.AddIndex(IndexName, FieldName, IndexOptions, FieldName)
          else
            DataSet.AddIndex(IndexName, FieldName, IndexOptions);
          Result := True;
        end; // if not
    //Set the index
    SetStrProp(DataSet, 'IndexName', IndexName);

    DataSet.First;
end;




end.

