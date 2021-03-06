unit u_dm_main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, BufDataset, FileUtil, u_finance_request, Forms, TypInfo,
  DateUtils, bitABachus, DOM, XMLRead, XMLWrite, LCLType, Dialogs;


type TTWSSettings = record
                     Host: string;
                     Port: integer;
                     ClientID: integer;
                    end;

     TAATSettings = record
                     TWS: TTWSSettings;
                    end;


type  TPD=record
    SHORT :string;
    LONG :string;
    STANDBY :string;
  end;

const TPositionDirection:TPD = (SHORT:'SHRT';LONG:'LONG';STANDBY:'STBY');

type TPositionParams=record
    //Params

      POS_ACTIVE : boolean;
      RE_OPEN, RESET_AVERAGE, RE_TAKE : boolean;
      OPEN_PERCENT,  STOP_PERCENT,  TAKE_PERCENT, PROT_MARGIN,  PROT_CORECT:double;
      SHORT_OPEN_PERCENT,  SHORT_STOP_PERCENT,  SHORT_TAKE_PERCENT, SHORT_PROT_MARGIN,  SHORT_PROT_CORECT : double;
      RE_OPEN_PERCENT, SHORT_RE_OPEN_PERCENT : double;
      NR_AVG : integer;
      TIME_AVERAGE : boolean;
      USE_EMA : boolean;
      FORCE_BUY : boolean;
      CLOSE_NOW_AT_MARKET : boolean;
      CLOSE_AT_MARKETCLOSING : boolean;
      STAND_BY_AFTER_PROT : boolean;
      STANDBY_AFTER_STOP  : boolean;

      EARLY_PROT: boolean;

      PRF_PRC_ERL : double; // prag procentual profit pentru corectie rapirda
      COR_PRC_ERL : double; // valoarea la care se inchide corectia rapida

      MIN_BOUNCE : double; // valoare minima profit bounce
      MAX_BOUNCE : double; // valoare maxima profit bounce
      BOUNCE : boolean;



      StrategyName : string[230];
end;

type TPositionData=record

      // live data from transactions
        NRPOS, VOLUME,
        HISTORY_INDEX:integer; // HISTORY_INDEX = unused but recorded
        TEMP_ID: Int64; // TEMP_ID = transaction pairing
        last_operation_milis : longint;

        OPENED :boolean;

        LAST_BUY_PRICE, LAST_SELL_PRICE,
        PROT_START_PRICE, LAST_MARKET_PRICE,


        STOP_PRICE: double;

        TOTAL_PL : double;

        AVERAGE_PRICE : double;
        SMA_PRICE : double;
        EMA_PRICE : double;
        NR_REC_PRICES : integer;
        OLDEST_PRICE : double;

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

        OrderDirection : string[100];

        str_Average32Info : string[255];

        // flags in data area
        b_Wait_For_Market_Close : boolean;
        b_Stop_Real : boolean;
        // end flags in data area

        BOUNCING : integer; // 0: not yet, 1: bouncing, 2: surpassed

        f_Open_Price : double;


end;


type TMarketPosition=record

   PosParams: TPositionParams;
   PosData: TPositionData;

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

    _sync_CPOS: TMarketPosition;
    _sync_action: string;

    procedure PrepareClonedPricesAverage(str_symbol:string);





  public
    { public declarations }
    _DB_VER : String;
    _APP_VER : string;
    dt_LastDateTime : TDateTime;
    inMainTimer, bStartStop: Boolean;

    tm_Market_start, tm_Market_stop:TTime;


    TempParams:TPositionParams;


    //  application settings
    AATSettings: TAATSettings;

    procedure Reset_BackTestData;

    //  general settings file
    //  Added Dan 20141031
    function GetAATDefaultSettings: TAATSettings;
    function LoadAATSettings(Stream: TStream): TAATSettings; overload;
    function LoadAATSettings(XMLFile: string): TAATSettings; overload;
    procedure SaveAATSettings(Stream: TStream; Settings: TAATSettings); overload;
    procedure SaveAATSettings(XMLFile: string; Settings: TAATSettings); overload;

    //  Added Dan 20141015
    function CreateExchangeConnector: TExchangeConnector;

    function  GetQuote(market: string; symbol: string): TMarketMessage;
    function  GetCurrentPosition:TMarketPosition;
    function  GetCurrentClonedPosition:TMarketPosition;
    procedure ModifyPosition(CPos:TMarketPosition);
    function  GetMarketName(str_symbol:string):string;
    function  GetSymbolName(str_symbol:string):string;


    procedure AddHistory(str_Action, str_State:string; CPos:TMarketPosition; f_price:double =0);

    procedure Set_MarketPlatform_str_Requests(str_s:string);
    function  Get_MarketPlatform_str_Requests:string;

    //  addded Dan 20141028
    //  opening file streams with these functions should overcome the errors in
    //  concurrent file shares by adding an extra index in the filename.
    //  The file index will be automatically incremented when a file access conflict will
    //  be detected during writing, while for reading it should be able to access
    //  the latest indexed file in readonly mode.
    function GetCurrentDataFileIndex(fname: shortstring; ext: shortstring): integer;
    function TryOpenFileStream(fname: shortstring; ext: shortstring; Mode: word): TFileStream;

    procedure LoadData;
    procedure SaveData;

    procedure CreateTempTables;
    procedure SyncClonePositions;

    procedure CloneHistory;
    procedure PrepareCloneHistory;

    function GetPositionsList : TList;

    function SortBufDataSet(DataSet: TBufDataSet;const FieldName: String; sorttype: TIndexOptions ): Boolean;
    function _SortBufDataSet(DataSet: TBufDataSet;const FieldName: String): Boolean;

    procedure _AddPriceHistory;
    procedure AddPriceHistory(CPos : TMarketPosition; str_action:string ='');


    function GetPosInfo(CPos: TMarketPosition):string;

    function CalcClonedPricesAverage(str_symbol:string; int_nr_prices:integer): double;

    procedure ResetAverage(var CPos:TMarketPosition);

    procedure SetTempParams;
    procedure SaveTempParams;

    procedure LoadParams;
    procedure SaveParams;


    function  CalcStand32Average(var CPos:TMarketPosition): double;
    function  CalcGenericAverage(var CPos:TMarketPosition; i_prev_nr_prices: integer): double;


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

procedure Tdm_Main._AddPriceHistory;
begin
  dt_LastDateTime:= _sync_CPOS.PosData.MARKET_TIME;
  if _sync_action<>'' then
    begin
      if _sync_CPOS.PosData.OrderDirection =TPositionDirection.LONG then
        _sync_action:= 'L'+_sync_action
      else
      if _sync_CPOS.PosData.OrderDirection =TPositionDirection.SHORT then
        _sync_action:= 'S'+_sync_action;
      dset_Prices.Insert;
      dset_Prices.FieldByName('SYMBOL').AsString := _sync_CPOS.PosData.SYMBOL ;
      dset_Prices.FieldByName('ACTION').AsString := _sync_action;
      dset_Prices.FieldByName('INFO').AsString := GetPosInfo(_sync_CPOS);
      dset_Prices.FieldByName('MARKET_TIME').AsDateTime  := _sync_CPOS.PosData.MARKET_TIME;
      dset_Prices.FieldByName('AAT_TIME').AsDateTime := Now;
      dset_Prices.FieldByName('VALUE').AsFloat  := _sync_CPOS.PosData.LAST_MARKET_PRICE;
      dset_Prices.FieldByName('NRPOS').AsInteger := _sync_CPOS.PosData.NRPOS;
      dset_Prices.FieldValues['TEMP_ID'] := _sync_CPOS.PosData.TEMP_ID;

      dset_Prices.FieldValues['SMA_PRICE'] := _sync_CPOS.PosData.SMA_PRICE;
      dset_Prices.FieldValues['EMA_PRICE'] := _sync_CPOS.PosData.EMA_PRICE;
      dset_Prices.FieldValues['AVERAGE_PRICE'] := _sync_CPOS.PosData.Algorithm_Price;

      dset_Prices.FieldByName('TIMEOUT').AsLongint:=_sync_CPOS.PosData.last_operation_milis;

      dset_Prices.Post;
    end
  else
  begin
    if (_sync_CPOS.PosData.Prev_Price <> _sync_CPOS.PosData.LAST_MARKET_PRICE) or _sync_CPOS.PosParams.TIME_AVERAGE then
      begin
        dset_Prices.Insert;
        dset_Prices.FieldByName('SYMBOL').AsString := _sync_CPOS.PosData.SYMBOL ;
        dset_Prices.FieldByName('ACTION').AsString := _sync_action;
        dset_Prices.FieldByName('INFO').AsString := GetPosInfo(_sync_CPOS);
        dset_Prices.FieldByName('MARKET_TIME').AsDateTime  := _sync_CPOS.PosData.MARKET_TIME;
        dset_Prices.FieldByName('AAT_TIME').AsDateTime := Now;
        dset_Prices.FieldByName('VALUE').AsFloat  := _sync_CPOS.PosData.LAST_MARKET_PRICE;
        dset_Prices.FieldByName('NRPOS').AsInteger := _sync_CPOS.PosData.NRPOS;
        dset_Prices.FieldValues['TEMP_ID'] := _sync_CPOS.PosData.TEMP_ID;

        dset_Prices.FieldValues['SMA_PRICE'] := _sync_CPOS.PosData.SMA_PRICE;
        dset_Prices.FieldValues['EMA_PRICE'] := _sync_CPOS.PosData.EMA_PRICE;
        dset_Prices.FieldValues['AVERAGE_PRICE'] := _sync_CPOS.PosData.Algorithm_Price;

        dset_Prices.FieldByName('TIMEOUT').AsInteger :=_sync_CPOS.PosData.last_operation_milis;
        dset_Prices.Post;
      end;
  end;
