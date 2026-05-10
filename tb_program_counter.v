`timescale 1ns / 1ps

module tb_program_counter();

    reg         clk;
    reg         rst;
    reg         ld_pc;
    reg         inc_pc;
    reg  [31:0] d_in;
    wire [31:0] pc_out;

    
    program_counter uut (
        .clk(clk),
        .rst(rst),
        .ld_pc(ld_pc),
        .inc_pc(inc_pc),
        .d_in(d_in),
        .pc_out(pc_out)
    );

    
    always #5 clk = ~clk;

    initial begin
       
        clk = 0; rst = 0; ld_pc = 0; inc_pc = 0; d_in = 32'b0;

        $display("------------------------------------------------------------");
        $display(" Thoi gian | rst | ld_pc | inc_pc |   d_in   |   pc_out");
        $display("------------------------------------------------------------");
        $monitor("%10t |  %b  |   %b   |    %b   | %h | %h", 
                 $time, rst, ld_pc, inc_pc, d_in, pc_out);

        //  Kiểm tra Reset
        #12; rst = 1;
        #10; rst = 0;

        // Kiểm tra tăng địa chỉ (inc_pc)
        #10; inc_pc = 1; // Tăng lên 1
        #10; inc_pc = 1; // Tăng lên 2
        #10; inc_pc = 0; // Dừng tăng, giữ giá trị 2

        //  Kiểm tra nạp địa chỉ nhảy (ld_pc)
        #10; d_in = 32'h0000_0ABC; ld_pc = 1;
        #10; ld_pc = 0; // Giữ giá trị 0ABC

        //  Kiểm tra tăng từ địa chỉ mới
        #10; inc_pc = 1;
        #10; inc_pc = 0; // Kỳ vọng: 0ABD

        //  Kiểm tra ưu tiên: Vừa nạp vừa tăng (ld_pc phải thắng)
        #10; d_in = 32'h0000_FFFF; ld_pc = 1; inc_pc = 1;
        #10; ld_pc = 0; inc_pc = 0; // Kỳ vọng: FFFF

        //  Reset về 0
        #10; rst = 1;
        #10; rst = 0;

        #20;
        $display("------------------------------------------------------------");
        $display("Hoan thanh mo phong Program Counter!");
        $finish;
    end

endmodule