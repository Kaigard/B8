
module PCU_way0 (
    input logic clk,
    input logic reset_n,
    input logic ready_i,
    input logic jumpFlag_i,
    input logic [31:0] jumpAddr_i,
    output logic valid_o,
    output logic [31:0] instAddr_o
);

    always_ff @(posedge clk or negedge reset_n) begin
        if(~reset_n) begin
            instAddr_o <= 32'b0;
            valid_o <= 1'b1;
        end else begin
            if(ready_i) begin
                instAddr_o <= instAddr_o + 8;
                valid_o <= 1'b1;
            end else begin
                if(jumpFlag_i) begin
                    instAddr_o <= jumpAddr_i;
                    valid_o <= 1'b1;
                end else begin
                    instAddr_o <= instAddr_o;
                    valid_o <= 1'b0;
                end
            end
        end
    end

endmodule