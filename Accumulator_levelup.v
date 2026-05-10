module Accumulator_levelup (
    input clk, rst, load_en,
    input [31:0] D,
    output reg [31:0] Q
);
    always @(posedge clk) begin
        if (rst) Q <= 32'b0;
        else if (load_en) Q <= D;
    end
endmodule