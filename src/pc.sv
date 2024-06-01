module PC(
    input logic clk,
    input logic rst_n,
    input logic[31:0] nxaddr,
    input logic update,
    output logic[31:0] craddr
);
always_ff@(negedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        craddr<=32'd0;
    end
    else if(update==1'b1)begin
        craddr<=nxaddr;
    end
end
endmodule