unit Dashboard;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, RTTICtrls, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Grids, DBGrids, ExtCtrls, DbCtrls, Buttons, ComCtrls, maskedit, DOM,
  BufDataset, u_dm_main, position, u_algorithm, u_finance_request,
  u_frm_history, u_frm_Debug, DateUtils, db,u_frm_about, LCLType, ActiveX;

const ct_SLOW_TIMER = 3000;


type

  { Tfrm_Main }

  Tfrm_Main = class(TForm)
    Bevel1: TBevel;
    btn_Close_Position: TBitBtn;
    btn_DEBUG: TBitBtn;
    btn_Launch: TBitBtn;
    btn_Modify: TBitBtn;
    btn_Delete: TBitBtn;
    btn_Close: TBitBtn;
    btn_History: TBitBtn;
    btn_Activate: TBitBtn;
    chk_DEBUG_PAUSE: TCheckBox;
    ck_StartStop: TCheckBox;
    chk_DEBUG: TCheckBox;
    DBGrid1: TDBGrid;
    dg_Positions: TDBGrid;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    gb_Pozitie: TGroupBox;
    GroupBox4: TGroupBox;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    lbl_Pos: TLabel;
    lbl_Ver: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lbl_OpenPrice: TLabel;
    lbl_OverallProfitLoss: TLabel;
    lbl_ProtMaxPrice: TLabel;
    lbl_ProtMinPrice: TLabel;
    lbl_StopLossPrice: TLabel;
    lbl_TakeProfitPrice: TLabel;
    lbl_DBVer: TLabel;
    lbl_Volume: TLabel;
    lbl_Current_PL: TLabel;
    ed_tm_Start: TMaskEdit;
    ed_tm_Stop: TMaskEdit;
    pnl_Info: TPanel;
    pnl_AppStatus: TPanel;
    pnl_Status: TPanel;
    tm_Timer: TTimer;
    procedure Bevel1ChangeBounds(Sender: TObject);
    procedure btn_Close_PositionClick(Sender: TObject);
    procedure btn_DEBUGClick(Sender: TObject);
    procedure btn_Close_Click(Sender: TObject);
    procedure btn_Delete_Click(Sender: TObject);
    procedure btn_History_Click(Sender: TObject);
    procedure btn_LaunchClick(Sender: TObject);
    procedure btn_Launch_Click(Sender: TObject);
    procedure btn_ActivateClick(Sender: TObject);
    procedure btn_Modify_Click(Sender: TObject);
    procedure chk_DEBUGChange(Sender: TObject);
    procedure chk_DEBUG_PAUSEChange(Sender: TObject);
    procedure chk_MEDIEREChange(Sender: TObject);
    procedure ck_StartStopChange(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure dg_PositionsCellClick(Column: TColumn);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure GroupBox2Click(Sender: TObject);
    procedure GroupBox3Click(Sender: TObject);
    procedure gb_PozitieClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure tm_TimerTimer(Sender: TObject);

  private
    bool_ForceStopTimer : Boolean;
    T1_ms, T2_ms, T3_ms: integer;
    T1_start,T1_stop: TDateTime;
    T2_start,T2_stop: TDateTime;
    T3_start,T3_stop: TDateTime;

    PositionList : TList;
    AlgorithmList: TList;

    TempParams:TMarketPosition;
    procedure LoadParams;
    procedure SaveParams;

    procedure GetSelectedPositionDetails;
    procedure SetupDEBUG;

    procedure RefreshPositions;

    procedure LaunchAllPositions;
    procedure PauseAllPositions;
    procedure ResumeAllPositions;
    procedure TermintateAllPositions;


  public
    { public declarations }


  end;

var
  frm_Main: Tfrm_Main;

implementation

{$R *.lfm}

{ Tfrm_Main }

procedure Tfrm_Main.btn_Launch_Click(Sender: TObject);
var
  i, int_interval: Integer;
  str_Field , str_Market: String;
  CPos:TMarketPosition;
  str_savefile:string;
begin

  { slow timer}
  int_interval := tm_Timer.Interval;
  tm_Timer.Interval := tm_Timer.Interval + ct_SLOW_TIMER;
  { done start slow timer }


  try
    dm_Main.dset_Temp_Positions.First;
    while not dm_Main.dset_Temp_Positions.eof do
     begin
        dm_Main.dset_Temp_Positions.Delete;
     end;
  finally
  end;


  dm_Main.dset_Temp_Positions.Insert;

  with dm_Main.dset_Temp_Positions do
  begin
        FieldValues['ACTIVE'] := True;
        FieldValues['CLOSE_NOW_AT_MARKET'] := False;
        FieldValues['VOLUME'] := 100;
        FieldValues['HISTORY_INDEX'] := 0;
        FieldValues['TEMP_ID'] := 0;
        FieldValues['OPENED'] := False;

        FieldValues['START_PRICE_MIN'] := 0;
        FieldValues['START_PRICE_MAX'] := 0;
        FieldValues['LAST_BUY_PRICE'] := 0;
        FieldValues['LAST_SELL_PRICE'] := 0;

        // configured parameters


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

        // done configured parameters

        FieldValues['COMPANY_NAME'] := '';
        FieldValues['MARKET'] := '';
        FieldValues['SYMBOL'] := '';
        FieldValues['TOTAL_PL'] := 0;

        FieldValues['PROT_START_PRICE'] := 0;
        FieldValues['STOP_PRICE'] := 0;
        FieldValues['PROTECTION_ZONE'] := False;
        FieldValues['LAST_MARKET_PRICE'] := 0;
        FieldValues['MARKET_TIME'] := 10; // ALGORITM DATETIME FOR POSITION START

        FieldValues['TIME_AVERAGE'] := False;

        FieldValues['SMA_PRICE'] := 0;
        FieldValues['EMA_PRICE'] := 0;
        FieldValues['AVERAGE_PRICE'] := 0;

        FieldValues['NR_REC_PRICES'] := 0;
        FieldValues['OLDEST_PRICE'] := 0;



        FieldValues['DIRECTION'] := TPositionDirection.STANDBY;
        FieldValues['PREV_DIRECTION'] := TPositionDirection.STANDBY;

        FieldValues['PREV_PRICE_1'] := 0;
        FieldValues['PREV_PRICE_2'] := 0;
        FieldValues['PREV_PRICE_3'] := 0;
        FieldValues['PREV_PRICE_4'] := 0;
        FieldValues['PREV_PRICE_5'] := 0;
        FieldValues['PREV_PRICE_6'] := 0;
        FieldValues['PREV_PRICE_7'] := 0;
        FieldValues['PREV_PRICE_8'] := 0;
        FieldValues['PREV_PRICE_9'] := 0;
        FieldValues['PREV_PRICE_10'] := 0;
        FieldValues['PREV_PRICE_11'] := 0;
        FieldValues['PREV_PRICE_12'] := 0;
        FieldValues['PREV_PRICE_13'] := 0;
        FieldValues['PREV_PRICE_14'] := 0;
        FieldValues['PREV_PRICE_15'] := 0;
        FieldValues['PREV_PRICE_16'] := 0;
        FieldValues['PREV_PRICE_17'] := 0;
        FieldValues['PREV_PRICE_18'] := 0;
        FieldValues['PREV_PRICE_19'] := 0;
        FieldValues['PREV_PRICE_20'] := 0;
        FieldValues['PREV_PRICE_21'] := 0;
        FieldValues['PREV_PRICE_22'] := 0;
        FieldValues['PREV_PRICE_23'] := 0;
        FieldValues['PREV_PRICE_24'] := 0;
        FieldValues['PREV_PRICE_25'] := 0;
        FieldValues['PREV_PRICE_26'] := 0;
        FieldValues['PREV_PRICE_27'] := 0;
        FieldValues['PREV_PRICE_28'] := 0;
        FieldValues['PREV_PRICE_29'] := 0;
        FieldValues['PREV_PRICE_30'] := 0;
        FieldValues['PREV_PRICE_31'] := 0;
        FieldValues['PREV_PRICE_32'] := 0;

  end;






  if frm_Lansare.ShowModal=mrOK then
  begin

    with dm_Main.dset_Temp_Positions do
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

      SaveParams;
    end;

    dm_main.dset_Temp_Positions.Post;

    str_Market := dm_Main.dset_Temp_Positions.FieldValues['MARKET'];
    if str_Market = '' then
     _ShowMessage(' MARKET ERROR ! ');

    {disable tm_Timer}
     bool_ForceStopTimer := True;
     CPos.NRPOS :=-1;
     CPos.MARKET_TIME := 2; // ALGORITM DEBUG DATETIME
     dm_Main.AddHistory('ALG STOP: '+DateTimeToStr(Now),'GENERIC',CPos);
    {done disable tm_Timer}

    dm_main.dset_Positions.Insert;
    for i:= 0 to dm_main.dset_Positions.FieldCount - 1 do
    begin
      try
        str_Field:=dm_main.dset_Positions.FieldDefs[i].Name;
        if  str_Field<> 'NRPOS' then
            dm_main.dset_Positions.FieldValues[str_Field]:= dm_main.dset_Temp_Positions.FieldValues[str_Field];
      Except
        _ShowMessage('Eroare la camp: '+str_Field);
      end;
    end;
    dm_main.dset_Positions.Post;

    {check NRPOS}
     if dm_main.dset_Positions.FieldByName('NRPOS').IsNull then
     begin
        _ShowMessage('BAZA DE DATE CORUPTA: '+DAteTimeToStr(dm_Main.dt_LastDateTime));
        CPos.MARKET_TIME := 1; // ERROR DATE TIME
        dm_Main.AddHistory('DB CORRUP (NRPOS)','GENERIC',CPos);
     end;
    {done check NRPOS}


    {enable tm_Timer}
    CPos.MARKET_TIME := 2; // ALGORITM DATE TIME
    dm_Main.AddHistory('ALG REST: '+DateTimeToStr(Now),'GENERIC',CPos);
    bool_ForceStopTimer := False;
    {done enable tm_Timer}
  end
  else
    dm_main.dset_Temp_Positions.Cancel;

  tm_Timer.Interval := int_interval; { restore timer }

end;

procedure Tfrm_Main.btn_ActivateClick(Sender: TObject);
begin

    dm_Main.inMainTimer := True;
    tm_Timer.Enabled := False;

    if not dm_Main.dset_Positions.EOF then
    begin
      dm_Main.dset_Positions.Edit;
      dm_Main.dset_Positions.FieldByName('ACTIVE').AsBoolean := True;
      dm_Main.dset_Positions.Post;
    end;

    dm_Main.inMainTimer := False;
    tm_Timer.Enabled := True;


end;


procedure Tfrm_Main.btn_Modify_Click(Sender: TObject);
var
  i, int_interval: Integer;
  str_Field : String;
  CPos :TMarketPosition;
  b_Status: boolean;
begin

  { slow timer}
  int_interval := tm_Timer.Interval;
  tm_Timer.Interval := tm_Timer.Interval + ct_SLOW_TIMER;
  { done start slow timer }

  { disable tm_Timer }
  //while dm_Main.inMainTimer do
  //      Application.ProcessMessages;
  dm_Main.inMainTimer:= True;
  tm_Timer.Enabled := False;
  { done disable tm_Timer }

  dm_main.dset_Positions.Edit;
  b_Status := dm_main.dset_Positions.FieldValues['ACTIVE'];
  dm_main.dset_Positions.FieldValues['ACTIVE'] := False;    { dezactivate position }
  dm_main.dset_Positions.Post;

  dm_Main.inMainTimer:= False;
  tm_Timer.Enabled := True;                   { enable tm_Timer }


  try
    dm_Main.dset_Temp_Positions.First;
    while not dm_Main.dset_Temp_Positions.eof do
     begin
        dm_Main.dset_Temp_Positions.Delete;
     end;
  finally
  end;

  dm_Main.dset_Temp_Positions.Insert;

  for i:= 0 to dm_main.dset_Positions.FieldCount - 1 do
  begin
    try
      str_Field:=dm_main.dset_Positions.FieldDefs[i].Name;
      if  str_Field<> 'NRPOS' then
          dm_main.dset_Temp_Positions.FieldValues[str_Field]:= dm_main.dset_Positions.FieldValues[str_Field];
    finally
    end;
  end;

  dm_main.dset_Temp_Positions.FieldValues['ACTIVE'] := b_Status;

  if frm_Lansare.ShowModal=mrOK then
  begin
    dm_main.dset_Temp_Positions.Post;

    { disable timer}
    //while dm_Main.inMainTimer do
    //       Application.ProcessMessages;
    dm_Main.inMainTimer:= True;
    tm_Timer.Enabled := False;
    { done disable timer}

    dm_main.dset_Positions.Edit;
    for i:= 0 to dm_main.dset_Positions.FieldCount - 1 do
    begin
      try
        str_Field:=dm_main.dset_Positions.FieldDefs[i].Name;
        if  str_Field<> 'NRPOS' then
            dm_main.dset_Positions.FieldValues[str_Field]:= dm_main.dset_Temp_Positions.FieldValues[str_Field];
      finally
      end;
    end;
    dm_main.dset_Positions.Post;

    {enable tm_Timer}
    dm_Main.inMainTimer:= False;
    tm_Timer.Enabled := True;;
    {done enable tm_Timer}
  end
  else
  begin
    dm_main.dset_Temp_Positions.Cancel;
    dm_main.dset_Positions.Edit;
    dm_main.dset_Positions.FieldValues['ACTIVE'] := b_Status;
    dm_main.dset_Positions.Post;
  end;

  tm_timer.Interval := int_interval;    { restore timer }
end;

procedure Tfrm_Main.chk_DEBUGChange(Sender: TObject);
begin
   MARKET_DEBUG_MODE:= chk_DEBUG.Checked;
   if MARKET_DEBUG_MODE then
    btn_DEBUG.Enabled := True
   else
     btn_DEBUG.Enabled := False;
end;

procedure Tfrm_Main.chk_DEBUG_PAUSEChange(Sender: TObject);
begin
  if chk_DEBUG_PAUSE.Checked then
   PauseAllPositions
  else
   ResumeAllPositions;
end;

procedure Tfrm_Main.chk_MEDIEREChange(Sender: TObject);
begin
end;

procedure Tfrm_Main.ck_StartStopChange(Sender: TObject);
begin
  dm_Main.bStartStop:=ck_StartStop.Checked;
end;

procedure Tfrm_Main.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin

end;

procedure Tfrm_Main.dg_PositionsCellClick(Column: TColumn);
begin
  try

     GetSelectedPositionDetails;
  except
  end;
end;

procedure Tfrm_Main.btn_Close_Click(Sender: TObject);
begin

  dm_Main.inMainTimer := True;
  tm_Timer.Enabled := False;

  if not dm_Main.dset_Positions.EOF then
  begin
    dm_Main.dset_Positions.Edit;
    dm_Main.dset_Positions.FieldByName('ACTIVE').AsBoolean := False;
    dm_Main.dset_Positions.Post;
  end;

  dm_Main.inMainTimer := False;
  tm_Timer.Enabled := True;


end;

procedure Tfrm_Main.btn_DEBUGClick(Sender: TObject);
begin
  if frm_Debug.ShowModal=mrOK then
  begin
    SetupDEBUG;
  end;
end;

procedure Tfrm_Main.Bevel1ChangeBounds(Sender: TObject);
begin

end;

procedure Tfrm_Main.btn_Close_PositionClick(Sender: TObject);
var
   str_Pos:string;
   str_Symbol:string;
   str_Volume:string;
   str_Oper:string;
   str_Open:string;
   str_msg1,str_msg2:string;
   i_Reply:integer;
begin


  while dm_Main.inMainTimer do
      Application.ProcessMessages;

  dm_Main.inMainTimer := True;
  tm_Timer.Enabled := False;

  if not dm_Main.dset_Positions.EOF then
  begin
    str_Pos :=dm_Main.dset_Positions.FieldByName('NRPOS').AsString;
    str_Symbol :=dm_Main.dset_Positions.FieldByName('SYMBOL').AsString;
    str_Volume :=dm_Main.dset_Positions.FieldByName('VOLUME').AsString;
    str_Open :=dm_Main.dset_Positions.FieldByName('DIRECTION').AsString;
    if str_Open = TPositionDirection.STANDBY then
    begin
      _ShowMessage('Pozitia nu este deschisa !');
    end
    else
    begin
      if str_Open = TPositionDirection.LONG then
       str_Oper := 'SELL'
      else
       str_Oper := 'BUY';

      str_msg1 := 'Doriti inchiderea pozitiei '+stR_Pos+' unde avem '+str_symbol+' X '+str_Volume+' deschis '+str_Open+' ?'+#13#10+'Inchiderea se va face prin '+str_Oper+' '+str_Symbol+' X '+str_Volume;
      str_msg2 := 'INCHIDERE MANUALA DE POZITIE';
      i_Reply := Application.MessageBox(PChar(str_msg1),PChar(str_msg2) , MB_ICONQUESTION + MB_YESNO);
      if i_Reply = IDYES then
      begin
        dm_Main.dset_Positions.Edit;
        dm_Main.dset_Positions.FieldByName('CLOSE_NOW_AT_MARKET').AsBoolean := True;
        dm_Main.dset_Positions.Post;
        _ShowMessage('Pozitia '+stR_Pos+' unde avem '+str_symbol+' X '+str_Volume+' se va inchide la piata.');
      end;
    end;
  end;

  dm_Main.inMainTimer := False;
  tm_Timer.Enabled := True;
end;

procedure Tfrm_Main.btn_Delete_Click(Sender: TObject);
var int_idx:integer;
   str_pos:string;
begin
  dm_Main.inMainTimer := True;
  tm_Timer.Enabled := False;

  if not dm_Main.dset_Positions.EOF then
  begin
    if not dm_Main.dset_Positions.FieldByName('ACTIVE').AsBoolean then
     begin
        str_pos := dm_Main.dset_Positions.FieldByName('NRPOS').AsString;
        dm_Main.dset_Positions.Delete;
        try
           GetSelectedPositionDetails;
        except
        end;

        int_idx := dm_Main.dset_History.FieldByName('IDX').AsInteger;
        dm_Main.dset_History.Filter := 'NRPOS='+str_pos;
        dm_Main.dset_History.Filtered := True;

        dm_main.dset_History.First;
        while not dm_main.dset_History.eof do
         begin
           dm_main.dset_History.Edit;
           dm_main.dset_History.FieldByName('STATUS').AsString := 'ARHIVAT' ;
           dm_main.dset_History.Post;
           dm_main.dset_History.Next;
         end;

        dm_Main.dset_History.Filter := '';
        dm_Main.dset_History.Filtered := False;
        dm_Main.dset_History.Locate('IDX',int_idx,[]);

     end;
  end;

  tm_Timer.Enabled := True;
  dm_Main.inMainTimer := False;
end;

procedure Tfrm_Main.btn_History_Click(Sender: TObject);
var  int_idx: integer;
     IndexHistory : TIndexDef;
begin
  if dm_Main.dset_Positions.EOF then exit;

  dm_Main.CloneHistory;

  frm_History := Tfrm_History.Create(Application);
  frm_History.HistoryPos := dm_Main.GetCurrentPosition;
  frm_History.str_HistorySymbol := dm_Main.dset_Positions.FieldByName('SYMBOL').AsString;
  frm_History.PrepareChart;

  frm_History.ShowModal;

  frm_History.Free;
  frm_History := nil;

end;

procedure Tfrm_Main.btn_LaunchClick(Sender: TObject);
begin

end;

procedure Tfrm_Main.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin

  dm_Main.SaveData;
end;

procedure Tfrm_Main.FormCreate(Sender: TObject);
begin
  CoInitialize(nil);

  dm_Main.inMainTimer:= False;
  bool_ForceStopTimer := False;
  MARKET_DEBUG_MODE := chk_DEBUG.Checked;
  Application.CreateForm(Tfrm_Debug, frm_Debug);
  Application.CreateForm(Tfrm_about, frm_about);
  SetupDEBUG;

  dm_Main._DB_VER := '_v'+lbl_DBVer.Caption;
  dm_Main._APP_VER := lbl_Ver.Caption+lbl_DBVer.Caption;
  dm_Main.LoadData;

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

  LoadParams;


  frm_about.Label1.Caption := frm_about.Label1.Caption+ ' '+dm_Main._APP_VER;
  frm_About.ShowModal;

  LaunchAllPositions;

end;



procedure Tfrm_Main.tm_TimerTimer(Sender: TObject);
var
  tm_now: TTime;
begin
  if bool_ForceStopTimer then exit;

  if chk_DEBUG_PAUSE.Checked then exit;

  if ck_StartStop.Checked then
   begin
      tm_now := Time;
      dm_Main.bStartStop := True;
      dm_Main.tm_Market_start := StrToTime(ed_tm_Start.Text);
      dm_Main.tm_Market_stop := StrToTime(ed_tm_Stop.Text);
      if (tm_now>dm_Main.tm_Market_stop) or (tm_now<dm_Main.tm_Market_start) then
        exit;
   end;

  if not dm_Main.inMainTimer then
  begin
    tm_Timer.Enabled := False;
    dm_Main.inMainTimer:= True;
    T1_start  := Now;
    pnl_Status.Font.Color := clRed;
    pnl_Status.Caption := 'Running ...';

    { give time to core application }
    Application.ProcessMessages;
    { done time to core application }

    dm_Main.Set_MarketPlatform_str_Requests('');

    try
      RefreshPositions;
      GetSelectedPositionDetails;
      dm_Main.SaveData;
    except
      _ShowMessage('EXCEPTION RUN ALGORITM !');
    end;

    T1_stop  := Now;
    T1_ms :=MilliSecondsBetween(T1_start ,T1_stop);
//    T2_ms :=MilliSecondsBetween(T2_start ,T2_stop);
//    T3_ms :=MilliSecondsBetween(T3_start ,T3_stop);
    pnl_Status.Font.Color := clBlack;
    pnl_Status.Caption := 'Idle ... ('+IntToStr(T1_ms)+' ms)'+dm_Main.Get_MarketPlatform_str_Requests;
    pnl_Info.Caption := 'getrt='+IntToStr(T2_ms)+'  recalc='+IntToStr(T3_ms);
    { give time to core application }
    Application.ProcessMessages;
    { done time to core application }
    dm_Main.inMainTimer:= False;
    tm_Timer.Enabled := True;
  end;
end;

procedure Tfrm_Main.LoadParams;
var
  vFile : file of TMarketPosition ;
  str_savefile:string;
begin
  str_savefile := '';
  str_savefile := ExtractFileDir(Application.ExeName);
  str_savefile := str_savefile + '\_params'+lbl_DBVer.Caption+'.ldb';

  if FileExists (str_savefile) then
  begin
    try
      AssignFile(vFile, str_savefile);
      Reset(vFile);
      Read(vFile, TempParams);
    except
    end;
  end;
end;

procedure Tfrm_Main.SaveParams;
var
  vFile : file of TMarketPosition ;
  str_savefile:string;
begin
  str_savefile := '';
  str_savefile := ExtractFileDir(Application.ExeName);
  str_savefile := str_savefile + '\_params'+lbl_DBVer.Caption+'.ldb';

  AssignFile(vFile, str_savefile);
  Rewrite(vFile);
  Write(vFile, TempParams);
  CloseFile (vFile);
end;

procedure Tfrm_Main.GetSelectedPositionDetails;
var Cpos:TMarketPosition;
begin
  CPos := dm_Main.GetCurrentPosition;
  if CPos.SYMBOL <> '' then
  begin
    if CPos.OPENED then
    begin
      lbl_Volume.Caption:= FormatFloat('0', Cpos.VOLUME );
      if Cpos.DIRECTION = TPositionDirection.LONG then
      begin
           lbl_Pos.Caption := Cpos.SYMBOL + '  (DESCHIS LONG)' ;
           lbl_Current_PL.Caption:= FormatFloat('0', (Cpos.VOLUME*Cpos.LAST_MARKET_PRICE) - (Cpos.VOLUME*CPos.LAST_BUY_PRICE) );
           lbl_OpenPrice.Caption:= FormatFloat('0.00', Cpos.LAST_BUY_PRICE);
           lbl_StopLossPrice.Caption:= FormatFloat('0.00', Cpos.STOP_PRICE);
           lbl_TakeProfitPrice.Caption:= FormatFloat('0.00', Cpos.LAST_BUY_PRICE * (1 + (Cpos.TAKE_PERCENT / 100)) );
           lbl_ProtMaxPrice.Caption:= FormatFloat('0.00', Cpos.PROT_START_PRICE );
           lbl_ProtMinPrice.Caption:= FormatFloat('0.00 %', Cpos.PROT_CORECT);
           lbl_OverallProfitLoss.Caption:=FormatFloat('0', Cpos.TOTAL_PL);
      end
      else
      begin
           lbl_Pos.Caption := Cpos.SYMBOL + '  (DESCHIS SHORT)' ;
           lbl_Current_PL.Caption:= FormatFloat('0',  (Cpos.VOLUME*CPos.LAST_SELL_PRICE) - (Cpos.VOLUME*Cpos.LAST_MARKET_PRICE));
           lbl_OpenPrice.Caption:= FormatFloat('0.00', Cpos.LAST_SELL_PRICE);
           lbl_StopLossPrice.Caption:= FormatFloat('0.00', Cpos.STOP_PRICE);
           lbl_TakeProfitPrice.Caption:= FormatFloat('0.00', Cpos.LAST_SELL_PRICE * (1 + (Cpos.SHORT_TAKE_PERCENT / 100)) );
           lbl_ProtMaxPrice.Caption:= FormatFloat('0.00', Cpos.PROT_START_PRICE );
           lbl_ProtMinPrice.Caption:= FormatFloat('0.00 %', Cpos.SHORT_PROT_CORECT);
           lbl_OverallProfitLoss.Caption:=FormatFloat('0', Cpos.TOTAL_PL);
      end;
    end
    else
    begin
      lbl_Pos.Caption := Cpos.SYMBOL + '  (STANDBY LONG/SHORT)' ;
      lbl_Volume.Caption:= FormatFloat('0', Cpos.VOLUME );
      lbl_Current_PL.Caption:= FormatFloat('0', 0);
      lbl_OpenPrice.Caption:= FormatFloat('0.00', Cpos.START_PRICE_MIN * (1 + (Cpos.OPEN_PERCENT / 100 ))) +' / '+ FormatFloat('0.00', Cpos.START_PRICE_MAX * (1 + (Cpos.SHORT_OPEN_PERCENT / 100 )));;
      lbl_StopLossPrice.Caption:= '-';
      lbl_TakeProfitPrice.Caption:= '-';
      lbl_ProtMaxPrice.Caption:= '-';
      lbl_ProtMinPrice.Caption:= '-';
      lbl_OverallProfitLoss.Caption:=FormatFloat('0', Cpos.TOTAL_PL);
    end;
  end
  else
  begin
    lbl_Volume.Caption:= FormatFloat('0', 0);
    lbl_Current_PL.Caption:= FormatFloat('0', 0);
    lbl_OpenPrice.Caption:= FormatFloat('0.00', 0);
    lbl_StopLossPrice.Caption:= '-';
    lbl_TakeProfitPrice.Caption:= '-';
    lbl_ProtMaxPrice.Caption:= '-';
    lbl_ProtMinPrice.Caption:= '-';
    lbl_OverallProfitLoss.Caption:=FormatFloat('0', 0);
  end;

end;

procedure Tfrm_Main.SetupDEBUG;
var i,j:integer;
begin
  btn_DEBUG.Enabled := chk_DEBUG.Checked ;

  if frm_Debug.mem_Prices.Lines.Count<=0 then exit;

  SetLength(arr_prices,frm_Debug.mem_Prices.Lines.Count*2);
  j:=0;
  for i:=0 to frm_Debug.mem_Prices.Lines.Count-1 do
  begin
   arr_prices[j] := StrToFloat(frm_Debug.mem_Prices.Lines.Strings[i]);
   inc(j);
   arr_prices[j] := arr_prices[j-1];
   inc(j);
  end;
end;

procedure Tfrm_Main.RefreshPositions;
var
  NrPositions, NrAlgorithms, i,j  : integer;
  Alg:TAlgorithm;
  pAlg:^TAlgorithm;
  pCPos :  ^TMarketPosition;
  bFound:boolean;
begin
  PositionList := dm_Main.GetPositionsList;
  NrPositions:=PositionList.Count;
  if NrPositions>0 then
   begin
     for i:=0 to NrPositions-1 do
     begin
       pCPos := PositionList.Items[i];
       bFound:=False;
       NrAlgorithms := AlgorithmList.Count;
       for j:=0 to NrAlgorithms-1 do
       begin
         pAlg := AlgorithmList.Items[j];
         if pAlg^.CurrentPosition.NRPOS = pCPos^.NRPOS then
           bFound:=True;
       end;
       if not bFound then
        begin
          pAlg := AllocMem (Sizeof(TAlgorithm));
          Alg := TAlgorithm.Create(pCPos^);
          pAlg^ := Alg;
          AlgorithmList.Add(pAlg);
          pAlg^.Start;
        end;
     end;
   end;
end;

procedure Tfrm_Main.LaunchAllPositions;
var
  NrPositions, i  : integer;
  Alg:TAlgorithm;
  pAlg:^TAlgorithm;
  pCPos :  ^TMarketPosition;
begin
  PositionList := dm_Main.GetPositionsList;

  AlgorithmList := TList.Create;

  T2_ms := 0;
  T3_ms := 0;

  NrPositions:=PositionList.Count;

  if NrPositions>0 then
   begin
     for i:=0 to NrPositions-1 do
     begin
       pCPos := PositionList.Items[i];
       pAlg := AllocMem (Sizeof(TAlgorithm));
       Alg := TAlgorithm.Create(pCPos^);
       pAlg^ := Alg;
       AlgorithmList.Add(pAlg);
       pAlg^.Start;
       T2_ms := T2_ms + MilliSecondsBetween(pAlg^.T1_Start,pAlg^.T1_Stop) ;
       T3_ms := T3_ms + MilliSecondsBetween(pAlg^.T2_Start,pAlg^.T2_Stop) ;
     end;
   end;

end;

procedure Tfrm_Main.PauseAllPositions;
var i,cnt:integer;
  pAlg: ^TAlgorithm;
begin
  for i:=0 to AlgorithmList.Count-1 do
  begin
    pAlg := AlgorithmList.Items[i];
    pAlg^.PAUSED := TRUE;
  end;
end;

procedure Tfrm_Main.ResumeAllPositions;
var i,cnt:integer;
  pAlg: ^TAlgorithm;
begin
  for i:=0 to AlgorithmList.Count-1 do
  begin
    pAlg := AlgorithmList.Items[i];
    pAlg^.PAUSED := False;
  end;
end;

procedure Tfrm_Main.TermintateAllPositions;
var i,cnt:integer;
  pAlg: ^TAlgorithm;
begin
  for i:=0 to AlgorithmList.Count-1 do
  begin
    pAlg := AlgorithmList.Items[i];
    pAlg^.Terminate;
  end;
end;

procedure Tfrm_Main.FormPaint(Sender: TObject);
var Row, Ht: Word ;
begin
  Ht := (ClientHeight + 255) div 256 ;
  for Row := 0 to 255 do
   with Canvas do begin
     Brush.Color := RGBToColor(255-Round(Row*1), 255-Round(Row*1.1), 255-Round(Row*1.2)) ;
     FillRect(Rect(0, Row*Ht + 100, ClientWidth, (Row + 1) * Ht + 100)) ;
   end;
end;

procedure Tfrm_Main.GroupBox2Click(Sender: TObject);
begin

end;

procedure Tfrm_Main.GroupBox3Click(Sender: TObject);
begin

end;

procedure Tfrm_Main.gb_PozitieClick(Sender: TObject);
begin

end;

procedure Tfrm_Main.Image1Click(Sender: TObject);
begin

end;

end.

