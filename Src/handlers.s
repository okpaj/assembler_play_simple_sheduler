
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

	.type PendSV_Handler, %function
PendSV_Handler:

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

