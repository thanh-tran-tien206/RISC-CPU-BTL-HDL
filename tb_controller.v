`timescale 1ns / 1ps

module controller_tb;

    // Các tín hiệu vào (Inputs)
    reg clk;
    reg rst;
    reg [2:0] opcode;
    reg zero;

    // Các tín hiệu ra (Outputs)
    wire sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e;
    wire [2:0] debug_state;

    // Khởi tạo đơn vị cần kiểm tra (Unit Under Test - UUT)
    controller uut (
        .clk(clk), 
        .rst(rst), 
        .opcode(opcode), 
        .zero(zero), 
        .sel(sel), 
        .rd(rd), 
        .ld_ir(ld_ir), 
        .halt(halt), 
        .inc_pc(inc_pc), 
        .ld_ac(ld_ac), 
        .ld_pc(ld_pc), 
        .wr(wr), 
        .data_e(data_e), 
        .debug_state(debug_state)
    );

    // Tạo xung Clock (Chu kỳ 10ns)
    always #5 clk = ~clk;

    initial begin
        // Khởi tạo các giá trị ban đầu [cite: 1]
        clk = 0;
        rst = 1;
        opcode = 3'b000;
        zero = 0;

        // Reset hệ thống 
        #15 rst = 0;
        
        // --- Trường hợp 1: Thử nghiệm lệnh HALT (opcode 000) ---
        // Chờ qua các trạng thái fetch cho đến khi tới OP_ADDR
        @(posedge clk); // INST_ADDR
        @(posedge clk); // INST_FETCH
        @(posedge clk); // INST_LOAD
        @(posedge clk); // IDLE
        
        opcode = 3'b000; // 
        @(posedge clk); // OP_ADDR -> halt sẽ lên 1 
        
        // --- Trường hợp 2: Thử nghiệm lệnh ADD/LOAD (opcode 010) ---
        rst = 1; #10 rst = 0; // Reset để chạy lại từ đầu
        opcode = 3'b010; 
        
        // Chờ đến trạng thái ALU_OP và STORE để xem rd và ld_ac [cite: 22, 28]
        wait(debug_state == 3'd6); // ALU_OP
        #10;
        wait(debug_state == 3'd7); // STORE
        #10;

        // --- Trường hợp 3: Thử nghiệm lệnh STORE (opcode 110) ---
        opcode = 3'b110;
        wait(debug_state == 3'd7); // STORE 
        // Lúc này wr và data_e phải bằng 1 [cite: 30]

        #50;
        $stop; // Dừng mô phỏng
    end
      
    // Theo dõi các thay đổi tín hiệu trên Console
    initial begin
        $monitor("Time=%0t | State=%d | Opcode=%b | Halt=%b | Rd=%b | Wr=%b | Ld_AC=%b", 
                 $time, debug_state, opcode, halt, rd, wr, ld_ac);
    end

endmodule