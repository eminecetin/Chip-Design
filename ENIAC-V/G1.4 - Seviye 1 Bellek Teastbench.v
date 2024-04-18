module cache_memory_tb;

// Inputs
reg [31:0] address;
reg [31:0] write_data;
reg write_enable;
reg read_enable;

// Outputs
wire [31:0] read_data;

// Instantiate the cache_memory module
cache_memory mem (
  .address(address),
  .write_data(write_data),
  .write_enable(write_enable),
  .read_enable(read_enable),
  .read_data(read_data)
);

// Initialize the inputs
initial begin
  address = 0;
  write_data = 0;
  write_enable = 0;
  read_enable = 0;
end

// Write to the cache memory
always #5 write_enable = 1;
always #10 write_enable = 0;

// Read from the cache memory
always #15 read_enable = 1;
always #20 read_enable = 0;

endmodule
