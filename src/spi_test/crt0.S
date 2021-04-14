.global main

  .section ".text.init"
  .globl Reset_Handler
  .type Reset_Handler, %function
Reset_Handler:
.option push
.option norelax
    la      gp, __global_pointer$
.option pop
    la      sp, __stack_top
    csrw    mscratch, sp

    jal     main

    .size   Reset_Handler, . - Reset_Handler

__exit:
    j      __exit
