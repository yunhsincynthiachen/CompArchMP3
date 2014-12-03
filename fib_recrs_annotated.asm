#Michael Bocamazo, 2014/11/28
#Fibonacci Recursive Implementation
li $v0, 0
li $a0, 4 #value of N
li $a1, 0 #return address
jal fib
move $v1, $v0 #moves the result to $v1
li $v0, 0
li $a0, 10 #value of N
li $a1, 0 #return address
jal fib
add $v1, $v1, $v0
li $v0, 10 #10 means exit, special for syscalls
syscall
fib:
beq $a0, 0, ret0
beq $a0, 1, ret1 #if(N==1) or (N==0), return 1
add $sp, $sp, -12 #Push $ra, $a0, $a1; which are return addr, N, feval
sw $ra, 8($sp) #stores feval into 8
sw $a0, 4($sp) #stores value of N into 4
sw $a1, 0($sp) #stores value of return addr into 0
add $a0, $a0, -1 #decrement N-1 (which is F(N-1))
jal fib #recurse 
add $a1, $v0, $zero #retain fib_1 (gets included in stack on next call)
add $a0, $a0, -1 #decrement N again
jal fib #F(N-2)
add $v0, $v0, $a1 #return fib_1+fib_2
lw $ra, 8($sp) #Pop $ra, $a0, $a1; which are addr, N, feval
lw $a0, 4($sp)
lw $a1, 0($sp)
add $sp, $sp, 12
jr $ra
ret0:
li $v0, 0
jr $ra
ret1: 
li $v0, 1 #Return 1
jr $ra