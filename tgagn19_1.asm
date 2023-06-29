.data
first: .word 1
second: .word 2
.text
.globl main
main:

li $v0,5 #cin 1st number
syscall
move $t0,$v0

li $v0,5 #cin 2nd number
syscall
move $t1,$v0

li $v0,5 #cin 3rd number
syscall
move $t2,$v0

sub $t3 $t2 $t0 #t3=t2-t0
abs $t3 $t3 

sub $t4 $t2 $t1 #t4=t2-t1
abs $t4 $t4 

sle $t5 $t3 $t4 #if t3<=t4 (t5=1|0)
beq $t5 $zero, Else   #if t5==0 -> else
lw $t5 ,first  #print 1
li $v0, 1
move $a0, $t5
syscall
j exit    #jump to exit

Else:
lw $t5 ,second   # print 2
li $v0, 1
move $a0, $t5
syscall

exit:     # close the system
li $v0, 10
syscall


