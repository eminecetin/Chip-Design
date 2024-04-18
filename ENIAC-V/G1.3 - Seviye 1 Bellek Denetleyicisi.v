module cache_controller #(
  parameter CACHE_SIZE = 4 * 1024, 
  parameter BLOCK_SIZE = 32, 
  parameter ADDR_WIDTH = 12
  // Define start and end addresses for cache memory range
  parameter CACHE_START = 32'h40000000;
  parameter CACHE_END = 32'h40100000;
) (
  input clk,
  input [ADDR_WIDTH-1:0] addr,
  input [31:0] data_in,
  input we,
  input cs,
  output reg [31:0] data_out,
  output stall,
  output reg [31:0] data_to_memory
);

  // Constants
  localparam BLOCKS = CACHE_SIZE / BLOCK_SIZE;
  localparam OFFSET_WIDTH = log2(BLOCK_SIZE);
  localparam INDEX_WIDTH = log2(BLOCKS);

  // Cache memory
  cache_memory cache (
    .clk(clk),
    .addr(addr),
    .data_in(data_to_memory),
    .we(we),
    .cs(cs),
    .data_out(data_out)
  );

  // Cache memory state
  reg [31:0] cache_mem [0:BLOCKS-1][0:(BLOCK_SIZE/4)-1];
  reg [ADDR_WIDTH-1:0] cache_tag [0:BLOCKS-1];
  reg cache_valid [0:BLOCKS-1];

  // Outputs
  assign data_to_memory = data_out;
  assign stall = 0;

    // Check if incoming address is within the memory range
  always @(posedge clk) begin
    if (addr >= CACHE_START && addr <= CACHE_END) begin
        if (cs) begin
        // Address signals
        reg [INDEX_WIDTH-1:0] index = addr[ADDR_WIDTH-1:OFFSET_WIDTH];
        reg [OFFSET_WIDTH-1:0] offset = addr[OFFSET_WIDTH-1:0];

        if (cache_valid[index] & (cache_tag[index] == addr[ADDR_WIDTH-1:OFFSET_WIDTH+INDEX_WIDTH])) begin
          // Hit
          data_out <= cache_mem[index][offset];
          if (we) begin
            cache_mem[index][offset] <= data_in;
            if (ALLOCATE) begin
              // Write allocate
              cache_mem[index][offset] <= data_in;
              cache_valid[index] <= 1;
              cache_tag[index] <= addr[ADDR_WIDTH-1:OFFSET_WIDTH+INDEX_WIDTH];
            end
            else begin
              // Write through
              cache_mem[index][offset] <= data_in;
              stall <= 1;
            end
          end
        end
        else begin
          // Miss
          data_to_memory <= cache_mem[index][0];
          cache_mem[index][0] <= data_out;
          cache_valid[index] <= 1;
          cache_tag[index] <= addr[ADDR_WIDTH-1:OFFSET_WIDTH+INDEX_WIDTH];
          if (we & ALLOCATE) begin
            cache_mem[index][offset] <= data_in;
          end
          stall <= 1;
        end
      end
    end else begin
      // Pass through accesses for addresses outside of memory range
      data_out <= data_in;
    end
  end
endmodule
