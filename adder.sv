module adder (
    input logic [31:0] a, // First input
    input logic [31:0] b, // Second input
    output logic [31:0] sum // Output sum
);
    always @(*) begin
        sum = a + b; // Perform addition
    end
endmodule