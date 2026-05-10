module CPU_Top (
    input clk,
    input rst,
    output halt // Tín hiệu dừng hệ thống
);
    // Các đường dây kết nối nội bộ
    wire [31:0] bus_data;      // Bus dữ liệu chung (inout)
    wire [31:0] addr_to_mem;   // Địa chỉ gửi đến Memory
    wire [31:0] pc_to_mux;     // Địa chỉ từ PC
    wire [31:0] ir_to_mux;     // Địa chỉ từ IR (địa chỉ toán hạng)
    wire [31:0] alu_out;       // Kết quả từ ALU
    wire [31:0] acc_out;       // Dữ liệu từ Accumulator (inA của ALU)
    
    wire [2:0] opcode;         // Mã lệnh từ IR gửi đến Controller/ALU
    wire [28:0] ir_addr_part;  // Phần địa chỉ của lệnh
    wire is_zero;              // Cờ zero từ ALU
    
    // Các tín hiệu điều khiển từ Controller
    wire sel, rd, wr, ld_ir, ld_ac, ld_pc, inc_pc, data_e;

    // Khối Program Counter
    program_counter PC (
        .clk(clk), .rst(rst), .ld_pc(ld_pc), .inc_pc(inc_pc),
        .d_in({3'b000, ir_addr_part}), .pc_out(pc_to_mux)
    );

    // Khối Address Mux
    address_mux #(.WIDTH(32)) AddrMux (
        .pc_addr(pc_to_mux), .ir_addr({3'b000, ir_addr_part}),
        .sel(sel), .addr_out(addr_to_mem)
    );

    // Khối Instruction Register
    instruction_reg IR (
        .clk(clk), .rst(rst), .ld_ir(ld_ir),
        .data_in(bus_data), .opcode(opcode), .addr(ir_addr_part)
    );

    // Khối Controller
    controller ControlUnit (
        .clk(clk), .rst(rst), .opcode(opcode), .is_zero(is_zero),
        .sel(sel), .rd(rd), .ld_ir(ld_ir), .halt(halt),
        .inc_pc(inc_pc), .ld_ac(ld_ac), .ld_pc(ld_pc),
        .wr(wr), .data_e(data_e)
    );

    // Khối ALU
    ALU MainALU (
        .inA(acc_out), .inB(bus_data), .opcode(opcode),
        .out(alu_out), .is_zero(is_zero)
    );

    // Khối Accumulator
    Accumulator ACC (
        .clk(clk), .rst(rst), .load_en(ld_ac),
        .D(alu_out), .Q(acc_out)
    );

    // Khối Memory
    memory RAM (
        .clk(clk), .addr(addr_to_mem),
        .rd(rd), .wr(wr), .data(bus_data)
    );

    // Điều khiển Bus dữ liệu (Tri-state buffer cho STO)
    // Khi lệnh STO (Store) thực thi, đưa dữ liệu từ ACC ra Bus để ghi vào RAM
    assign bus_data = (data_e) ? acc_out : 32'bz;

endmodule