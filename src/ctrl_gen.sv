module CTRL_GEN(
    input logic[6:0] op,
    input logic[5:0] rs1,
    input logic[5:0] rs2,
    input logic[5:0] rd,
    input logic[2:0] func3,
    input logic[6:0] func7,
    output logic[2:0] extop,
    output logic regwr,
    output logic aluasrc,
    output logic[1:0] alubsrc,
    output logic[3:0] aluctr,
    output logic[2:0] branch,
    output logic memtoreg,
    output logic memwr,
    output logic[2:0] memop
);
// U type code
localparam LUI_OP=5'b01101;
localparam AUIPC_OP=5'b00101;
// I type code
localparam ICODE_OP=5'b00100;
// R type code
localparam RCODE=5'b01100;
// J type code
localparam JAL=5'b11011;
localparam JALR=5'b11001;
// B type code
localparam BCODE=5'b11000;

localparam LCODE=5'b00000;

localparam SCODE=5'b01000;

localparam IMMI = 3'b000;
localparam IMMU = 3'b001;
localparam IMMS = 3'b010;
localparam IMMB = 3'b011;
localparam IMMJ = 3'b100;
always_comb begin:IMM_GEN
    case(op[6:2])
        LUI_OP,AUIPC_OP:begin
            extop=IMMU;
        end
        ICODE_OP:begin
            extop=IMMI;
        end
        JAL,JALR:begin
            extop=IMMJ;
        end
        BCODE:begin
            extop=IMMB;
        end
        LCODE:begin
            extop=IMMI;
        end
        SCODE:begin
            extop=IMMS;
        end
    endcase
end
always_comb begin : ALU_OP
    case(op[6:2])
        LUI_OP:aluctr=4'b0011;
        AUIPC_OP:aluctr=4'b0000;
        ICODE_OP:begin
            case(func3)
                3'b011:aluctr=4'b1010;
                3'b101:aluctr={func7[5],func3};
                default:aluctr={1'b0,func3};
            endcase
        end
        RCODE:begin
            aluctr={func7[5],func3};
        end
        JAL,JALR,SCODE,LCODE:aluctr=4'b0000;
        BCODE:begin
            case(func3)
                3'b110,3'b111:aluctr=4'b1010;
                default:aluctr=4'b0010;
            endcase
        end
    endcase
end
always_comb begin:ALU_ASRC
    case(op[6:2])
        AUIPC_OP,JAL,JALR:aluasrc=1'b1;
        default:aluasrc=1'b0;
    endcase
end
always_comb begin:ALU_BSRC
    case(op[6:2])
        RCODE:alubsrc=2'b00;
        LUI_OP,AUIPC_OP,ICODE_OP,LCODE,SCODE:alubsrc=2'b01;
        JAL,JALR:alubsrc=2'b10;
    endcase
end
always_comb begin:MEM_OP
    memop=func3;
end
always_comb begin : MEM2REG
    case(op[6:2])
        LCODE:memtoreg=1'b1;
        default:memtoreg=1'b0;
    endcase
end
always_comb begin:REGWR
    case(op[6:2])
        LUI_OP,AUIPC_OP,ICODE_OP,RCODE,JAL,JALR,LCODE:regwr=1'b1;
        default:regwr=1'b0;
    endcase
end
always_comb begin:MEMWR
    case(op[6:2])
        SCODE:memwr=1'b1;
        default:memwr=1'b0;
    endcase
end
always_comb begin : BRANCH
    case(op[6:2])
        JAL:branch=3'b001;
        JALR:branch=3'b010;
        BCODE:branch={1'b1,func3[1:0]};
        default:branch=3'd0;
    endcase
end
endmodule