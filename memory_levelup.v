module memory_levelup (
    input clk, rd, wr,
    input [31:0] addr,
    inout [31:0] data
);
    reg [31:0] ram [0:255];
    reg [31:0] out_buf;
    assign data = (rd && !wr) ? out_buf : 32'bz;
    always @(posedge clk) begin
        if (wr && !rd) ram[addr[7:0]] <= data;
        if (rd && !wr) out_buf <= ram[addr[7:0]];
    end
endmodule