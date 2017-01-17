unit Dashboard;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, RTTICtrls, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Grids, DBGrids, ExtCtrls, DbCtrls, Buttons, ComCtrls, maskedit, DOM,
  BufDataset, u_dm_main, position, u_algorithm, u_finance_request,
  u_frm_history, u_frm_Debug, DateUtils, db,u_frm_about, LCLType;

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
    btn_Deactivate: TBitBtn;
    btn_History: TBitBtn;
    btn_Activate: TBitBtn;
    Button1: TButton;
    chk_DEBUG_PAUSE: TCheckBox;
    ck_StartStop: TCheckBox;
    DBGrid1: TDBGrid;
    dg_Positions: TDBGrid;
    gb_Testing: TGroupBox;
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
    pnl_Task1: TPanel;
    pnl_Task10: TPanel;
    pnl_Task11: TPanel;
    pnl_Task12: TPanel;
    pnl_Task13: TPanel;
    pnl_Task14: TPanel;
    pnl_Task15: TPanel;
    pnl_Provider: TPanel;
    pnl_Task2: TPanel;
    pnl_Task4: TPanel;
    pnl_Task3: TPanel;
    pnl_Task5: TPanel;
    pnl_Task6: TPanel;
    pnl_Task7: TPanel;
    pnl_Task8: TPanel;
    pnl_Task9: TPanel;
    pnl_ThreadStatus: TPanel;
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
    procedure Button1Click(Sender: TObject);
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
    procedure pnl_Task3Click(Sender: TObject);
    procedure tm_TimerTimer(Sender: TObject);

  private
    bool_ForceStopTimer : Boolean;
    T1_ms, T2_ms, T3_ms: integer;
    T1_start,T1_stop: TDateTime;
    T2_start,T2_stop: TDateTime;
    T3_start,T3_stop: TDateTime;

    TaskPanelArray:array[1..15] of TPanel;
    PositionList : TList;
    AlgorithmList: TList;


    procedure GetSelectedPositionDetails;
    procedure SetupDEBUG;

    procedure RefreshPositions;

    procedure LaunchAllPositions;
    procedure PauseAllPositions;
    procedure ResumeAllPositions;
    procedure TermintateAllAlgorithms;

    Function ClosePositionAtMarket:boolean;

    procedure RefreshParams(pAlg:TPAlgorithm;CPos:TMarketPosition);

    function GetAlgorithmByID(AlgID:integer):TPAlgorithm;


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
  str_savefile, str_TempDate:string;
  dt_Temp : TDateTime;
begin
  if AlgorithmList.Count >=15 then
   begin
     _ShowMessage('Se pot lansa maxim 15 pozitii !');
     Exit;
   end;
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
        FieldValues['RESET_AVERAGE'] := True;

        // configured parameters
        dm_main.SetTempParams;
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

        FieldValues['BOUNCE'] := False;
        FieldValues['BOUNCING'] := 0;

        FieldValues['MIN_BOUNCE'] := 0;
        FieldValues['MAX_BOUNCE'] := 0;
        FieldValues['PRF_PRC_ERL'] := 0.35;
        FieldValues['COR_PRC_ERL'] := 0.5;



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

    dm_Main.SaveTempParams;

    dm_main.dset_Temp_Positions.Post;
    dt_Temp := Now;
    str_TempDate := DateTimeToStr(dt_Temp);

    str_Market := dm_Main.dset_Temp_Positions.FieldValues['MARKET'];
    if str_Market = '' then
     _ShowMessage(' MARKET ERROR ! ');

    {disable tm_Timer}
     bool_ForceStopTimer := True;
     CPos.PosData.NRPOS :=-1;
     CPos.PosData.MARKET_TIME := 2; // ALGORITM DEBUG DATETIME
     dm_Main.AddHistory('ALG STOP: '+str_TempDate,'GENERIC',CPos);
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
        CPos.PosData.MARKET_TIME := 1; // ERROR DATE TIME
        dm_Main.AddHistory('DB CORRUP (NRPOS)','GENERIC',CPos);
     end;
    {done check NRPOS}


    {enable tm_Timer}
    CPos.PosData.MARKET_TIME := 2; // ALGORITM DATE TIME
    dm_Main.AddHistory('ALG REST: '+str_TempDate,'GENERIC',CPos);
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
      dm_Main.dset_Positions.FieldByName('ACTIVE').AsBoolean := True; // redundant ???
      dm_Main.dset_Positions.Post;

    end;

    dm_Main.inMainTimer := False;
    tm_Timer.Enabled := True;


