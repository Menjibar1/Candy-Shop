       .data

intro:	.asciiz "Welcome to BobCat Candy, home to the famous BobCat Bars! \n"
askPrice:	.asciiz "Please enter the price of a BobCat Bar: "
askWrapper:	.asciiz "Please enter the number of wrappers needed to exchange for a new bar: "
askMoney:	.asciiz "How much do you have? "

good:	.asciiz "Good! Let me run the numbers... \n"
firstBuy: .asciiz "You first buy "
wrapperExchange: .asciiz "Then, you will get another "
bars:	.asciiz " bars.\n"

end1:	.asciiz "With $"
end2:	.asciiz ", you will receive a maximum of "
end3:	.asciiz " BobCat bars!"


		.text
		
		
main:		addi $sp, $sp, -4

		li $v0, 4
		la $a0, intro
		syscall
		
		li $v0, 4
		la $a0, askPrice
		syscall
		
		li $v0, 5
		syscall
		move $a0, $v0	#putting price in a0
		
		sw $a0, 0($sp)	#storing price in stack since we need to use a0 for more system calls
		
		
		li $v0, 4
		la $a0, askWrapper
		syscall
		
		li $v0, 5
		syscall
		move $a1, $v0	#putting wrapper in a1
		
		
		li $v0, 4
		la $a0, askMoney
		syscall
		
		li $v0, 5
		syscall
		move $s0, $v0	#putting money in s0
		
		
		li $v0, 4
		la $a0, good
		syscall
		
		lw $a0 0($sp)
		
		div $t0, $s0, $a0	#checking how many bars you can buy in the beginning
		li $v0, 0		#this is incase you can't buy any bars, the value printed will be 0
		beq $t0, $zero, noMoreBars	#if you can't any bars then skip to the end
		
		li $v0, 4
		la $a0, firstBuy
		syscall
		
		add $a0, $t0, $zero	#s1 has how many bars we can buy in the beginning so put it into a0 so we can print it
		li $v0, 1
		syscall
		
		li $v0, 4
		la $a0, bars
		syscall
		
		add $a0, $t0, $zero	#We are about to call the recursive function so the saved values we need are the amount of bars bought initally (a0) and the amount of wrappers to get another bar (a1)
		add $t2, $t0, $zero
		jal maxBars
		add $v0, $v0, $t2	#this isn't right but it gives the right answer, I can't figure out how to add the initial amount of bars into it without this
	
noMoreBars:	sw $v0, 0($sp)
		li $v0, 4
		la $a0,	end1
		syscall
		
		add $a0, $s0, $zero	#s0 is where we originally saved the starting money
		li $v0, 1
		syscall
		
		li $v0, 4
		la $a0,	end2
		syscall
		
		lw $v0, 0($sp)
		add $a0, $v0, $zero
		li $v0, 1
		syscall
		
		li $v0, 4
		la $a0,	end3
		syscall
		
		j end
		
		
		
maxBars:	addi $sp, $sp, -12
		sw $ra 8($sp)	#storing the return address
		
		div $t0, $a0, $a1
		bne $t0, $zero, newBars
		li $v0, 0
		
		j noMoreShopping
		
		

newBars:	div $a0, $a0, $a1
		sw $a0 4($sp)
		
		li $v0, 4
		la $a0, wrapperExchange
		syscall
		
		lw $a0 4($sp)
		li $v0, 1
		syscall
		
		li $v0, 4
		la $a0, bars
		syscall
		
		lw $a0 4($sp)
		jal maxBars
		
		lw $a0 4($sp)
		add $v0, $a0, $v0	#updating the return value
		
		j noMoreShopping
		
noMoreShopping:	lw $ra, 8($sp)
		addi $sp, $sp, 12
		jr $ra
		
		
end: 		addi $sp, $sp 4
		li $v0, 10 
		syscall
