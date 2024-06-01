module SHIFTER(
    input logic[31:0] src,
    input logic direction,
    input logic sign,
    input logic[31:0] num,
    output logic[31:0] result
);
localparam LEFT=1'b1;
localparam RIGHT=1'b0;

localparam SIGNED=1'b1;
localparam UNSIGNED=1'b0;
logic [31:0] result_rs;
logic [31:0] result_ru;
logic [31:0] result_l;
always_comb begin
    result_rs=src>>num;
    result_ru=src>>>num;
    result_l=src<<num;
    result=direction?result_l:sign?result_rs:result_ru;
end
endmodule