end;


procedure Tdm_Main.AddPriceHistory(CPos: TMarketPosition;  str_action:string ='');
begin
   _sync_CPOS:= CPOS;
   _sync_action:= str_action;
   TThread.Synchronize(nil, @_AddPriceHistory);
end;


function Tdm_Main.GetPosInfo(CPos: TMarketPosition): string;
var str_info: string;
    f_long_open,f_short_open:double;
begin
 if CPos.PosData.OPENED then
   str_info := 'O:1 D:'+CPos.PosData.DIRECTION
 else
  begin
    if CPos.PosData.PREV_DIRECTION <> TPositionDirection.STANDBY then
      f_short_open := CPos.PosData.START_PRICE_MAX * (1 + (CPos.PosParams.SHORT_RE_OPEN_PERCENT / 100 ))
    else
      f_short_open := CPos.PosData.START_PRICE_MAX * (1 + (CPos.PosParams.SHORT_OPEN_PERCENT / 100 ));

    if CPos.PosData.PREV_DIRECTION <> TPositionDirection.STANDBY then
      f_long_open := CPos.PosData.START_PRICE_MIN * (1 + (CPos.PosParams.RE_OPEN_PERCENT / 100 ))
    else
      f_long_open := CPos.PosData.START_PRICE_MIN * (1 + (CPos.PosParams.OPEN_PERCENT / 100 ));

   str_info := 'O:0 L/S:'+FormatFloat('0.00',f_long_open)+'/'+FormatFloat('0.00',f_short_open)+' D:'+CPos.PosData.DIRECTION;
  end;

 if Cpos.PosParams.TIME_AVERAGE then
   str_info := str_info +' MT:1'
 else
   str_info := str_info +' MT:0';

 if Cpos.PosParams.USE_EMA then
   str_info := str_info +' EMA:1'
 else
   str_info := str_info +' EMA:0';

 if Cpos.PosParams.BOUNCE then
   str_info := str_info +' B:1'
 else
   str_info := str_info +' B:0';

 str_info := str_info +' Bin:'+IntToStr(CPos.PosData.BOUNCING);

 str_info := str_info+' NA:' + IntToStr(Cpos.PosParams.NR_AVG);
 str_info := str_info+' RA:' + IntToStr(Cpos.PosData.NR_REC_PRICES);
 (*
 str_info := str_info+' AP:' + FormatFloat('0.00', Cpos.PosData.Algorithm_Price );
 str_info := str_info+' BP:' + FormatFloat('0.00', Cpos.PosData.LAST_BUY_PRICE);
 str_info := str_info+' SP:' + FormatFloat('0.00', Cpos.PosData.LAST_SELL_PRICE);

 str_info := str_info+' LO:' + FormatFloat('0.00', Cpos.PosParams.OPEN_PERCENT);
 str_info := str_info+' LS:' + FormatFloat('0.00', Cpos.PosParams.STOP_PERCENT);
 str_info := str_info+' LT:' + FormatFloat('0.00', Cpos.PosParams.TAKE_PERCENT);
 str_info := str_info+' LP:' + FormatFloat('0.00', Cpos.PosParams.PROT_MARGIN);
 str_info := str_info+' LC:' + FormatFloat('0.00', Cpos.PosParams.PROT_CORECT);

 str_info := str_info+' SO:' + FormatFloat('0.00', Cpos.PosParams.SHORT_OPEN_PERCENT);
 str_info := str_info+' SS:' + FormatFloat('0.00', Cpos.PosParams.SHORT_STOP_PERCENT);
 str_info := str_info+' ST:' + FormatFloat('0.00', Cpos.PosParams.SHORT_TAKE_PERCENT);
 str_info := str_info+' SP:' + FormatFloat('0.00', Cpos.PosParams.SHORT_PROT_MARGIN);
 str_info := str_info+' SC:' + FormatFloat('0.00', Cpos.PosParams.SHORT_PROT_CORECT );
 *)

 str_Info := Str_info+' AVG('+Cpos.PosData.str_Average32Info+')';

 str_Info := Str_info+' C:'+TimeToStr(CPos.PosData.MARKET_TIME)+'/P:'+TimeToStr(CPos.PosData.Prev_Market_Time);

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

procedure Tdm_Main.ResetAverage(var CPos: TMarketPosition);
begin
  {BEGIN mobile average RESET}
  CPos.PosData.NR_REC_PRICES := 0;
  CPos.PosData.AVERAGE_PRICE := CPos.PosData.LAST_MARKET_PRICE;

  CPos.PosData.PREV_PRICE_1 := 0;
  CPos.PosData.PREV_PRICE_2 := 0;
  CPos.PosData.PREV_PRICE_3 := 0;
  CPos.PosData.PREV_PRICE_4 := 0;
  CPos.PosData.PREV_PRICE_5 := 0;
  CPos.PosData.PREV_PRICE_6 := 0;
  CPos.PosData.PREV_PRICE_7 := 0;
  CPos.PosData.PREV_PRICE_8 := 0;
  CPos.PosData.PREV_PRICE_9 := 0;
  CPos.PosData.PREV_PRICE_10 := 0;
  CPos.PosData.PREV_PRICE_11 := 0;
  CPos.PosData.PREV_PRICE_12 := 0;
  CPos.PosData.PREV_PRICE_13 := 0;
  CPos.PosData.PREV_PRICE_14 := 0;
  CPos.PosData.PREV_PRICE_15 := 0;
  CPos.PosData.PREV_PRICE_16 := 0;
  CPos.PosData.PREV_PRICE_17 := 0;
  CPos.PosData.PREV_PRICE_18 := 0;
  CPos.PosData.PREV_PRICE_19 := 0;
  CPos.PosData.PREV_PRICE_20 := 0;
  CPos.PosData.PREV_PRICE_21 := 0;
  CPos.PosData.PREV_PRICE_22 := 0;
  CPos.PosData.PREV_PRICE_23 := 0;
  CPos.PosData.PREV_PRICE_24 := 0;
  CPos.PosData.PREV_PRICE_25 := 0;
  CPos.PosData.PREV_PRICE_26 := 0;
  CPos.PosData.PREV_PRICE_27 := 0;
  CPos.PosData.PREV_PRICE_28 := 0;
  CPos.PosData.PREV_PRICE_29 := 0;
  CPos.PosData.PREV_PRICE_30 := 0;
  CPos.PosData.PREV_PRICE_31 := 0;
  CPos.PosData.PREV_PRICE_32 := 0;
  {END mobile average 32x}

end;

procedure Tdm_Main.SetTempParams;
begin

  with dset_Temp_Positions do
  begin
          FieldValues['CLOSE_AT_MARKETCLOSING'] := TempParams.CLOSE_AT_MARKETCLOSING  ;


          FieldValues['OPEN_PERCENT'] := TempParams.OPEN_PERCENT;
          FieldValues['RE_OPEN_PERCENT'] := TempParams.RE_OPEN_PERCENT;
          FieldValues['PROT_CORECT']  := TempParams.PROT_CORECT;
          FieldValues['PROT_MARGIN']  := TempParams.PROT_MARGIN;

          FieldValues['STOP_PERCENT'] := TempParams.STOP_PERCENT;
          FieldValues['TAKE_PERCENT'] := TempParams.TAKE_PERCENT;

          FieldValues['SHORT_OPEN_PERCENT'] := TempParams.SHORT_OPEN_PERCENT;
          FieldValues['SHORT_RE_OPEN_PERCENT'] := TempParams.SHORT_RE_OPEN_PERCENT;
          FieldValues['SHORT_PROT_CORECT']  := TempParams.SHORT_PROT_CORECT;
          FieldValues['SHORT_PROT_MARGIN']  := TempParams.SHORT_PROT_MARGIN;

          FieldValues['SHORT_STOP_PERCENT'] := TempParams.SHORT_STOP_PERCENT;
          FieldValues['SHORT_TAKE_PERCENT'] := TempParams.SHORT_TAKE_PERCENT;

          FieldValues['NR_AVG'] := TempParams.NR_AVG;
          FieldValues['USE_EMA'] := TempParams.USE_EMA;
          FieldValues['FORCE_BUY'] := TempParams.FORCE_BUY;

          FieldValues['RE_OPEN'] := TempParams.RE_OPEN;
          FieldValues['RE_TAKE'] := TempParams.RE_TAKE;
          FieldValues['RESET_AVERAGE'] := TempParams.RESET_AVERAGE;
          FieldValues['STAND_BY_AFTER_PROT'] := TempParams.STAND_BY_AFTER_PROT;
          FieldValues['STANDBY_AFTER_STOP'] := TempParams.STANDBY_AFTER_STOP;
          FieldValues['EARLY_PROT'] := TempParams.EARLY_PROT;

          FieldValues['BOUNCE'] := TempParams.BOUNCE;
          FieldValues['MIN_BOUNCE'] := TempParams.MIN_BOUNCE;
          FieldValues['MAX_BOUNCE'] := TempParams.MAX_BOUNCE;
          FieldValues['PRF_PRC_ERL'] := TempParams.PRF_PRC_ERL;
          FieldValues['COR_PRC_ERL'] := TempParams.COR_PRC_ERL;

  end;

end;

