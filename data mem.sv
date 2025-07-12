module data_mem (
    input  logic        clk,         // Clock signal
    input  logic [31:0] address,     // Address to read/write data
    input  logic [31:0] write_data,  // Data to write (if write enable is high)
    input  logic        mem_write,   // Write enable signal
    output logic [31:0] read_data    // Data read from memory
);

    logic [31:0] memory [0:255]; // Memory array (256 x 32 bits)

    // Continuous read from memory
    assign read_data = memory[address[7:0] / 4];

    // Write operation on positive clock edge
    always_ff @(posedge clk) begin
        if (mem_write) begin
            memory[address[7:0] / 4] <= write_data;
        end
    end

endmodule
