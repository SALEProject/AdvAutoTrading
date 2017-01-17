unit u_frm_about;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons;

type

  { Tfrm_about }

  Tfrm_about = class(TForm)
    BitBtn1: TBitBtn;
    Image2: TImage;
    Image3: TImage;
    Label1: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    procedure Memo1Change(Sender: TObject);
    procedure Memo2Change(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frm_about: Tfrm_about;

implementation

{$R *.lfm}

{ Tfrm_about }

procedure Tfrm_about.Memo2Change(Sender: TObject);
begin

end;

procedure Tfrm_about.Memo1Change(Sender: TObject);
begin

end;

end.

