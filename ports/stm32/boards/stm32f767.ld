/*
    GNU linker script for STM32F767
*/

/* Specify the memory areas */
MEMORY
{
    FLASH (rx)      : ORIGIN = 0x08000000, LENGTH = 1024K
    FLASH_ISR (rx)  : ORIGIN = 0x08000000, LENGTH = 32K     /* sector 0, 32K */
    FLASH_APP (rx)  : ORIGIN = 0x08008000, LENGTH = 2016K   /* sectors 1-11 3x32K 1*128K 7*256K */
    FLASH_FS (r)    : ORIGIN = 0x08008000, LENGTH = 96K     /* sectors 1, 2, 3 (32K each) */
    FLASH_TEXT (rx) : ORIGIN = 0x08020000, LENGTH = 896K    /* sectors 4-7 1*128Kib 3*256KiB = 896K */
    DTCM (xrw)      : ORIGIN = 0x20000000, LENGTH = 128K    /* Used for storage cache */
    ETH_RXDMA (rw)  : ORIGIN = 0x20020000, LENGTH = 256    /* 32 * 5 bytes for DMARxDscrTab in ethernetif.c */
    ETH_TXDMA (rw)  : ORIGIN = 0x20020100, LENGTH = 256    /* 32 * 5 bytes for DMATxDscrTab in ethernetif.c */
    RAM (xrw)       : ORIGIN = 0x20024000, LENGTH = 368K    /* SRAM1 = 368K, SRAM2 = 16K */
}

/* produce a link error if there is not this amount of RAM for these sections */
_minimum_stack_size = 2K;
_minimum_heap_size = 16K;


/* Ethernet DMA Descriptor table / buffer */
SECTIONS
{
    .RxDescripSection : { *(.DMARxDscrTab_section) } >ETH_RXDMA
    .TxDescripSection : { *(.DMATxDscrTab_section) } >ETH_TXDMA
}

/* Define tho top end of the stack.  The stack is full descending so begins just
   above last byte of RAM.  Note that EABI requires the stack to be 8-byte
   aligned for a call. */
_estack = ORIGIN(RAM) + LENGTH(RAM);

/* RAM extents for the garbage collector */
_ram_start = ORIGIN(RAM);
_ram_end = ORIGIN(RAM) + LENGTH(RAM);
_heap_start = _ebss; /* heap starts just after statically allocated memory */
_heap_end = 0x20078000; /* tunable */
