`timescale 1ns / 1ps

module branch_predictor_tb();
  reg clock;
  reg branch;
  reg branch_taken;

  wire prediction;

  branch_predictor dut (
    .clock(clock),
    .branch(branch),
    .branch_taken(branch_taken),
    .prediction(prediction)
  );

  initial begin
    clock = 0;
    branch = 0;
    branch_taken = 0;
  end

  always #5 clock = ~clock;

  // Test case 1: Not a branch instruction
  initial begin
    #10 branch = 0;
    #10 branch_taken = 0;
    #10 $display("Not a branch instruction, prediction: %d", prediction);
  end

  // Test case 2: Not taken branch instruction
  initial begin
    #10 branch = 1;
    #10 branch_taken = 0;
    #10 $display("Not taken branch instruction, prediction: %d", prediction);
  end

  // Test case 3: Taken branch instruction
  initial begin
    #10 branch = 1;
    #10 branch_taken = 1;
    #10 $display("Taken branch instruction, prediction: %d", prediction);
  end

endmodule
