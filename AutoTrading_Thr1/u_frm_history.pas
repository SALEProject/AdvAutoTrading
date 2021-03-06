unit u_frm_history;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TASources, TAGraph, TAIntervalSources,
  TADbSource, TASeries, Forms, Controls, Graphics, Dialogs, DBGrids, ExtCtrls,
  Buttons, StdCtrls, BarChart, u_dm_main, TAChartUtils, TAChartAxisUtils,
  PrintersDlgs, BufDataset, OSPrinters,  Printers, taprint, process, LCLIntf;

type

  { Tfrm_History }

  Tfrm_History = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    CheckBox1: TCheckBox;
    cb_GraphType: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    PriceChart: TChart;
    dg_history: TDBGrid;
    dg_Prices: TDBGrid;
    mem_Export: TMemo;
    ChartSeries: TLineSeries;
    SMA_AvgSeries: TLineSeries;
    EMA_AvgSeries: TLineSeries;
    PrintDialog1: TPrintDialog;
    StaticText1: TStaticText;
    Timer1: TTimer;
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure chkMarksChange(Sender: TObject);
    procedure cb_GraphTypeChange(Sender: TObject);
    procedure dg_historyTitleClick(Column: TColumn);
    procedure FormCreate(Sender: TObject);
    procedure PriceChartAfterDrawBackground(ASender: TChart; ACanvas: TCanvas;
      const ARect: TRect);
    procedure PriceChartAxisList1MarkToText(var AText: String; AMark: Double);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
  public
    int_ColIndex:integer;
    int_DateTimeColumn:integer;
    sl_Dates: TStringList;
    str_HistorySymbol : string;
    HistoryPos : TMarketPosition;


    procedure SwitchSort(int_newColumn:integer);
    procedure PrepareChart;
    { public declarations }
  end;

var
  frm_History: Tfrm_History;

implementation

{$R *.lfm}

{ Tfrm_History }

procedure Tfrm_History.FormCreate(Sender: TObject);
var i:integer;
begin
 int_ColIndex := -1;
 for i:=0 to dg_history.Columns.Count-1 do
     if dg_history.Columns.Items[i].FieldName = 'DATETIME' then
         int_DateTimeColumn := i;

 sl_Dates := nil;
end;

procedure Tfrm_History.PriceChartAfterDrawBackground(ASender: TChart;
  ACanvas: TCanvas; const ARect: TRect);
begin

end;

procedure Tfrm_History.PriceChartAxisList1MarkToText(var AText: String;
  AMark: Double);
var i:integer;
begin
 i := Trunc(AMark);
 if i<0 then i:=0;
 if i>=sl_Dates.Count then i:=sl_Dates.Count-1;
 AText := sl_Dates.Strings[i];
end;

procedure Tfrm_History.Timer1Timer(Sender: TObject);
begin
    if dm_Main.inMainTimer then exit; // exit if in main timer

    dg_history.DataSource.DataSet.DisableControls;
    dg_Prices.DataSource.DataSet.DisableControls ;
    dm_Main.CloneHistory;
    PrepareChart;
    dg_history.DataSource.DataSet.EnableControls;
    dg_Prices.DataSource.DataSet.EnableControls ;
end;

procedure Tfrm_History.SwitchSort(int_newColumn: integer);
begin
  if int_ColIndex <>-1 then
     dg_history.Columns.Items[int_ColIndex].Title.Color := clBtnFace;

  int_ColIndex := int_newColumn ;
  dg_history.Columns.Items[int_ColIndex].Title.Color := clGreen;



end;

procedure Tfrm_History.PrepareChart;
var
  i:integer;
  TempSeries : TLineSeries;
  str_Label,str_Action:string;
  f_Value, f_sma_avg,f_ema_avg, f_DateTime:double;
begin

  if sl_Dates <> nil then
    sl_Dates.Free ;

  sl_Dates := TStringList.Create;


  ChartSeries.Clear;
  SMA_AvgSeries.Clear;
  EMA_AvgSeries.Clear;

  i:=0;

  dm_Main.ds_ClonedPrices.Dataset.DisableControls;
  dm_Main.ds_ClonedPrices.Dataset.First;
  while not dm_Main.ds_ClonedPrices.Dataset.EOF do
  begin
    f_DateTime := dm_Main.ds_ClonedPrices.Dataset.FieldByName('MARKET_TIME').AsFloat;
    str_Action := dm_Main.ds_ClonedPrices.Dataset.FieldByName('ACTION').AsString;
    f_Value    := dm_Main.ds_ClonedPrices.Dataset.FieldByName('VALUE').AsFloat;
    f_sma_Avg  := dm_Main.ds_ClonedPrices.Dataset.FieldByName('SMA_PRICE').AsFloat;
    f_ema_Avg  := dm_Main.ds_ClonedPrices.Dataset.FieldByName('EMA_PRICE').AsFloat;

    str_Label :=  DateTimeToStr(f_DateTime);
    sl_Dates.Add(str_Label);
    if (str_Action<>'') then
       str_Action := str_Action +'@'+FormatFloat('0.00',f_Value)+' ('+TimeToStr(f_DateTime)+')';

    if cb_GraphType.ItemIndex = 1 then
       str_Action := '*'
    else
      if cb_GraphType.ItemIndex = 2 then
        str_Action := '';

    ChartSeries.AddXY(i,f_Value,str_Action,clBlack);
    SMA_AvgSeries.AddXY(i,f_sma_Avg,str_Action,clRed);
    EMA_AvgSeries.AddXY(i,f_ema_Avg,str_Action,clGreen);
    inc(i);

    dm_Main.ds_ClonedPrices.Dataset.Next;
  end;

  dm_Main.ds_ClonedPrices.Dataset.EnableControls;

