module CPU_Top_levelup (
    input clk, rst,
    output halt,
    output [31:0] acc_val
);
    wire [31:0] bus_data, pc_out, addr_mem, alu_out, acc_out;
    wire [3:0] op; 
    wire [27:0] ir_addr;
    wire sel, rd, ld_ir, ld_ac, ld_pc, inc_pc, wr, data_e, is_zero;

    assign acc_val = acc_out;
    assign bus_data = data_e ? acc_out : 32'bz;

    //  Program Counter
    program_counter_levelup PC (
        .clk(clk), .rst(rst), .ld_pc(ld_pc), .inc_pc(inc_pc), 
        .d_in(ir_addr), .pc_out(pc_out)
    );
    
    //  Address Mux 
    address_mux_levelup AddrMux (
        .pc_addr(pc_out), 
        .ir_addr(ir_addr), 
        .sel(sel), 
        .addr_out(addr_mem)
    );

    //  Instruction Register
    instruction_reg_levelup IR (
        .clk(clk), .rst(rst), .ld_ir(ld_ir), 
        .data_in(bus_data), .opcode(op), .addr(ir_addr)
    );
    
    //  Controller
    controller_levelup CU (
        .clk(clk), .rst(rst), .opcode(op), .is_zero(is_zero), 
        .sel(sel), .rd(rd), .ld_ir(ld_ir), .halt(halt), 
        .inc_pc(inc_pc), .ld_ac(ld_ac), .ld_pc(ld_pc), .wr(wr), .data_e(data_e)
    );
    
    // ALU
    ALU_levelup ALU (
        .inA(acc_out), .inB(bus_data), .opcode(op), 
        .out(alu_out), .is_zero(is_zero)
    );
    
    //  Accumulator
    Accumulator_levelup ACC (
        .clk(clk), .rst(rst), .load_en(ld_ac), 
        .D(alu_out), .Q(acc_out)
    );
    
    //  Memory
    memory_levelup RAM (
        .clk(clk), .rd(rd), .wr(wr), 
        .addr(addr_mem), .data(bus_data)
    );

endmodule