/*
 * Command for accessing DataFlash.
 *
 * Copyright (C) 2008 Atmel Corporation
 */
#include <common.h>

int do_lua(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	printf("Launching LUA: \n");
	lua_main(0, NULL);
	printf("done\n");
	
	return 0;
}

U_BOOT_CMD(
	lua,	1,	1,	do_lua,
	"lua interpreter",
	"");
