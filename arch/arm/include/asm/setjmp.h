#ifndef __ASM_ARM_SETJMP_H
#define __ASM_ARM_SETJMP_H

#include <config.h>

/**
 * v1 - v7, fp, ip, sp, lr
 */

typedef int mp_buf[11];

extern int	setjmp(jmp_buf env);
extern int	longjmp(jmp_buf env, int value);

#endif
