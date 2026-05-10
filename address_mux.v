module address_mux #(
    parameter WIDTH = 32  // Độ rộng mặc định là 32-bit
)(
    input      [WIDTH-1:0] pc_addr,  // Địa chỉ từ Program Counter (khi sel = 1)
    input      [WIDTH-1:0] ir_addr,  // Địa chỉ từ Instruction Register (khi sel = 0)
    input                  sel,      // Tín hiệu chọn từ Controller
    output reg [WIDTH-1:0] addr_out  // Địa chỉ xuất ra bộ nhớ
);

    // Logic chọn địa chỉ (Combinational Logic)
    always @(*) begin
        if (sel)
            addr_out = pc_addr;      // Giai đoạn nạp lệnh (Fetch)
        else
            addr_out = ir_addr;      // Giai đoạn thực thi (Execute)
    end

endmodule