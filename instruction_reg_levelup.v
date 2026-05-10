module instruction_reg_levelup (
    input clk, rst, ld_ir,
    input [31:0] data_in,
    output reg [3:0] opcode,
    output reg [27:0] addr
);
    always @(posedge clk) begin
        if (rst) {opcode, addr} <= 32'b0;
        else if (ld_ir) begin
            opcode <= data_in[31:28];
            addr   <= data_in[27:0];
        end
    end
endmodule