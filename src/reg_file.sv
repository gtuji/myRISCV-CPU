module REG_FILE(
    input logic clk,
    input logic wen,
    input logic[4:0] addrW,
    input logic[4:0] addrA,
    input logic[4:0] addrB,
    input logic[31:0] din,
    output logic[31:0] doutA,
    output logic[31:0] doutB
);
logic[31:0]regs[0:31];
always_ff @(posedge clk) begin
    if(wen==1'b1)begin
        regs[addrW]<=din;
    end
end
always_comb begin
    doutA=regs[addrA];
end
always_comb begin
    doutB=regs[addrB];
end
endmodule