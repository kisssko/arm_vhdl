/* Simple startup file for Cortex-M3:
 * https://jacobmossberg.se/posts/2018/08/11/run-c-program-bare-metal-on-arm-cortex-m3.html#arm-cortex-m3-boot-sequence
 */
 
 /* Thumb-2 instructions are only supported in unified syntax mode */
 .syntax unified
 
/* Vector table definition */
 .section ".cs3.interrupt_vector"
 .long  __cs3_stack                 /* Top of Stack                 */
 .long  Reset_Handler               /* Reset Handler                */
 .long  NMI_Handler                 /* NMI Handler                  */
 .long  HardFault_Handler           /* Hard Fault Handler           */
 .long  MemManage_Handler           /* MPU Fault Handler            */
 .long  BusFault_Handler            /* Bus Fault Handler            */
 .long  UsageFault_Handler          /* Usage Fault Handler          */
 .long  0                           /* Reserved                     */
 .long  0                           /* Reserved                     */
 .long  0                           /* Reserved                     */
 .long  0                           /* Reserved                     */
 .long  SVC_Handler                 /* SVCall Handler               */
 .long  DebugMon_Handler            /* Debug Monitor Handler        */
 .long  0                           /* Reserved                     */
 .long  PendSV_Handler              /* PendSV Handler               */
 .long  SysTick_Handler             /* SysTick Handler              */
 
/* Vendor specific interrupts
 *  ---- Not implemented
 */
 
 /* Program section */
 .section ".text"
 
 /* Declare as thumb function. Otherwise it will not be linked
 * correctly
 */
 .thumb_func
 /* Export the symbol so linker can see this */
 .global Reset_Handler
Reset_Handler:
 /* Jump to main(), a thumb function */
 LDR     R0, =main
 BX      R0
 /* If main() ever exit, this should hold MCU from running wild */
 B       .
 
/* This is how the lazy guy doing it: by aliasing all the
 * interrupts into single address
 */
.thumb_func
NMI_Handler:
.thumb_func
HardFault_Handler:
.thumb_func
MemManage_Handler:
.thumb_func
BusFault_Handler:
.thumb_func
UsageFault_Handler:
.thumb_func
SVC_Handler:
.thumb_func
DebugMon_Handler:
.thumb_func
PendSV_Handler:
.thumb_func
SysTick_Handler:
 B    . /* while(1); */
