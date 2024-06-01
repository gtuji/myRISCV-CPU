module ALU(
    input logic[31:0] a,
    input logic[31:0] b,
    input logic[3:0] sel,
    output logic[31:0] f,
    output logic zero,
    output logic less
);
logic cin,direction,sign;
logic [31:0] b_adder_src;
logic [31:0] sum,result;
wire cout,overflow;
always_comb begin
    cin=sel[3]&(~|sel[2:0])|(sel[2:0]==3'b010);
    b_adder_src={32{cin}}^b;
    direction=sel==3'b001;
    sign=~sel[3];
    less=sign?overflow^sum[31]:cin^cout;
    zero=~|{cout,sum};
end
always_comb begin
    case(sel[2:0])
        3'b000,3'b010:f=sum;
        3'b001,3'b101:f=result;
        3'b011:f=b;
        3'b100:f=a^b;
        3'b110:f=a|b;
        3'b111:f=a&b;
    endcase
end
ADDER#(
    .WIDTH(32)
) u_ADDER (
    .a(a),
    .b(b_adder_src),
    .cin(cin),
    .sum(sum),
    .cout(cout),
    .overflow(overflow)
);

SHIFTER u_SHIFTER(
    .src(a),
    .num(b),
    .direction(direction),
    .sign(sign),
    .result(result)
);
endmodule