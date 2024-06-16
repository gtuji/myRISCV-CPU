module CPU_TOP_TB;
bit clk,rst_n;
localparam PERIOD=20;
string path="E:/project/SystemVerilog/riscv/riscv_tests";
// initial begin
//     forever #(PERIOD/2) clk=~clk;
// end
// initial begin
//     repeat(3)@(posedge clk)
//         rst_n=1'b0;
//     rst_n=1'b1;
// end
integer maxcycles =10000;
integer numcycles;
string testcase;
//useful tasks
task step;  //step for one cycle ends 1ns AFTER the posedge of the next cycle
    begin
      #9  clk=1'b0;
      #10 clk=1'b1;
      numcycles = numcycles + 1;
      #1 ;
    end
  endtask
  
  task stepn; //step n cycles
    input integer n;
    integer i;
    begin
      for (i =0; i<n ; i=i+1)
        step();
    end
  endtask
  
  task resetcpu;  //reset the CPU and the test
    begin
      rst_n = 1'b0;
      step();
      #5 rst_n = 1'b1;
      numcycles = 0;
    end
  endtask
task run;
  integer i;
  begin
    i = 0;
    while( (u_CPU_TOP.inst_w!==32'hdead10cc) && (i<maxcycles))
    begin
      i = i+1;
      step();
    end
  end
endtask
task checkmagnum;
    begin
      if(numcycles>maxcycles)
    begin
      $display("!!!Error:test case %s does not terminate!", testcase);
    end
    else if(u_CPU_TOP.u_REG_FILE.regs[10]==32'hc0ffee)
        begin
          $display("OK:test case %s finshed OK at cycle %d.",
                    testcase, numcycles-1);
        end
    else if(u_CPU_TOP.u_REG_FILE.regs[10]==32'hdeaddead)
    begin
      $display("!!!ERROR:test case %s finshed with error in cycle %d.",
                testcase, numcycles-1);
    end
    else
    begin
        $display("!!!ERROR:test case %s unknown error in cycle %d.",
                testcase, numcycles-1);
    end
  end
endtask
task loadtestcase;  //load intstructions to instruction mem
    begin
        $readmemh({path,"/inst/",testcase, "-riscv32-npc.bin-logisim-inst.txt"},u_CPU_TOP.u_ICACHE.mem);
      $display("---Begin test case %s-----", testcase);
    end
  endtask
task loaddatamem;
    begin
      $readmemh({path,"/inst/",testcase, "-riscv32-npc.bin-logisim-inst.txt"},u_CPU_TOP.u_DCACHE.mem);
  end
endtask
task run_riscv_test;
    begin
    loadtestcase();
    loaddatamem();
    resetcpu();
    run();
    checkmagnum();
  end
endtask

initial begin
    testcase = "simple";
    run_riscv_test();
    testcase = "add";
    run_riscv_test();
    testcase = "addi";
    run_riscv_test();
    testcase = "and";
    run_riscv_test();
    testcase = "andi";
    run_riscv_test();
    testcase = "auipc";
    run_riscv_test();
    testcase = "beq";
    run_riscv_test();
    testcase = "bge";
    run_riscv_test();
    testcase = "bgeu";
    run_riscv_test();
    testcase = "blt";
    run_riscv_test();
    testcase = "bne";
    run_riscv_test();
    testcase = "jal";
    run_riscv_test();
    testcase = "jalr";
    run_riscv_test();
    testcase = "lb";
    run_riscv_test();
    testcase = "lbu";
    run_riscv_test();
    testcase = "lh";
    run_riscv_test();
    testcase = "lhu";
    run_riscv_test();
    testcase = "lui";
    run_riscv_test();
    testcase = "lw";
    run_riscv_test();
    testcase = "or";
    run_riscv_test();
    testcase = "ori";
    run_riscv_test();
    testcase = "sb";
    run_riscv_test();
    testcase = "sh";
    run_riscv_test();
    testcase = "sll";
    run_riscv_test();
    testcase = "slli";
    run_riscv_test();
    testcase = "slt";
    run_riscv_test();
    testcase = "slti";
    run_riscv_test();
    testcase = "sltiu";
    run_riscv_test();
    testcase = "sltu";
    run_riscv_test();
    testcase = "sra";
    run_riscv_test();
    testcase = "srai";
    run_riscv_test();
    testcase = "srl";
    run_riscv_test();
    testcase = "srli";
    run_riscv_test();
    testcase = "sub";
    run_riscv_test();
    testcase = "sw";
    run_riscv_test();
    testcase = "xor";
    run_riscv_test();
    testcase = "xori";
    run_riscv_test();
end
CPU_TOP u_CPU_TOP(
    .clk(clk),
    .rst_n(rst_n)
);

endmodule