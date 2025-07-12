module control_unit (
    input  logic [6:0] opcode,
    output logic       branch,
    output logic       memwrite,
    output logic       alusrc,
    output logic       regwrite,
    output logic       jump,
    output logic [1:0]  imm_src,
    output logic [1:0] result_src,
    input  logic  funct7,
    input  logic [2:0] funct3,
    output logic [3:0] alu_control
);
logic [1:0] alu_op;
always @(*) begin
    case (opcode)
        7'b0110011: begin // R-type
            alusrc    = 0;
            result_src  = 2'b00;
            regwrite  = 1;
            memwrite  = 0;
            branch    = 0;
            alu_op     = 2'b10;
            jump      = 0;
        end

        7'b0000011: begin // lw
            alusrc    = 1;
            result_src  = 2'b01;
            regwrite  = 1;
            memwrite  = 0;
            branch    = 0;
            alu_op     = 2'b00;
            jump      = 0;
        end

        7'b0010011: begin // addi
            alusrc    = 1;
            result_src  = 2'b00;
            regwrite  = 1;
            memwrite  = 0;
            branch    = 0;
            alu_op     = 2'b00;
            jump      = 0;
        end

        7'b0100011: begin // sw
            alusrc    = 1;
            result_src  = 2'bxx; // don't care
            regwrite  = 0;
            memwrite  = 1;
            branch    = 0;
            alu_op     = 2'b00;
            jump      = 0;
        end

        7'b1100011: begin // beq
            alusrc    = 0;
            result_src  = 2'bxx; // don't care
            regwrite  = 0;
            memwrite  = 0;
            branch    = 1;
            alu_op     = 2'b01;
            jump      = 0;
        end

        7'b1101111: begin // jal
            alusrc    = 1'bx;
            result_src  = 2'b10;
            regwrite  = 1;
            memwrite  = 0;
            branch    = 0;
            alu_op     = 2'bxx;
            jump      = 1;
        end

        default: begin
            alusrc    = 0;
            result_src  = 2'b00;
            regwrite  = 1;
            memwrite  = 0;
            branch    = 0;
            alu_op     = 2'b00;
            jump      = 0;
        end
    endcase
end
always_comb begin
    case (alu_op)
        2'b00: alu_control = 4'b0010; // ADD
        2'b01: alu_control = 4'b0110; // SUB
        2'b10: begin // R-type or I-type
            case (funct3)
                3'b000: alu_control = (funct7 == 1'b0) ? 4'b0010 : 4'b0110; // ADD/SUB
                3'b001: alu_control = 4'b0001; // SLL
                3'b100: alu_control = 4'b0000; // XOR
                3'b101: alu_control = (funct7 == 1'b1) ? 4'b0100 : 4'b0101; // SRA/SRL
                3'b110: alu_control = 4'b1000; // OR
                3'b111: alu_control = 4'b0011; // AND
                default: alu_control = 4'b0000;
            endcase
        end
        default: alu_control = 4'b0000;
    endcase
end
always_comb begin
    case (opcode)
        7'b0000011,
        7'b0010011: imm_src = 2'b00; // I-type (lw, addi)
        7'b0100011: imm_src = 2'b01; // S-type (sw)
        7'b1100011: imm_src = 2'b10; // B-type (beq)
        7'b1101111: imm_src = 2'b11; // J-type (jal)
        7'b0110011: imm_src = 2'bxx; // R-type (no imm)
        default:    imm_src = 2'bxx;
    endcase
end

endmodule
