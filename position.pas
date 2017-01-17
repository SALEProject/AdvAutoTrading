unit Position;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  DbCtrls, ExtCtrls, Buttons, u_algorithm, u_dm_main, db, u_finance_request ;

type

  { Tfrm_Lansare }

  Tfrm_Lansare = class(TForm)
    Bevel1: TBevel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    DBCheckBox1: TDBCheckBox;
    DBCheckBox2: TDBCheckBox;
    DBCheckBox3: TDBCheckBox;
    DBCheckBox4: TDBCheckBox;
    DBCheckBox5: TDBCheckBox;
    dbck_ForceBuy: TDBCheckBox;
    dbck_ForceBuy1: TDBCheckBox;
    dbck_ForceBuy2: TDBCheckBox;
    dbck_ForceBuy3: TDBCheckBox;
    dbck_ForceBuy4: TDBCheckBox;
    dbck_ForceBuy5: TDBCheckBox;
    DBComboBox1: TDBComboBox;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    dbEd_Company_Name: TDBEdit;
    dbEd_OpenPercent: TDBEdit;
    dbEd_ShortOpenPercent: TDBEdit;
    dbEd_Re_OpenPercent: TDBEdit;
    dbEd_ProtCorect: TDBEdit;
    dbEd_ProtCorect1: TDBEdit;
    dbEd_ProtMargin: TDBEdit;
    dbEd_ProtMargin1: TDBEdit;
    dbEd_Short_RE_OpenPercent: TDBEdit;
    dbEd_StopPercent: TDBEdit;
    dbEd_StopPercent1: TDBEdit;
    dbEd_Symbol: TDBEdit;
    Activ: TGroupBox;
    dbEd_TakePercent: TDBEdit;
    dbEd_TakePercent1: TDBEdit;
    dbEd_Volume: TDBEdit;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label16: TLabel;
    Label2: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label3: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label4: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label5: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    Label55: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lbl_Market: TDBText;
    ed_Name: TEdit;
    ed_Symbol: TEdit;
    Label15: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    lb_strategies: TListBox;
    Parametri: TGroupBox;
    Informatii: TGroupBox;
    Label14: TLabel;
    lbl_Industry: TLabel;
    lbl_Link: TLabel;
    lbl_Sector: TLabel;
    lbl_MarketPrice: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label1: TLabel;
    timer: TTimer;
    procedure BitBtn1Click(Sender: TObject);
    procedure btn_LaunchClick(Sender: TObject);
    procedure btn_LaunhClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure dbEd_Company_NameChange(Sender: TObject);
    procedure dbEd_Company_NameEditingDone(Sender: TObject);
    procedure dbEd_OpenPercentEditingDone(Sender: TObject);
    procedure dbEd_SymbolChange(Sender: TObject);
    procedure dbEd_SymbolEditingDone(Sender: TObject);
    procedure ed_NameChange(Sender: TObject);
    procedure ed_SymbolChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure InformatiiClick(Sender: TObject);
    procedure Label30Click(Sender: TObject);
    procedure Label34Click(Sender: TObject);
    procedure Label53Click(Sender: TObject);
    procedure lb_strategiesClick(Sender: TObject);
    procedure timerTimer(Sender: TObject);
  private
    { private declarations }
    indicator: string;
    procedure FindByName;
    procedure FindBySymbol;
  public
    { public declarations }
    function DataValidation:boolean;
    function HasSymbol:boolean;

    procedure SetParams;

  end;

var
  frm_Lansare: Tfrm_Lansare;
  arr_strategies: array[0..1000] of TPositionParams;
  nr_strategies:integer;


implementation

{$R *.lfm}

{ Tfrm_Lansare }

procedure Tfrm_Lansare.FormCreate(Sender: TObject);
var
  str_savefile: string;
begin
  str_savefile:= '';
  lbl_Industry.Caption:= '-';
  lbl_Link.Caption:= '-';
  lbl_Market.Caption:= '-';
  lbl_MarketPrice.Caption:= '-';
  lbl_Sector.Caption:= '-';
  indicator:= 'l_fix';

  str_savefile := ExtractFileDir(Application.ExeName);
  str_savefile := str_savefile + '\_nyse_nasdaq.tbufdb';
  if FileExists (str_savefile) then
    dm_Main.dset_Symbols.LoadFromFile (str_savefile);

  {str_savefile := ExtractFileDir(Application.ExeName);
  str_savefile := str_savefile + '\history.aatdb';
  if FileExists (str_savefile) then
    dm_Main.dset_Symbols.LoadFromFile (str_savefile);}
end;

procedure Tfrm_Lansare.FormShow(Sender: TObject);
var
  sl_Files:TStringList;
  str_savefile :string;
  i:integer;
  vFile : file of TPositionParams;
begin
  // populate strategies
 lb_strategies.Clear;
 str_savefile := '';
 str_savefile := ExtractFileDir(Application.ExeName);
 sl_Files := FindAllFiles(str_savefile,'*aatp',true) ;
 nr_strategies:=sl_Files.Count;
 for i:=0 to nr_strategies-1 do
 begin
   str_savefile := sl_Files.Strings[i];
   if FileExists (str_savefile) then
   begin
     try
       AssignFile(vFile, str_savefile);
       Reset(vFile);
       Read(vFile, arr_strategies[i]);
       CloseFile(vFile);
       lb_strategies.Items.Add(arr_strategies[i].StrategyName);
     except
     end;
   end;
 end;
