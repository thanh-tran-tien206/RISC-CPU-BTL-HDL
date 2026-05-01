`timescale 1ns / 1ps

module tb_Accumulator();

    reg clk;
    reg rst;
    reg load_en;
    reg [31:0] D;
    wire [31:0] Q;

 
    Accumulator uut (
        .clk(clk),
        .rst(rst),
        .load_en(load_en),
        .D(D),
        .Q(Q)
    );

   
    always #5 clk = ~clk;

    initial begin
       
        $display("---------------------------------------------------------");
        $display(" Thoi gian | rst | load_en |      D (hex) |      Q (hex)");
        $display("---------------------------------------------------------");
        $monitor("%10t |   %b |       %b | %h | %h", $time, rst, load_en, D, Q);

       
        clk = 0; rst = 0; load_en = 0; D = 32'h0;

       
        #12; rst = 1;     
        #10.1; rst = 0;    

      
        #10.1; D = 32'hAAAA_5555; load_en = 1; 
        #10.1; load_en = 0;                    
        
      
        #10.1; D = 32'h1234_ABCD;
        #10.1; 

      
        #10.1; load_en = 1;
        #10.1; load_en = 0;

      
        #10.1; D = 32'hFFFF_FFFF; load_en = 1; rst = 1; 
        #10.1; rst = 0; load_en = 0; 

        #20;
        $display("---------------------------------------------------------");
        $display("Hoan thanh mo phong Accumulator!");
        $finish;
    end

endmodule