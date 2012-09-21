#ifndef _LUADEFS_H_
#define _LUADEFS_H_

#define BUFSIZ		0x1FFF
#define EXIT_FAILURE	1
#define EXIT_SUCCESS	0

// Don't need fflush in u-boot
#define fflush(a)	((void *)0)

#endif /* _LUADEFS_H_ */
