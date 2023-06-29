.data
set: .space 80  # reserve space for 20 integers
prompt1: .asciiz "YES"
prompt2: .asciiz "NO"
space: .asciiz " "
newLine: .asciiz "\n"
.text
main:
    
    # read the number of operations
    li $v0, 5
    syscall
    move $t1, $v0   # save the number of operations in t1
    
    addi $t0, $zero, 0      #save the state of index in array 

    
loop:
    beq $t1, $zero, exit     # if we have performed all the operations, exit
    
    # read the operation code
    li $v0, 5
    syscall
    move $t2, $v0
    
    # perform the operation
    beq $t2, 1, input
    beq $t2, 2, delete
    beq $t2, 3, lookup
    beq $t2, 4, display
    
    j loop          # if the operation code is invalid, go back to the prompt
    
input:
   
    # read the element from the user
    li $v0, 5
    syscall
    move $t3, $v0   # save the element value
    
    beq $t0 $zero insert
    
    addi $t4 $zero 0  #save indexing for array
    
loop1:
    lw $t5, set($t4)   # Load current element
    beq $t3, $t5, no_insert	 # If number is found jump no insertion 
    addi $t4, $t4, 4    	# Move to next element
    bne $t4, $t0, loop1  	# Continue looping if end of array hasn't been reached
    j insert        		 # If number not found, add it to array
    
    
insert:

addi $t4 $zero 0  #save indexing for array
    
loop4:
    lw $t5, set($t4)   # Load current element
    sge $t6 $t5 $t3  #save 0/1 in t6 from greater or equal result 
    beq $t6 1 insert_next     #if number on index is garter than input insert with sorting 
    addi $t4, $t4, 4    # Move to next element
    bne $t4, $t0, loop4 # Continue looping if end of array hasn't been reached
    j last_insert         # If greater number not found insert as last element


insert_next:  # insertion with sorting

 beq $t0 $zero last_insert # if it is first time inserting in an array go straight to insertion 
 move $t6 $t5   
 sw $t3 set($t4)
 
while2:    # storing next element address and changing the value of an address we are on
	addi $t4, $t4, 4 
	lw $t5, set($t4)   # Load current element
	sw $t6 set($t4)
	move $t6 $t5   
 	beq $t4 $t0 finish_while2
 	j while2


finish_while2:  # decrease number of operations and increase araay end pointer (t0)
sub $t1 $t1 1
addi $t0 $t0 4
j loop


last_insert: 		#if it is first number in set or  first occuring, insert at index 0 
   sw $t3, set($t0)   # Add number to the end of an array
   addi $t0 $t0 4
   sub $t1 $t1 1
   j loop
    
no_insert:  # decrease number of operations and jump to the first loop 
sub $t1 $t1 1
j loop

lookup:
   
    li $v0, 5
    syscall
    move $t3, $v0
    
   addi $t4 $zero 0  #save indexing for array
    
loop2:
    beq $t0 $zero not_found
    lw $t5, set($t4)   # Load current element
    beq $t3, $t5, found # If number is found jump to the prompt YES
    addi $t4, $t4, 4    # Move to next element
    bne $t4, $t0, loop2  # Continue looping if end of array hasn't been reached
    j not_found         # If number not found jump to the prompt NO
  
      
found:
la $a0,prompt1
li $v0,4
syscall
sub $t1 $t1 1
 li $v0 4
 la $a0 newLine
 syscall
j loop
  
not_found: 
la $a0,prompt2
li $v0,4
syscall
sub $t1 $t1 1
 li $v0 4
 la $a0 newLine
 syscall
j loop

display:
addi $t4 $zero 0  #save indexing for array


while:
 beq $t4 $t0 while_finish
 
 lw $t5 set($t4) # load current num from index of arr
 

 #print nums
 li $v0 1 
 move $a0 $t5
 syscall
 
 #print space
 li $v0 4
 la $a0 space   # print on the same line with spacing 
 syscall
 
 addi $t4 $t4 4
 
 j while
 

while_finish:
sub $t1 $t1 1
li $v0 4
la $a0 newLine  # print new line for the next operation number
syscall
j loop

delete:

 li $v0, 5
 syscall
 move $t3, $v0
 
addi $t4 $zero 0  #save indexing for array
    
loop3:
    #beq $t0 $zero del_not_found     # if there is no guarantee that number exists in an array
    lw $t5, set($t4)   # Load current element
    beq $t3, $t5, del # If number is found jump to deleting
    addi $t4, $t4, 4    # Move to next element
    bne $t4, $t0, loop3  # Continue looping if end of array hasn't been reached
    j del_not_found        # If number not found jump to first loop


del:  # deleting so if there are more elements after input we move them 4 bytes left in set so that we dont have a gap

while1:
 
 beq $t4 $t0 finish_while  # if end of an array is reached finish looping 
 
 move $t5 $t4   
 addi $t4, $t4, 4 
 lw $t6, set($t4)   
 sw $t6 set($t5)
 
 j while1


finish_while:
sub $t1 $t1 1
sub $t0 $t0 4
j loop


del_not_found: # if not found decrease number of operations and jump to the first loop
sub $t1 $t1 1
j loop

exit:
li $v0, 10      # Exit the program
syscall
 
