{ pr24p — I/O State Functions
  Phase 2: eof, eoln, and subrange_check.
  Until p24c compiles these, hand-written .spc stubs in runtime.spc. }

program io_state;

{ _p24p_eof() : boolean
  Returns true (1) if UART input is at end-of-transmission.
  On this VM, EOF is signaled by EOT byte (0x04).
  Peeks at the next character without consuming it.
  Note: requires a one-character lookahead buffer. }
function _p24p_eof: integer;
begin
  { Implementation uses a global lookahead buffer.
    If buffer is empty, read a char.
    If char = 4 (EOT), return 1 (true).
    Otherwise store in buffer and return 0 (false). }
end;

{ _p24p_eoln() : boolean
  Returns true (1) if UART input is at end-of-line.
  Peeks at the next character: true if LF (10) or EOF. }
function _p24p_eoln: integer;
begin
  { Uses same lookahead buffer as eof.
    Returns 1 if next char is LF or EOT. }
end;

{ _p24p_subrange_check(value, low, high)
  Like bounds_check but prints "RANGE" instead of "BOUNDS".
  For subrange types (type month = 1..12). }
procedure _p24p_subrange_check(value, low, high: integer);
begin
  if (value < low) or (value > high) then
  begin
    writeln('RANGE');
    halt
  end
end;