end;

procedure Tfrm_Lansare.InformatiiClick(Sender: TObject);
begin

end;

procedure Tfrm_Lansare.Label30Click(Sender: TObject);
begin

end;

procedure Tfrm_Lansare.Label34Click(Sender: TObject);
begin

end;

procedure Tfrm_Lansare.Label53Click(Sender: TObject);
begin

end;

procedure Tfrm_Lansare.lb_strategiesClick(Sender: TObject);
begin
  SetParams;
end;

procedure Tfrm_Lansare.dbEd_SymbolEditingDone(Sender: TObject);
begin
  FindBySymbol;
end;

procedure Tfrm_Lansare.ed_NameChange(Sender: TObject);
begin
  FindByName;
end;

procedure Tfrm_Lansare.ed_SymbolChange(Sender: TObject);
begin
  FindBySymbol;
end;

procedure Tfrm_Lansare.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  timer.Enabled := False;
end;

procedure Tfrm_Lansare.dbEd_Company_NameEditingDone(Sender: TObject);
begin
end;

procedure Tfrm_Lansare.dbEd_OpenPercentEditingDone(Sender: TObject);
begin
end;

procedure Tfrm_Lansare.dbEd_SymbolChange(Sender: TObject);
begin
end;

procedure Tfrm_Lansare.btn_LaunhClick(Sender: TObject);
begin

end;

procedure Tfrm_Lansare.btn_LaunchClick(Sender: TObject);
begin

end;

procedure Tfrm_Lansare.BitBtn1Click(Sender: TObject);
begin
  if (NOT DataValidation) or (NOT HasSymbol) then  { integrity check }
    begin
      _ShowMessage ('Va rugam corectati datele de lansare a pozitiei !');
      ModalResult := mrNone;
    end;
end;

procedure Tfrm_Lansare.Button1Click(Sender: TObject);
begin

end;

procedure Tfrm_Lansare.dbEd_Company_NameChange(Sender: TObject);
begin
end;



procedure Tfrm_Lansare.timerTimer(Sender: TObject);
var
  marketPrice: double;
  symbol,str_market: string;
  mres: TMarketMessage;

begin
  symbol:= dbEd_Symbol.Caption;
  str_Market := lbl_Market.Caption;
  if (symbol <> '') and (str_market='NASDAQ') then
  begin
    mres:= dm_Main.GetQuote(str_Market, symbol);
    if mres.f_price > 0 then
      begin
        lbl_MarketPrice.Caption:= FloatToStr(mres.f_price);
      end;
  end;
end;

procedure Tfrm_Lansare.FindByName;
var
  exists: boolean;
  cname, strName, symbol, market: string;
  mres: TMarketMessage;

begin
  cname:= ed_Name.Text;
  exists:= dm_Main.dset_Symbols.Locate('NAME', cname,[loPartialKey,loCaseInsensitive]);
  if not exists then
   // ShowMessage('Compania introdusa de dumneavoastra nu exista!')
  else
  begin
    mres:= dm_Main.GetQuote(dm_Main.dset_Symbols['MARKET'], dm_Main.dset_Symbols['SYMBOL']);
    lbl_Industry.Caption:= dm_Main.dset_Symbols['INDUSTRY'];
    lbl_Link.Caption:= dm_Main.dset_Symbols['LINK'];
    lbl_MarketPrice.Caption:= FloatToStr(mres.f_price);
    lbl_Sector.Caption:= dm_Main.dset_Symbols['SECTOR'];
    cname := dm_Main.dset_Symbols['NAME'];
    symbol:= dm_Main.dset_Symbols['SYMBOL'];
    market:= dm_Main.dset_Symbols['MARKET'];
    dm_Main.dset_Temp_Positions['MARKET']:= market;
    dm_Main.dset_Temp_Positions['COMPANY_NAME']:= cname;
    dm_Main.dset_Temp_Positions['SYMBOL']:= symbol;
    dm_Main.dset_Temp_Positions.FieldByName('MARKET').AsString:= market;
  end;
end;

procedure Tfrm_Lansare.FindBySymbol;
var
  exists: boolean;
  cname, strName, symbol, market: string;
  mres: TMarketMessage;
