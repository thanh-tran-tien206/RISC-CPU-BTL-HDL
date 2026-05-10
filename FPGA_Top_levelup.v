module FPGA_Top_levelup (
    input sys_clk,        // Xung 125MHz từ board FPGA
    input btn_rst,        // Nút nhấn Reset
    output [3:0] led,     // 4 đèn LED hiển thị kết quả
    output halt_led       // 1 đèn LED báo CPU dừng
);

    wire clk_1hz;         // Dây nối xung 1Hz từ khối Div sang khối CPU
    wire h_flag;          // Dây nối cờ halt
    wire [31:0] acc_wire; // Dây lấy dữ liệu thanh ghi AC

    // Gọi khối chia tần số
    clk_1hz_levelup Div (
        .clk_in(sys_clk), 
        .rst(btn_rst), 
        .clk_out(clk_1hz)
    );

    // Gọi khối CPU trung tâm và nối xung 1Hz vào 
    CPU_Top_levelup CPU (
        .clk(clk_1hz),    // <--- CPU chạy bằng xung chậm ở đây
        .rst(btn_rst), 
        .halt(h_flag), 
        .acc_val(acc_wire)
    );

    // Đẩy kết quả ra ngoại vi
    assign led = acc_wire[3:0]; // Hiển thị 4 bit cuối của kết quả tính toán
    assign halt_led = h_flag;

endmodule