module controller (
    input clk,
    input rst,
    input [2:0] opcode,
    input is_zero,          //  input này để xử lý lệnh SKZ
    output reg sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e,
    output [2:0] debug_state
);
    reg [2:0] state, next_state;
    parameter INST_ADDR = 3'd0, INST_FETCH = 3'd1, INST_LOAD = 3'd2, IDLE = 3'd3,
              OP_ADDR = 3'd4, OP_FETCH = 3'd5, ALU_OP = 3'd6, STORE = 3'd7;

    // Định nghĩa Opcode chuẩn theo ALU
    localparam HLT=3'b000, SKZ=3'b001, ADD=3'b010, AND=3'b011, 
               XOR=3'b100, LDA=3'b101, STO=3'b110, JMP=3'b111;

    // 1. Chuyển trạng thái (Reset đồng bộ)
    always @(posedge clk) begin
        if (rst) state <= INST_ADDR;
        else     state <= next_state;      
    end
    assign debug_state = state;

    // 2. Logic trạng thái kế tiếp (Vòng tròn 8 bước)
    always @(*) begin
        next_state = state + 1;
    end

    // 3. Logic đầu ra (Khớp 100% với bảng Phase)
    always @(*) begin
        // Giá trị mặc định
        sel=0; rd=0; ld_ir=0; halt=0; inc_pc=0; ld_ac=0; ld_pc=0; wr=0; data_e=0;

        case(state)
            INST_ADDR: begin
                sel = 1;
            end
            INST_FETCH: begin
                sel = 1; rd = 1;
            end
            INST_LOAD: begin
                sel = 1; rd = 1; ld_ir = 1;
            end
            IDLE: begin
                sel = 1; rd = 1; ld_ir = 1;
            end
            OP_ADDR: begin
                sel = 0;
                if (opcode == HLT) halt = 1;
            end
            OP_FETCH: begin
                sel = 0;
                if (opcode == ADD || opcode == AND || opcode == XOR || opcode == LDA) 
                    rd = 1;
            end
            ALU_OP: begin
                sel = 0;
                if (opcode == ADD || opcode == AND || opcode == XOR || opcode == LDA) 
                    rd = 1;
                if (opcode == SKZ && is_zero) 
                    inc_pc = 1;
                if (opcode == JMP) 
                    ld_pc = 1;
                if (opcode == STO) 
                    data_e = 1;
            end
            STORE: begin
                sel = 0;
                // Luôn tăng PC ở bước cuối để trỏ sang lệnh tiếp theo
                inc_pc = 1; 
                if (opcode == ADD || opcode == AND || opcode == XOR || opcode == LDA) begin
                    rd = 1; ld_ac = 1;
                end
                if (opcode == JMP) 
                    ld_pc = 1;
                if (opcode == STO) begin
                    wr = 1; data_e = 1;
                end
            end
        endcase
    end
endmodule