unit bitABachus;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

 type TStringArray = array of string;

 function SplitString(s: string; marker: string): TStringArray;
 function SplitAndTrimString(s: string; marker: string): TStringArray;
 function ParseFormat(s: string; mask: string): TStringArray;
 function LevenshteinDistance0(s: string; t: string): integer;
 function LevenshteinDistance1(s: string; t: string): integer;

 (* working on this

 digit:= 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
 alfa:= a..z | A..Z
 char:= *ascii char*
 chars:= char | char chars
 string:= ' chars ' | " chars "
 number:= digit | + digit | - digit | number digit | number . number
 value:= string | number
 identifier:= alfa | identifier number | identifier alfa | identifier _
 constant:= value
 attribute:= identifier : value | attribute : function
 function:= identifier(expression)
 expression:= constant | attribute | function |

 *)

implementation

 function SplitString(s: string; marker: string): TStringArray;
  var idx, k: integer;
  begin
   SetLength(result, 0);

   idx:= Pos(marker, s);
   while idx > 0 do
    begin
     k:= Length(result);
     SetLength(result, k + 1);
     result[k]:= Copy(s, 1, idx - 1);
     Delete(s, 1, idx);

     idx:= Pos(marker, s);
    end;

   if s <> '' then
    begin
     k:= Length(result);
     SetLength(result, k + 1);
     result[k]:= s;
    end;
  end;

 function SplitAndTrimString(s: string; marker: string): TStringArray;
  var idx, k: integer;
      ss: string;
  begin
   SetLength(result, 0);

   idx:= Pos(marker, s);
   while idx > 0 do
    begin
     ss:= Trim(Copy(s, 1, idx - 1));
     Delete(s, 1, idx);

     if ss <> '' then
      begin
       k:= Length(result);
       SetLength(result, k + 1);
       result[k]:= ss;
      end;

     idx:= Pos(marker, s);
    end;

   s:= Trim(s);
   if s <> '' then
    begin
     k:= Length(result);
     SetLength(result, k + 1);
     result[k]:= s;
    end;
  end;

 function ParseFormat(s: string; mask: string): TStringArray;
  var i, k, idx: integer;
      str_input, str_mask, ss: string;
      old_char, new_char: char;
      b: boolean;
  begin
   SetLength(result, 0);

   //  scan string and mask for CR, LF, tabs and consecutive spaces

   s:= Trim(s);
   mask:= Trim(mask);

   str_input:= '';
   old_char:= #0;
   for i:= 1 to Length(s) do
    begin
     new_char:= s[i];

     if new_char = #13 then new_char:= ' ';
     if new_char = #10 then new_char:= ' ';
     if new_char = #9 then new_char:= ' ';

     if (new_char = ' ') and (old_char = ' ') then Continue;
     str_input:= str_input + new_char;
     old_char:= new_char;
    end;

   str_mask:= '';
   old_char:= #0;
   for i:= 1 to Length(mask) do
    begin
     new_char:= mask[i];

     if new_char = #13 then new_char:= ' ';
     if new_char = #10 then new_char:= ' ';
     if new_char = #9 then new_char:= ' ';

     if (new_char = ' ') and (old_char = ' ') then Continue;
     str_mask:= str_mask + new_char;
     old_char:= new_char;
    end;

   idx:= Pos('%s', str_mask);
   b:= true; //  assume the form is respected
   while b and (idx > 0) do
    begin
     Delete(str_input, 1, idx - 1);
     Delete(str_mask, 1, idx + 1); //  delete including the %s placeholder

     idx:= Pos('%s', str_mask); //  get the next position of %s placeholder
     if idx > 0 then
      ss:= Copy(str_mask, 1, idx - 1) //  get the expression between placeholders
     else
      ss:= str_mask; //  there is no placeholder anymore

     if ss = '' then i:= Length(str_input) + 1 else i:= Pos(ss, str_input);
     if i > 0 then
      begin
       k:= Length(result);
       SetLength(result, k + 1);
       result[k]:= Copy(str_input, 1, i - 1);
       Delete(str_input, 1, i - 1);
      end else b:= false;

     idx:= Pos('%s', str_mask);
    end;

   if not b then SetLength(result, 0); //  the form was not respected
  end;

 function LevenshteinDistance0(s: string; t: string): integer;
  var len_s, len_t, cost, c1, c2, c3: integer;
  begin
   len_s:= Length(s);
   len_t:= Length(t);
   cost:= 0;

   if len_s = 0 then begin result:= len_t; Exit; end;
   if len_t = 0 then begin result:= len_s; Exit; end;
   if (len_s = len_t) and (s = t) then begin result:= 0; Exit; end;

   if s[1] <> t[1] then cost:= 1;

   c1:= LevenshteinDistance0(Copy(s, 2, len_s - 1), t) + 1;
   c2:= LevenshteinDistance0(s, Copy(t, 2, len_t - 1)) + 1;
   c3:= LevenshteinDistance0(Copy(s, 2, len_s - 1), Copy(t, 2, len_t - 1)) + cost;

   result:= c1;
   if c2 < result then result:= c2;
   if c3 < result then result:= c3;
  end;

 function LevenshteinDistance1(s: string; t: string): integer;
  var len_s, len_t, cost, c1, c2, c3, i, j: integer;
      d: array of array of integer;
  begin
   len_s:= Length(s);
   len_t:= Length(t);

   if len_s = 0 then begin result:= len_t; Exit; end;
   if len_t = 0 then begin result:= len_s; Exit; end;
   if (len_s = len_t) and (s = t) then begin result:= 0; Exit; end;

   SetLength(d, len_s + 1);
   for i:= 0 to len_s do
    begin
     SetLength(d[i], len_t + 1);
     d[i][0]:= i;
    end;

   for j:= 0 to len_t do d[0, j]:= j;

   for i:= 1 to len_s do
    for j:= 1 to len_t do
     begin
      cost:= 0;
      if s[i] <> t[j] then cost:= 1;

      c1:= d[i - 1, j] + 1;
      c2:= d[i, j -1] + 1;
      c3:= d[i - 1, j - 1] + cost;

      d[i, j]:= c1;
      if c2 < d[i, j] then d[i, j]:= c2;
      if c3 < d[i, j] then d[i, j]:= c3;
     end;

   result:= d[i, j];

   for i:= 0 to len_s do SetLength(d[i], 0);
   SetLength(d, 0);
  end;


end.

