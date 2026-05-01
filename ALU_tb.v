`timescale 1ns / 1ps

module tb_ALU();

    
    reg  [31:0] inA;
    reg  [31:0] inB;
    reg  [2:0]  opcode;
    
    wire [31:0] out;
    wire        is_zero;

    
    localparam HLT = 3'b000, SKZ = 3'b001, ADD = 3'b010, AND = 3'b011,
               XOR = 3'b100, LDA = 3'b101, STO = 3'b110, JMP = 3'b111;

    
    ALU uut (
        .inA(inA),
        .inB(inB),
        .opcode(opcode),
        .out(out),
        .is_zero(is_zero)
    );

   
    initial begin
       
$display("------------------------------------------------------------------");
        $display("Thoi gian | Opcode |      inA (hex) |      inB (hex) |      out (hex) | is_zero");
        $display("------------------------------------------------------------------");
        
       
        $monitor("%8t  |    %b | %h | %h | %h |      %b", 
                 $time, opcode, inA, inB, out, is_zero);

        
        inA = 32'd0; 
        inB = 32'd0; 
        opcode = HLT;
        #10; 
        
        // TEST CASE 1:  ADD 
       
        inA = 32'd15; 
        inB = 32'd25; 
        opcode = ADD;
        #10; 

       
        // TEST CASE 2:  AND 
        
        inA = 32'hFFFF0000; 
        inB = 32'hFF00FF00; 
        opcode = AND;
        #10; 

        
        // TEST CASE 3: XOR
        
        inA = 32'hAAAAAAAA; 
        inB = 32'h55555555; 
        opcode = XOR;
        #10; 

       
        // TEST CASE 4:  LDA (Load inB)
       
        inA = 32'd99; 
        inB = 32'h1234ABCD; 
        opcode = LDA;
        #10; 

       
        // TEST CASE 5:  inA (HLT, SKZ, STO, JMP)
       
        inA = 32'hCAFEBA5E; 
        inB = 32'd0; 
        opcode = STO;
        #10; 

      
        // TEST CASE 6:  is_zero 
       
        inA = 32'd0; 
        inB = 32'd999; 
        opcode = ADD;
        #10; 

      
        // TEST CASE 7:  SKZ with inA = 0
      
        inA = 32'd0; 
        inB = 32'hFFFFFFFF; 
        opcode = SKZ;
        #10; 

        
        // TEST CASE 8: is_zero nhay su thay doi inA ko thay doi opcode
      
        inA = 32'd5;
        #5;  
        inA = 32'd0;
        #5;  
        
        
        // TEST CASE 9: inA != 0 but result=0
inA = 32'd10;
inB = -32'd10; 
opcode = ADD;
#10;


        $display("------------------------------------------------------------------");
        $display("Hoan thanh mo phong!");
        $finish; 
    end

endmodule