
	.syntax unified
	.cpu cortex-m4
	.thumb

	.global EnableInterrupts
	.global DisableInterrupts
	.global WaitForInterrupt
	.global CallSVC

	.global ChangeStack
	@.global Change2MainStack

	.global Get_PSP
	.global Set_PSP

	.global RegsToStack
	.global StackToRegs

	.global CallBarriers

	.global get_svc_type


	.type CallBarriers, %function
CallBarriers:
	isb
	dsb
	bx lr

	@
	@ uint32_t RegsToStack(void);
	@ callee saved registers to current process stack = PSP
	@ returns stack pointer after saving registers
	@ called in Handler
	@
	.type RegsToStack, %function
RegsToStack:
	mrs r0, psp
	stmdb r0!, {r4 - r11}
	bx lr


	@ void StackToRegs(uint32_t sp);
	.type StackToRegs, %function
StackToRegs:
	ldmia r0!, {r4-r11}
	msr psp, r0
	bx lr

	@ r0 = in par 1 = psp value to set
	@ returns nothing
	@ void Set_PSP(uint32_t new_psp)

	.type Set_PSP, %function
Set_PSP:
	msr psp, r0
	bx lr

	@ no argument
	@ returns uint32 = proces stack pointer PSP content
	@ uint32_t Get_psp_addr(void)

	.type Get_PSP, %function
Get_PSP:
	mrs r0, psp
	bx lr

	@.extern _estack

	.type EnableInterupts, %function
EnableInterrupts:
	cpsie i
	bx lr

	.type DisableInterrupts, %function
DisableInterrupts:
	cpsid i
	bx lr


	.type WaitForInterrupt, %function
WaitForInterrupt:
	wfi
	bx lr


	@ just calls SVC
	@ no arguments, no return value
	@ void CallSVC(void)

	.align 2
	.type CallSVC, %function
CallSVC:
	svc #1
	bx lr

	@ input value of psp
	@ output none
	@ void ChangeStack(uint32_t psp)

	.type ChangeStack, %function
ChangeStack:
	mrs r1, control
	@mov r0, sp      @ if this is called in thread mode stack is still main
					@ but what when this routine called in handler mode?!?!
					@

	@ sub r1, #1024   @ it will be thread stack address

	orr r1, #2
	msr control, r1  @ from now thread mode will use PSP
	isb
@	msr psp, r0       @ assuming we are in thread mode it sets PSP stack
					 @ TODO - verify beheviour of routine depending on
					 @ is this called in Handler
	bx lr

	.type Change2MainStack, %function
Change2MainStack:
	mrs r0, control
	@mvn r1, #2
	bic r0, #2
	msr control, r0
	isb
	bx lr


	@ uint8_t get_svc_type(void)
	@ extracts and returns svc number from psp stack
	@ arg - defines stack on which operate
	@ 0 means main stack
	@ 1 means process stack

	.type get_svc_type, %function
get_svc_type:
	@tst r0, r0
	@ite eq
	@mrseq r0, msp
	@mrsne r0, psp
	mrs r0, psp			    @ load stack pointer of interrupted thread

	ldr r1, [r0, #(6*4)]	@ load PC from thread stack => OK

@	ldr r2, [r1, #-4]		@ load instruction before interrupt -> somehow
							@ this offset is not proper, very close but not
							@ in DF## (svc ##) instruction.
							@ Maybe -4 is working in ARM mode for all instructions
							@ being 32 bit. But for CM offset and PC is differnt
							@ depending on size of instruction
	ldr r0, [r1, #-2]  		@ OK Loads svc#imm (it it 16 bit instruction)
					   		@ into lower half of register
	mov r1, #0xf
	and r0, r1				@ only #imm in r0

	bx lr
