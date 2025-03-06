/**
 */
#include <stdint.h>
#include "../include/asm.h"


static void init(void);


/**
*/
void main(void)
{
    // TODO デバイスの初期化
    init();

    while(1)
    {
        NOP();
    }
}



/**
 */
static void init(void)
{
}
