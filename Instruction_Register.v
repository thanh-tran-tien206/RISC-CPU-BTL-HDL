module instruction_reg (
    input             clk,      // Xung clock
    input             rst,      // Reset đồng bộ (active high)
    input             ld_ir,    // Tín hiệu cho phép nạp lệnh từ Controller
    input      [31:0] data_in,  // Dữ liệu lệnh từ Bus bộ nhớ
    output reg [2:0]  opcode,   // 3-bit mã lệnh trả về Controller/ALU
    output reg [28:0] addr      // Địa chỉ bộ nhớ đi kèm lệnh
);

    // Instruction Register hoạt động đồng bộ với clk
    always @(posedge clk) begin
        if (rst) begin
            opcode <= 3'b000;
            addr   <= 29'b0;
        end
        else if (ld_ir) begin
            // Nạp dữ liệu từ Bus vào thanh ghi
            opcode <= data_in[31:29]; // Giả sử 3 bit cao là Opcode
            addr   <= data_in[28:0];  // Các bit còn lại là địa chỉ
        end
        // Nếu ld_ir = 0, giá trị opcode và addr được giữ nguyên
    end

endmodule