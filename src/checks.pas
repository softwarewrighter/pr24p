{ pr24p — Runtime Checks
  Phase 1: Compiler-generated safety checks.
  Will compile with p24c once procedure support lands.
  Until then, hand-written .spc stubs in runtime.spc. }

program checks;

{ _p24p_bounds_check(index, low, high)
  Called by compiler-generated array access code.
  If index < low or index > high, prints diagnostic and halts. }
procedure _p24p_bounds_check(index, low, high: integer);
begin
  if (index < low) or (index > high) then
  begin
    writeln('BOUNDS');
    halt
  end
end;

{ _p24p_nil_check(ptr)
  Called before pointer dereference.
  If ptr = 0 (nil), prints diagnostic and halts. }
procedure _p24p_nil_check(ptr: integer);
begin
  if ptr = 0 then
  begin
    writeln('NIL');
    halt
  end
end;