procedure Tdm_Main.SaveTempParams;
begin
  with dset_Temp_Positions do
  begin

    TempParams.CLOSE_AT_MARKETCLOSING  := FieldValues['CLOSE_AT_MARKETCLOSING'];

    TempParams.OPEN_PERCENT := FieldValues['OPEN_PERCENT'];
    TempParams.RE_OPEN_PERCENT := FieldValues['RE_OPEN_PERCENT'] ;
    TempParams.PROT_CORECT := FieldValues['PROT_CORECT'];
    TempParams.PROT_MARGIN := FieldValues['PROT_MARGIN'];

    TempParams.STOP_PERCENT := FieldValues['STOP_PERCENT'];
    TempParams.TAKE_PERCENT := FieldValues['TAKE_PERCENT'];

    TempParams.SHORT_OPEN_PERCENT := FieldValues['SHORT_OPEN_PERCENT'];
    TempParams.SHORT_RE_OPEN_PERCENT := FieldValues['SHORT_RE_OPEN_PERCENT'];
    TempParams.SHORT_PROT_CORECT := FieldValues['SHORT_PROT_CORECT'];
    TempParams.SHORT_PROT_MARGIN := FieldValues['SHORT_PROT_MARGIN'];

    TempParams.SHORT_STOP_PERCENT := FieldValues['SHORT_STOP_PERCENT'];
    TempParams.SHORT_TAKE_PERCENT := FieldValues['SHORT_TAKE_PERCENT'];

    TempParams.NR_AVG := FieldValues['NR_AVG'];
    TempParams.USE_EMA := FieldValues['USE_EMA'];
    TempParams.FORCE_BUY := FieldValues['FORCE_BUY'];

    TempParams.RE_OPEN := FieldValues['RE_OPEN'];
    TempParams.RE_TAKE := FieldValues['RE_TAKE'];
    TempParams.RESET_AVERAGE := FieldValues['RESET_AVERAGE'];
    TempParams.STAND_BY_AFTER_PROT := FieldValues['STAND_BY_AFTER_PROT'];
    TempParams.EARLY_PROT := FieldValues['EARLY_PROT'];

    TempParams.BOUNCE := FieldValues['BOUNCE'];
    TempParams.MIN_BOUNCE := FieldValues['MIN_BOUNCE'];
    TempParams.MAX_BOUNCE := FieldValues['MAX_BOUNCE'];
    TempParams.PRF_PRC_ERL := FieldValues['PRF_PRC_ERL'];
    TempParams.COR_PRC_ERL := FieldValues['COR_PRC_ERL'];

    SaveParams;
  end;
end;

procedure Tdm_Main.DataModuleCreate(Sender: TObject);
begin
 SetLength(ExchangeConnectors, 0);
 AATSettings:= LoadAATSettings(StringReplace(Application.ExeName, '.exe', '.xml', [rfIgnoreCase]));

 MarketPlatform := TExchangeConnector.Create;
 MarketPlatform.OwnerThreadID :=-1;
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

//  added Dan 20141031
function GetXMLExpression(Node: TDomNode): string;
 begin
  result:= '';

  if node.ChildNodes.Count = 1 then
   if node.ChildNodes.Item[0].NodeName = '#text' then
    result:= node.ChildNodes.Item[0].NodeValue;
 end;

function Tdm_Main.GetAATDefaultSettings: TAATSettings;
 begin
  FillChar(result, sizeof(result), 0);
  result.TWS.Host:= '127.0.0.1';
  result.TWS.Port:= 7496;
  result.TWS.ClientID:= SecondOfTheDay(Now);
 end;

function Tdm_Main.LoadAATSettings(Stream: TStream): TAATSettings; overload;

 function Parse_TWSSettings(Node: TDOMNode): TTWSSettings;
  var i: integer;
      xml_node: TDOMNode;
      node_name: string;
  begin
   FillChar(result, sizeof(result), 0);

   for i:= 0 to Node.ChildNodes.Count - 1 do
    begin
     xml_node:= Node.ChildNodes.Item[i];
     node_name:= UpperCase(xml_node.NodeName);

     if node_name = 'HOST'     then result.Host    := GetXMLExpression(xml_node);
     if node_name = 'PORT'     then result.Port    := StrToIntDef(GetXMLExpression(xml_node), 7496);
     if node_name = 'CLIENTID' then result.ClientID:= StrToIntDef(GetXMLExpression(xml_node), SecondOfTheDay(Now));

     xml_node:= nil;
    end;
  end;

 var doc: TXMLDocument;
     i, k: integer;
     node: TDOMNode;
     node_name: string;
 begin
  result:= GetAATDefaultSettings;

  doc:= TXMLDocument.Create;
  ReadXMLFile(doc, Stream);

  for i:= 0 to doc.DocumentElement.ChildNodes.Count - 1 do
   begin
    node:= doc.DocumentElement.ChildNodes.Item[i];
    node_name:= UpperCase(node.NodeName);

    if node_name = 'TWS' then result.TWS:= Parse_TWSSettings(node);

    node:= nil;
   end;

  doc.Free;
 end;

function Tdm_Main.LoadAATSettings(XMLFile: string): TAATSettings; overload;
 var FS: TFileStream;
 begin
  if FileExists(XMLFile) then
   begin;
    FS:= TFileStream.Create(XMLFile, fmOpenRead);
    result:= LoadAATSettings(FS);
    FS.Free;
   end
  else
   begin
    result:= GetAATDefaultSettings;
    SaveAATSettings(XMLFile, result);
   end;
 end;

procedure Tdm_Main.SaveAATSettings(Stream: TStream; Settings: TAATSettings); overload;
 var doc: TXMLDocument;
     doc_node, node: TDOMElement;
     node_TWS: TDOMElement;
     txt: TDOMText;
     s: string;
     i: integer;
 begin
  doc:= TXMLDocument.Create;

  doc_node:= doc.CreateElement('AdvAutoTrading');
  doc.AppendChild(doc_node);

  //  ODBC settings
  node_TWS:= doc.CreateElement('TWS');
  doc_node.AppendChild(node_TWS);

  node:= doc.CreateElement('Host');
  node.AppendChild(doc.CreateTextNode(Settings.TWS.Host));
  node_TWS.AppendChild(node);

  node:= doc.CreateElement('Port');
  node.AppendChild(doc.CreateTextNode(IntToStr(Settings.TWS.Port)));
  node_TWS.AppendChild(node);

  node:= doc.CreateElement('ClientID');
  node.AppendChild(doc.CreateTextNode(IntToStr(Settings.TWS.ClientID)));
  node_TWS.AppendChild(node);

  WriteXMLFile(doc, Stream);
  doc.Free;
 end;