begin
  symbol:= ed_Symbol.Text;
  exists:= dm_Main.dset_Symbols.Locate('SYMBOL', symbol,[loPartialKey,loCaseInsensitive]);
  if not exists then
   // ShowMessage('Simbolul introdus de dumneavoastra nu exista!')
  else
  begin
    mres:= dm_Main.GetQuote(dm_Main.dset_Symbols['MARKET'], dm_Main.dset_Symbols['SYMBOL']);
    lbl_Industry.Caption:= dm_Main.dset_Symbols['INDUSTRY'];
    lbl_Link.Caption:= dm_Main.dset_Symbols['LINK'];
    lbl_MarketPrice.Caption:= FloatToStr(mres.f_price);
    lbl_Sector.Caption:= dm_Main.dset_Symbols['SECTOR'];
    cname := dm_Main.dset_Symbols.FieldValues['NAME'];
    symbol:= dm_Main.dset_Symbols.FieldValues['SYMBOL'];
    market:= dm_Main.dset_Symbols.FieldValues['MARKET'];
    dm_Main.dset_Temp_Positions.FieldValues['COMPANY_NAME']:= cname;
    dm_Main.dset_Temp_Positions.FieldValues['SYMBOL']:= symbol;
    dm_Main.dset_Temp_Positions.FieldByName('MARKET').AsString:= market;
  end;

end;

function Tfrm_Lansare.DataValidation: boolean;
var b_isvalid:boolean;
begin
  b_isValid := true;
  with dm_Main.dset_Temp_Positions do
  begin

    if FieldValues['SHORT_OPEN_PERCENT'] >=0 then
      begin
        _ShowMessage('Procentul de deschidere SHORT nu poate fi zero sau mai mare pentru pozitii SHORT');
        b_isValid := False;
      end;

    if FieldValues['SHORT_RE_OPEN_PERCENT'] >=0 then
      begin
        _ShowMessage('Procentul de re-deschidere SHORT nu poate fi zero sau mai mare pentru pozitii SHORT');
        b_isValid := False;
      end;

    if FieldValues['SHORT_STOP_PERCENT'] <=0 then
      begin
        _ShowMessage('Procentul de SHORT STOP LOSS nu poate mai mic ca zero pentru pozitii SHORT');
        b_isValid := False;
      end;

    if FieldValues['SHORT_TAKE_PERCENT'] >=0 then
      begin
        _ShowMessage('Procentul de SHORT TAKE PROFIT nu poate mai mare ca zero pentru pozitii SHORT');
        b_isValid := False;
      end;

    if FieldValues['SHORT_PROT_MARGIN'] >0 then
      begin
        _ShowMessage('Procentul de ZONA PROTECTIE PROFIT SHORT nu poate mai mare ca zero pentru pozitii SHORT');
        b_isValid := False;
      end;

    if FieldValues['SHORT_PROT_CORECT'] <=0 then
      begin
        _ShowMessage('Procentul de CORECTIE ZONA PROTECTIE PROFIT SHORT nu poate mai mic ca zero pentru pozitii SHORT');
        b_isValid := False;
      end;

    if FieldValues['SHORT_PROT_MARGIN']<=FieldValues['SHORT_TAKE_PERCENT'] then
      begin
        _ShowMessage('TAKE PROFIT < ZONA PROTECTIE PROFIT pentru pozitii SHORT');
        b_isValid := False;
      end;


    //long


    if FieldValues['OPEN_PERCENT'] <=0 then
      begin
        _ShowMessage('Procentul de deschidere nu poate fi zero sau mai mic pentru pozitii long');
        b_isValid := False;
      end;

    if FieldValues['RE_OPEN_PERCENT'] <=0 then
      begin
        _ShowMessage('Procentul de re-deschidere nu poate fi zero sau mai mic pentru pozitii long');
        b_isValid := False;
      end;

    if FieldValues['STOP_PERCENT'] >=0 then
      begin
        _ShowMessage('Procentul de STOP LOSS nu poate mai mare ca zero pentru pozitii long');
        b_isValid := False;
      end;

    if FieldValues['TAKE_PERCENT'] <=0 then
      begin
        _ShowMessage('Procentul de TAKE PROFIT nu poate mai mic ca zero pentru pozitii long');
        b_isValid := False;
      end;

    if FieldValues['PROT_MARGIN'] <0 then
      begin
        _ShowMessage('Procentul de ZONA PROTECTIE PROFIT nu poate mai mic ca zero pentru pozitii long');
        b_isValid := False;
      end;

    if FieldValues['PROT_CORECT'] >=0 then
      begin
        _ShowMessage('Procentul de CORECTIE ZONA PROTECTIE PROFIT nu poate mai mare ca zero pentru pozitii long');
        b_isValid := False;
      end;

    if FieldValues['PROT_MARGIN']>=FieldValues['TAKE_PERCENT'] then
      begin
        _ShowMessage('TAKE PROFIT > ZONA PROTECTIE PROFIT pentru pozitii long');
        b_isValid := False;
      end;
  end;
 Result := b_isvalid;
end;

function Tfrm_Lansare.HasSymbol: boolean;
var b_HasSymbol:boolean;
begin
 b_hasSymbol := False;
 with dm_Main.dset_Temp_Positions do
 begin
   if  (FieldValues['SYMBOL'] <>'') and (FieldValues['MARKET']<>'') then
      b_HasSymbol := True
   else
       _ShowMessage ('Nu ati introdus nici o companie !');
 end;
 Result := b_HasSymbol;
end;

procedure Tfrm_Lansare.SetParams;
begin
 dm_Main.TempParams := arr_strategies[lb_strategies.ItemIndex];
 dm_Main.SetTempParams;;
end;

end.

