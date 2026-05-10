`timescale 1ns / 1ps

module tb_memory();

    reg          clk;
    reg  [31:0]  addr;
    reg          rd;
    reg          wr;
    wire [31:0]  data;

    reg  [31:0]  data_reg;
    assign data = (wr && !rd) ? data_reg : 32'bz;

    memory uut (
        .clk(clk),
        .addr(addr),
        .rd(rd),
        .wr(wr),
        .data(data)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0; addr = 0; rd = 0; wr = 0; data_reg = 0;

        $display("------------------------------------------------------------");
        $display(" Thoi gian | rd | wr |   addr   |   data (hex)");
        $display("------------------------------------------------------------");
        
      
        $monitor("%10t |  %b |  %b | %h | %h", $time, rd, wr, addr, data);

        // Ghi du lieu vao o nho 0x01
        #10; addr = 32'h01; data_reg = 32'hABCD_1234; wr = 1; rd = 0;
        #10; wr = 0; 

        // Ghi du lieu vao o nho 0x02
        #10; addr = 32'h02; data_reg = 32'h5555_AAAA; wr = 1;
        #10; wr = 0;

        // Doc du lieu tu o nho 0x01
        #10; addr = 32'h01; rd = 1; wr = 0;
        #10; 
        
        // Doc du lieu tu o nho 0x02
        #10; addr = 32'h02;
        #10;

        // Trang thai nghi
        #10; rd = 0; wr = 0;
        #10;

        $display("------------------------------------------------------------");
        $display("Hoan thanh mo phong Memory!");
        $finish;
    end
endmodule