end;

procedure Tfrm_History.BitBtn2Click(Sender: TObject);
var i:integer;
  str_savefile:string;
begin
 with dg_history.DataSource do
 begin
   Dataset.First;
   mem_Export.Lines.Clear;
   Mem_Export.lines.Add('<font face="Courier New">');
   Mem_Export.Lines.Add('AUTOTRADER ver'+dm_Main._APP_VER+' Date/ora: '+DAteTimeToStr(Now)+'<BR>');
    Mem_Export.Lines.Add('LONG    OPEN:'+FormatFloat('0.00',HistoryPos.OPEN_PERCENT)+'%'+'<BR>');
    Mem_Export.Lines.Add('SHORT   OPEN:'+FormatFloat('0.00',HistoryPos.SHORT_OPEN_PERCENT)+'%'+'<BR>');
    Mem_Export.Lines.Add('LONG  REOPEN:'+FormatFloat('0.00',HistoryPos.RE_OPEN_PERCENT)+'%'+'<BR>');
    Mem_Export.Lines.Add('SHORT REOPEN:'+FormatFloat('0.00',HistoryPos.SHORT_RE_OPEN_PERCENT)+'%'+'<BR>');
    Mem_Export.Lines.Add('LONG  TAKE:'+FormatFloat('0.00',HistoryPos.TAKE_PERCENT)+'%'+'<BR>');
    Mem_Export.Lines.Add('SHORT TAKE:'+FormatFloat('0.00',HistoryPos.SHORT_TAKE_PERCENT)+'%'+'<BR>');
    Mem_Export.Lines.Add('LONG PROT PROF:'+FormatFloat('0.00',HistoryPos.PROT_MARGIN )+'%'+'<BR>');
    Mem_Export.Lines.Add('LONG PROT CLOS:'+FormatFloat('0.00',HistoryPos.PROT_CORECT  )+'%'+'<BR>');
    Mem_Export.Lines.Add('SHORT PROT PROF:'+FormatFloat('0.00',HistoryPos.SHORT_PROT_MARGIN)+'%'+'<BR>');
    Mem_Export.Lines.Add('SHORT PROT CLOS:'+FormatFloat('0.00',HistoryPos.SHORT_PROT_CORECT  )+'%'+'<BR>');
     Mem_Export.Lines.Add('<table>');
   Mem_Export.Lines.Add('<tr>');
   for i:=0 to DataSet.FieldCount-1 do
    begin
      Mem_Export.Lines.Add('<td>');
      Mem_Export.Lines.Add(DataSet.FieldDefs[i].Name);
      Mem_Export.Lines.Add('</td>');
    end;
   Mem_Export.Lines.Add('</tr>');
   while not DataSet.EOF do
   begin
     Mem_Export.Lines.Add('<tr>');
     for i:=0 to DataSet.FieldCount-1 do
      Mem_Export.Lines.Add('<td>'+DataSet.Fields[i].AsString+'</td>');
     Mem_Export.Lines.Add('</tr>');
     Dataset.Next;
   end;
   Mem_Export.Lines.Add('<table>');

   str_savefile := '';
   str_savefile := ExtractFileDir(Application.ExeName);
   str_savefile := str_savefile + '\HISTORY_EXPORT_'+str_HistorySymbol+'.HTM';

   mem_Export.Lines.SaveToFile(str_savefile);
   ShowMessage('Export realizat in '+str_savefile);
   DataSet.First;
 end;
end;

procedure Tfrm_History.BitBtn3Click(Sender: TObject);
var i:integer;
  str_savefile:string;
