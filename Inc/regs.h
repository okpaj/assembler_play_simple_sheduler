/*
 * regs.h
 *
 *  Created on: Dec 8, 2023
 *      Author: Uzytkownik
 */

#ifndef REGS_H_
#define REGS_H_

#include <stdint.h>

#define RCC_BASE    ((volatile void *)(0x40023800))
#define GPIOA_BASE  ((volatile void *)(0x40020000))
#define EXTI_BASE   ((volatile void *)(0x40013C00))
#define SYSCFG_BASE ((volatile void *)(0x40013800))

#define NOT_RESOLVED_ 666

struct RCC_t {
	uint32_t r[12];
	uint32_t AHB1ENR;

} volatile * RCC = RCC_BASE;

struct GPIO_t {
	uint32_t MODER;
	uint32_t OTYPER;
	uint32_t OSPEEDR;
	uint32_t PUPDR;
	uint32_t IDR;
	uint32_t ODR;
	uint32_t BSRR;
} volatile * GPIOA = GPIOA_BASE;

struct EXTI_t {
	uint32_t IMR;
	uint32_t EMR;
	uint32_t RTSR;
	uint32_t FTSR;
	uint32_t SWIER;
	uint32_t PR;
} volatile * EXTI = EXTI_BASE;

struct SYSCFG_t {
	uint32_t MEMRMP;
	uint32_t PMC;
	uint32_t EXTICR[4];
	uint32_t notused1[2];
	uint32_t CMPCR;
} volatile * SYSCFG = SYSCFG_BASE;



#endif /* REGS_H_ */
