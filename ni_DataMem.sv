module ni_DataMemory(
    input logic clk_i,
    input logic [63:0] address_i, // Address from ALU or load instruction
    input logic [63:0] write_data_i, // Data from RegFile to write to memory
    input logic write_enable_i, // Write enable signal
    input logic read_enable_i, // Read enable signal
    input logic memtoreg_i, // Control signal to select data from memory or ALU
    input logic [63:0] alu_result_i, // ALU result
    output logic [63:0] read_data_o // Output data
);

    // Memory declaration: 64 locations of 64-bit width
    logic [63:0] data_memory [63:0];

    // Initialize memory with specific values
    initial begin
        data_memory[1] = 64'h0000000000000211; // Example value 1
        data_memory[2] = 64'h0000000000000522; // Example value 2
        data_memory[3] = 64'h0000000000000003; // Example value 3
        data_memory[4] = 64'h0000000000000005; // Example value 4
        // Add more initial values as needed
    end

    // Synchronous write operation
    always_ff @(posedge clk_i) begin
        if (write_enable_i) begin
            data_memory[address_i] <= write_data_i;
        end
    end

    // Combinational logic to select data to output
    always_comb begin
        if (memtoreg_i && read_enable_i) begin
            read_data_o = data_memory[address_i];
        end else begin
            read_data_o = alu_result_i;
        end
    end

endmodule
