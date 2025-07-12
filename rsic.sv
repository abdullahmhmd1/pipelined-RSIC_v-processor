module rsic (
  input  logic clk

);
wire [31:0] pcF;
wire [31:0] next_pcF;
wire [31:0] pc_puls4F;
wire [31:0] RDF;
wire [31:0] instrD;
wire [31:0] pcD;
wire [31:0] pc_puls4D;
wire        regwriteD;
wire [1:0]  resultsrcD;
wire        memwriteD;
wire        jumpD;
wire        branchD;
wire [3:0]  alu_controlD;
wire        alusrcD;
wire [1:0]  immsrcD;
wire [31:0] immD ;
wire [31:0] pc_plus_4D;
wire [31:0] RD1D;
wire [31:0] RD2D;
wire        regwriteE;
wire [1:0]  resultsrcE;
wire        memwriteE;
wire        jumpE;
wire        branchE;
wire [3:0]  alu_controlE;
wire        alusrcE;
wire        immsrcE;
wire [31:0] immE ;
wire [31:0] pc_plus_4E;
wire [31:0] RD1E;
wire [31:0] RD2E;
wire        zeroE;
wire        pcsrc;
assign pcsrc=(branchE&zeroE)|jumpE;
wire [31:0] pcE;
wire [4:0]  rs1E;
wire [4:0]  rs2E;
wire [4:0]  rdE;
wire [31:0] srcAE;
wire [31:0] srcBE;
wire [31:0] write_dataE;
wire [31:0] alu_resultE;
wire [31:0] pc_targetE;
wire        regwriteM;
wire [1:0]  resultsrcM;
wire        memwriteM;
wire [31:0] write_dataM;
wire [31:0] alu_resultM;
wire [4:0]  rdM;
wire [31:0] pc_plus_4M;
wire [31:0] RDM;
wire        regwriteW;
wire [1:0]  resultsrcW;
wire [31:0] alu_resultW;
wire [31:0] RDW;
wire [4:0]  rdW;
wire [31:0] pc_plus_4W;
wire [31:0] resultW;
wire       stallF;
wire       stallD;
wire       flushE;
wire       flushD;
wire [1:0] forwardAE;
wire [1:0] forwardBE;
mux2to1 pcmux(
  .a(pc_puls4F),
  .b(pc_targetE),
  .sel(pcsrc),
  .out(next_pcF)
);
mux2to1 alusrc_mux(
  .a(write_dataE),
  .b(immE),
  .sel(alusrcE),
  .out(srcBE)
);
mux3to1 srcAEmux(
  .a(RD1E),
  .b(resultW),
  .c(alu_resultM),
  .sel(forwardAE),
  .out(srcAE)
);
mux3to1 srcBEmux(
  .a(RD2E),
  .b(resultW),
  .c(alu_resultM),
  .sel(forwardBE),
  .out(write_dataE)
);
mux3to1 resultmux(
  .a(alu_resultW),
  .b(RDW),
  .c(pc_plus_4W),
  .sel(resultsrcW),
  .out(resultW)
);
reg_file regfile(
    .clk(~clk),                  // Clock signal
    .read_reg1(instrD[19:15]),     // Register to read from (rs1)
    .read_reg2(instrD[24:20]),     // Register to read from (rs2)
    .write_reg(rdW),     // Register to write to (rd)
    .write_data(resultW),   // Data to write
    .regwrite(regwriteW),             // Write enable signal
    .read_data1(RD1D),  // Output data from read_reg1
    .read_data2(RD2D)
);
pc pc1(
  .clk(clk), // Clock signal
  .next_pc(next_pcF), // Next program counter value
  .en(~stallF), // Enable signal to update PC
  .pc_value(pcF)
);
hazard_unit hu(
     .Rs1D(instrD[19:15]),
     .Rs2D(instrD[24:20]),
     .RdE(rdE),
     .Rs1E(rs1E),
     .rs2E(rs2E),
     .pc_src(pcsrc),
     .result_srcE(resultsrcE[0]),
     .regwriteM(regwriteM),
     .RdM(rdM),
     .RdW(rdW),
     .regwriteW(regwriteW),
     .stallF(stallF),
     .stallD(stallD),
     .flushE(flushE),
     .flushD(flushD),
     .forwardAE(forwardAE),
     .forwardBE(forwardBE)
);
M_alu alu(
 .a(srcAE), 
 .b(srcBE), // Inputs to the ALU
 .alucontrol(alu_controlE), // ALU control signal
 .result(alu_resultE), // Output of the ALU
 .zero(zeroE) // Zero flag
);
adder adder1(
  .a(pcE),
  .b(immE),
  .sum(pc_targetE)
);
adder adder2(
  .a(pcF),
  .b(32'd4),
  .sum(pc_puls4F)
);
control_unit cu(
    .opcode(instrD[6:0]),
    .branch(branchD),
    .memwrite(memwriteD),
    .alusrc(alusrcD),
    .regwrite(regwriteD),
    .jump(jumpD),
    .imm_src(immsrcD),
    .result_src(resultsrcD),
    .funct7(instrD[30]),
    .funct3(instrD[14:12]),
    .alu_control(alu_controlD)
);
data_mem dm(
   .clk(clk),         // Clock signal
   .address(alu_resultM),     // Address to read/write data
   .write_data(write_dataM),  // Data to write (if write enable is high)
   .mem_write(memwriteM),   // Write enable signal  
   .read_data(RDM)
);
imm_gen ig(
    .instruction(instrD[31:7]), 
    .imm_src(immsrcD),
    .imm (immD)
);
instruction_mem im(
  .pc_value(pcF),
  .instruction(RDF)
);
pipeF F(
  .instructionF(RDF),
  .pcF(pcF),
  .pc_plus_4F(pc_puls4F),
  .en(~stallD),
  .clk(clk),
  .clr(flushD),
  .instruction_outD(instrD),
  .pc_outD(pcD),
  .pc_plus_4D(pc_puls4D)
);
pipeD D(
.RD1D(RD1D),
.RD2D(RD2D),
.immD(immD),
.pcD(pcD),
.rs1D(instrD[19:15]),
.rs2D(instrD[24:20]),
.rdD(instrD[11:7]),
.pc_plus_4D(pc_puls4D),
.regwriteD(regwriteD),
.result_srcD(resultsrcD),
.memwriteD(memwriteD),
.alusrcD(alusrcD),
.branchD(branchD),
.jumpD(jumpD),
.alu_controlD(alu_controlD),
.clk(clk), 
.clr(flushE),
.RD1E(RD1E),
.RD2E(RD2E),
.immE(immE),
.pcE(pcE),
.rs1E(rs1E),
.rs2E(rs2E),
.rdE(rdE),
.pc_plus_4E(pc_plus_4E),
.regwriteE(regwriteE),
.result_srcE(resultsrcE),
.memwriteE(memwriteE),
.alusrcE(alusrcE),
.branchE(branchE),
.jumpE(jumpE),
.alu_controlE(alu_controlE)

);
pipeE E(
.regwriteE(regwriteE),
.result_srcE(resultsrcE),
.memwriteE(memwriteE),
.alu_resultE(alu_resultE),
.write_dataE(write_dataE),
.pc_plus_4E(pc_plus_4E),
.RdE(rdE),
.clk(clk),
.regwriteM(regwriteM),
.result_srcM(resultsrcM),
.memwriteM(memwriteM),
.alu_resultM(alu_resultM),
.write_dataM(write_dataM),
.pc_plus_4M(pc_plus_4M),
.RdM(rdM)
);
pipeM M(
.regwriteM(regwriteM),
.result_srcM(resultsrcM),
.alu_resultM(alu_resultM),
.read_dataM(RDM),
.RdM(rdM),
.pc_plus_4M(pc_plus_4M),
.clk(clk),
.regwriteW(regwriteW),
.result_srcW(resultsrcW),
.alu_resultW(alu_resultW),
.read_dataW(RDW),
.RdW(rdW),
.pc_plus_4W(pc_plus_4W)
);
























endmodule
