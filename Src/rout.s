
	.syntax unified
	.cpu cortex-m4
	.thumb

	.global EnableInterrupts
	.global DisableInterrupts
	.global WaitForInterrupt
	.global CallSVC
	.global ChangeStack
	.global Change2MainStack
	.global Get_psp_addr


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

	.align 2
	.type CallSVC, %function
CallSVC:
	svc #1
	bx lr


	.type ChangeStack, %function
ChangeStack:
	mrs r0, control
	mov r1, sp      @ if this is called in thread mode stack is still main
					@ but what when this routine called in handler mode?!?!
					@

	sub r1, #1024   @ it will be thread stack address

	orr r0, #2
	msr control, r0  @ from now thread mode will use PSP
	isb
	mov sp, r1       @ assuming we are in thread mode it sets PSP stack
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

	.type Get_psp_addr, %function
Get_psp_addr:
	mrs r0, psp
	bx lr
