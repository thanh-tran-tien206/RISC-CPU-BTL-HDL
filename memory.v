module memory (
    input             clk,      // Xung clock
    input      [31:0] addr,     // Địa chỉ 32-bit
    input             rd,       // Tín hiệu đọc (active high)
    input             wr,       // Tín hiệu ghi (active high)
    inout      [31:0] data      // Cổng dữ liệu hai chiều (inout)
);

    // Khai báo mảng bộ nhớ (có 256 ô nhớ, mỗi ô 32-bit)
    reg [31:0] ram [0:255];

    // Đăng ký một biến đệm để điều khiển cổng inout
    reg [31:0] data_out;

    // Logic Đọc: Khi rd=1 và wr=0, đưa dữ liệu ra cổng data. 
    // Ngược lại, đặt cổng ở trạng thái trở kháng cao (Hi-Z) để có thể nhận dữ liệu vào.
    assign data = (rd && !wr) ? data_out : 32'bz;

    // Hoạt động đồng bộ với xung clk
    always @(posedge clk) begin
        if (wr && !rd) begin
            // Ghi dữ liệu từ cổng inout vào RAM
            ram[addr[7:0]] <= data; 
        end
        if (rd && !wr) begin
            // Đọc dữ liệu từ RAM ra biến đệm
            data_out <= ram[addr[7:0]];
        end
    end

endmodule