procedure Tdm_Main.SaveAATSettings(XMLFile: string; Settings: TAATSettings); overload;
 var FS: TFileStream;
 begin
  FS:= TFileStream.Create(XMLFile, fmCreate);
  SaveAATSettings(FS, Settings);
  FS.Free;
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

  CPos.PosData.PREV_PRICE_32 := CPos.PosData.PREV_PRICE_31;
  CPos.PosData.PREV_PRICE_31 := CPos.PosData.PREV_PRICE_30;
  CPos.PosData.PREV_PRICE_30 := CPos.PosData.PREV_PRICE_29;
  CPos.PosData.PREV_PRICE_29 := CPos.PosData.PREV_PRICE_28;
  CPos.PosData.PREV_PRICE_28 := CPos.PosData.PREV_PRICE_27;
  CPos.PosData.PREV_PRICE_27 := CPos.PosData.PREV_PRICE_26;
  CPos.PosData.PREV_PRICE_26 := CPos.PosData.PREV_PRICE_25;
  CPos.PosData.PREV_PRICE_25 := CPos.PosData.PREV_PRICE_24;
  CPos.PosData.PREV_PRICE_24 := CPos.PosData.PREV_PRICE_23;
  CPos.PosData.PREV_PRICE_23 := CPos.PosData.PREV_PRICE_22;
  CPos.PosData.PREV_PRICE_22 := CPos.PosData.PREV_PRICE_21;
  CPos.PosData.PREV_PRICE_21 := CPos.PosData.PREV_PRICE_20;
  CPos.PosData.PREV_PRICE_20 := CPos.PosData.PREV_PRICE_19;
  CPos.PosData.PREV_PRICE_19 := CPos.PosData.PREV_PRICE_18;
  CPos.PosData.PREV_PRICE_18 := CPos.PosData.PREV_PRICE_17;
  CPos.PosData.PREV_PRICE_17 := CPos.PosData.PREV_PRICE_16;
  CPos.PosData.PREV_PRICE_16 := CPos.PosData.PREV_PRICE_15;
  CPos.PosData.PREV_PRICE_15 := CPos.PosData.PREV_PRICE_14;
  CPos.PosData.PREV_PRICE_14 := CPos.PosData.PREV_PRICE_13;
  CPos.PosData.PREV_PRICE_13 := CPos.PosData.PREV_PRICE_12;
  CPos.PosData.PREV_PRICE_12 := CPos.PosData.PREV_PRICE_11;
  CPos.PosData.PREV_PRICE_11 := CPos.PosData.PREV_PRICE_10;
  CPos.PosData.PREV_PRICE_10 := CPos.PosData.PREV_PRICE_9;
  CPos.PosData.PREV_PRICE_9 := CPos.PosData.PREV_PRICE_8;
  CPos.PosData.PREV_PRICE_8 := CPos.PosData.PREV_PRICE_7;
  CPos.PosData.PREV_PRICE_7 := CPos.PosData.PREV_PRICE_6;
  CPos.PosData.PREV_PRICE_6 := CPos.PosData.PREV_PRICE_5;
  CPos.PosData.PREV_PRICE_5 := CPos.PosData.PREV_PRICE_4;
  CPos.PosData.PREV_PRICE_4 := CPos.PosData.PREV_PRICE_3;
  CPos.PosData.PREV_PRICE_3 := CPos.PosData.PREV_PRICE_2;
  CPos.PosData.PREV_PRICE_2 := CPos.PosData.PREV_PRICE_1;
  CPos.PosData.PREV_PRICE_1 := CPos.PosData.Prev_Price;    // PREV_PRICE MUST CONTAIN PREVIOUS PRICE AS LAST MUST CONTAIN CURRENT PRICE !

    arr_prices[0] := CPos.PosData.LAST_MARKET_PRICE;
    arr_prices[1] := CPos.PosData.PREV_PRICE_1;
    arr_prices[2] := CPos.PosData.PREV_PRICE_2;
    arr_prices[3] := CPos.PosData.PREV_PRICE_3;
    arr_prices[4] := CPos.PosData.PREV_PRICE_4;
    arr_prices[5] := CPos.PosData.PREV_PRICE_5;
    arr_prices[6] := CPos.PosData.PREV_PRICE_6;
    arr_prices[7] := CPos.PosData.PREV_PRICE_7;
    arr_prices[8] := CPos.PosData.PREV_PRICE_8;
    arr_prices[9] := CPos.PosData.PREV_PRICE_9;
    arr_prices[10] := CPos.PosData.PREV_PRICE_10;
    arr_prices[11] := CPos.PosData.PREV_PRICE_11;
    arr_prices[12] := CPos.PosData.PREV_PRICE_12;
    arr_prices[13] := CPos.PosData.PREV_PRICE_13;
    arr_prices[14] := CPos.PosData.PREV_PRICE_14;
    arr_prices[15] := CPos.PosData.PREV_PRICE_15;
    arr_prices[16] := CPos.PosData.PREV_PRICE_16;
    arr_prices[17] := CPos.PosData.PREV_PRICE_17;
    arr_prices[18] := CPos.PosData.PREV_PRICE_18;
    arr_prices[19] := CPos.PosData.PREV_PRICE_19;
    arr_prices[20] := CPos.PosData.PREV_PRICE_20;
    arr_prices[21] := CPos.PosData.PREV_PRICE_21;
    arr_prices[22] := CPos.PosData.PREV_PRICE_22;
    arr_prices[23] := CPos.PosData.PREV_PRICE_23;
    arr_prices[24] := CPos.PosData.PREV_PRICE_24;
    arr_prices[25] := CPos.PosData.PREV_PRICE_25;
    arr_prices[26] := CPos.PosData.PREV_PRICE_26;
    arr_prices[27] := CPos.PosData.PREV_PRICE_27;
    arr_prices[28] := CPos.PosData.PREV_PRICE_28;
    arr_prices[29] := CPos.PosData.PREV_PRICE_29;
    arr_prices[30] := CPos.PosData.PREV_PRICE_30;
    arr_prices[31] := CPos.PosData.PREV_PRICE_31;
    arr_prices[32] := CPos.PosData.PREV_PRICE_32;

    avg_price := 0;
    cnt:=0;
    CPos.PosData.str_Average32Info := '';

    if CPos.PosParams.NR_AVG>32 then
      nr_prices:=32
    else
      nr_prices:=Cpos.PosParams.NR_AVG;

    for i:=0 to nr_prices do
    begin
      avg_price := avg_price + arr_prices[i];
      if arr_prices[i] >0 then
      begin
        inc(cnt);
        CPos.PosData.str_Average32Info := CPos.PosData.str_Average32Info +' '+FormatFloat('0.00',arr_prices[i]);
      end;
    end;
    avg_price := avg_price / (cnt);

    CPos.PosData.SMA_PRICE := avg_price;

    Result := avg_price;
end;

function Tdm_Main.CalcGenericAverage(var CPos: TMarketPosition; i_prev_nr_prices:integer ): double;
var
  f_old_sum, f_new_average : double;
begin

  if i_prev_nr_prices < CPos.PosParams.NR_AVG then
  begin
    f_old_sum := CPos.PosData.EMA_PRICE * i_prev_nr_prices;
    f_new_average := (f_old_sum  + CPos.PosData.LAST_MARKET_PRICE) / CPos.PosData.NR_REC_PRICES;
  end
  else
  begin
    CPos.PosData.OLDEST_PRICE := CPos.PosData.EMA_PRICE;
    //f_new_average := CPos.PosData.EMA_PRICE - CPos.PosData.OLDEST_PRICE / CPos.PosParams.NR_AVG + CPos.PosData.LAST_MARKET_PRICE / CPos.PosParams.NR_AVG ;
    f_new_average := (CPos.PosData.EMA_PRICE*(CPos.PosParams.NR_AVG-1) + CPos.PosData.LAST_MARKET_PRICE) / CPos.PosParams.NR_AVG;
  end;

//  f_new_average := Round(f_new_average*1000)/1000;
  CPos.PosData.EMA_PRICE := f_new_average;
  Result := f_new_average;
end;

