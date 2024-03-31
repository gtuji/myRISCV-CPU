module MEMORY(
    input logic clka,
    input logic clkb,
    input logic wea,
    input logic web,
    input logic[31:0] dina,
    input logic[31:0] dinb,
    input logic[7:0] addra,
    input logic[7:0] addrb,
    input logic[3:0] byteena,
    input logic[3:0] byteenb,
    output logic[31:0] douta,
    output logic[31:0] doutb
);
logic[31:0] mem[256];
always_ff@(negedge clka)begin
    if(wea==1'b1)begin
        mem[addra]<=dina&{{8{byteena[3]}},{8{byteena[2]}},{8{byteena[1]}},{8{byteena[0]}}};
    end
end
always_ff@(negedge clkb)begin
    if(web==1'b1)begin
        mem[addrb]<=dinb&{{8{byteenb[3]}},{8{byteenb[2]}},{8{byteenb[1]}},{8{byteenb[0]}}};
    end
end
always_comb begin
    douta=mem[addra]&{{8{byteena[3]}},{8{byteena[2]}},{8{byteena[1]}},{8{byteena[0]}}};
    doutb=mem[addrb]&{{8{byteenb[3]}},{8{byteenb[2]}},{8{byteenb[1]}},{8{byteenb[0]}}};
end
endmodule