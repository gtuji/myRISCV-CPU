module ALU(
    input logic[31:0] A,
    input logic[31:0] B,
    input logic[3:0] SEL,
    output logic[31:0] F,
    output logic overflow
);
always_comb begin
    case(SEL)
        4'd1:
            {overflow,F}=A+B;
        4'd2:
            F=A-B;
        4'd3:
            F=A&B;
        4'd4:
            F=A|B;
        4'd5:
            F=A^B;
        4'd6:
            F=A>>B[4:0];
        4'd7:
            F=A>>>B[4:0];
        4'd8:
            F=A<<B[4:0];
    endcase
end
endmodule