procedure Tdm_Main.Reset_BackTestData;
begin
  MarketPlatform.ResetDebugList;
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
  CPos.PosData.SYMBOL := '';
  CPos.PosData.LAST_MARKET_PRICE := 0;
  CPos.PosData.Current_PL := 0;
  CPos.PosData.Open_Price  := 0;
  CPos.PosData.Open_Value  := 0;
  CPos.PosData.Take_Price  := 0;
  CPos.PosData.Prot_Correction_Price  := 0;
  CPos.PosData.Prev_Price := 0;
  try
    CPos.PosData.SYMBOL := dset_Positions.FieldValues['SYMBOL'];
  except

  end;

  if (Not dset_Positions.EOF) or (CPos.PosData.SYMBOL<>'') then
   begin
     CPos.PosParams.POS_ACTIVE := dset_Positions.FieldValues['ACTIVE'] ;
     Cpos.PosData.NRPOS:=dset_Positions.FieldValues['NRPOS'] ;
     CPos.PosData.VOLUME :=dset_Positions.FieldValues['VOLUME'] ;
     CPos.PosData.HISTORY_INDEX:=dset_Positions.FieldValues['HISTORY_INDEX'] ;
     CPos.PosData.TEMP_ID:=dset_Positions.FieldValues['TEMP_ID'] ;
     CPos.PosData.OPENED:=dset_Positions.FieldValues['OPENED'] ;

     CPos.PosData.START_PRICE_MIN:= dset_Positions.FieldValues['START_PRICE_MIN'] ;
     CPos.PosData.START_PRICE_MAX:= dset_Positions.FieldValues['START_PRICE_MAX'] ;

     CPos.PosData.LAST_BUY_PRICE:=dset_Positions.FieldValues['LAST_BUY_PRICE'] ;
     CPos.PosData.LAST_SELL_PRICE:=dset_Positions.FieldValues['LAST_SELL_PRICE'] ;

     CPos.PosData.STOP_PRICE :=dset_Positions.FieldValues['STOP_PRICE'] ;

     {LONG PARAMETERS}
     CPos.PosParams.OPEN_PERCENT:=dset_Positions.FieldValues['OPEN_PERCENT'] ;
     CPos.PosParams.RE_OPEN_PERCENT:=dset_Positions.FieldValues['RE_OPEN_PERCENT'] ;
     CPos.PosParams.STOP_PERCENT:=dset_Positions.FieldValues['STOP_PERCENT'] ;
     CPos.PosParams.TAKE_PERCENT:=dset_Positions.FieldValues['TAKE_PERCENT'] ;
     CPos.PosParams.PROT_MARGIN:= dset_Positions.FieldValues['PROT_MARGIN'] ;
     CPos.PosParams.PROT_CORECT:= dset_Positions.FieldValues['PROT_CORECT'] ;
     {END LONG PARAMETERS}

     {SHORT PARAMETERS}
     CPos.PosParams.SHORT_OPEN_PERCENT:=dset_Positions.FieldValues['SHORT_OPEN_PERCENT'] ;
     CPos.PosParams.SHORT_RE_OPEN_PERCENT:=dset_Positions.FieldValues['SHORT_RE_OPEN_PERCENT'] ;
     CPos.PosParams.SHORT_STOP_PERCENT:=dset_Positions.FieldValues['SHORT_STOP_PERCENT'] ;
     CPos.PosParams.SHORT_TAKE_PERCENT:=dset_Positions.FieldValues['SHORT_TAKE_PERCENT'] ;
     CPos.PosParams.SHORT_PROT_MARGIN:= dset_Positions.FieldValues['SHORT_PROT_MARGIN'] ;
     CPos.PosParams.SHORT_PROT_CORECT:= dset_Positions.FieldValues['SHORT_PROT_CORECT'] ;
     {END SHORT PARAMETERS}

     CPos.PosData.PROT_START_PRICE:= dset_Positions.FieldValues['PROT_START_PRICE'];
     Cpos.PosData.isProtection := dset_Positions.FieldValues['PROTECTION_ZONE'];

     CPos.PosData.COMPANY_NAME:= dset_Positions.FieldValues['COMPANY_NAME'] ;
     CPos.PosData.MARKET:= dset_Positions.FieldValues['MARKET'] ;
     CPos.PosData.SYMBOL:= dset_Positions.FieldValues['SYMBOL'] ;
     CPos.PosData.TOTAL_PL := dset_Positions.FieldValues['TOTAL_PL'] ;

     CPos.PosParams.RE_OPEN := dset_Positions.FieldValues['RE_OPEN'] ;
     CPos.PosParams.RE_TAKE := dset_Positions.FieldValues['RE_TAKE'] ;
     CPos.PosParams.RESET_AVERAGE := dset_Positions.FieldValues['RESET_AVERAGE'] ;

     Cpos.PosData.LAST_MARKET_PRICE := dset_Positions.FieldValues['LAST_MARKET_PRICE'];
     Cpos.PosData.MARKET_TIME := dset_Positions.FieldValues['MARKET_TIME'];

     Cpos.PosData.DIRECTION := dset_Positions.FieldValues['DIRECTION'];
     Cpos.PosData.PREV_DIRECTION := dset_Positions.FieldValues['PREV_DIRECTION'];

     CPos.PosData.Prev_Price := CPos.PosData.LAST_MARKET_PRICE;
     CPos.PosParams.FORCE_BUY := dset_Positions.FieldValues['FORCE_BUY'];

     CPos.PosParams.CLOSE_AT_MARKETCLOSING  := dset_Positions.FieldValues['CLOSE_AT_MARKETCLOSING'];
     CPos.PosParams.CLOSE_NOW_AT_MARKET   := dset_Positions.FieldValues['CLOSE_NOW_AT_MARKET'];
     CPos.PosParams.STAND_BY_AFTER_PROT   := dset_Positions.FieldValues['STAND_BY_AFTER_PROT'];
     CPos.PosParams.STANDBY_AFTER_STOP   := dset_Positions.FieldValues['STANDBY_AFTER_STOP'];
     CPos.PosParams.EARLY_PROT   := dset_Positions.FieldValues['EARLY_PROT'];

     CPos.PosParams.BOUNCE := dset_Positions.FieldValues['BOUNCE'];
     CPos.PosParams.MIN_BOUNCE := dset_Positions.FieldValues['MIN_BOUNCE'];
     CPos.PosParams.MAX_BOUNCE := dset_Positions.FieldValues['MAX_BOUNCE'];
     CPos.PosParams.PRF_PRC_ERL := dset_Positions.FieldValues['PRF_PRC_ERL'];
     CPos.PosParams.COR_PRC_ERL := dset_Positions.FieldValues['COR_PRC_ERL'];

     CPos.PosData.BOUNCING := dset_Positions.FieldValues['BOUNCING'];



     {BEGIN mobile average GENERIC}
     CPos.PosParams.NR_AVG := dset_Positions.FieldValues['NR_AVG'];
     CPos.PosData.AVERAGE_PRICE := dset_Positions.FieldValues['AVERAGE_PRICE'];
     CPos.PosData.SMA_PRICE := dset_Positions.FieldValues['SMA_PRICE'];
     CPos.PosData.EMA_PRICE := dset_Positions.FieldValues['EMA_PRICE'];
     CPos.PosParams.USE_EMA := dset_Positions.FieldValues['USE_EMA'];

     CPos.PosData.NR_REC_PRICES := dset_Positions.FieldValues['NR_REC_PRICES'];
     CPos.PosData.OLDEST_PRICE  := dset_Positions.FieldValues['OLDEST_PRICE'];
     CPos.PosParams.TIME_AVERAGE :=  dset_Positions.FieldValues['TIME_AVERAGE'];
     {END mobile average 32x}

     {BEGIN mobile average GENERIC}
     CPos.PosData.PREV_PRICE_1 := dset_Positions.FieldValues['PREV_PRICE_1'];
     CPos.PosData.PREV_PRICE_2 := dset_Positions.FieldValues['PREV_PRICE_2'];
     CPos.PosData.PREV_PRICE_3 := dset_Positions.FieldValues['PREV_PRICE_3'];
     CPos.PosData.PREV_PRICE_4 := dset_Positions.FieldValues['PREV_PRICE_4'];
     CPos.PosData.PREV_PRICE_5 := dset_Positions.FieldValues['PREV_PRICE_5'];
     CPos.PosData.PREV_PRICE_6 := dset_Positions.FieldValues['PREV_PRICE_6'];
     CPos.PosData.PREV_PRICE_7 := dset_Positions.FieldValues['PREV_PRICE_7'];
     CPos.PosData.PREV_PRICE_8 := dset_Positions.FieldValues['PREV_PRICE_8'];
     CPos.PosData.PREV_PRICE_9 := dset_Positions.FieldValues['PREV_PRICE_9'];
     CPos.PosData.PREV_PRICE_10 := dset_Positions.FieldValues['PREV_PRICE_10'];
     CPos.PosData.PREV_PRICE_11 := dset_Positions.FieldValues['PREV_PRICE_11'];
     CPos.PosData.PREV_PRICE_12 := dset_Positions.FieldValues['PREV_PRICE_12'];
     CPos.PosData.PREV_PRICE_13 := dset_Positions.FieldValues['PREV_PRICE_13'];
     CPos.PosData.PREV_PRICE_14 := dset_Positions.FieldValues['PREV_PRICE_14'];
     CPos.PosData.PREV_PRICE_15 := dset_Positions.FieldValues['PREV_PRICE_15'];
     CPos.PosData.PREV_PRICE_16 := dset_Positions.FieldValues['PREV_PRICE_16'];
     CPos.PosData.PREV_PRICE_17 := dset_Positions.FieldValues['PREV_PRICE_17'];
     CPos.PosData.PREV_PRICE_18 := dset_Positions.FieldValues['PREV_PRICE_18'];
     CPos.PosData.PREV_PRICE_19 := dset_Positions.FieldValues['PREV_PRICE_19'];
     CPos.PosData.PREV_PRICE_20 := dset_Positions.FieldValues['PREV_PRICE_20'];
     CPos.PosData.PREV_PRICE_21 := dset_Positions.FieldValues['PREV_PRICE_21'];
     CPos.PosData.PREV_PRICE_22 := dset_Positions.FieldValues['PREV_PRICE_22'];
     CPos.PosData.PREV_PRICE_23 := dset_Positions.FieldValues['PREV_PRICE_23'];
     CPos.PosData.PREV_PRICE_24 := dset_Positions.FieldValues['PREV_PRICE_24'];
     CPos.PosData.PREV_PRICE_25 := dset_Positions.FieldValues['PREV_PRICE_25'];
     CPos.PosData.PREV_PRICE_26 := dset_Positions.FieldValues['PREV_PRICE_26'];
     CPos.PosData.PREV_PRICE_27 := dset_Positions.FieldValues['PREV_PRICE_27'];
     CPos.PosData.PREV_PRICE_28 := dset_Positions.FieldValues['PREV_PRICE_28'];
     CPos.PosData.PREV_PRICE_29 := dset_Positions.FieldValues['PREV_PRICE_29'];
     CPos.PosData.PREV_PRICE_30 := dset_Positions.FieldValues['PREV_PRICE_30'];
     CPos.PosData.PREV_PRICE_31 := dset_Positions.FieldValues['PREV_PRICE_31'];
     CPos.PosData.PREV_PRICE_32 := dset_Positions.FieldValues['PREV_PRICE_32'];
     {END mobile average 32x}


   end;

  Result := CPos;
end;

function Tdm_Main.GetCurrentClonedPosition: TMarketPosition;
var
  CPos:TMarketPosition;
