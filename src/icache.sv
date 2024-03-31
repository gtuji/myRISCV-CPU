module ICACHE(
    input logic clk,
    input logic[7:0] raddr,
     input logic ren,
    output logic[31:0] dout
);
logic[31:0] mem[256];
always_ff@(negedge clk) begin
    if(ren==1'b1)
        dout<=mem[raddr];
end
initial begin
    // $readmemh();
end
endmodule