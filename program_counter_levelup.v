module program_counter_levelup (
    input clk, rst, ld_pc, inc_pc,
    input [27:0] d_in,
    output reg [31:0] pc_out
);
    always @(posedge clk) begin
        if (rst) pc_out <= 32'b0;
        else if (ld_pc) pc_out <= {4'b0000, d_in};
        else if (inc_pc) pc_out <= pc_out + 1;
    end
endmodule