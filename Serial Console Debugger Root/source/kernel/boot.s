
// This is a comment in an ARM assembly source file
// The following line defines that the following assembly code will
// be placed in the .text.boot section, specified in the linker file
.section ".text.boot"
// The following line declares the _start is global variable - it is
// visible from outside of the assembly file
.global _start

_start:
    // Read data from the multiprocessor affinity register (CP15) and
    // stores the result into register r1. Contains info about multiprocessors.
    mrc p15, #0, r1, c0, c0, #5
    // 3 AND with contents in r1, store result back to r1
    and r1, r1, #3
    // Check if result in register r1 is 0
    cmp r1, #0
    // Branch to 'halt' on result not equal to zero
    bne halt
    // Set the stack pointer to 0x8000 by moving 0x8000 to 'sp'
    mov sp, #0x8000
   // Set the register r4 to the start of the bss segment
    ldr r4, =__bss_start
    // Set the register r9 to the end of the bss segment
    ldr r9, =__bss_end
    // Set the registers r5 - r8 to zero
    mov r5, #0
    mov r6, #0
    mov r7, #0
    mov r8, #0
    // Branch to forward to label 2
    b       2f

1:
    // Store the consecutive values from registers r5 - r8 back into r4
    stmia r4!, {r5-r8}

2:
    // Subtract the address value in register r9 from the address value in register r4
    // The condition flags are updated with the result, result is not stored in a register
    cmp r4, r9
    // Branch backwards to label 1 if previous result is < 0
    blo 1b
    // Move the address value 0x100 to register r2
    mov r2, #0x100
    // load register r3 with the address of kernel_main (main function in c source file)
    ldr r3, =kernel_main
    // Branch to the address contained in register r3
    blx r3
    // Branch to label halt
    b halt

halt:
    // Wait for event
    wfe
    // branch to label halt
    b halt    