begin
  CPos.PosData.SYMBOL := '';
  CPos.PosData.LAST_MARKET_PRICE := 0;
  CPos.PosData.Current_PL := 0;
  CPos.PosData.Open_Price  := 0;
  CPos.PosData.Open_Value  := 0;
  CPos.PosData.Take_Price  := 0;
  CPos.PosData.Prot_Correction_Price  := 0;
  CPos.PosData.Prev_Price := 0;
  try
    CPos.PosData.SYMBOL := dset_ClonedPositions.FieldValues['SYMBOL'];
  except
  end;
  if (Not dset_ClonedPositions.EOF) or (CPos.PosData.SYMBOL<>'') then
   begin
     CPos.PosParams.POS_ACTIVE := dset_ClonedPositions.FieldValues['ACTIVE'] ;
     Cpos.PosData.NRPOS:=dset_ClonedPositions.FieldValues['NRPOS'] ;
     CPos.PosData.VOLUME :=dset_ClonedPositions.FieldValues['VOLUME'] ;
     CPos.PosData.HISTORY_INDEX:=dset_ClonedPositions.FieldValues['HISTORY_INDEX'] ;
     CPos.PosData.TEMP_ID:=dset_ClonedPositions.FieldValues['TEMP_ID'] ;
     CPos.PosData.OPENED:=dset_ClonedPositions.FieldValues['OPENED'] ;

     CPos.PosData.STOP_PRICE :=dset_ClonedPositions.FieldValues['STOP_PRICE'] ;


     CPos.PosData.START_PRICE_MIN:= dset_ClonedPositions.FieldValues['START_PRICE_MIN'] ;
     CPos.PosData.START_PRICE_MAX:= dset_ClonedPositions.FieldValues['START_PRICE_MAX'] ;
     CPos.PosData.LAST_BUY_PRICE:=dset_ClonedPositions.FieldValues['LAST_BUY_PRICE'] ;
     CPos.PosData.LAST_SELL_PRICE:=dset_ClonedPositions.FieldValues['LAST_SELL_PRICE'] ;

     CPos.PosParams.OPEN_PERCENT:=dset_ClonedPositions.FieldValues['OPEN_PERCENT'] ;
     CPos.PosParams.RE_OPEN_PERCENT:=dset_ClonedPositions.FieldValues['RE_OPEN_PERCENT'] ;
     CPos.PosParams.STOP_PERCENT:=dset_ClonedPositions.FieldValues['STOP_PERCENT'] ;
     CPos.PosParams.TAKE_PERCENT:=dset_ClonedPositions.FieldValues['TAKE_PERCENT'] ;
     CPos.PosParams.PROT_MARGIN:= dset_ClonedPositions.FieldValues['PROT_MARGIN'] ;
     CPos.PosParams.PROT_CORECT:= dset_ClonedPositions.FieldValues['PROT_CORECT'] ;

     CPos.PosParams.SHORT_OPEN_PERCENT:=dset_ClonedPositions.FieldValues['SHORT_OPEN_PERCENT'] ;
     CPos.PosParams.SHORT_RE_OPEN_PERCENT:=dset_ClonedPositions.FieldValues['SHORT_RE_OPEN_PERCENT'] ;
     CPos.PosParams.SHORT_STOP_PERCENT:=dset_ClonedPositions.FieldValues['SHORT_STOP_PERCENT'] ;
     CPos.PosParams.SHORT_TAKE_PERCENT:=dset_ClonedPositions.FieldValues['SHORT_TAKE_PERCENT'] ;
     CPos.PosParams.SHORT_PROT_MARGIN:= dset_ClonedPositions.FieldValues['SHORT_PROT_MARGIN'] ;
     CPos.PosParams.SHORT_PROT_CORECT:= dset_ClonedPositions.FieldValues['SHORT_PROT_CORECT'] ;

     CPos.PosParams.FORCE_BUY := dset_ClonedPositions.FieldValues['FORCE_BUY'];

     CPos.PosParams.CLOSE_AT_MARKETCLOSING  := dset_ClonedPositions.FieldValues['CLOSE_AT_MARKETCLOSING'];
     CPos.PosParams.CLOSE_NOW_AT_MARKET   := dset_ClonedPositions.FieldValues['CLOSE_NOW_AT_MARKET'];
     CPos.PosParams.STAND_BY_AFTER_PROT   := dset_ClonedPositions.FieldValues['STAND_BY_AFTER_PROT'];
     CPos.PosParams.STANDBY_AFTER_STOP   := dset_ClonedPositions.FieldValues['STANDBY_AFTER_STOP'];
     CPos.PosParams.EARLY_PROT   := dset_ClonedPositions.FieldValues['EARLY_PROT'];

     CPos.PosParams.BOUNCE := dset_ClonedPositions.FieldValues['BOUNCE'];
     CPos.PosParams.MIN_BOUNCE := dset_ClonedPositions.FieldValues['MIN_BOUNCE'];
     CPos.PosParams.MAX_BOUNCE := dset_ClonedPositions.FieldValues['MAX_BOUNCE'];
     CPos.PosParams.PRF_PRC_ERL := dset_ClonedPositions.FieldValues['PRF_PRC_ERL'];
     CPos.PosParams.COR_PRC_ERL := dset_ClonedPositions.FieldValues['COR_PRC_ERL'];



     CPos.PosData.PROT_START_PRICE:= dset_ClonedPositions.FieldValues['PROT_START_PRICE'];
     Cpos.PosData.isProtection := dset_ClonedPositions.FieldValues['PROTECTION_ZONE'];

     CPos.PosData.COMPANY_NAME:= dset_ClonedPositions.FieldValues['COMPANY_NAME'] ;
     CPos.PosData.MARKET:= dset_ClonedPositions.FieldValues['MARKET'] ;
     CPos.PosData.SYMBOL:= dset_ClonedPositions.FieldValues['SYMBOL'] ;
     CPos.PosData.TOTAL_PL := dset_ClonedPositions.FieldValues['TOTAL_PL'] ;

     CPos.PosParams.RE_OPEN := dset_ClonedPositions.FieldValues['RE_OPEN'] ;
     CPos.PosParams.RE_TAKE := dset_ClonedPositions.FieldValues['RE_TAKE'] ;
     CPos.PosParams.RESET_AVERAGE := dset_ClonedPositions.FieldValues['RESET_AVERAGE'] ;

     Cpos.PosData.LAST_MARKET_PRICE := dset_ClonedPositions.FieldValues['LAST_MARKET_PRICE'];
     Cpos.PosData.MARKET_TIME := dset_ClonedPositions.FieldValues['MARKET_TIME'];

     Cpos.PosData.DIRECTION := dset_ClonedPositions.FieldValues['DIRECTION'];
     Cpos.PosData.PREV_DIRECTION := dset_ClonedPositions.FieldValues['PREV_DIRECTION'];

     CPos.PosData.Prev_Price := CPos.PosData.LAST_MARKET_PRICE;

     CPos.PosData.BOUNCING := dset_ClonedPositions.FieldValues['BOUNCING'];


     {BEGIN mobile average GENERIC}

      CPos.PosParams.NR_AVG := dset_ClonedPositions.FieldValues['NR_AVG'];
      CPos.PosData.AVERAGE_PRICE := dset_ClonedPositions.FieldValues['AVERAGE_PRICE'];
      CPos.PosData.SMA_PRICE := dset_ClonedPositions.FieldValues['SMA_PRICE'];
      CPos.PosData.EMA_PRICE := dset_ClonedPositions.FieldValues['EMA_PRICE'];
      CPos.PosParams.USE_EMA := dset_ClonedPositions.FieldValues['USE_EMA'];


      CPos.PosData.NR_REC_PRICES := dset_ClonedPositions.FieldValues['NR_REC_PRICES'];
      CPos.PosData.OLDEST_PRICE  := dset_ClonedPositions.FieldValues['OLDEST_PRICE'];
      CPos.PosParams.TIME_AVERAGE := dset_ClonedPositions.FieldValues['TIME_AVERAGE'];
      {END mobile average GENERIC}


      {BEGIN mobile average 32x}
       CPos.PosData.PREV_PRICE_1 := dset_ClonedPositions.FieldValues['PREV_PRICE_1'];
       CPos.PosData.PREV_PRICE_2 := dset_ClonedPositions.FieldValues['PREV_PRICE_2'];
       CPos.PosData.PREV_PRICE_3 := dset_ClonedPositions.FieldValues['PREV_PRICE_3'];
       CPos.PosData.PREV_PRICE_4 := dset_ClonedPositions.FieldValues['PREV_PRICE_4'];
       CPos.PosData.PREV_PRICE_5 := dset_ClonedPositions.FieldValues['PREV_PRICE_5'];
       CPos.PosData.PREV_PRICE_6 := dset_ClonedPositions.FieldValues['PREV_PRICE_6'];
       CPos.PosData.PREV_PRICE_7 := dset_ClonedPositions.FieldValues['PREV_PRICE_7'];
       CPos.PosData.PREV_PRICE_8 := dset_ClonedPositions.FieldValues['PREV_PRICE_8'];
       CPos.PosData.PREV_PRICE_9 := dset_ClonedPositions.FieldValues['PREV_PRICE_9'];
       CPos.PosData.PREV_PRICE_10 := dset_ClonedPositions.FieldValues['PREV_PRICE_10'];
       CPos.PosData.PREV_PRICE_11 := dset_ClonedPositions.FieldValues['PREV_PRICE_11'];
       CPos.PosData.PREV_PRICE_12 := dset_ClonedPositions.FieldValues['PREV_PRICE_12'];
       CPos.PosData.PREV_PRICE_13 := dset_ClonedPositions.FieldValues['PREV_PRICE_13'];
       CPos.PosData.PREV_PRICE_14 := dset_ClonedPositions.FieldValues['PREV_PRICE_14'];
       CPos.PosData.PREV_PRICE_15 := dset_ClonedPositions.FieldValues['PREV_PRICE_15'];
       CPos.PosData.PREV_PRICE_16 := dset_ClonedPositions.FieldValues['PREV_PRICE_16'];
       CPos.PosData.PREV_PRICE_17 := dset_ClonedPositions.FieldValues['PREV_PRICE_17'];
       CPos.PosData.PREV_PRICE_18 := dset_ClonedPositions.FieldValues['PREV_PRICE_18'];
       CPos.PosData.PREV_PRICE_19 := dset_ClonedPositions.FieldValues['PREV_PRICE_19'];
       CPos.PosData.PREV_PRICE_20 := dset_ClonedPositions.FieldValues['PREV_PRICE_20'];
       CPos.PosData.PREV_PRICE_21 := dset_ClonedPositions.FieldValues['PREV_PRICE_21'];
       CPos.PosData.PREV_PRICE_22 := dset_ClonedPositions.FieldValues['PREV_PRICE_22'];
       CPos.PosData.PREV_PRICE_23 := dset_ClonedPositions.FieldValues['PREV_PRICE_23'];
       CPos.PosData.PREV_PRICE_24 := dset_ClonedPositions.FieldValues['PREV_PRICE_24'];
       CPos.PosData.PREV_PRICE_25 := dset_ClonedPositions.FieldValues['PREV_PRICE_25'];
       CPos.PosData.PREV_PRICE_26 := dset_ClonedPositions.FieldValues['PREV_PRICE_26'];
       CPos.PosData.PREV_PRICE_27 := dset_ClonedPositions.FieldValues['PREV_PRICE_27'];
       CPos.PosData.PREV_PRICE_28 := dset_ClonedPositions.FieldValues['PREV_PRICE_28'];
       CPos.PosData.PREV_PRICE_29 := dset_ClonedPositions.FieldValues['PREV_PRICE_29'];
       CPos.PosData.PREV_PRICE_30 := dset_ClonedPositions.FieldValues['PREV_PRICE_30'];
       CPos.PosData.PREV_PRICE_31 := dset_ClonedPositions.FieldValues['PREV_PRICE_31'];
       CPos.PosData.PREV_PRICE_32 := dset_ClonedPositions.FieldValues['PREV_PRICE_32'];
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

      dset_Positions.Locate('NRPOS',Cpos.PosData.NRPOS,[]);

      dset_Positions.Edit;

      dset_Positions.FieldValues['FORCE_BUY'] := CPos.PosParams.FORCE_BUY;

      dset_Positions.FieldValues['ACTIVE'] := CPos.PosParams.POS_ACTIVE;
      dset_Positions.FieldValues['VOLUME'] := CPos.PosData.VOLUME;
      dset_Positions.FieldValues['HISTORY_INDEX'] := CPos.PosData.HISTORY_INDEX;
      dset_Positions.FieldValues['TEMP_ID'] := CPos.PosData.TEMP_ID;
      dset_Positions.FieldValues['OPENED'] := CPos.PosData.OPENED;

      dset_Positions.FieldValues['START_PRICE_MIN'] := CPos.PosData.START_PRICE_MIN;
      dset_Positions.FieldValues['START_PRICE_MAX'] := CPos.PosData.START_PRICE_MAX;

      dset_Positions.FieldValues['LAST_BUY_PRICE'] := CPos.PosData.LAST_BUY_PRICE;
      dset_Positions.FieldValues['LAST_SELL_PRICE'] := CPos.PosData.LAST_SELL_PRICE;

      dset_Positions.FieldValues['OPEN_PERCENT'] := CPos.PosParams.OPEN_PERCENT;
      dset_Positions.FieldValues['RE_OPEN_PERCENT'] := CPos.PosParams.RE_OPEN_PERCENT;
      dset_Positions.FieldValues['STOP_PERCENT'] := CPos.PosParams.STOP_PERCENT;
      dset_Positions.FieldValues['TAKE_PERCENT'] := CPos.PosParams.TAKE_PERCENT;
      dset_Positions.FieldValues['PROT_MARGIN'] := CPos.PosParams.PROT_MARGIN;
      dset_Positions.FieldValues['PROT_CORECT'] := CPos.PosParams.PROT_CORECT;

      dset_Positions.FieldValues['SHORT_OPEN_PERCENT'] := CPos.PosParams.SHORT_OPEN_PERCENT;
      dset_Positions.FieldValues['SHORT_RE_OPEN_PERCENT'] := CPos.PosParams.SHORT_RE_OPEN_PERCENT;
      dset_Positions.FieldValues['SHORT_STOP_PERCENT'] := CPos.PosParams.SHORT_STOP_PERCENT;
      dset_Positions.FieldValues['SHORT_TAKE_PERCENT'] := CPos.PosParams.SHORT_TAKE_PERCENT;
      dset_Positions.FieldValues['SHORT_PROT_MARGIN'] := CPos.PosParams.SHORT_PROT_MARGIN;
      dset_Positions.FieldValues['SHORT_PROT_CORECT'] := CPos.PosParams.SHORT_PROT_CORECT;

      dset_Positions.FieldValues['COMPANY_NAME'] := CPos.PosData.COMPANY_NAME;
      dset_Positions.FieldValues['MARKET'] := CPos.PosData.MARKET;
      dset_Positions.FieldValues['SYMBOL'] := CPos.PosData.SYMBOL;
      dset_Positions.FieldValues['TOTAL_PL'] := CPos.PosData.TOTAL_PL;

      dset_Positions.FieldValues['PROT_START_PRICE'] := CPos.PosData.PROT_START_PRICE;
      dset_Positions.FieldValues['PROTECTION_ZONE'] := Cpos.PosData.isProtection;

      dset_Positions.FieldValues['LAST_MARKET_PRICE'] := Cpos.PosData.LAST_MARKET_PRICE;

      dset_Positions.FieldValues['MARKET_TIME'] := Cpos.PosData.MARKET_TIME;

      dset_Positions.FieldValues['RE_OPEN'] := CPos.PosParams.RE_OPEN;
      dset_Positions.FieldValues['RE_TAKE'] := CPos.PosParams.RE_TAKE;
      dset_Positions.FieldValues['RESET_AVERAGE'] :=  CPos.PosParams.RESET_AVERAGE;

      dset_Positions.FieldValues['CLOSE_NOW_AT_MARKET'] := CPos.PosParams.CLOSE_NOW_AT_MARKET ;
      dset_Positions.FieldValues['CLOSE_AT_MARKETCLOSING'] := CPos.PosParams.CLOSE_AT_MARKETCLOSING  ;
      dset_Positions.FieldValues['STAND_BY_AFTER_PROT'] := CPos.PosParams.STAND_BY_AFTER_PROT;
      dset_Positions.FieldValues['STANDBY_AFTER_STOP'] := CPos.PosParams.STANDBY_AFTER_STOP;
      dset_Positions.FieldValues['EARLY_PROT'] := CPos.PosParams.EARLY_PROT;

      dset_Positions.FieldValues['BOUNCE'] := CPos.PosParams.BOUNCE;
      dset_Positions.FieldValues['MIN_BOUNCE'] := CPos.PosParams.MIN_BOUNCE;
      dset_Positions.FieldValues['MAX_BOUNCE'] := CPos.PosParams.MAX_BOUNCE;
      dset_Positions.FieldValues['PRF_PRC_ERL'] := CPos.PosParams.PRF_PRC_ERL;
      dset_Positions.FieldValues['COR_PRC_ERL'] := CPos.PosParams.COR_PRC_ERL;

      dset_Positions.FieldValues['BOUNCING'] := CPos.PosData.BOUNCING;


      dset_Positions.FieldValues['DIRECTION'] := Cpos.PosData.DIRECTION;
      dset_Positions.FieldValues['PREV_DIRECTION'] := Cpos.PosData.PREV_DIRECTION;


      dset_Positions.FieldValues['STOP_PRICE'] := CPos.PosData.STOP_PRICE;


      {BEGIN mobile average GENERIC}
      dset_Positions.FieldValues['OLDEST_PRICE'] := CPos.PosData.OLDEST_PRICE ;
      dset_Positions.FieldValues['NR_REC_PRICES'] := CPos.PosData.NR_REC_PRICES;

      dset_Positions.FieldValues['NR_AVG'] := CPos.PosParams.NR_AVG;

      dset_Positions.FieldValues['AVERAGE_PRICE'] := CPos.PosData.AVERAGE_PRICE;
      dset_Positions.FieldValues['SMA_PRICE'] := CPos.PosData.SMA_PRICE;
      dset_Positions.FieldValues['EMA_PRICE'] := CPos.PosData.EMA_PRICE;
      dset_Positions.FieldValues['USE_EMA'] := CPos.PosParams.USE_EMA;

      dset_Positions.FieldValues['TIME_AVERAGE'] := CPos.PosParams.TIME_AVERAGE;
      {END mobile average GENERIC}

      {BEGIN mobile average 32x}
      dset_Positions.FieldValues['PREV_PRICE_1'] := CPos.PosData.PREV_PRICE_1;
      dset_Positions.FieldValues['PREV_PRICE_2'] := CPos.PosData.PREV_PRICE_2;
      dset_Positions.FieldValues['PREV_PRICE_3'] := CPos.PosData.PREV_PRICE_3;
      dset_Positions.FieldValues['PREV_PRICE_4'] := CPos.PosData.PREV_PRICE_4;
      dset_Positions.FieldValues['PREV_PRICE_5'] := CPos.PosData.PREV_PRICE_5;
      dset_Positions.FieldValues['PREV_PRICE_6'] := CPos.PosData.PREV_PRICE_6;
      dset_Positions.FieldValues['PREV_PRICE_7'] := CPos.PosData.PREV_PRICE_7;
      dset_Positions.FieldValues['PREV_PRICE_8'] := CPos.PosData.PREV_PRICE_8;
      dset_Positions.FieldValues['PREV_PRICE_9'] := CPos.PosData.PREV_PRICE_9;
      dset_Positions.FieldValues['PREV_PRICE_10'] := CPos.PosData.PREV_PRICE_10;
      dset_Positions.FieldValues['PREV_PRICE_11'] := CPos.PosData.PREV_PRICE_11;
      dset_Positions.FieldValues['PREV_PRICE_12'] := CPos.PosData.PREV_PRICE_12;
      dset_Positions.FieldValues['PREV_PRICE_13'] := CPos.PosData.PREV_PRICE_13;
      dset_Positions.FieldValues['PREV_PRICE_14'] := CPos.PosData.PREV_PRICE_14;
      dset_Positions.FieldValues['PREV_PRICE_15'] := CPos.PosData.PREV_PRICE_15;
      dset_Positions.FieldValues['PREV_PRICE_16'] := CPos.PosData.PREV_PRICE_16;

      dset_Positions.FieldValues['PREV_PRICE_17'] := CPos.PosData.PREV_PRICE_17;
      dset_Positions.FieldValues['PREV_PRICE_18'] := CPos.PosData.PREV_PRICE_18;
      dset_Positions.FieldValues['PREV_PRICE_19'] := CPos.PosData.PREV_PRICE_19;
      dset_Positions.FieldValues['PREV_PRICE_20'] := CPos.PosData.PREV_PRICE_20;
      dset_Positions.FieldValues['PREV_PRICE_21'] := CPos.PosData.PREV_PRICE_21;
      dset_Positions.FieldValues['PREV_PRICE_22'] := CPos.PosData.PREV_PRICE_22;
      dset_Positions.FieldValues['PREV_PRICE_23'] := CPos.PosData.PREV_PRICE_23;
      dset_Positions.FieldValues['PREV_PRICE_24'] := CPos.PosData.PREV_PRICE_24;
      dset_Positions.FieldValues['PREV_PRICE_25'] := CPos.PosData.PREV_PRICE_25;
      dset_Positions.FieldValues['PREV_PRICE_26'] := CPos.PosData.PREV_PRICE_26;
      dset_Positions.FieldValues['PREV_PRICE_27'] := CPos.PosData.PREV_PRICE_27;
      dset_Positions.FieldValues['PREV_PRICE_28'] := CPos.PosData.PREV_PRICE_28;
      dset_Positions.FieldValues['PREV_PRICE_29'] := CPos.PosData.PREV_PRICE_29;
      dset_Positions.FieldValues['PREV_PRICE_30'] := CPos.PosData.PREV_PRICE_30;
      dset_Positions.FieldValues['PREV_PRICE_31'] := CPos.PosData.PREV_PRICE_31;
      dset_Positions.FieldValues['PREV_PRICE_32'] := CPos.PosData.PREV_PRICE_32;
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