end;


procedure Tfrm_Main.btn_Modify_Click(Sender: TObject);
var
  i, int_interval, iPos: Integer;
  str_Field : String;
  CPos :TMarketPosition;
  b_Status: boolean;
  pAlg:TPAlgorithm;
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

  //pause the algorithm !
  iPos := dm_main.dset_Positions.FieldByName('NRPOS').AsInteger;
  pAlg := GetAlgorithmByID(iPos);
  pAlg^.PAUSED := True;

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
  pAlg^.PAUSED := False;
end;

procedure Tfrm_Main.Button1Click(Sender: TObject);
begin
  if MARKET_DEBUG_MODE then
  begin
     dm_Main.Reset_BackTestData;
  end;
end;

procedure Tfrm_Main.chk_DEBUGChange(Sender: TObject);
begin
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

  tm_Timer.Enabled := False;

  if not dm_Main.dset_Positions.EOF then
  begin
    str_Pos :=dm_Main.dset_Positions.FieldByName('NRPOS').AsString;
    str_Symbol :=dm_Main.dset_Positions.FieldByName('SYMBOL').AsString;
    str_Volume :=dm_Main.dset_Positions.FieldByName('VOLUME').AsString;
    str_Open :=dm_Main.dset_Positions.FieldByName('DIRECTION').AsString;
    if str_Open <> TPositionDirection.STANDBY then
    begin
      str_msg1 := 'Pozitia este deschisa, doriti inchiderea ei ?';
      str_msg2 := 'INCHIDERE/DEZACTIVARE POZITIE';
      i_Reply := Application.MessageBox(PChar(str_msg1),PChar(str_msg2) , MB_ICONQUESTION + MB_YESNO);
      if i_Reply = IDYES then
      begin
       if ClosePositionAtMarket then
       begin

       end;
      end;
    end;
    dm_Main.dset_Positions.Edit;
    dm_Main.dset_Positions.FieldByName('ACTIVE').AsBoolean := False;
    dm_Main.dset_Positions.Post;
  end;

  tm_Timer.Enabled := True;

end;

procedure Tfrm_Main.btn_DEBUGClick(Sender: TObject);
begin
  if frm_Debug.ShowModal=mrOK then
  begin
    if MARKET_DEBUG_MODE then
    begin
      PauseAllPositions;
      SetupDEBUG;
      ResumeAllPositions;
    end;
  end;
end;

procedure Tfrm_Main.Bevel1ChangeBounds(Sender: TObject);
begin

end;

procedure Tfrm_Main.btn_Close_PositionClick(Sender: TObject);
begin
  ClosePositionAtMarket;
end;

procedure Tfrm_Main.btn_Delete_Click(Sender: TObject);
var int_idx, i, alg_idx, i_pos:integer;
   TempPAlgorithm :TPAlgorithm;
   str_pos:string;
