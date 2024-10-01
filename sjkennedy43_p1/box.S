.section .text
.global     box
box:
    // standard entry: save link and stack frame registers

    //    load the stack frame with the pointer to current frame
    stp     x29, x30, [sp, -16]!

    // Save the arguments.  Called functions may overwrite x0-x3
    sub     sp, sp, 32
    stp     x0, x1, [sp]
    stp     x2, x3, [sp, 16]

    // sr in w0, sc in w1, er int w2, ec in w3
    
    // Make sure the argument are valid

    bl      _box_check_box_ ;//assuming that box check box is going to access parameters from the inital function call from box
    cmp     w0, 0
    bne     _box_error_

 
    // first, draw the corners:
    // +        +
    // +        +
    ldp     x0, x1, [sp]
    ldp     x2, x3, [sp, 16]
    bl      _box_draw_corners_

    // Now, draw the top and bottom:
    // +------+
    // +------+

    // You figure out what goes here
    LDP X0, X1, [SP]
    LDP X2, X3, [SP, 16]
    BL _box_draw_top_and_bottom_

    // draw left and right sides

    // You figure out what goes here
    LDP X0, X1, [SP]
    LDP X2, X3, [SP, 16]
    BL _box_draw_right_left_

    mov     w0, 0
    b       _box_exit_

_box_error_:
    mov     w0, 1

_box_exit_:
    add     sp, sp, 32  ; // pop save arg regs
    ldp     x29, x30, [sp], 16
    ret
_box_check_box_: 
    STP x29, X30, [SP, -16]! //set up frame pointer and stack pointer

    SUB SP, SP, 32      // make space for our original parameters
    STP X0, X1, [SP] // sr, sc
    STP X2, X3, [SP, 16] // er, ec

    MOV X6, X0 // save X0 since its about to get changed a lot 

    SUB SP, SP, 16  // make space for the return
    BL term_txtheight // save height into X4
    MOV X4, X0      // X0 is going to be changed ecause of the next  function call so save into X4
    ADD SP, SP, 16   // restore stack pointer

    SUB SP, SP, 16  // make space for the return
    BL term_txtwidth // save width into X5 (just for logical consistency and being able to keep it straight in my head)
    MOV X5, X0      // save width into X5
    ADD SP, SP, 16  // restore stack pointer

    CMP W2, W4 // if end row is >= max width 
    BGE _box_check_box_error_ // return error

    CMP W3, W5  // if end column is >= max height
    BGE _box_check_box_error_ // return error

    CMP W2, W6 // if end_row is <= start_row
    BLE _box_check_box_error_ // return error

    CMP W3, W1 // if end_col is <= start_col
    BLE _box_check_box_error_ // return error

    ADD SP, SP, 32
    LDP X29, X30, [SP], 16 //load tehm back to working order 
    MOV W0, 0
    RET
_box_check_box_error_:
    ADD SP, SP, 32
    LDP X29, X30, [SP], 16 //load tehm back to working order 
    MOV W0, 1
    ret

_box_draw_corners_:
    STP X29, X30, [SP, -16]! //set up stack frame and frame pointer

    SUB SP, SP, 32  
    STP X0, X1, [SP]
    STP X2, X3, [SP, 16] // save sr, sc, er, ec

    LDR W0, [SP]        // move sr into first parameter
    LDR W1, [SP, 8]     // move sc into second parameter
    MOV W2, '+'         // move '+' into third parameter
    SUB SP, SP, 16
    BL putc_to          // putc_to(start_row, start_column, '+'); 
    ADD SP, SP, 16

    LDR W0, [SP]        // start row first parameter
    LDR W1, [SP, 24]    // end column second parameter
    MOV W2, '+'         // '+' third parameter
    SUB SP, SP, 16
    BL putc_to          // putc_to(start_row, end_column, '+');
    ADD SP, SP, 16

    LDR W0, [SP, 16]    // end row first parameter
    LDR W1, [SP, 8]     // start column second parameter
    MOV W2, '+'         // '+' third parameter
    SUB SP, SP, 16
    BL putc_to          // putc_to(end_row, start_column, '+');
    ADD SP, SP, 16

    LDR W0, [SP, 16]    // end row first parameter
    LDR W1, [SP, 24]    // end column second parameter 
    MOV W2, '+'         // '+' third parameter
    SUB SP, SP, 16
    BL putc_to          // putc_to(end_row, end_column, '+');
    ADD SP, SP, 16

    ADD SP, SP, 32      // cleanup original parameters
    LDP X29, X30, [SP], 16// cleanup

    MOV W0, 0
    RET

_box_draw_top_and_bottom_:
    STP X29, X30, [SP, -16]! // set up stack frame

    SUB SP, SP, 32      // save all original parameters
    STP X0, X1, [SP]
    STP X2, X3, [SP, 16]
// set up the top row
    LDR W0, [SP] // move start row into W0
    LDR W4, [SP, 8]
    ADD W1, W4, 1 // move start column + 1 into W1
    MOV W2, '-' // move '-' into W2
    LDR W3, [SP, 24] // load the end column