procedure Tdm_Main.AddHistory(str_Action, str_State: string;
  CPos: TMarketPosition;  f_price:double=0);
begin



  if CPos.PosData.NRPOS = -1 then
  begin
    CPos.PosData.SYMBOL:= '';
    CPos.PosData.PREV_DIRECTION := TPositionDirection.STANDBY ;
    CPos.PosData.DIRECTION :=TPositionDirection.STANDBY ;
    CPos.PosData.LAST_MARKET_PRICE := -1;
    dt_LastDateTime := IncMilliSecond(dt_LastDateTime);
    CPos.PosData.MARKET_TIME := 3; // ALGORITM DATETIME FOR NRPOS -1
    CPos.PosData.Current_PL := 0;
    CPos.PosData.TEMP_ID := 0;
  end;
  dm_Main.dset_History.Insert;
  dm_Main.dset_History['NRPOS']:= CPos.PosData.NRPOS;
  dm_Main.dset_History['ACTION']:= str_Action;
  dm_Main.dset_History['SYMBOL']:= CPos.PosData.SYMBOL;
  dm_Main.dset_History['TEMP_ID']:= CPos.PosData.TEMP_ID;
  dm_Main.dset_History['STATUS']:= 'ACTIV';

  dm_Main.dset_History['PREV_DIR']:= CPos.PosData.PREV_DIRECTION;
  dm_Main.dset_History['CURR_DIR']:= CPos.PosData.DIRECTION;


  if f_price<=0 then
    dm_Main.dset_History['PRICE']:= CPos.PosData.LAST_MARKET_PRICE
  else
    dm_Main.dset_History['PRICE']:= f_price;


  dm_Main.dset_History['AVERAGE_PRICE'] := CPos.PosData.AVERAGE_PRICE;
  dm_Main.dset_History['EMA_PRICE'] := CPos.PosData.EMA_PRICE;
  dm_Main.dset_History['SMA_PRICE'] := CPos.PosData.SMA_PRICE;

  dm_Main.dset_History['STATE']:= str_State;
  dm_Main.dset_History['DATETIME']:= CPos.PosData.MARKET_TIME;

  dm_Main.dset_History['PROFIT_LOSS']:= CPos.PosData.Current_PL;

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

