`timescale 1ns / 1ps

module tb_instruction_reg();

    reg         clk;
    reg         rst;
    reg         ld_ir;
    reg  [31:0] data_in;
    
    wire [2:0]  opcode;
    wire [28:0] addr;

    // Khởi tạo 
    instruction_reg uut (
        .clk(clk),
        .rst(rst),
        .ld_ir(ld_ir),
        .data_in(data_in),
        .opcode(opcode),
        .addr(addr)
    );

    
    always #5 clk = ~clk;

    initial begin
        
        clk = 0; rst = 0; ld_ir = 0; data_in = 32'b0;

        $display("------------------------------------------------------------");
        $display(" Thoi gian | rst | ld_ir | Data_in  | Opcode | Address");
        $display("------------------------------------------------------------");
        $monitor("%10t |  %b  |   %b   | %h |   %b  | %h", 
                 $time, rst, ld_ir, data_in, opcode, addr);

        // 1. Kiểm tra Reset đồng bộ
        #12; rst = 1;
        #10; rst = 0;

        // 2. Thử nạp lệnh ADD (010) với địa chỉ 0x00000FF
        #10; 
        data_in = {3'b010, 29'h00000FF}; 
        ld_ir = 1; // Cho phép nạp
        #10;
        ld_ir = 0; // Khóa nạp

        // 3. Thay đổi data_in nhưng ld_ir = 0 (Giá trị cũ phải được giữ nguyên)
        #10;
        data_in = {3'b111, 29'hFFFFFFF}; 
        #10;

        // 4. Nạp lệnh mới JMP (111)
        #10;
        ld_ir = 1;
        #10;
        ld_ir = 0;

        // 5. Reset giữa chừng
        #10;
        rst = 1;
        #10;
        rst = 0;

        #20;
        $display("------------------------------------------------------------");
        $display("Hoan thanh mo phong Instruction Register!");
        $finish;
    end

endmodule