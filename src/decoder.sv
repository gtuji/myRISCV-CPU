module DECODER(
    input logic[31:0] inst,
    output logic[6:0] op,
    output logic[5:0] rs1,
    output logic[5:0] rs2,
    output logic[5:0] rd,
    output logic[2:0] func3,
    output logic[6:0] func7
);

always_comb begin : DECODER_PROC
    op=inst[6:0];
    rs1=inst[19:15];
    rs2=inst[24:20];
    rd=inst[11:7];
    func3=inst[14:12];
    func7=inst[31:25];
end
endmodule