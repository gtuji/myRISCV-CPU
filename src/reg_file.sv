module REG_FILE(
    input logic clk,
    input logic wen,
    input logic[5:0] addrW,
    input logic[5:0] addrA,
    input logic[5:0] addrB,
    input logic[31:0] din,
    output logic[31:0] doutA,
    output logic[31:0] doutB
);
logic[31:0]regs[1:31];
always_ff @(negedge clk) begin
    if(wen==1'b1&&(|addrW))begin
        regs[addrW]<=din;
    end
end
always_comb begin
    doutA=|addrA?regs[addrA]:32'd0;
end
always_comb begin
    doutB=|addrB?regs[addrB]:32'd0;
end
endmodule