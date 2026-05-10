`timescale 1ns / 1ps

module tb_CPU_levelup();
    
    reg clk;
    reg rst;
    wire halt;
    wire [31:0] acc_val;

    //  Gọi module CPU trung tâm
    CPU_Top_levelup uut (
        .clk(clk),
        .rst(rst),
        .halt(halt),
        .acc_val(acc_val)
    );

    //  Tạo xung Clock (Chu kỳ 10ns -> 100MHz)
    always #5 clk = ~clk;

    initial begin
        // Khởi tạo
        clk = 0;
        rst = 1;


        //  NẠP DỮ LIỆU (DATA) 
        uut.RAM.ram[10] = 32'd15;  // Bộ nhớ tại địa chỉ 10 chứa số 15
        uut.RAM.ram[11] = 32'd5;   // Bộ nhớ tại địa chỉ 11 chứa số 5
        uut.RAM.ram[12] = 32'd10;  // Bộ nhớ tại địa chỉ 12 chứa số 10

        //  NẠP MÃ LỆNH (INSTRUCTIONS) 
        // Cấu trúc:4-bit Opcode + 28-bit Address
        
        // Lệnh 1: LDA 10 (Opcode: 0101 -> 5) => Nạp số 15 vào Accumulator
        uut.RAM.ram[0] = 32'h5000000A; 
        
        // Lệnh 2: ADD 11 (Opcode: 0010 -> 2) => AC = 15 + 5 = 20
        uut.RAM.ram[1] = 32'h2000000B; 
        
        // Lệnh 3: SHL    (Opcode: 1001 -> 9) => AC = 20 << 1 = 40 (Lệnh mới nâng cấp)
        uut.RAM.ram[2] = 32'h90000000; 
        
        // Lệnh 4: SUB 12 (Opcode: 1000 -> 8) => AC = 40 - 10 = 30 (Lệnh mới nâng cấp)
        uut.RAM.ram[3] = 32'h8000000C; 
        
        // Lệnh 5: STO 13 (Opcode: 0110 -> 6) => Lưu số 30 từ AC ra bộ nhớ tại địa chỉ 13
        uut.RAM.ram[4] = 32'h6000000D; 
        
        // Lệnh 6: HLT    (Opcode: 0000 -> 0) => Dừng hệ thống
        uut.RAM.ram[5] = 32'h00000000; 

        
        // Nhả Reset để CPU bắt đầu chu trình Fetch-Decode-Execute
        #15 rst = 0; 

        // Chờ đến khi cờ halt được CPU bật lên
        wait(halt == 1'b1);
        #20; 

       
        $display("========================================");
        $display("          KET QUA MO PHONG CPU          ");
        $display("========================================");
        $display("Gia tri cuoi cung trong Accumulator (acc_val) = %d", acc_val);
        $display("Gia tri luu trong RAM tai dia chi 13          = %d", uut.RAM.ram[13]);
        
        if (uut.RAM.ram[13] == 32'd30) begin
            $display("=> TEST PASSED! CPU chay dung hoan toan cac lenh nang cap.");
        end else begin
            $display("=> TEST FAILED! Vui long kiem tra lai.");
        end
        $display("========================================");

        $finish;
    end
endmodule