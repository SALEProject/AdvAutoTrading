unit u_MarketPosition;

{$mode objfpc}{$H+}

interface

uses
 Classes, SysUtils;

 type TNewPositionParams = record
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
                        end;

 type TNewMarketPosition = class
                        private
                         FPositionParams: TNewPositionParams;

                         procedure SetActive(Value: boolean);
                         function GetPositionParams: TNewPositionParams;
                         procedure SetPositionParams(Value: TNewPositionParams);
                        public
                         procedure Save;

                         property Active: boolean read FPositionParams.POS_ACTIVE write SetActive;
                         property PositionParams: TNewPositionParams read GetPositionParams write SetPositionParams;
                        end;

implementation

 procedure TNewMarketPosition.SetActive(Value: boolean);
  begin
   if FPositionParams.POS_ACTIVE <> Value then
    begin
     FPositionParams.POS_ACTIVE:= Value;
     Save;
    end;
  end;

 function TNewMarketPosition.GetPositionParams: TNewPositionParams;
  begin
   result:= FPositionParams;
  end;

 procedure TNewMarketPosition.SetPositionParams(Value: TNewPositionParams);
  var oldValue: TNewPositionParams;
  begin
   oldValue:= FPositionParams;
   FPositionParams:= Value;
   if CompareByte(oldValue, Value, sizeof(Value)) <> 0 then Save;
  end;

 procedure TNewMarketPosition.Save;
  begin

  end;

end.

