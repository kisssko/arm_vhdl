/*
 * Define the supported output formats - elf32-littlearm is the
 *  default
 */
OUTPUT_FORMAT("elf32-littlearm", "elf32-bigarm", "elf32-littlearm")
 
/* Define the target architecture */
OUTPUT_ARCH(arm)
 
/* Define the system entry point */
ENTRY(ISR_VECTORS)
 
/* Define the memory layout for the board */
SECTIONS
{
  /* text: test code section: Flash region of HC08 */
  . = 0x00000000;
  .text :
  {
    KEEP(*(.cs3.interrupt_vector));
    *obj/startup.o(.text)
    *obj/startup.o(.data)
    *(.text*)
  }

   /*.flash 0x00000000 :
   {
       KEEP(*(.cs3.interrupt_vector));
       *(.text .text.*);
       *(.rodata .rodata.*);
      __sidata = .;
   }*/
 

  /* data segment */
  .data : { *(.data) }


  /* bss segment */
  __bss_start__ = .;
  .bss : { *(.bss) }
  __bss_end__ = .;

  /* End of uninitalized data segement */
  _end = .;
 
  __cs3_stack = 0x20008000;
}
