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
logic[31:0] dout;
logic[1:0] sel;
logic[3:0] mask;
logic[1:0] num;
always_comb begin
    sel=addr[1:0];
    case(memop[2:0])
        3'b010:begin
            mask=4'b1111;
            num=2'd3;
        end
        3'b001:begin
            case(sel[1])
                1'b0:mask=4'b0011;
                1'b1:mask=4'b1100;
            endcase
            num=2'd2;
        end
        3'b000:begin
            case(sel)
                2'b00:mask=4'b0001;
                2'b01:mask=4'b0010;
                2'b10:mask=4'b0100;
                2'b11:mask=4'b1000;
            endcase
            num=2'd1;
        end
        default:begin
            mask=4'd0;
            num=2'd0;
        end
    endcase
    case(memop[2:0])
        3'b010:data_out=dout;
        3'b001:data_out={{16{dout[16*(sel[1]+1)-1]}},dout[16*sel[1]+:16]};
        3'b000:data_out={{24{dout[8*(sel+1)-1]}},dout[8*sel+:8]};
        3'b101:data_out={16'd0,dout[16*sel[1]+:16]};
        3'b100:data_out={24'd0,dout[8*sel+:8]};
        default:data_out=32'd0;
    endcase
end
always_ff@(negedge wrclk)begin
    if(wen)begin
        case(num)
            2'd1:begin
                for(int i=0;i<4;i++)begin
                    if(mask[i]==1'b1)
                        mem[addr[31:2]][i*8+:8]<=data_in[7:0];
                end
            end
            2'd2:begin
                for(int i=0;i<2;i++)begin
                    if(mask[i*2+:2]==2'b11)begin
                        mem[addr[31:2]][i*16+:16]<=data_in[15:0];
                    end
                end
            end
            2'd3:begin
                if(mask==4'b1111)begin
                    mem[addr[31:2]]<=data_in;
                end
            end
            default:mem[addr[31:2]]<=mem[addr[31:2]];
        endcase
    end
end
always@(posedge rdclk)begin
    if(!wen)
        dout<=mem[addr[31:2]];
end
endmodule