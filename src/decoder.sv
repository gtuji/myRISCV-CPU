module DECODER(
    input logic[31:0] inst,
    output logic[6:0] op,
    output logic[5:0] rs1,
    output logic[5:0] rs2,
    output logic[5:0] rd,
    output logic[2:0] func3,
    output logic[6:0] func7,
    output logic[11:0] immI,
    output logic[11:0] immS,
    output logic[11:0] immB,
    output logic[19:0] immU,
    output logic[19:0] immJ
);

always_comb begin : DECODER_PROC
    op=inst[6:0];
    rs1=inst[19:15];
    rs2=inst[24:20];
    rd=inst[11:7];
    func3=inst[14:12];
    func7=inst[31:25];
    immI=inst[31:20];
    immS={inst[31:25],inst[11:7]};
    immB={inst[31],inst[7],inst[30:25],inst[11:8]};
    immU=inst[31:12];
    immJ={inst[31],inst[19:12],inst[20],inst[30:21]};
end
endmodule