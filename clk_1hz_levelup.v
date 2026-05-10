module clk_1hz_levelup (
    input clk_in, rst,
    output reg clk_out
);
    reg [26:0] cnt;
    always @(posedge clk_in) begin
        if (rst) begin cnt <= 0; clk_out <= 0; end
        else if (cnt == 62500000 - 1) begin cnt <= 0; clk_out <= ~clk_out; end
        else cnt <= cnt + 1;
    end
endmodule