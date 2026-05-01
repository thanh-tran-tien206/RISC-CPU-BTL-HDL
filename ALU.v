module ALU (
    input  [31:0] inA,      
    input  [31:0] inB,      
    input  [2:0]  opcode,   
    output reg [31:0] out,  
    output        is_zero   
);

    localparam HLT = 3'b000, SKZ = 3'b001, ADD = 3'b010, AND = 3'b011,
               XOR = 3'b100, LDA = 3'b101, STO = 3'b110, JMP = 3'b111;

    always @(*) begin
        case (opcode)
            HLT, SKZ, JMP, STO : out = inA; 
            ADD : out = inA + inB;
            AND : out = inA & inB;
            XOR : out = inA ^ inB;
            LDA : out = inB;
            default: out = inA;
        endcase
    end

  
    assign is_zero = (inA == 32'b0); 

endmodule