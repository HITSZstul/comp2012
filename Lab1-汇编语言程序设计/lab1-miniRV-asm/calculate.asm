Init:
	lui  s1, 0xFFFFF # s1 = 0xFFFFF000
	j Main
Main:
	jal Input

	jal Decode
	
	jal Calculate

	jal Main #循环输入

Input:
	lw s0,0x70(s1) 			# s0 = 0xFFFFF070 read Input
	ret

Decode:
	#li s0, 2099537
#	li s0, 2161145
	srli a3, s0, 21 		# a3 = s0 >> 21
	andi a3, a3, 0x7 		# a3 = s0 & 0x7 a3 is op

	srli a2, s0, 8 			# a2 = s0 >> 8
	andi a2, a2, 0xF 		# a2 = s0 & 0xFF a2 is 1st operand down 4bit
	srli a1, s0, 12 		# a1 = s0 >> 12
	andi a1, a1, 0xF 		# a1 = s0 & 0xFF a1 is 1st operand upper 4bit

	##
	#这里的a1.a2是第一个操作数operand1
	##

	andi a5, s0, 0xF 		# a5 = s0 & 0xFF a5 is 2nd operand down 4bit
	srli a4, s0, 4 			# a4 = s0 >> 4
	andi a4, a4, 0xF 		# a4 = s0 & 0xFF a4 is 2nd operand upper 4bit

	##
	#这里的a4.a5是第二个操作数operand2
	##
	
	ret

Calculate:
	
	beq a3, zero, Zero
	
	li t1, 1
	beq a3, t1, Add

	li t1, 2
	beq a3, t1, Sub

	li t1, 3
	beq a3, t1, Mul

	li t1, 4
	beq a3, t1, Div

	li t1, 5
	beq a3, t1, Random

	j Exit

DisPlay:
	sw a7, 0x60(s1)   			# t2 = 0xFFFFF070
	sw a7, 0x00(s1)
	j Main

Hex_To_10:
	##
	# t0:参数；t2:结果
	##
	addi t0, zero, 1000			# t0 = 1000
	addi t1, zero, 0			# t1 = 0
Thousand_Loop:
	blt a0, t0, Out_Thousand	# 若小于1000, 赋值t1
	addi t1, t1, 1				# t1 = t1 + 1
	addi a0, a0, -1000			# a0 = a0 - 1000
	j Thousand_Loop
Out_Thousand:
	slli t1, t1, 12				# t1 = t1 >> 12
	add t2, t1, t2 				# t2 = t1 + t2
##
##第二位数
##
	addi t0, zero, 100			# t0 = 100
	addi t1, zero, 0			# t1 = 0
Hundred_Loop:
	blt a0, t0, Out_Hundred	# 若小于100，赋值t1
	addi t1, t1, 1				# t1 = t1 + 1
	addi a0, a0, -100			# a0 = a0 - 100
	j Hundred_Loop
Out_Hundred:
	slli t1, t1, 8			# t1 = t1 >> 8
	add t2, t1, t2 			# t2 = t1 + t2

##
##第三位数
##
	addi t0, zero, 10		# t0 = 10
	addi t1, zero, 0		# t1 = 0
Ten_Loop:
	blt a0, t0, Out_Ten		# 若小于10，赋值t1
	addi t1, t1, 1			# t1 = t1 + 1
	addi a0, a0, -10		# a0 = a0 - 10
	j Ten_Loop
Out_Ten:
	slli t1, t1, 4			# t1 = t1 >> 4
	add t2, t1, t2 			# t2 = t1 + t2
##
##第四位数
##
#	addi t0, zero, 1		# t0 = 1
#	addi t1, zero, 0		# t1 = 0
#One_Loop:
#	blt a0, t0, Out_One		# 若小于1，赋值t1
#	addi t1, t1, 1			# t1 = t1 + 1
#	addi a0, a0, -1			# a0 = a0 - 1
#	j One_Loop
#Out_One:
	add t2, a0, t2 			# t2 = t1 + t2
	slli t2, t2, 16			# t2 = t2 >> 16
	
	add a7, t2, a6			# t2 = t2 + a6
	j DisPlay		# 调用DisPlay_10
#############################################
#############################################
	
Zero:
	add a7, zero,zero
	j DisPlay
##
# ADD a1.a2 op a4.a5
##
#############################################
#############################################
Add:
	add a6, a2, a5 			# a0 = a2 + a5
	li t1,10
	blt a6, t1, NotOverFlow 	# 若小数部分不超过10，则不进位
	add a0, a1, a4 			# 否则将进位加到整数部分
	addi a0, a0, 1			# a6 = a6 + 1，且a6为整数部分之和
	addi a6, a6, -10		# a0 = a0 - 10，且a0为小数部分之和
NotOverFlow:				# 若不进位，则直接进行整数相加
	add a0, a0, zero  			# a0 = a1 + a2 # no carry save
	j Hex_To_10
##
# a0,a6 is the answer but they are hex
##
#############################################
#############################################
#############################################
Sub:
	blt a1, a4, NotSubOverFlow	# 若a2 < a5，则直接减
	bne a1, a4, sign_neq 		# not equal

	blt a2, a5, sign		# 进一步判断更大的数
	sub a7, a2, a5 			# a7 = a2 - a5
	j Hex_To_10

