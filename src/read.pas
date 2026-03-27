{ pr24p — Read Support
  Phase 1: UART input routines for read/readln.
  Will compile with p24c once procedure/function support lands.
  Until then, hand-written .spc stubs in runtime.spc. }

program read;

{ _p24p_read_char() : char
  Read single character from UART via sys 2 (GETC). }
function _p24p_read_char: integer;
begin
  _p24p_read_char := getc
end;

{ _p24p_read_int() : integer
  Read signed integer from UART. Handles optional leading
  minus sign, accumulates decimal digits until non-digit.
  Skips leading spaces and tabs. }
function _p24p_read_int: integer;
var
  c, n, neg: integer;
begin
  n := 0;
  neg := 0;
  { skip whitespace }
  c := getc;
  while (c = 32) or (c = 9) do
    c := getc;
  { check for sign }
  if c = 45 then
  begin
    neg := 1;
    c := getc
  end
  else if c = 43 then
    c := getc;
  { accumulate digits }
  while (c >= 48) and (c <= 57) do
  begin
    n := n * 10 + (c - 48);
    c := getc
  end;
  if neg = 1 then
    n := -n;
  _p24p_read_int := n
end;

{ _p24p_read_ln()
  Consume characters from UART until LF (10) is read. }
procedure _p24p_read_ln;
var
  c: integer;
begin
  c := getc;
  while c <> 10 do
    c := getc
end;
