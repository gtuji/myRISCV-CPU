module CPU_TOP(
    input logic clk,
    input logic rst_n
    // input logic[31:0] din,
    // output logic[31:0] dout
);
wire[31:0] craddr_w;
wire[31:0] inst_w;
wire[31:0] nxaddr_w;

wire[6:0] op_w;
wire[5:0] rs1_w;
wire[5:0] rs2_w;
wire[5:0] rd_w;
wire[2:0] func3_w;
wire[6:0] func7_w;

wire[11:0] immI_w;
wire[11:0] immS_w;
wire[11:0] immB_w;
wire[19:0] immU_w;
wire[19:0] immJ_w;
wire[31:0] imm_w;

wire[2:0] extop_w;
wire regwr_w;
wire aluasrc_w;
wire[1:0] alubsrc_w;
wire[3:0] aluctr_w;
wire[2:0]  branch_w;
wire memtoreg_w;
wire memwr_w;
wire[2:0] memop_w;

wire[31:0] a_w,b_w,f_w;
wire less_w,zero_w;

wire[31:0] doutA_w,doutB_w;
wire[31:0] data_out_w;

wire pc_asrc_w,pc_bsrc_w;
wire[31:0] din_w;
assign a_w=aluasrc_w?craddr_w:doutA_w;
assign b_w={32{alubsrc_w==2'b00}}&doutB_w|{32{alubsrc_w==2'b01}}&imm_w|{32{alubsrc_w==2'b10}}&32'd4;
assign nxaddr_w=(pc_asrc_w?imm_w:4)+(pc_bsrc_w?doutA_w:craddr_w);
assign din_w=memtoreg_w?data_out_w:f_w;
ALU u_ALU(
    .a(a_w),
    .b(b_w),
    .f(f_w),
    .sel(aluctr_w),
    .zero(zero_w),
    .less(less_w)
);
BRANCH_CON u_BRANCH_CON(
    .branch(branch_w),
    .less(less_w),
    .zero(zero_w),
    .pc_asrc(pc_asrc_w),
    .pc_bsrc(pc_bsrc_w)
);
CTRL_GEN u_CTRL_GEN(
    .op(op_w),
    .rs1(rs1_w),
    .rs2(rs2_w),
    .rd(rd_w),
    .func3(func3_w),
    .func7(func7_w),
    .extop(extop_w),
    .regwr(regwr_w),
    .aluasrc(aluasrc_w),
    .alubsrc(alubsrc_w),
    .aluctr(aluctr_w),
    .branch(branch_w),
    .memtoreg(memtoreg_w),
    .memwr(memwr_w),
    .memop(memop_w)
);
DECODER u_DECODER(
    .inst(inst_w),
    .op(op_w),
    .rs1(rs1_w),
    .rs2(rs2_w),
    .rd(rd_w),
    .func3(func3_w),
    .func7(func7_w),
    .immI(immI_w),
    .immS(immS_w),
    .immB(immB_w),
    .immU(immU_w),
    .immJ(immJ_w)
);
ICACHE u_ICACHE(
    .clk(clk),
    .raddr(craddr_w),
    .ren(1'b1),
    .dout(inst_w)
);
DCACHE u_DCACHE(
    .wrclk(clk),
    .rdclk(clk),
    .memop(memop_w),
    .data_in(doutB_w),
    .addr(f_w),
    .wen(memwr_w),
    .data_out(data_out_w)
);
IMM_GEN u_IMM_GEN(
    .immI(immI_w),
    .immS(immS_w),
    .immB(immB_w),
    .immU(immU_w),
    .immJ(immJ_w),
    .extop(extop_w),
    .imm(imm_w)
);
PC u_PC(
    .clk(clk),
    .rst_n(rst_n),
    .nxaddr(nxaddr_w),
    .update(1'b1),
    .craddr(craddr_w)
);
REG_FILE u_REG_FILE(
    .clk(clk),
    .wen(regwr_w),
    .addrW(rd_w),
    .addrA(rs1_w),
    .addrB(rs2_w),
    .din(din_w),
    .doutA(doutA_w),
    .doutB(doutB_w)
);
endmodule