.data
    prompt1: .asciiz "Enter the first string (up to 15 characters): "
    prompt2: .asciiz "Enter the second string (up to 15 characters): "
    str1: .space 16    # Allocate memory for the first string
    str2: .space 16    # Allocate memory for the second string
    arr1 : .space 64
    arr2 : .space 64
.text
    # Print prompt and read first string
    li $v0, 4
    la $a0, prompt1
    syscall
    
    li $v0, 8
    la $a0, str1
    li $a1, 16
    syscall
    
    # Print prompt and read second string
    li $v0, 4
    la $a0, prompt2
    syscall
    
    li $v0, 8
    la $a0, str2
    li $a1, 16
    syscall
    
    # Initialize variables for string index pointers
    la $t0, str1  
    la $t1, str2   
    
    #Initialize variables for array index pointers
    la $t6 arr1
    la $t7 arr2
    
  
    #initialize first index values as zero 
    andi $t6 $t6 0xFFFFFFFC   # align the address on a word boundary
    andi $t7 $t7 0xFFFFFFFC	# align the address on a word boundary
    sw $zero ($t6) # defining array1 index 0 as 0 
    sw $zero ($t7) # defining array2 index 0 as 0
      
    #Initialize variables for loops 
    li $t2, 0  #i 
    li $t3, 0  #j

loop1:
    lb $a0, ($t0)        # Load the next character from the input string
    beqz $a0 print_exit  

loop2:
 
    lb $a0, ($t1)        # Load the next character from the input string
    beqz $a0, end_loop2
  
    # i==0 ||j ==0 
    beqz $t2 define_zero
    
    #if str1(i-1)=str2(j-1)
    sub $t0 $t0 1 # index i-1 
    lb $t4 ($t0)
    sub $t1 $t1 1 # index j-1
    lb $t5 ($t1)
    addi $t0 $t0 1  # put back to index i
    addi $t1 $t1 1  # put back to index j
    bne $t4 $t5 not_equal
    j equal
    
define_zero:    
add $t3 $t3 1 
mul $t8 $t3 4  # take appropriate index to store  the zero value j*4
add $t7 $t7 $t8 # get placing from the beginning      
sw $zero ($t7)  # put zero  on index
sub $t7 $t7 $t8
addi $t1 $t1 1 # to increaze str2 indexing
j loop2

end_loop2:
#copying arr2 to arr1 
    # Initialize registers
    li $t4, 0                    # Initialize index variable $t0 to 0
    li $t5, 64                   # Set the length of the arrays (number of elements)

copy_loop:
    beq $t4, $t5, done_out           # If index equals length, exit the loop

    # Copy element from source array to destination array
    lw $t8, ($t7)               # Load element from source array
   
    sw $t8, ($t6)               # Store element into destination array
    

    # Update pointers and index
    addi $t6, $t6, 4             # Increment source array pointer by 4 (word size)
    addi $t7, $t7, 4             # Increment destination array pointer by 4 (word size)
    addi $t4, $t4, 1             # Increment index by 1

    j copy_loop                  # Jump back to the beginning of the loop
    

done_out:
la $t1, str2 
li $t3 0
addi $t0 $t0 1 
addi $t2 $t2 1  
sub $t6 $t6 256 # get back to the starting point of an array
sub $t7 $t7 256 # get back to the srarting point of an array

j loop1


equal:

# arr1[i-1]+1

move $t8 $t3
mul $t8 $t8 4  # get index for array 
add $t6 $t6 $t8 # get value from the index above
lw $t4 ($t6)  # load value to t4 register 
add $t4 $t4 1
sub $t6 $t6 $t8

#arr2[i] = ... 

move $t8 $t3
add $t8 $t8 1
mul $t8 $t8 4
add $t7 $t7 $t8
sw $t4 ($t7)   

sub $t7 $t7 $t8

addi $t3 $t3 1
addi $t1 $t1 1  
j loop2

not_equal:

#arr1[i] 

add $t3 $t3 1
mul $t3 $t3 4
add $t6 $t6 $t3
lw $t8 ($t6)   #arr1[i]


sub $t6 $t6 $t3
div $t3 $t3 4
sub $t3 $t3 1

#arr2[i-1] 

mul $t3 $t3 4 
add $t7 $t7 $t3
lw $t4 ($t7) # arr2[i-1]

sub $t7 $t7 $t3
div $t3 $t3 4

slt $t9 $t8 $t4
beq $t9 1 fill_arr1
beq $t9 0 fill_arr2
    
fill_arr1:

move $t9 $t3
add $t9 $t9 1 
mul $t9 $t9 4
add $t7 $t7 $t9
sw $t4 ($t7)

sub $t7 $t7 $t9 

addi $t3 $t3 1
addi $t1 $t1 1 
j loop2

fill_arr2:

move $t9 $t3
add $t9 $t9 1 
mul $t9 $t9 4
add $t7 $t7 $t9
sw $t8 ($t7)

sub $t7 $t7 $t9 

addi $t3 $t3 1
addi $t1 $t1 1 
j loop2

    
print_exit:

la $t2 str2
li $t3, 0            # Initialize counter to 0
count_loop:
        lb $t1, ($t2)      # Load a character from the string
        beqz $t1, load   # If null terminator is encountered, exit the loop
        addi $t3, $t3, 1    # Increment counter
        addi $t2 $t2 1
        j count_loop        # Jump back to the beginning of the loop
               
load: 
mul $t3 $t3 4
add $t6 $t6 $t3
lw $t3 ($t6)
move $a0, $t3            
li $v0, 1              
syscall      
  
# Exit program
exit:
li $v0, 10
syscall