sign:
	sub a7, a5, a2 			# a7 = a5 - a2
	j Hex_To_10

sign_neq:
	sub a0, a1, a4 			# a0 = a2 - a5
	bge a2, a5, sign_borrow	# 判断是否需要借位
	addi a2, a2, 10			# a2 = a2 + 10
	addi a0, a0, -1			# a0 = a0 - 1
sign_borrow:
	sub a6, a2, a5 			# a6 = a2 - a5
	j Hex_To_10

NotSubOverFlow:				
	sub a0, a4, a1 			# a0 = a2 - a5
	bge a5, a2, borrow_sign	# 判断是否需要借位
	addi a5, a5, 10			# a2 = a2 + 10
	addi a0, a0, -1			# a0 = a0 - 1
borrow_sign:
	sub a6, a5, a2 			# a6 = a2 - a5
	j Hex_To_10
#############################################
##
#这里的a1.a2是第一个操作数operand1
##
#############################################
Mul:
	slli s4, a4, 4			# s4 = a5 << 4
	add s4, s4, a5			# s4 = a4 << 4 + a5
							# 此时的s4存储operand2的无符号整数
Loop_for_mul:
	beq s4, zero, Exit_for_mul	# 判断是否结束
	slli a2, a2, 1			# a2 = a2 << 1
	slli a1, a1, 1			# a1 = a1 << 1	这里将小数和整数部分都左移一位
	addi s4, s4, -1			# s4 = s4 - 1	记录循环次数
	jal Loop_for_mul

Exit_for_mul: 				# 处理小数进位
	add t0, zero, zero		# t0 = 0
	addi t1, zero, 10     	# t1 = 10
Get_Decimal:
	blt a2, t1, Out_Get_Decimal	# 若小数部分小于10，则直接获取
	addi t0, t0, 1			# 否则将进位加到整数部分
	addi a2, a2, -10		# a2 = a2 - 10，且a2为小数部分之和
	jal Get_Decimal
Out_Get_Decimal:
	add a0, a1, t0			# a1 = a1 + t0
	add a6, a2, zero		# a6 = a2
	jal Hex_To_10
#############################################
Div:
	slli s4, a4, 4			# s4 = a5 << 4
	add s4, s4, a5			# s4 = a4 << 4 + a5
							# 此时的s4存储operand2的无符号整数
Loop_for_Div:
	beq s4, zero, Exit_for_Div	# 判断是否结束

	andi t0, a1, 0x01		# t0 = a1 & 0x1	# 判断整数最后一位是否为1
	andi t1, a2, 0x01		# t1 = a2 & 0x1	# 判断小数最后一位是否为1
	srli a2, a2, 1			# a2 = a2 >> 1	
	srli a1, a1, 1			# a1 = a1 >> 1	这里将小数和整数部分都右移一位

	addi s4, s4, -1			# s4 = s4 - 1	记录循环次数
	beq t0, zero, Not_Decimal_plus  #若整数最后一位为1，小数部分加0.5
	addi a2, a2, 5			# a2 = a2 + 0.5
Not_Decimal_plus:
	beq t1, zero, NotDivOverFlow	# 若小数最后一位为1，则进一位
	addi a2, a2, 1 			# a2++
NotDivOverFlow:
	jal Loop_for_Div

Exit_for_Div: 				
	add a0, a1, zero		# a1 = a1
	add a6, a2, zero		# a6 = a2
	jal Hex_To_10

#############################################

Random:
	bne s4, zero, Not_Init
	slli s2, a1, 28			# 
	slli s3, a2, 24			# 
	add s2, s3, s2			# 
	slli s3, a4, 20
	add s2, s3, s2			# 
	slli s3, a5, 16
	add s2, s3, s2			# 
	slli s3, a1, 12
	add s2, s3, s2			# 
	slli s3, a2, 8
	add s2, s3, s2			# 
	slli s3, a4, 4
	add s2, s3, s2			# 
	add s2, a5, s2			# 这里将s2设置为{A，B，A，B}
	addi s4, zero, 1			# s4 = s4 + 1
	
Not_Init:
#############################################
#####接下来获取0，1，21，31位
#############################################

	andi t0, s2, 0x01			# t0 = s2 & 0x1	获取第0位
	srli s3, s2, 1 			    # 获取第1位
	andi t1, s3, 0x01
	xor t1, t0, t1			    # t1 = s2 & 0x1 | (s2 >> 1) & 0x1 将第1位和第0位异或
	srli s3, s2, 21			    # 获取第21位
	andi t0, s3, 0x1		    # t0存储第21位
	xor t1, t0, t1			    # t1 = s2 & 0x1 | (s2 >> 1) & 0x1 | (s2 >> 21) & 0	将t1和t0异或
	srli s3, s2, 31				# t0 = s2 >> 31
	andi t0, s3, 0x01			# t0 = s2 & 0x1	获取第0位
	xor t1, t0, t1			    # t1此时储存下一个随机数

############################################
####### 	接下来执行移位操作	##############
############################################

	srli s2, s2, 1			# s2 = s2 >> 1
	slli t1, t1, 31
	add s2, s2, t1
	add a7, s2, zero
	j DisPlay

Exit:

