module pipeF(
 input  logic [31:0] instructionF,
 input  logic [31:0] pcF,
 input  logic [31:0] pc_plus_4F,
 input  logic        en,
 input  logic        clk,
 input  logic        clr,
 output logic [31:0] instruction_outD,
 output logic [31:0] pc_outD,
 output logic [31:0] pc_plus_4D
);
always_ff @(posedge clk ) begin
    if (clr) begin
        instruction_outD <= 32'b0;
        pc_outD <= 32'b0;
        pc_plus_4D <= 32'b0;
    end else if (en) begin
        instruction_outD <= instructionF;
        pc_outD <= pcF;
        pc_plus_4D <= pc_plus_4F;
    end
end
endmodule
/////////////////////////
module pipeD(
input logic [31:0] RD1D,
input logic [31:0] RD2D,
input logic [31:0] immD,
input logic [31:0] pcD,
input logic [4:0] rs1D,
input logic [4:0] rs2D,
input logic [4:0] rdD,
input logic [31:0] pc_plus_4D,
input logic        regwriteD,
input logic [1:0] result_srcD,
input logic        memwriteD,
input logic        alusrcD,
input logic        branchD,
input logic        jumpD,
input logic [3:0] alu_controlD,
input logic        clk, 
input logic        clr,
output logic [31:0] RD1E,
output logic [31:0] RD2E,
output logic [31:0] immE,
output logic [31:0] pcE,
output logic [4:0] rs1E,
output logic [4:0] rs2E,
output logic [4:0] rdE,
output logic [31:0] pc_plus_4E,
output logic        regwriteE,
output logic [1:0] result_srcE,
output logic        memwriteE,
output logic        alusrcE,
output logic        branchE,
output logic        jumpE,
output logic [3:0] alu_controlE


);
always_ff @(posedge clk ) begin
    if (clr) begin
        RD1E <= 32'b0;
        RD2E <= 32'b0;
        immE <= 32'b0;
        pcE <= 32'b0;
        rs1E <= 5'b0;
        rs2E <= 5'b0;
        rdE <= 5'b0;
        pc_plus_4E <= 32'b0;
        regwriteE <= 1'b0;
        result_srcE <= 2'b00;
        memwriteE <= 1'b0;
        alusrcE <= 1'b0;
        branchE <= 1'b0;
        jumpE <= 1'b0;
        alu_controlE <= 4'b0000;
       
    end else begin
        RD1E <= RD1D;
        RD2E <= RD2D;
        immE <= immD;
        pcE <= pcD;
        rs1E <= rs1D;
        rs2E <= rs2D;
        rdE <= rdD;
        pc_plus_4E <= pc_plus_4D;
        regwriteE <= regwriteD;
        result_srcE <= result_srcD;
        memwriteE <= memwriteD;
        alusrcE <= alusrcD;
        branchE <= branchD;
        jumpE <= jumpD;
        alu_controlE <= alu_controlD;
        
    end
end
endmodule
/////////////////////////
module pipeE(
    input logic      regwriteE,
    input logic [1:0] result_srcE,
    input logic      memwriteE,
    input logic [31:0] alu_resultE,
    input logic [31:0] write_dataE  ,
    input logic [31:0] pc_plus_4E,
    input logic [4:0] RdE,
    input logic        clk,
    output logic      regwriteM,
    output logic [1:0] result_srcM,
    output logic      memwriteM,
    output logic [31:0] alu_resultM,
    output logic [31:0] write_dataM  ,
    output logic [31:0] pc_plus_4M,
    output logic [4:0] RdM

);
always_ff @(posedge clk) begin
    regwriteM <= regwriteE;
    result_srcM <= result_srcE;
    memwriteM <= memwriteE;
    alu_resultM <= alu_resultE;
    write_dataM <= write_dataE;
    pc_plus_4M <= pc_plus_4E;
    RdM <= RdE;
end

endmodule
/////////////////////////
module pipeM(
 input logic      regwriteM,
 input logic [1:0] result_srcM,
 input logic [31:0] alu_resultM,
 input logic [31:0] read_dataM,
 input logic [4:0] RdM,
 input logic [31:0] pc_plus_4M,
 input logic        clk,
 output logic      regwriteW,
 output logic [1:0] result_srcW,
 output logic [31:0] alu_resultW,
 output logic [31:0] read_dataW,
 output logic [4:0] RdW,
 output logic [31:0] pc_plus_4W

);
always_ff @(posedge clk) begin
    regwriteW <= regwriteM;
    result_srcW <= result_srcM;
    alu_resultW <= alu_resultM;
    read_dataW <= read_dataM;
    RdW <= RdM;
    pc_plus_4W <= pc_plus_4M;
end
endmodule