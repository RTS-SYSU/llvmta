ENTRY(main)

SECTIONS
{
   /DISCARD/ : { *(.ARM.attributes) }
   /DISCARD/ : { *(.debug_line) }
   /DISCARD/ : { *(.debug_frame) }
   /DISCARD/ : { *(.debug_info) }
   /DISCARD/ : { *(.debug_abbrev) }
   /DISCARD/ : { *(.debug_aranges) }
   /DISCARD/ : { *(.debug_ranges) }
   /DISCARD/ : { *(.debug_str) }
   /DISCARD/ : { *(.debug_loc) }
   /DISCARD/ : { *(.debug_macinfo) }
   /DISCARD/ : { *(.debug_pubnames) }
   /DISCARD/ : { *(.debug_pubtypes) }
   /DISCARD/ : { *(.comment) }
   /DISCARD/ : { *(.ARM.exidx) }
   /DISCARD/ : { *(.eh_frame) }
   .text : { *(.text); . = ALIGN(4); }
   .data : { *(.data); . = ALIGN(4); }
   .rodata : { *(.rodata); . = ALIGN(4); }
   .rodata.cst8 : { *(.rodata.cst8); . = ALIGN(4); }
   .rodata.str1.1 : { *(.rodata.str1.1); . = ALIGN(4); }
   .bss : { *(.bss); . = ALIGN(4); }
}
