`timescale 1ns / 1ps

module tb_address_mux();

    // Khai báo tham số độ rộng bit
    parameter W = 32;

    reg  [W-1:0] pc_addr;
    reg  [W-1:0] ir_addr;
    reg          sel;
    wire [W-1:0] addr_out;

    // Khởi tạo module Address Mux với tham số W
    address_mux #(.WIDTH(W)) uut (
        .pc_addr(pc_addr),
        .ir_addr(ir_addr),
        .sel(sel),
        .addr_out(addr_out)
    );

    initial begin
        
        $display("------------------------------------------------------------");
        $display(" Thoi gian | sel |    pc_addr   |    ir_addr   |   addr_out");
        $display("------------------------------------------------------------");
        $monitor("%10t |  %b  |   %h   |   %h   |   %h", 
                 $time, sel, pc_addr, ir_addr, addr_out);

        
        pc_addr = 32'h0000_1000; // Giả sử địa chỉ lệnh là 0x1000
        ir_addr = 32'h0000_ABCD; // Giả sử địa chỉ toán hạng là 0xABCD
        sel = 0;

        // 1. Test chọn ir_addr (Execute Phase)
        #10; sel = 0; 
        // Kỳ vọng: addr_out = ABCD

        // 2. Test chọn pc_addr (Fetch Phase)
        #10; sel = 1;
        // Kỳ vọng: addr_out = 1000

        // 3. Thay đổi pc_addr khi đang chọn pc_addr
        #10; pc_addr = 32'h0000_1004;
        // Kỳ vọng: addr_out cập nhật ngay lập tức sang 1004

        // 4. Thay đổi ir_addr khi đang chọn pc_addr
        #10; ir_addr = 32'h0000_EEEE;
        // Kỳ vọng: addr_out vẫn giữ 1004 vì sel vẫn bằng 1

        // 5. Chuyển sang chọn ir_addr
        #10; sel = 0;
        // Kỳ vọng: addr_out cập nhật sang EEEE

        #10;
        $display("------------------------------------------------------------");
        $display("Hoan thanh mo phong Address Mux!");
        $finish;
    end

endmodule