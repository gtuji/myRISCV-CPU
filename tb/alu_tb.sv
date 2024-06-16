module ALU_TB;
bit[31:0] a,b;
logic[3:0] sel;
wire[31:0] f;
wire zero,less;
localparam ADD=4'd0;
localparam SUB=4'd8;
localparam LEFT=3'd1;
localparam SC=4'd2;
localparam UC=4'd10;
localparam LR=4'd5;
localparam AR=4'd13;
task add;
    sel=4'd0;
    assert(randomize(a));
    assert(randomize(b));
    #1step;
    assert (f==(a+b)) 
    else   $error("f!=a+b");
endtask
task sub;
    sel=4'd8;
    assert(randomize(a)with{a<32'd65536;});
    assert(randomize(b)with{b<32'd65536;});
    #1step;
    assert (f==(a-b)) 
    else   $error("f!=a-b");
endtask
task left_shift;
    sel=LEFT;
    assert(randomize(a));
    assert(randomize(b)with{
        b<32'd5;
    });
    #1step;
    assert(f==(a<<b))
    else
    $error("f!=(a<<b)");
endtask
task sign_comp;
    sel=SC;
    assert(randomize(a));
    assert(randomize(b));
    #1step;
    assert(less==$unsigned($signed(a)<$signed(b)))
    else
    $error("less!=(a<b),a=%0d,b=%0d,less=%0b,$signed(a)<$signed(b)=%0b",$signed(a),$signed(b),less,$signed(a)<$signed(b));
endtask
task unsign_comp;
    sel=UC;
    assert(randomize(a));
    assert(randomize(b));
    #1step;
    assert(less==(a<b))
    else
    $error("less!=(a<b),a=%0d,b=%0d,less=%0b,a<b=%0b",a,b,less,a<b);
endtask
task ar;
    sel=AR;
    assert(randomize(a));
    assert(randomize(b)with{
        b<32'd5;
    });
    #1step;
    assert(f==(a>>b))
    else
    $error("f!=(a>>b)");
endtask
task lr;
    sel=LR;
    assert(randomize(a));
    assert(randomize(b)with{
        b<32'd5;
    });
    #1step;
    assert(f==(a>>>b))
    else
    $error("f!=(a>>>b)");
endtask
initial begin
    repeat(10)begin
        #1ns;
        add();
    end
    repeat(10)begin
        #1ns;
        sub();
    end
    repeat(10)begin
        #1ns;
        left_shift();
    end
    repeat(10)begin
        #1ns;
        sign_comp();
    end
    repeat(10)begin
        #1ns;
        unsign_comp();
    end
    repeat(10)begin
        #1ns;
        ar();
    end
    repeat(10)begin
        #1ns;
        lr();
    end
    $finish;
end
ALU u_ALU(
    .a(a),
    .b(b),
    .sel(sel),
    .f(f),
    .zero(zero),
    .less(less)
);
endmodule