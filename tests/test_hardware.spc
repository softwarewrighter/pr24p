.proc main 0
; test led_on
call lon
; test read_switch: read and print
call rs
call wi
call wl
; test led_off
call lof
; print OK
push 79
sys 1
push 75
sys 1
call wl
halt
.end
; led_on: sys 3 convention 1=on
.proc lon 0
push 1
sys 3
ret 0
.end
; led_off: sys 3 convention 0=off
.proc lof 0
push 0
sys 3
ret 0
.end
.proc rs 0
push 0
ret 0
.end
.proc wi 1
loada 0
dup
push 0
lt
jz a0
push 45
sys 1
neg
a0:
storel 0
push 0
a1:
loadl 0
push 10
mod
push 48
add
loadl 0
push 10
div
storel 0
loadl 0
jnz a1
a2:
dup
jz a3
sys 1
jmp a2
a3:
drop
ret 1
.end
.proc wl 0
push 10
sys 1
ret 0
.end
