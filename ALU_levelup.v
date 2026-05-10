module ALU_levelup (
    input  [31:0] inA,
    input  [31:0] inB,
    input  [3:0]  opcode,   // 4-bit Opcode
    output reg [31:0] out,
    output        is_zero
);
    // Logic is_zero bất đồng bộ từ Accumulator (inA)
    assign is_zero = (inA == 32'b0);

    always @(*) begin
        case(opcode)
            4'b0000: out = inA;          // HLT
            4'b0001: out = inA;          // SKZ
            4'b0010: out = inA + inB;    // ADD
            4'b0011: out = inA & inB;    // AND
            4'b0100: out = inA ^ inB;    // XOR
            4'b0101: out = inB;          // LDA
            4'b0110: out = inA;          // STO
            4'b0111: out = inA;          // JMP
            // --- Lệnh nâng cao ---
            4'b1000: out = inA - inB;    // SUB
            4'b1001: out = inA << 1;     // SHL (Dịch trái)
            4'b1010: out = inA >> 1;     // SHR (Dịch phải)
            4'b1011: out = inA | inB;    // OR
            4'b1100: out = ~inA;         // NOT
            4'b1101: out = inA + 1;      // INC
            4'b1110: out = inA - 1;      // DEC
            default: out = inA;
        endcase
    end
endmodule