

MEMORY
    {
     /*ram (rw): ORIGIN = BASE, LENGTH = 1M*/
     ram (rw): ORIGIN = 0x40000, LENGTH = 1M
    }

SECTIONS
{
	.text : {} >ram
	.rodata :{} >ram
/*
    .text.start (0x40000) : {
        *(.text)
    }
    .data :
    {
        . = ALIGN(4);
        *(.data)
    }
*/
}
