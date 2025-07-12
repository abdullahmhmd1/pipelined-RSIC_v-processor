module instruction_mem (
    input  logic [31:0] pc_value,      // Current program counter value
    output logic [31:0] instruction    // Output instruction
);

    logic [31:0] instructions [0:255]; // Memory for instructions (256 x 32 bits)

    // Fetch instruction based on the lower 8 bits of the PC value
    assign instruction = instructions[pc_value[7:0] / 4];

endmodule
