`timescale 1ns / 1ps

module controller (
    input clk,
    input rst,              
    input [2:0] opcode,
    input zero,
    output reg sel,
    output reg rd,
    output reg ld_ir,
    output reg halt,
    output reg inc_pc,
    output reg ld_ac,
    output reg ld_pc,
    output reg wr,
    output reg data_e,

    output [2:0] debug_state
);

    //========================
    // STATE DECLARATION
    //========================
    reg [2:0] state, next_state;

    parameter INST_ADDR  = 3'd0,
              INST_FETCH = 3'd1,
              INST_LOAD  = 3'd2,
              IDLE       = 3'd3,
              OP_ADDR    = 3'd4,
              OP_FETCH   = 3'd5,
              ALU_OP     = 3'd6,
              STORE      = 3'd7;

    assign debug_state = state;

    //========================
    // STATE REGISTER (SYNC RESET)
    //========================
    always @(posedge clk) begin
        if (rst)
            state <= INST_ADDR;
        else
            state <= next_state;
    end

    //========================
    // NEXT STATE LOGIC
    //========================
    always @(*) begin
        case(state)
            INST_ADDR:  next_state = INST_FETCH;
            INST_FETCH: next_state = INST_LOAD;
            INST_LOAD:  next_state = IDLE;
            IDLE:       next_state = OP_ADDR;
            OP_ADDR:    next_state = OP_FETCH;
            OP_FETCH:   next_state = ALU_OP;
            ALU_OP:     next_state = STORE;
            STORE:      next_state = INST_ADDR;
            default:    next_state = INST_ADDR;
        endcase
    end

    always @(*) begin
        sel = 0;
        rd = 0;
        ld_ir = 0;
        halt = 0;
        inc_pc = 0;
        ld_ac = 0;
        ld_pc = 0;
        wr = 0;
        data_e = 0;

        case(state)
            INST_ADDR: begin
                sel = 1;
            end
            INST_FETCH: begin
                sel = 1;
                rd  = 1;
            end
            INST_LOAD: begin
                sel   = 1;
                rd    = 1;
                ld_ir = 1;
            end
            IDLE: begin
                sel   = 1;
                rd    = 1;
                ld_ir = 1;
            end
            OP_ADDR: begin
                inc_pc = 1;
                if(opcode==3'b000)begin
                    halt = 1;
                end
            end
            OP_FETCH: begin
                if(opcode == 3'b010 || opcode == 3'b011||
                   opcode == 3'b100 || opcode == 3'b101)begin
                    rd=1;
                end
            end
            ALU_OP: begin
                case(opcode)
                    3'b010, 
                    3'b011, 
                    3'b100, 
                    3'b101: 
                    begin
                        rd = 1;
                    end
                    3'b001: begin
                        inc_pc = zero;
                    end
                    3'b111: begin
                        ld_pc = 1;
                    end
                    3'b110: begin
                        data_e =1;
                    end
                    default: begin
                    end
                endcase
            end
            STORE: begin
                case(opcode)
                    3'b010, 
                    3'b011, 
                    3'b100, 
                    3'b101: 
                    begin
                        rd=1;
                        ld_ac =1;
                    end
                    3'b111: begin
                        ld_pc =1;
                    end
                    3'b110: begin
                        wr=1;
                        data_e =1;
                    end
                    default: begin
                    end
                endcase
            end
        endcase
    end
endmodule
