.module runtime
.export _p24p_write_int
.export _p24p_write_bool
.export _p24p_write_ln
.export _p24p_write_str
.export _p24p_abs
.export _p24p_odd
.export _p24p_ord
.export _p24p_chr
.export _p24p_succ
.export _p24p_pred
.export _p24p_sqr

; pr24p — Pascal Runtime Library
; Phase 0: Hand-written .spc stubs for p-code VM syscall wrappers

; _p24p_write_int ( n -- )
; Print signed integer to UART as decimal.
; Handles negative numbers (prints '-' prefix).
; Uses div/mod by 10 to extract digits, pushes onto eval stack
; in reverse order with a zero sentinel, then prints from most
; significant to least significant via sys 1 (PUTC).
.proc _p24p_write_int 1
    loada 0              ; load argument n
    ; check for negative
    dup                  ; n n
    push 0               ; n n 0
    lt                   ; n (n<0?)
    jz positive
    ; print minus sign
    push 45              ; n '-'
    sys 1                ; n
    neg                  ; -n
positive:
    storel 0             ; local0 = abs(n)
    push 0               ; push sentinel
extract:
    loadl 0              ; load n
    push 10
    mod                  ; n % 10
    push 48
    add                  ; n % 10 + '0' = digit char
    loadl 0
    push 10
    div                  ; n / 10
    storel 0             ; update n = n / 10
    loadl 0
    jnz extract          ; if n != 0, extract more digits
wi_print:
    dup
    jz wi_done
    sys 1                ; PUTC digit
    jmp wi_print
wi_done:
    drop                 ; discard sentinel
    ret 1
.end

; _p24p_write_bool ( b -- )
; Print TRUE or FALSE to UART.
; Compares argument to 0: if zero prints FALSE, otherwise prints TRUE.
; Each character is pushed and output via sys 1 (PUTC).
.proc _p24p_write_bool 0
    loada 0              ; load argument b
    jz wb_false
    ; print "TRUE"
    push 84              ; 'T'
    sys 1
    push 82              ; 'R'
    sys 1
    push 85              ; 'U'
    sys 1
    push 69              ; 'E'
    sys 1
    jmp wb_done
wb_false:
    ; print "FALSE"
    push 70              ; 'F'
    sys 1
    push 65              ; 'A'
    sys 1
    push 76              ; 'L'
    sys 1
    push 83              ; 'S'
    sys 1
    push 69              ; 'E'
    sys 1
wb_done:
    ret 1
.end

; _p24p_write_ln ( -- )
; Print newline (LF) to UART via sys 1 (PUTC).
.proc _p24p_write_ln 0
    push 10              ; LF
    sys 1
    ret 0
.end

; _p24p_write_str ( addr -- )
; Print null-terminated string from data segment to UART.
; Walks bytes via loadb, calls sys 1 (PUTC) for each until null.
.proc _p24p_write_str 1
    loada 0              ; load string address
    storel 0             ; local0 = pointer
ws_loop:
    loadl 0              ; load pointer
    loadb                ; load byte at pointer
    dup
    jz ws_done           ; null terminator -> done
    sys 1                ; PUTC
    loadl 0
    push 1
    add
    storel 0             ; pointer++
    jmp ws_loop
ws_done:
    drop                 ; discard null byte
    ret 1
.end

; Phase 1: Standard functions
; Hand-written .spc until p24c supports function compilation.
; Will be replaced with Pascal-compiled versions when p24c Phase 1 lands.

; _p24p_abs ( x -- |x| )
; Absolute value. Returns x if x >= 0, else -x.
.proc _p24p_abs 0
    loada 0              ; load x
    dup
    push 0
    lt                   ; x < 0?
    jz abs_done
    neg                  ; negate if negative
abs_done:
    ret 1
.end

; _p24p_odd ( x -- x mod 2 <> 0 )
; Returns true (1) if x is odd, false (0) if even.
.proc _p24p_odd 0
    loada 0              ; load x
    push 2
    mod                  ; x mod 2
    push 0
    ne                   ; result != 0 -> true
    ret 1
.end

; _p24p_ord ( c -- c )
; Character to integer. Identity on this VM (chars are integers).
.proc _p24p_ord 0
    loada 0
    ret 1
.end

; _p24p_chr ( n -- n )
; Integer to character. Identity on this VM (chars are integers).
.proc _p24p_chr 0
    loada 0
    ret 1
.end

; _p24p_succ ( x -- x+1 )
; Next ordinal value.
.proc _p24p_succ 0
    loada 0
    push 1
    add
    ret 1
.end

; _p24p_pred ( x -- x-1 )
; Previous ordinal value.
.proc _p24p_pred 0
    loada 0
    push 1
    sub
    ret 1
.end

; _p24p_sqr ( x -- x*x )
; Square of integer.
.proc _p24p_sqr 0
    loada 0
    dup
    mul
    ret 1
.end

.endmodule
