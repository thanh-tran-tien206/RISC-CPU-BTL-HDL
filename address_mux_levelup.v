module address_mux_levelup (
    input      [31:0] pc_addr,  // Địa chỉ từ Program Counter 
    input      [27:0] ir_addr,  // Địa chỉ từ Instruction Register (28-bit)
    input             sel,      // Tín hiệu chọn từ Controller
    output reg [31:0] addr_out  // Địa chỉ xuất ra Memory
);

    always @(*) begin
        if (sel)
            addr_out = pc_addr;
        else
            // Ghép 4 bit 0 vào đầu để chuyển từ 28-bit sang 32-bit
            addr_out = {4'b0000, ir_addr};
    end

endmodule
