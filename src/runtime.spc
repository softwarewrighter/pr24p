; pr24p — Pascal Runtime Library
; Phase 0: Hand-written .spc stubs for p-code VM syscall wrappers

; _p24p_write_int ( n -- )
; Print signed integer to UART as decimal.
; Handles negative numbers (prints '-' prefix).
; Uses div/mod by 10 to extract digits, pushes onto eval stack
; in reverse order with a zero sentinel, then prints from most
; significant to least significant via sys 1 (PUTC).
.proc _p24p_write_int 1
    enter 1
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
print:
    dup
    jz done
    sys 1                ; PUTC digit
    jmp print
done:
    drop                 ; discard sentinel
    leave
    ret 1
.end
