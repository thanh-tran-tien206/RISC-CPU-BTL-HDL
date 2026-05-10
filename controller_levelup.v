module controller_levelup (
    input clk, rst, is_zero,
    input [3:0] opcode,
    output reg sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e
);
    reg [2:0] state, next_state;
    parameter INST_ADDR=0, INST_FETCH=1, INST_LOAD=2, IDLE=3, 
              OP_ADDR=4, OP_FETCH=5, ALU_OP=6, STORE=7;

    always @(posedge clk) state <= rst ? INST_ADDR : next_state;
    always @(*) next_state = state + 1;

    always @(*) begin
        sel=0; rd=0; ld_ir=0; halt=0; inc_pc=0; ld_ac=0; ld_pc=0; wr=0; data_e=0;
        case(state)
            INST_ADDR: sel = 1;
            INST_FETCH: begin sel = 1; rd = 1; end
            INST_LOAD: begin sel = 1; rd = 1; ld_ir = 1; end
            IDLE: begin sel = 1; rd = 1; ld_ir = 1; end
            OP_ADDR: begin
                if (opcode == 4'b0000) halt = 1;
            end
            OP_FETCH: begin
                if (opcode == 4'b0010 || opcode == 4'b0011 || opcode == 4'b0100 || 
                    opcode == 4'b0101 || opcode == 4'b1000 || opcode == 4'b1011) rd = 1;
            end
            ALU_OP: begin
                if (opcode == 4'b0010 || opcode == 4'b0011 || opcode == 4'b0100 || 
                    opcode == 4'b0101 || opcode == 4'b1000 || opcode == 4'b1011) rd = 1;
                if (opcode == 4'b0001 && is_zero) inc_pc = 1;
                if (opcode == 4'b0111) ld_pc = 1;
                if (opcode == 4'b0110) data_e = 1;
            end
            STORE: begin
                inc_pc = 1;
                if (opcode == 4'b0110) begin wr = 1; data_e = 1; end
                if (opcode >= 4'b0010 && opcode != 4'b0110 && opcode != 4'b0111) begin
                    ld_ac = 1;
                    if (opcode != 4'b1001 && opcode != 4'b1010 && opcode != 4'b1100) rd = 1;
                end
                if (opcode == 4'b0111) ld_pc = 1;
            end
        endcase
    end
endmodule