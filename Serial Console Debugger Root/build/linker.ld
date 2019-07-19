ENTRY(__start)

SECTIONS
{
    . = 0x8000;
    __start = .;
    /* Symbol __text_start defines the start of the executable code */
    __text_start = .;
    /* .text : starts the section where the executable code is placed 
    Note the curly parentheses after the section name */
    .text :
    {
        /* KEEP tells the linker that the boot script file should not be optimized
           This line of code is only required for the text section /*
        KEEP(*(.text.boot));
        /* The following line of code tells the linker to place all .text components 
           from the object files here */
        *(.text);
        /* To align the section to a 4KB block, the align keyword is used */
        . = ALIGN(4096);
    }
    /* Symbol __text_end defines the end of the executable code section */
    __text_end = .;
}