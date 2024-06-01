module DCACHE(
    input logic wrclk,
    input logic rdclk,
    input logic[2:0] memop,
    input logic[31:0] data_in,
    input logic[31:0] addr,
    input logic wen,
    output logic[31:0] data_out
);
logic[31:0] mem[0:1023];
logic[31:0] din;
logic[31:0] dout;
logic[1:0] sel;
always_comb begin
    sel=addr[1:0];
    case(memop[2:0])
        3'b010:din=data_in;
        // 3'b001:din={{16{data_in[15]}},data_in[15:0]};
        3'b001:din[addr[1]]=$signed(data_in[15:0]);
        // 3'b000:din={{24{data_in[7]}},data_in[7:0]};
        3'b000:din[addr[1:0]]=$signed(data_in[7:0]);
        // 3'b101:din={{16{1'b0}},data_in[15:0]};
        3'b101:din[addr[1]]=data_in[15:0];
        // 3'b100:din={{24{1'b0}},data_in[7:0]};
        3'b100:din[addr[1:0]]=data_in[7:0];
    endcase
    case(memop[2:0])
        3'b010:data_out=dout;
        // 3'b001:data_out={{16{dout[16*(sel+1)-1]}},dout[16*sel+:16]};
        3'b001:data_out=$signed(dout[sel[1]*16+:16]);
        // 3'b000:data_out={{24{dout[8*(sel+1)-1]}},dout[8*sel+:8]};
        3'b000:data_out=$signed(dout[sel*8+:8]);
        // 3'b101:data_out={{16{1'b0}},dout[16*sel+:16]};
        3'b101:data_out=dout[16*sel+:16];
        // 3'b100:data_out={{24{1'b0}},dout[8*sel+:8]};
        3'b100:data_out=dout[8*sel+:8];
    endcase
end
always_ff@(negedge wrclk)begin
    if(wen)begin
        mem[addr[31:2]]<=din;
    end
end
always@(posedge rdclk)begin
    if(!wen)
        dout<=mem[addr[31:2]];
end
endmodule