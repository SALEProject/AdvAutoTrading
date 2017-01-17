unit u_Logger;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ExtCtrls, Forms;

type

{ TLogger }

 TLogger=class
  private
  public
    pnl_InfoPannel : TPanel;
    procedure LogDisplayMessage(str_msg:string);
    procedure LogDBMessage(str_msg:string);
end;

 var
    log_Logger : TLogger;

implementation

uses u_dm_main;
{ TLogger }

procedure TLogger.LogDisplayMessage(str_msg: string);
begin
  pnl_InfoPannel.Caption := str_msg;
  Application.ProcessMessages;
end;

procedure TLogger.LogDBMessage(str_msg: string);
var CPos:TMarketPosition;
begin
  CPos.NRPOS := -1;
  dm_Main.AddHistory(str_msg,'ERROR',Cpos);
  Application.ProcessMessages;
end;

end.

