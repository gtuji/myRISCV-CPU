module PC(
    input logic clk,
    input logic rst_n,
    input logic[7:0] nxaddr,
    input logic update,
    output logic[7:0] craddr
);
always_ff@(negedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        craddr<=8'd0;
    end
    else if(update==1'b1)begin
        craddr<=nxaddr;
    end
    else begin
        craddr<=craddr+8'd1;
    end
end
endmodule