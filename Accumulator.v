module Accumulator (
    input         clk,        
    input         rst,        
    input         load_en,    
    input  [31:0] D,          
    output reg [31:0] Q       //(inA cho ALU)
);

    
    always @(posedge clk) begin
        if (rst) begin
            Q <= 32'b0;          
        end 
        else if (load_en) begin
            Q <= D;              
        end
        
    end

endmodule