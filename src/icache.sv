module ICACHE(
    input logic clk,
    input logic[31:0] raddr,
    input logic ren,
    output logic[31:0] dout
);
logic[31:0] mem[1024];
/* always_ff@(negedge clk) begin
    if(ren==1'b1)
        dout<=mem[raddr[31:2]];
end */
always_comb begin
    dout=mem[raddr[31:2]];
end
// initial begin
//     // $readmemh();
//     for(int i=0;i<1024;i++)begin
//         mem[i]=8'd0;
//     end
//     mem[0]=32'h06400313;
//     mem[1]=32'h01400393;
//     mem[2]=32'h00730E33;
// end
endmodule