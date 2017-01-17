unit u_frm_debug;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids,
  Buttons, StdCtrls, u_finance_request ;

type

  { Tfrm_Debug }

  Tfrm_Debug = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    mem_Prices: TMemo;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mem_PricesChange(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frm_Debug: Tfrm_Debug;

implementation

{$R *.lfm}

{ Tfrm_Debug }

procedure Tfrm_Debug.FormCreate(Sender: TObject);
begin
end;

procedure Tfrm_Debug.mem_PricesChange(Sender: TObject);
begin

end;

procedure Tfrm_Debug.BitBtn1Click(Sender: TObject);
begin

end;

end.

