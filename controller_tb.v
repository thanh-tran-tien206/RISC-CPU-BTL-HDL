`timescale 1ns / 1ps

module controller_tb;
    // Tin hieu dau vao (Inputs)
    reg clk;
    reg rst;
    reg [2:0] opcode;
    reg is_zero;

    // Tin hieu dau ra (Outputs)
    wire sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e;
    wire [2:0] debug_state;

    // Khoi tao don vi can kiem tra (UUT)
    controller uut (
        .clk(clk), .rst(rst), .opcode(opcode), .is_zero(is_zero), 
        .sel(sel), .rd(rd), .ld_ir(ld_ir), .halt(halt), 
        .inc_pc(inc_pc), .ld_ac(ld_ac), .ld_pc(ld_pc), 
        .wr(wr), .data_e(data_e), .debug_state(debug_state)
    );

    // Tao xung Clock chu ky 10ns
    always #5 clk = ~clk;

    initial begin
        // Khoi tao ban dau
        clk = 0; rst = 1; opcode = 3'b000; is_zero = 0;
        
        // Giai doan Reset
        #15 rst = 0;

        // --- Kich ban 1: Kiem tra chu ky Fetch va lenh HALT ---
        @(posedge clk); // INST_ADDR 
        @(posedge clk); // INST_FETCH 
        @(posedge clk); // INST_LOAD 
        @(posedge clk); // IDLE 
        opcode = 3'b000; 
        @(posedge clk); // OP_ADDR -> halt se len 1 
        
        // --- Kich ban 2: Lenh ADD/LOAD (opcode 010) ---
        rst = 1; #10 rst = 0; 
        opcode = 3'b010; 
        wait(debug_state == 3'd6); // ALU_OP: rd = 1 
        #10;
        wait(debug_state == 3'd7); // STORE: ld_ac = 1 
        #10;

        // --- Kich ban 3: Lenh STORE (opcode 110) ---
        opcode = 3'b110;
        wait(debug_state == 3'd7); // STORE: wr = 1, data_e = 1

        #50;
        $stop; 
    end
      
    initial begin
        $monitor("Time=%0t | State=%d | Opcode=%b | Halt=%b | Rd=%b | Wr=%b | Ld_AC=%b", 
                 $time, debug_state, opcode, halt, rd, wr, ld_ac);
    end
endmodule
