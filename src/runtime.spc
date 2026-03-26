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
