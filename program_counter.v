module program_counter (
    input             clk,      // Xung clock
    input             rst,      // Reset đồng bộ (active high)
    input             ld_pc,    // Nạp địa chỉ mới (cho lệnh JMP)
    input             inc_pc,   // Tăng địa chỉ (cho lệnh bình thường hoặc SKZ)
    input      [31:0] d_in,     // Địa chỉ nạp vào từ Instruction Register
    output reg [31:0] pc_out    // Địa chỉ chương trình hiện tại
);

    // Hoạt động tại cạnh lên của clock
    always @(posedge clk) begin
        if (rst) begin
            pc_out <= 32'b0;    // Reset bộ đếm về 0
        end
        else if (ld_pc) begin
            pc_out <= d_in;     // Ưu tiên nạp địa chỉ nhảy (JMP)
        end
        else if (inc_pc) begin
            pc_out <= pc_out + 1; // Tăng địa chỉ lên 1
        end
        // Nếu không có tín hiệu nào, pc_out giữ nguyên giá trị
    end

endmodule