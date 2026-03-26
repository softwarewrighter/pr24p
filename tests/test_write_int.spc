; Test _p24p_write_int with various values

.proc main 0
    enter 0
    ; Test positive number
    push 42
    call _p24p_write_int
    push 10
    sys 1                ; newline
    ; Test zero
    push 0
    call _p24p_write_int
    push 10
    sys 1                ; newline
    ; Test negative
    push -123
    call _p24p_write_int
    push 10
    sys 1                ; newline
    ; Test single digit
    push 7
    call _p24p_write_int
    push 10
    sys 1                ; newline
    ; Test large number
    push 999999
    call _p24p_write_int
    push 10
    sys 1                ; newline
    halt
.end
