module pc(

    input logic clk, // Clock signal
    input logic [31:0] next_pc, // Next program counter value
    input logic en, // Enable signal to update PC
    output logic [31:0] pc_value // Current program counter value
);
logic [31:0] pc_reg=0; // Register to hold the current PC value 
    always_ff @(posedge clk ) begin
         begin
        if (en) begin // Check if the enable signal is high
            pc_reg=next_pc; // Update PC with the next value
            pc_value = pc_reg; // Output the current PC value
        end
         end
    end

endmodule