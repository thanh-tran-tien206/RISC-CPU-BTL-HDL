`timescale 1ns / 1ps

module tb_controller();
    // Khai bao cac tin hieu ket noi voi Module Controller
    reg clk;
    reg rst;
    reg [2:0] opcode;
    reg is_zero;
    
    wire sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e;
    wire [2:0] debug_state;

    // Khoi tao Unit Under Test (UUT)
    controller uut (
        .clk(clk), 
        .rst(rst), 
        .opcode(opcode), 
        .is_zero(is_zero),
        .sel(sel), 
        .rd(rd), 
        .ld_ir(ld_ir), 
        .halt(halt), 
        .inc_pc(inc_pc), 
        .ld_ac(ld_ac), 
        .ld_pc(ld_pc), 
        .wr(wr), 
        .data_e(data_e), 
        .debug_state(debug_state)
    );

    // Dinh nghia Opcode giong nhu trong module Controller
    localparam HLT=3'b000, SKZ=3'b001, ADD=3'b010, STO=3'b110, JMP=3'b111;

    
    always #5 clk = ~clk;

    initial begin
        // --- BUOC 0: Khoi tao he thong ---
        clk = 0; rst = 1; is_zero = 0; opcode = HLT;
        #15 rst = 0; // Tha reset sau 1.5 chu ky clock

        // --- BUOC 1: Kiem tra lenh ADD (Tinh toan) ---
        // Ky vong: ld_ac phai bat o buoc STORE (State 7)
        opcode = ADD; 
        $display("Time=%0t | Bat dau lenh ADD", $time);
        repeat (8) @(posedge clk); 

        // --- BUOC 2: Kiem tra lenh SKZ khi ket qua truoc do bang 0 ---
        // Ky vong: inc_pc phai bat 2 lan (State 6 va State 7)
        opcode = SKZ; is_zero = 1;
        $display("Time=%0t | Bat dau lenh SKZ (Zero=1)", $time);
        repeat (8) @(posedge clk);

        // --- BUOC 3: Kiem tra lenh STO (Ghi bo nho) ---
        // Ky vong: wr va data_e phai bat o buoc STORE (State 7)
        opcode = STO; is_zero = 0;
        $display("Time=%0t | Bat dau lenh STO", $time);
        repeat (8) @(posedge clk);

        // --- BUOC 4: Kiem tra lenh JMP (Nhay dia chi) ---
        // Ky vong: ld_pc phai bat o State 6 va 7
        opcode = JMP;
        $display("Time=%0t | Bat dau lenh JMP", $time);
        repeat (8) @(posedge clk);

        // --- BUOC 5: Kiem tra lenh HLT (Dung he thong) ---
        opcode = HLT;
        $display("Time=%0t | Bat dau lenh HLT", $time);
        repeat (8) @(posedge clk);

        #50;
        $display("Mo phong ket thuc thanh cong!");
        $finish;
    end

   
    initial begin
        $monitor("T=%4t | State=%d | Op=%b | Halt=%b | IncPC=%b | LdAC=%b | Wr=%b", 
                 $time, debug_state, opcode, halt, inc_pc, ld_ac, wr);
    end

endmodule