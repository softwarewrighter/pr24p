{ pr24p — Heap Management
  Phase 2: Dynamic memory allocation with leak tracking.
  Will compile with p24c once pointer/record support lands.
  Until then, hand-written .spc stubs in runtime.spc. }

program heap;

const
  MAX_ALLOCS = 16;

var
  alloc_count: integer;
  free_count: integer;
  ptrs: array[0..15] of integer;

{ _p24p_heap_init()
  Initialize heap tracking state. Must be called before any
  allocation. Zeros counters and pointer tracking array. }
procedure _p24p_heap_init;
var
  i: integer;
begin
  alloc_count := 0;
  free_count := 0;
  for i := 0 to MAX_ALLOCS - 1 do
    ptrs[i] := 0
end;

{ _p24p_new(size) : integer
  Allocate size words of heap memory via sys 4 (ALLOC).
  Returns the allocated address. Tracks pointer for leak
  detection. If tracking table is full, allocation still
  succeeds but won't be tracked. }
function _p24p_new(size: integer): integer;
var
  addr, i: integer;
begin
  addr := alloc(size);  { sys 4 }
  alloc_count := alloc_count + 1;
  { find empty slot in tracking table }
  for i := 0 to MAX_ALLOCS - 1 do
    if ptrs[i] = 0 then
    begin
      ptrs[i] := addr;
      break
    end;
  _p24p_new := addr
end;

{ _p24p_dispose(ptr)
  Free heap memory at ptr via sys 5 (FREE).
  Removes pointer from tracking table. }
procedure _p24p_dispose(ptr: integer);
var
  i: integer;
begin
  free(ptr);  { sys 5 }
  free_count := free_count + 1;
  { remove from tracking table }
  for i := 0 to MAX_ALLOCS - 1 do
    if ptrs[i] = ptr then
    begin
      ptrs[i] := 0;
      break
    end
end;

{ _p24p_leak_report()
  Report unfreed allocations at program exit.
  Prints "LEAK:N" if N allocations were not freed,
  or "OK:0" if all allocations were properly freed. }
procedure _p24p_leak_report;
var
  leaks: integer;
begin
  leaks := alloc_count - free_count;
  if leaks > 0 then
  begin
    write('LEAK:');
    writeln(leaks)
  end
  else
  begin
    write('OK:');
    writeln(0)
  end
end;