begin
  dm_Main.inMainTimer := True;
  tm_Timer.Enabled := False;

  if not dm_Main.dset_Positions.EOF then
  begin
    if not dm_Main.dset_Positions.FieldByName('ACTIVE').AsBoolean then
     begin
        i_pos :=  dm_Main.dset_Positions.FieldByName('NRPOS').AsInteger;
        str_pos := dm_Main.dset_Positions.FieldByName('NRPOS').AsString;
        dm_Main.dset_Positions.Delete;
        try
           GetSelectedPositionDetails;
        except
        end;

        alg_idx:=-1;
        for i:=0 to AlgorithmList.Count -1 do
        begin
         TempPAlgorithm := TPAlgorithm(AlgorithmList.Items[i]);
         if TempPAlgorithm^.CurrentPosition.PosData.NRPOS =i_pos then
           alg_idx := i;
        end;

        if alg_idx<>-1 then
         begin
          TempPAlgorithm := TPAlgorithm(AlgorithmList.Items[alg_idx]);
          TempPAlgorithm^.Terminate;
          While not TPAlgorithm(AlgorithmList.Items[alg_idx])^.DONE do;
          AlgorithmList.Remove(TempPAlgorithm);
          TempPAlgorithm^.Free;
          Freemem(TempPAlgorithm);
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
  TermintateAllAlgorithms;
  dm_Main.SaveData;
end;

procedure Tfrm_Main.FormCreate(Sender: TObject);
var i, i_frm:integer;
begin
  TaskPanelArray[1]:=pnl_Task1;
  TaskPanelArray[2]:=pnl_Task2;
  TaskPanelArray[3]:=pnl_Task3;
  TaskPanelArray[4]:=pnl_Task4;
  TaskPanelArray[5]:=pnl_Task5;
  TaskPanelArray[6]:=pnl_Task6;
  TaskPanelArray[7]:=pnl_Task7;
  TaskPanelArray[8]:=pnl_Task8;
  TaskPanelArray[9]:=pnl_Task9;
  TaskPanelArray[10]:=pnl_Task10;
  TaskPanelArray[11]:=pnl_Task11;
  TaskPanelArray[12]:=pnl_Task12;
  TaskPanelArray[13]:=pnl_Task13;
  TaskPanelArray[14]:=pnl_Task14;
  TaskPanelArray[15]:=pnl_Task15;

  for i:=1 to 15 do
  begin
   TaskPanelArray[i].Caption :='';;
   TaskPanelArray[i].Color := pnl_ThreadStatus.Color;
  end;

  dm_Main.inMainTimer:= False;
  bool_ForceStopTimer := False;

  Application.CreateForm(Tfrm_Debug, frm_Debug);
  Application.CreateForm(Tfrm_about, frm_about);
  SetupDEBUG;

  dm_Main._DB_VER := '_v'+lbl_DBVer.Caption;
  dm_Main._APP_VER := lbl_Ver.Caption+lbl_DBVer.Caption;


  dm_Main.LoadData;



  frm_about.Label1.Caption := frm_about.Label1.Caption+ ' '+dm_Main._APP_VER;
  i_frm := frm_About.ShowModal;

  IB_TEST_ONLY:=false;
  USE_GOOGLE := False;
  MARKET_DEBUG_MODE:= False;

  if i_frm=mrok  then // mrOK for IB
  begin
    pnl_Provider.Caption :='IB LIVE';
    pnl_Provider.Font.Color := clRed ;
  end
  else
  if i_frm=mrRetry  then // mrRetry for IB TEST
  begin
    IB_TEST_ONLY:=True;
    pnl_Provider.Caption :='IB TEST';
    pnl_Provider.Font.Color := clRed ;
  end
  else
  if i_frm=mrIgnore then // mrIgnore for GOOGLE
  begin
    USE_GOOGLE := True;
    pnl_Provider.Caption :='GOOG';
    pnl_Provider.Font.Color := clGreen ;
  end
  else
  if i_frm=mrYes then // mrYes for Back-Testing
  begin
    MARKET_DEBUG_MODE:= TRUE;
    pnl_Provider.Caption :='BCKTST';
    pnl_Provider.Font.Color := clGreen ;
    gb_Testing.Visible := True;
  end;


  dm_Main.bStartStop:=ck_StartStop.Checked;
  LaunchAllPositions;
  tm_Timer.Enabled:= true;

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
    pnl_ThreadStatus.Font.Color := clRed;
    pnl_ThreadStatus.Caption := 'Running ...';

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
    { give time to core application }
    Application.ProcessMessages;
    { done time to core application }
    dm_Main.inMainTimer:= False;
    tm_Timer.Enabled := True;
  end;
