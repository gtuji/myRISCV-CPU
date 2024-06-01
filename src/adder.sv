module ADDER#(
    parameter WIDTH=32
)(
    input logic[WIDTH-1:0] a,
    input logic[WIDTH-1:0] b,
    input logic cin,
    output logic[WIDTH-1:0] sum,
    output logic cout,
    output logic overflow
);
always_comb begin
    {cout,sum}=a+b+cin;
    overflow=a[WIDTH-1]==b[WIDTH-1]&&sum[WIDTH-1]!=a[WIDTH-1];
end
endmodule