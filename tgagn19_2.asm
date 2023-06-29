.data
.text
.globl main
main:

li $v0,5 #cin 1st number
syscall
move $t0,$v0
move $t2 $t0

li $v0,5 #cin 2nd number
syscall
move $t1,$v0
move $t3 $t1

gcd:
beq $t1, $0, exit   
div $t4, $t0, $t1  # t4 = a / b 
mfhi $t4     #  a % b 
move $t0, $t1     
move $t1, $t4
j gcd

exit:
move $t4, $t0  # ans ->  t4

div $t0, $t2, $t4 
div $t1, $t3, $t4

move $a0, $t0
li $v0, 1
syscall

li $a0, 32  #space
li $v0, 11  
syscall

move $a0, $t1
li $v0, 1
syscall

li $v0, 10 #exit program
syscall