end;


procedure Tfrm_Main.GetSelectedPositionDetails;
var Cpos:TMarketPosition;
begin
  CPos := dm_Main.GetCurrentPosition;
  if CPos.PosData.SYMBOL <> '' then
  begin
    if CPos.PosData.OPENED then
    begin
      lbl_Volume.Caption:= FormatFloat('0', Cpos.PosData.VOLUME );
      if Cpos.PosData.DIRECTION = TPositionDirection.LONG then
      begin
           lbl_Pos.Caption := CPos.PosData.SYMBOL + '  (DESCHIS LONG)' ;
           lbl_Current_PL.Caption:= FormatFloat('0', (Cpos.PosData.VOLUME*Cpos.PosData.LAST_MARKET_PRICE) - (Cpos.PosData.VOLUME*CPos.PosData.LAST_BUY_PRICE) );
           lbl_OpenPrice.Caption:= FormatFloat('0.00', Cpos.PosData.LAST_BUY_PRICE);
           lbl_StopLossPrice.Caption:= FormatFloat('0.00', Cpos.PosData.STOP_PRICE);
           lbl_TakeProfitPrice.Caption:= FormatFloat('0.00', Cpos.PosData.LAST_BUY_PRICE * (1 + (Cpos.PosParams.TAKE_PERCENT / 100)) );
           lbl_ProtMaxPrice.Caption:= FormatFloat('0.00', Cpos.PosData.PROT_START_PRICE );
           lbl_ProtMinPrice.Caption:= FormatFloat('0.00 %', Cpos.PosParams.PROT_CORECT);
           lbl_OverallProfitLoss.Caption:=FormatFloat('0', Cpos.PosData.TOTAL_PL);
      end
      else
      begin
           lbl_Pos.Caption := CPos.PosData.SYMBOL + '  (DESCHIS SHORT)' ;
           lbl_Current_PL.Caption:= FormatFloat('0',  (Cpos.PosData.VOLUME*CPos.PosData.LAST_SELL_PRICE) - (Cpos.PosData.VOLUME*Cpos.PosData.LAST_MARKET_PRICE));
           lbl_OpenPrice.Caption:= FormatFloat('0.00', Cpos.PosData.LAST_SELL_PRICE);
           lbl_StopLossPrice.Caption:= FormatFloat('0.00', Cpos.PosData.STOP_PRICE);
           lbl_TakeProfitPrice.Caption:= FormatFloat('0.00', Cpos.PosData.LAST_SELL_PRICE * (1 + (Cpos.PosParams.SHORT_TAKE_PERCENT / 100)) );
           lbl_ProtMaxPrice.Caption:= FormatFloat('0.00', Cpos.PosData.PROT_START_PRICE );
           lbl_ProtMinPrice.Caption:= FormatFloat('0.00 %', Cpos.PosParams.SHORT_PROT_CORECT);
           lbl_OverallProfitLoss.Caption:=FormatFloat('0', Cpos.PosData.TOTAL_PL);
      end;
    end
    else
    begin
      lbl_Pos.Caption := CPos.PosData.SYMBOL + '  (STANDBY LONG/SHORT)' ;
      lbl_Volume.Caption:= FormatFloat('0', Cpos.PosData.VOLUME );
      lbl_Current_PL.Caption:= FormatFloat('0', 0);
      lbl_OpenPrice.Caption:= FormatFloat('0.00', Cpos.PosData.START_PRICE_MIN * (1 + (Cpos.PosParams.OPEN_PERCENT / 100 ))) +' / '+ FormatFloat('0.00', Cpos.PosData.START_PRICE_MAX * (1 + (Cpos.PosParams.SHORT_OPEN_PERCENT / 100 )));;
      lbl_StopLossPrice.Caption:= '-';
      lbl_TakeProfitPrice.Caption:= '-';
      lbl_ProtMaxPrice.Caption:= '-';
      lbl_ProtMinPrice.Caption:= '-';
      lbl_OverallProfitLoss.Caption:=FormatFloat('0', Cpos.PosData.TOTAL_PL);
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

  if frm_Debug.mem_Prices.Lines.Count<=0 then exit;

  SetLength(arr_prices,frm_Debug.mem_Prices.Lines.Count);
  j:=0;
  for i:=0 to frm_Debug.mem_Prices.Lines.Count-1 do
  begin
   arr_prices[j] := StrToFloat(frm_Debug.mem_Prices.Lines.Strings[i]);
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
         if pAlg^.CurrentPosition.PosData.NRPOS = pCPos^.PosData.NRPOS then
          begin
           bFound:=True; // mark as found so you dont launch again
           // now lets update the task with params/percentages from DB
           RefreshParams(pAlg, pCPos^);
           // save prepared current working data
           dm_Main.ModifyPosition(pAlg^.OutputPositionData);
          end;
       end;
       if not bFound then
        begin
          pAlg := AllocMem (Sizeof(TAlgorithm));
          Alg := TAlgorithm.Create(pCPos^);
          if NrPositions<15 then
             Alg.pnl_TaskInfo := TaskPanelArray[NrPositions]
          else
             Alg.pnl_TaskInfo := nil;
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
       if i<15 then
          Alg.pnl_TaskInfo := TaskPanelArray[i+1]
       else
          Alg.pnl_TaskInfo := nil;
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

