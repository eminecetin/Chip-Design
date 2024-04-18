module cache_controller_tb;
  reg [ADDR_WIDTH-1:0] addr;
  reg [31:0] data_in;
  reg [31:0] data_out;
  reg [1:0] rw;
  reg [2:0] hit_miss;
  reg stall;
  reg we;
  wire [31:0] data_out;
  wire [2:0] hit_miss;
  wire stall;
  
  cache_controller cache_ctrl(.clk(clk), .reset(reset), .addr(addr),
                               .data_in(data_in), .data_out(data_out),
                               .rw(rw), .hit_miss(hit_miss), .stall(stall),
                               .we(we));

  initial begin
    // write test cases
    we = 1;
    rw = 2'b01;
    data_in = 32'hdeadbeef;
    addr = 32'h10000000;
    #1
    we = 0;
    rw = 2'b00;
    addr = 32'h10000000;
    #1
    if (data_out == 32'hdeadbeef) begin
      $display("Write test case 1 passed");
    end else begin
      $display("Write test case 1 failed");
    end
    // read test cases
    rw = 2'b00;
    addr = 32'h10000000;
    #1
    if (data_out == 32'hdeadbeef) begin
      $display("Read test case 1 passed");
    end else begin
      $display("Read test case 1 failed");
    end
    // miss test cases
    rw = 2'b00;
    addr = 32'h20000000;
    #1
    if (hit_miss == 2'b10) begin
      $display("Miss test case 1 passed");
    end else begin
      $display("Miss test case 1 failed");
    end
    // hit test cases
    rw = 2'b00;
    addr = 32'h10000000;
    #1
    if (hit_miss == 2'b01) begin
      $display("Hit test case 1 passed");
    end else begin
      $display("Hit test case 1 failed");
    end
  end
endmodule
