`timescale 1ns / 1ps
module tb_CPU_System();
    reg clk, rst;
    wire halt;

    CPU_Top uut (.clk(clk), .rst(rst), .halt(halt));

    always #5 clk = ~clk;

    initial begin
        clk = 0; rst = 1;
        
        // Nạp chương trình vào RAM 
        // Địa chỉ 0: LDA 0x10 -> 101 (opcode) + 00...10
        uut.RAM.ram[0] = {3'b101, 29'h10}; 
        // Địa chỉ 1: ADD 0x11 -> 010 (opcode) + 00...11
        uut.RAM.ram[1] = {3'b010, 29'h11};
        // Địa chỉ 2: STO 0x50 -> 110 (opcode) + 00...50
        uut.RAM.ram[2] = {3'b110, 29'h50};
        // Địa chỉ 3: HLT      -> 000 (opcode) + 0
        uut.RAM.ram[3] = {3'b000, 29'h0};

        // Nạp dữ liệu
        uut.RAM.ram[16] = 32'd10; // Địa chỉ 0x10 chứa số 10
        uut.RAM.ram[17] = 32'd20; // Địa chỉ 0x11 chứa số 20

        #15 rst = 0; // Bắt đầu chạy

        // Chờ cho đến khi lệnh HLT được thực thi
        wait(halt == 1);
        
        #20;
        $display("Ket qua tai dia chi 0x50: %d", uut.RAM.ram[80]); // 0x50 = 80
        if (uut.RAM.ram[80] == 30) 
            $display("TEST SUCCESSFUL!");
        else 
            $display("TEST FAILED!");
            
        $finish;
    end
endmodule