_box_top_loop_:
    CMP W1, W3          //compare the start row with the end column of the loop
    BGE _box_bottom_line_ // branch to box bottom line if W1 becomes greater than or equal to W3 basically a for loop 
    
    SUB SP, SP, 32      // get the stack ready to preserve the three parameters
    STR W0, [SP, 8]     // Save start row
    STR W1, [SP, 16]    // Save advancing column
    STR W2, [SP, 24]    // Save '-'
    BL putc_to              // putc_to(start_row, advance_column, '-');
    LDR W0, [SP, 8]     // Load the Start Row into W0
    LDR W1, [SP, 16]    // Load the Advancing Column into W1
    LDR W2, [SP, 24]    // Load '-'
    ADD SP, SP, 32      // release what was within the stack

    ADD W1, W1, 1       // start_row++
    B _box_top_loop_    // jump back up
_box_bottom_line_:
    LDR W0, [SP, 16]    // move end row into W0
    LDR W4, [SP, 8]
    ADD W1, W4, 1       // move start column + 1 into W1
    MOV W2, '-'         // move '-' into W2 (redundant but helps with visual consistency)
    LDR W3, [SP, 24]    // move end column - 1 into W3
_box_bottom_loop_:
    CMP W1, W3          // compare the end row with the end column of the loop
    BGE _box_draw_top_and_bottom_exit_ // leave the loop
    
    SUB SP, SP, 32      // get the stack ready to preserve the three parameters
    STR W0, [SP, 8]     // Save end row
    STR W1, [SP, 16]    // Save advancing column
    STR W2, [SP, 24]    // Save '-'
    BL putc_to              // putc_to(end_row, advance_column, '-');
    LDR W0, [SP, 8]     // Load the End Row into W0
    LDR W1, [SP, 16]    // Load the Advancing Column into W1
    LDR W2, [SP, 24]    // Load '-'
    ADD SP, SP, 32      // release what was within the stack

    
    ADD W1, W1, 1       // advance_column++
    B _box_bottom_loop_ // jump back up
_box_draw_top_and_bottom_exit_:
    ADD SP, SP, 32          // cleanup
    LDP X29, X30, [SP], 16

    MOV W0, 0
    RET

_box_draw_right_left_:
    STP X29, X30, [SP, -16]!    //set up frame pointer

    SUB SP, SP, 32
    STP X0, X1, [SP]        // sr in sp, sc in sp8
    STP X2, X3, [SP, 16] // er in sp16, ec in sp24 save everything possible 
    
    LDR W4, [SP]        // set up Start Row + 1 to be in W0
    ADD W0, W4, 1
    LDR W1, [SP, 8]     // Keep start Column in W1
    MOV W2, '|'         // Keep character in W2
    LDR W3, [SP, 16]    // Go until End Row - 1 and keep that in W3
    //SUB W3, W4, 1
_box_draw_right_side_loop:
    CMP W0, W3          // Compare Start Row against the End Row
    BGE _box_left_side_ // Make sure you go until Start Row >= End Row

    SUB SP, SP, 32
    STR W0, [SP, 8]     // Save Advancing Row into stack
    STR W1, [SP, 16]    // Save Start Column into stack
    STR W2, [SP, 24]    // Save '|' into stack
    BL putc_to          // putc_to(advance_row, start_column, '|')
    LDR W0, [SP, 8]     // Load Advancing Row into W0
    LDR W1, [SP, 16]    // Load Start Column into W1
    LDR W2, [SP, 24]    // Load '|' into W1
    ADD SP, SP, 32

    ADD W0, W0, 1       // increment Advancing row
    B _box_draw_right_side_loop // Loop agian in the for loop
_box_left_side_:
    LDR W4, [SP]        // Set up Start Row + 1 to be in W0
    ADD W0, W4, 1
    LDR W1, [SP, 24]    // Keep End Column in W1
    MOV W2, '|'        // Keep character in W2 (redundant but good for visual consistency)
    LDR W3, [SP, 16]    // Go until End Row - 1 and keep that in W3
    //SUB W3, W4, 1       
_box_draw_left_side_loop:
    CMP W0, W3          // Compare Start Row Against End Row
    BGE _box_right_left_exit_ // leave the loop

    SUB SP, SP, 32
    STR W0, [SP, 8]     // Save advancing row into stack
    STR W1, [SP, 16]    // Save End Column into stack
    STR W2, [SP, 24]    // Save '|' into stack
    BL putc_to              // putc_to(Advance_row, end_column, '|');
    LDR W0, [SP, 8]     // Load advance row into W0
    LDR W1, [SP, 16]    // Load End Column into W1
    LDR W2, [SP, 24]    // Load '|' into W2
    ADD SP, SP, 32      

    ADD W0, W0, 1       // advance to the next row
    B _box_draw_left_side_loop // jump back up
_box_right_left_exit_:
    ADD SP, SP, 32      // cleanup
    LDP X29, X30, [SP], 16

    MOV W0, 0
    RET