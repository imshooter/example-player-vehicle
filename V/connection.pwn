#include <YSI_Coding\y_hooks>

/**
 * # Header
 */

static
    MySQL:handle
;

/**
 * # External
 */

stock MySQL:MySQL_GetHandle() {
    return handle;
}

/**
 * # Calls
 */

hook OnGameModeInit() {
    handle = mysql_connect("localhost", "root", "", "v");
    
    return 1;
}

hook OnGameModeExit() {
    mysql_close(handle);
    
    return 1;
}
