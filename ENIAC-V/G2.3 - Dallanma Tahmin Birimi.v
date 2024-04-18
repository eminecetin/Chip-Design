module branch_predictor(
    input wire clock,
    input wire reset,
    input wire branch,
    input wire branch_taken,
    output reg prediction
);
    reg [1:0] state;

    always @(posedge clock) begin
        if (reset) begin
            state <= 2'b00;
            prediction <= 1'b0;
        end else begin
            case (state)
                2'b00: begin
                    if (branch) prediction <= 1'b1;
                    else prediction <= 1'b0;
                end
                2'b01: begin
                    if (branch) prediction <= 1'b1;
                    else prediction <= 1'b0;
                end
                2'b10: begin
                    if (branch) prediction <= 1'b1;
                    else prediction <= 1'b0;
                end
                2'b11: begin
                    if (branch) prediction <= 1'b1;
                    else prediction <= 1'b0;
                end
            endcase
            if (branch) begin
                if (branch_taken) state <= state;
                else state <= state + 1;
            end else begin
                state <= state;
            end
        end
    end
endmodule