begin
 with dg_Prices.DataSource do
 begin
   Dataset.First;
   mem_Export.Lines.Clear;
   Mem_Export.lines.Add('<font face="Courier New">');
   Mem_Export.Lines.Add('AUTOTRADER ver'+dm_Main._APP_VER+' Date/ora: '+DAteTimeToStr(Now)+'<BR>');
   Mem_Export.Lines.Add('LONG    OPEN:'+FormatFloat('0.00',HistoryPos.OPEN_PERCENT)+'%'+'<BR>');
   Mem_Export.Lines.Add('SHORT   OPEN:'+FormatFloat('0.00',HistoryPos.SHORT_OPEN_PERCENT)+'%'+'<BR>');
   Mem_Export.Lines.Add('LONG  REOPEN:'+FormatFloat('0.00',HistoryPos.RE_OPEN_PERCENT)+'%'+'<BR>');
   Mem_Export.Lines.Add('SHORT REOPEN:'+FormatFloat('0.00',HistoryPos.SHORT_RE_OPEN_PERCENT)+'%'+'<BR>');
   Mem_Export.Lines.Add('LONG  TAKE:'+FormatFloat('0.00',HistoryPos.TAKE_PERCENT)+'%'+'<BR>');
   Mem_Export.Lines.Add('SHORT TAKE:'+FormatFloat('0.00',HistoryPos.SHORT_TAKE_PERCENT)+'%'+'<BR>');
   Mem_Export.Lines.Add('LONG PROTPROF:'+FormatFloat('0.00',HistoryPos.PROT_MARGIN )+'%'+'<BR>');
   Mem_Export.Lines.Add('LONG CLS PROT:'+FormatFloat('0.00',HistoryPos.PROT_CORECT  )+'%'+'<BR>');
   Mem_Export.Lines.Add('SHORT PROTPROF:'+FormatFloat('0.00',HistoryPos.SHORT_PROT_MARGIN)+'%'+'<BR>');
   Mem_Export.Lines.Add('SHORT CLS PROT:'+FormatFloat('0.00',HistoryPos.SHORT_PROT_CORECT  )+'%'+'<BR>');
   Mem_Export.Lines.Add('<table>');
   Mem_Export.Lines.Add('<tr>');
   for i:=0 to DataSet.FieldCount-1 do
    begin
      Mem_Export.Lines.Add('<td>');
      Mem_Export.Lines.Add(DataSet.FieldDefs[i].Name);
      Mem_Export.Lines.Add('</td>');
    end;
   Mem_Export.Lines.Add('</tr>');
   while not DataSet.EOF do
   begin
     Mem_Export.Lines.Add('<tr>');
     for i:=0 to DataSet.FieldCount-1 do
      Mem_Export.Lines.Add('<td>'+DataSet.Fields[i].AsString+'</td>');
     Mem_Export.Lines.Add('</tr>');
     Dataset.Next;
   end;
   Mem_Export.Lines.Add('<table>');

   str_savefile := '';
   str_savefile := ExtractFileDir(Application.ExeName);
   str_savefile := str_savefile + '\PRICES_EXPORT_'+str_HistorySymbol+'.HTM';

   mem_Export.Lines.SaveToFile(str_savefile);
   ShowMessage('Export realizat in '+str_savefile);
   OpenDocument(str_savefile);
   DataSet.First;
 end;
end;

procedure Tfrm_History.BitBtn4Click(Sender: TObject);
const
  MARGIN = 10;
  TACHART_PRINT_CANVAS = false;
var
  r: TRect;
  d: Integer;

begin
  if not PrintDialog1.Execute then exit;
  Printer.Orientation := poLandscape;
  Printer.BeginDoc;
  try
    r := Rect(0, 0, Printer.PageWidth, Printer.PageHeight );
    d := r.Right - r.Left;
    r.Left += d div MARGIN;
    r.Right -= d div MARGIN;
    d := r.Bottom - r.Top;
    r.Top += d div MARGIN;
    r.Bottom -= d div MARGIN;
    if TACHART_PRINT_CANVAS then
      PriceChart.PaintOnCanvas(Printer.Canvas, r)
    else
      PriceChart.Draw(TPrinterDrawer.Create(Printer), r);
  finally
    Printer.EndDoc;
  end;

end;

procedure Tfrm_History.BitBtn5Click(Sender: TObject);
var
  str_savefile: string;
begin
 str_savefile := '';
 str_savefile := ExtractFileDir(Application.ExeName);
 str_savefile := str_savefile + '\GRAFIC_'+str_HistorySymbol+'.BMP';
 PriceChart.SaveToBitmapFile (str_savefile);
 ShowMessage('Export GRAFIC realizat in '+str_savefile);
end;

procedure Tfrm_History.CheckBox1Change(Sender: TObject);
begin
  Timer1.Enabled := CheckBox1.Checked;
end;

procedure Tfrm_History.chkMarksChange(Sender: TObject);
begin
end;

procedure Tfrm_History.cb_GraphTypeChange(Sender: TObject);
begin
 PrepareChart ;
end;

procedure Tfrm_History.dg_historyTitleClick(Column: TColumn);
begin
 SwitchSort(Column.Index);
 dm_Main._SortBufDataSet(TBufDataset(dm_Main.ds_ClonedHistory.DataSet),dg_history.Columns.Items[int_ColIndex].FieldName);
end;


end.

