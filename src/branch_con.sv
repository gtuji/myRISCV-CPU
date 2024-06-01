module BRANCH_CON(
    input logic[2:0] branch,
    input logic less,
    input logic zero,
    output logic pc_asrc,
    output logic pc_bsrc
);
localparam NO=3'b000;
localparam JUMP_PC=3'd1;
localparam JUMP_REG=3'd2;
localparam EQ=3'd4;
localparam UEQ=3'd5;
localparam LT=3'd6;// less than
localparam GT=3'd7;// greater than
always_comb begin
    case(branch)
        NO:begin
            pc_asrc=1'b0;
            pc_bsrc=1'b0;
        end
        JUMP_PC:begin
            pc_asrc=1'b1;
            pc_bsrc=1'b0;
        end
        JUMP_REG:begin
            pc_asrc=1'b1;
            pc_bsrc=1'b1;
        end
        EQ:begin
            pc_asrc=zero;
            pc_bsrc=1'b0;
        end
        UEQ:begin
            pc_asrc=~zero;
            pc_bsrc=1'b0;
        end
        LT:begin
            pc_asrc=less;
            pc_bsrc=1'b0;
        end
        GT:begin
            pc_asrc=~less;
            pc_bsrc=1'b0;
        end
    endcase
end 
endmodule