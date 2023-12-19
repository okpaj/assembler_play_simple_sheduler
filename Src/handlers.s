
	.syntax unified
	.cpu cortex-m4
	.thumb

	.global SVC_Handler
	.global NMI_Handler
  	.global HardFault_Handler
  	.global	MemManage_Handler
  	.global BusFault_Handler
  	.global	UsageFault_Handler
	.global PendSV_Handler

	@.extern _estack

	.type SVC_Handler, %function
SVC_Handler:

@	mrs r1, control
@	orr r1, #1 			@ sets thread in nonprivilege mode
@	orr r1, #2			@ sets thread use PSP stack
@	msr control, r1
@	isb
	msr psp, r0
	bx lr


	@

	.type PendSV_Handler, %function
PendSV_Handler:

	ldr r0, =prev_task_psp	@ loads address of variable prev_task_psp
	ldr r0, [r0]			@ loads address pointed by prev_task_psp
	cbz r0, PendSV_next_task  @ intial run if psp == 0, no prev task to save regs

	ldr r1, [r0]     		@ load stack pointer to r1

	@mrs r1, psp			    @  in fact not needed as we already have psp in r1
	stmdb r1!, {r4-r11}    @ save regs on stack
	str r1, [r0]			@ save new stack pointer (r1) in  *prev_task_psp

PendSV_next_task:

	ldr r0, =next_task_psp  @ loads pointer to next task's psp
	ldr r0, [r0]
	ldr r1, [r0]

	ldmia r1!, {r4-r11}    @ restore registers
	str r1, [r0]           @ save psp in *next_task_psp
	msr psp, r1            @ change stack to new task

	bx lr


	.type NMI_Handler, %function
NMI_Handler:
	bl .

	.type HardFault_Handler, %function
HardFault_Handler:
	bl .

	.type MemManage_Handler, %function
MemManage_Handler:
	bl .

	.type BusFault_Handler, %function
BusFault_Handler:
	bl .

	.type UsageFault_Handler, %function
UsageFault_Handler:
	bl .

