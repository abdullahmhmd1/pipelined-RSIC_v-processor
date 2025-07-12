module hazard_unit (
    input  logic [4:0] Rs1D, Rs2D, Rs1E, rs2E,
    input  logic [4:0] RdE, RdM, RdW,
    input  logic       regwriteM, regwriteW,
    input  logic       pc_src,
    input  logic       result_srcE,  // 1 = load instruction in EX stage

    output logic [1:0] forwardAE, forwardBE,
    output logic       stallF, stallD,
    output logic       flushD, flushE
);

    always_comb begin
        // Default values
        forwardAE = 2'b00;
        forwardBE = 2'b00;
        stallF    = 1'b0;
        stallD    = 1'b0;
        flushD    = 1'b0;
        flushE    = 1'b0;

        // Forwarding logic
        if ((Rs1E == RdM) && regwriteM && (Rs1E != 0))
            forwardAE = 2'b10;
        else if ((Rs1E == RdW) && regwriteW && (Rs1E != 0))
            forwardAE = 2'b01;

        if ((rs2E == RdM) && regwriteM && (rs2E != 0))
            forwardBE = 2'b10;
        else if ((rs2E == RdW) && regwriteW && (rs2E != 0))
            forwardBE = 2'b01;

        // Load-use hazard (stall)
        if (result_srcE && ((Rs1D == RdE) || (Rs2D == RdE))) begin
            stallF = 1'b1;
            stallD = 1'b1;
            flushE = 1'b1;
        end

        // Branch taken
        if (pc_src) begin
            flushD = 1'b1;
            flushE = 1'b1; // combine with previous flushE
        end
    end

endmodule