function Tdm_Main.GetCurrentDataFileIndex(fname: shortstring; ext: shortstring): integer;
 var path: string;
     filename, filemask: string;
     index, i, k: integer;
     rec: TSearchRec;
     lst_str: TStringArray;
 begin
  path:= IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));
  filename:= fname + _DB_VER + '*.';
  filemask:= fname + _DB_VER + '_%s.';
  if Pos('.', ext) = 1 then Delete(ext, 1, 1);
  filename:= filename + ext;
  filemask:= filemask + ext;

  index:= 0;
  k:= FindFirst(path + filename, faAnyFile, rec);
  if k = 0 then
   begin
    while k = 0 do
     begin
      filename:= ExtractFileName(rec.Name);
      lst_str:= ParseFormat(filename, filemask);
      if Length(lst_str) = 0 then continue
      else
       begin
        i:= StrToIntDef(lst_str[0], 0);
        if i > index then index:= i;
       end;

      k:= FindNext(rec);
     end;
    FindClose(rec);
   end;

  result:= index;
 end;

function Tdm_Main.TryOpenFileStream(fname: shortstring; ext: shortstring; Mode: word): TFileStream;
 var index: integer;
     path, filename, filemask, str_idx: string;
     FS: TFileStream;
     b: boolean;
 begin
  path:= IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));
  filemask:= fname + _DB_VER + '_%s.';
  if Pos('.', ext) = 1 then Delete(ext, 1, 1);
  filemask:= filemask + ext;

  index:= GetCurrentDataFileIndex(name, ext);

  b:= false;
  FS:= nil;
  while not b and (index < 1000) do
   try
    if index = 0 then str_idx:= '' else str_idx:= IntToStr(index);

    //FS:= TFileStream.Create(path + Format(filemask, str_idx), Mode);
    b:= true;
   except
    b:= false;
    index += 1;
   end;

  result:= FS;
 end;

procedure Tdm_Main.LoadData;
var str_savefile:string;

begin

  try
    str_savefile := ExtractFileDir(Application.ExeName);
    str_savefile := str_savefile + '\_positions'+_DB_VER+'.aatdb';
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
    str_savefile := str_savefile + '\_history'+_DB_VER+'.aatdb';
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
    str_savefile := str_savefile + '\_prices'+_DB_VER+'.aatdb';
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

  TempParams.OPEN_PERCENT := +0.30;
  TempParams.RE_OPEN_PERCENT := +0.20;
  TempParams.PROT_CORECT := -0.30;
  TempParams.PROT_MARGIN := +1.50;

  TempParams.STOP_PERCENT := -5.00;
  TempParams.TAKE_PERCENT := +5.00;

  TempParams.SHORT_OPEN_PERCENT := -0.30;
  TempParams.SHORT_RE_OPEN_PERCENT := -0.20;
  TempParams.SHORT_PROT_CORECT := +0.30;
  TempParams.SHORT_PROT_MARGIN := -1.50;

  TempParams.SHORT_STOP_PERCENT := +5.00;
  TempParams.SHORT_TAKE_PERCENT := -5.00;

  TempParams.NR_AVG := 0;
  TempParams.USE_EMA := False;
  TempParams.FORCE_BUY := False;
  TempParams.RE_OPEN := False;
  TempParams.RE_TAKE := False;

  TempParams.RESET_AVERAGE := TRUE;  // better to reset averages when starting position !

  TempParams.STAND_BY_AFTER_PROT := False;
  TempParams.STANDBY_AFTER_STOP := False;
  TempParams.EARLY_PROT := False;

  TempParams.BOUNCE := False;
  TempParams.MIN_BOUNCE := 0.1;
  TempParams.MAX_BOUNCE := 0.2;
  TempParams.PRF_PRC_ERL := 0.35;
  TempParams.COR_PRC_ERL := 0.5;


  LoadParams;

end;

procedure Tdm_Main.SaveData;
var str_savefile:string;
begin
  try
    str_savefile := ExtractFileDir(Application.ExeName);
    str_savefile := str_savefile + '\_positions'+_DB_VER+'.aatdb';
    dm_main.dset_Positions.SaveToFile(str_savefile);

    str_savefile := '';
    str_savefile := ExtractFileDir(Application.ExeName);
    str_savefile := str_savefile + '\_history'+_DB_VER+'.aatdb';
    dm_main.dset_History.SaveToFile(str_savefile);

    str_savefile := '';
    str_savefile := ExtractFileDir(Application.ExeName);
    str_savefile := str_savefile + '\_prices'+_DB_VER+'.aatdb';
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
      CPos.PosData.MARKET_TIME := 1; //ERROR DATE TIME
      CPos.PosData.NRPOS := NrPos;
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

procedure Tdm_Main.LoadParams;
var
  vFile : file of TPositionParams;
  str_savefile:string;
begin
  str_savefile := '';
  str_savefile := ExtractFileDir(Application.ExeName);
  str_savefile := str_savefile + '\_params_last_v'+_DB_VER+'.aatp';

  if FileExists (str_savefile) then
  begin
    try
      AssignFile(vFile, str_savefile);
      Reset(vFile);
      Read(vFile, TempParams);
      CloseFile(vFile);
    except
    end;
  end;
end;

procedure Tdm_Main.SaveParams;
var
  vFile : file of TPositionParams;
  str_savefile,str_msg1,str_msg2:string;
  str_id:string[230];
  i_reply :integer;
begin

  str_savefile := '';
  str_savefile := ExtractFileDir(Application.ExeName);
  str_savefile := str_savefile + '\_params_last_v'+_DB_VER+'.aatp';
  TempParams.StrategyName := 'Ultima strategie folosita';

  try
    AssignFile(vFile, str_savefile);
    Rewrite(vFile);
    Write(vFile, TempParams);
    CloseFile (vFile);
  Except
  end;

  str_msg1 := 'Doriti denumirea acestui set de parametrii ?';
  str_msg2 := 'SALVARE STRATEGIE';
  i_Reply := Application.MessageBox(PChar(str_msg1),PChar(str_msg2) , MB_ICONQUESTION + MB_YESNO);
  if i_Reply = IDYES then
  begin
    str_id := IntToStr(Int64(TimeStampToMSecs(DateTimeToTimeStamp(Now))));
    str_id := InputBox('Denumire strategie','Introduceti numele:','Strategie'+str_id);
    TempParams.StrategyName := str_id;
    str_savefile := '';
    str_savefile := ExtractFileDir(Application.ExeName);
    str_savefile := str_savefile + '\_params_'+str_id+'_v'+_DB_VER+'.aatp';
    try
      AssignFile(vFile, str_savefile);
      Rewrite(vFile);
      Write(vFile, TempParams);
      CloseFile (vFile);
    Except
    end;
  end
end;



end.

