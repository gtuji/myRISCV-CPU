module IMM_GEN(
    input logic[11:0] immI,
    input logic[11:0] immS,
    input logic[11:0] immB,
    input logic[19:0] immU,
    input logic[19:0] immJ,
    input logic[2:0] extop,
    output logic[31:0] imm
);
localparam IMMI = 3'b000;
localparam IMMU = 3'b001;
localparam IMMS = 3'b010;
localparam IMMB = 3'b011;
localparam IMMJ = 3'b100;

logic signed[31:0] immI_s;
logic signed[31:0] immS_s;
logic signed[31:0] immB_s;
logic signed[31:0] immU_s;
logic signed[31:0] immJ_s;
always_comb begin
    immI_s=$signed(immI);
    immS_s=$signed(immS);
    immB_s=$signed({immB,1'b0});
    immU_s=$signed({immU,12'd0});
    immJ_s=$signed({immJ,1'b0});
    case(extop)
        IMMI:imm=immI_s;
        IMMU:imm=immU_s;
        IMMS:imm=immS_s;
        IMMB:imm=immB_s;
        IMMJ:imm=immJ_s;
        default:imm=32'd0;
    endcase
end
endmodule