procedure Tfrm_Main.TermintateAllAlgorithms;
var i,cnt:integer;
  pAlg: ^TAlgorithm;
begin
  for i:=0 to AlgorithmList.Count-1 do
  begin
    pAlg := AlgorithmList.Items[i];
    pAlg^.Terminate;
  end;
end;

function Tfrm_Main.ClosePositionAtMarket:boolean;
var
   str_Pos:string;
   str_Symbol:string;
   str_Volume:string;
   str_Oper:string;
   str_Open:string;
   str_msg1,str_msg2:string;
   i_Reply:integer;
   flag: boolean;
begin
  if tm_Timer.Enabled then
   flag:= true
  else
   flag:= false;

  Result := False;

  while dm_Main.inMainTimer do
      Application.ProcessMessages;

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
        Result := True;
      end;
    end;
  end;

  if flag then
   tm_Timer.Enabled := True;

end;

procedure Tfrm_Main.RefreshParams(pAlg: TPAlgorithm; CPos: TMarketPosition);
var TempPos: TMarketPosition;
begin
  TempPos := CPos;

  pAlg^.InputPositionData := TempPos; // tell to get params from here

  // now lets prepare output data to be save with previous DB params
  pAlg^.OutputPositionData.PosParams := TempPos.PosParams;
  if not pAlg^.OutputPositionData.PosData.OPENED then
     pAlg^.OutputPositionData.PosParams.CLOSE_NOW_AT_MARKET := False;

  if pAlg^.OutputPositionData.PosData.OPENED then
      pAlg^.OutputPositionData.PosParams.FORCE_BUY := False;

end;

function Tfrm_Main.GetAlgorithmByID(AlgID: integer): TPAlgorithm;
var
  i, NrAlgorithms: integer;
  pAlg, pFoundAlg:^TAlgorithm;
begin
  pFoundAlg := nil;
  NrAlgorithms := AlgorithmList.Count;
  for i:=0 to NrAlgorithms-1 do
  begin
    pAlg := AlgorithmList.Items[i];
    if pAlg^.CurrentPosition.PosData.NRPOS = AlgID then
     begin
       pFoundAlg := pAlg;
     end;
  end;
  Result := pFoundAlg;
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

procedure Tfrm_Main.pnl_Task3Click(Sender: TObject);
begin

end;

end.

