/*
 * regs.h
 *
 *  Created on: Dec 8, 2023
 *      Author: Uzytkownik
 */

#ifndef REGS_CORE_H_
#define REGS_CORE_H_

#include <stdint.h>

#define ACTLR_BASE  ((volatile void *)(0xE000E008))
#define STK_BASE    ((volatile void *)(0xE000E010))
#define NVIC_BASE   ((volatile void *)(0xE000E100))
#define SCB_BASE    ((volatile void *)(0xE000ED00))
#define FAC_BASE    ((volatile void *)(0xE000ED88))
#define MPU_BASE    ((volatile void *)(0xE000ED90))
#define STIR_BASE   ((volatile void *)(0xE000EF00))
#define FPU_BASE    ((volatile void *)(0xE000EF30))

uint32_t volatile * ACTLR = ACTLR_BASE;

struct {
	uint32_t ISER[8];
	uint32_t notused1[24];
	uint32_t ICER[8];
	uint32_t notused2[24];
	uint32_t ISPR[8];
	uint32_t notused3[24];
	uint32_t ICPR[8];
	uint32_t notused4[24];
	uint32_t IABR[8];
	/*
	uint32_t notused5[NOT_RESOLVED_];
	uint32_t STIR;
	*/
} volatile * NVIC = NVIC_BASE;

struct STK_t {
	uint32_t CTRL;
	uint32_t LOAD;
	uint32_t VAL;
	uint32_t CALIB;
} volatile * STK = STK_BASE;

struct SCB_t {
	uint32_t CPUID;
	uint32_t ICSR;
	uint32_t VTOR;
	uint32_t AIRCR;
	uint32_t SCR;
	uint32_t CCR;
	uint32_t SHPRx[3];
	uint32_t SHCSR;
	/* others follows */
} volatile * SCB = SCB_BASE;



#endif /* REGS_H_ */
