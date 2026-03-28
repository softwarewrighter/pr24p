{ pr24p — Write Formatting
  Phase 2: Field-width output and write_char.
  Extends Phase 0 write routines with formatting support.
  Until p24c compiles these, hand-written .spc stubs in runtime.spc. }

program write_fmt;

{ _p24p_write_char(c)
  Write a single character to UART via sys 1 (PUTC). }
procedure _p24p_write_char(c: integer);
begin
  putc(c)  { sys 1 }
end;

{ _p24p_write_int_w(n, width)
  Write integer n right-justified in a field of given width.
  If the printed number is shorter than width, pad with spaces on the left.
  If longer, print the full number (no truncation). }
procedure _p24p_write_int_w(n, width: integer);
var
  digits, tmp, neg: integer;
begin
  { count digits + sign }
  neg := 0;
  if n < 0 then
  begin
    neg := 1;
    tmp := -n
  end
  else
    tmp := n;
  digits := 0;
  repeat
    digits := digits + 1;
    tmp := tmp div 10
  until tmp = 0;
  digits := digits + neg;  { add 1 for minus sign }
  { emit leading spaces }
  while digits < width do
  begin
    putc(32);  { space }
    width := width - 1
  end;
  { delegate to write_int }
  write_int(n)
end;

{ _p24p_write_char_w(c, width)
  Write character c right-justified in a field of given width. }
procedure _p24p_write_char_w(c, width: integer);
begin
  while 1 < width do
  begin
    putc(32);  { space }
    width := width - 1
  end;
  putc(c)
end;

{ _p24p_write_bool_w(b, width)
  Write boolean right-justified in a field of given width.
  TRUE is 4 chars, FALSE is 5 chars. }
procedure _p24p_write_bool_w(b, width: integer);
var
  len: integer;
begin
  if b <> 0 then len := 4 else len := 5;
  while len < width do
  begin
    putc(32);  { space }
    width := width - 1
  end;
  write_bool(b)
end;

{ _p24p_write_str_w(addr, width)
  Write string right-justified in a field of given width.
  Must walk string first to count length. }
procedure _p24p_write_str_w(addr, width: integer);
var
  len, p: integer;
begin
  { count string length }
  len := 0;
  p := addr;
  while mem[p] <> 0 do
  begin
    len := len + 1;
    p := p + 1
  end;
  { emit leading spaces }
  while len < width do
  begin
    putc(32);  { space }
    width := width - 1
  end;
  write_str(addr)
end;
