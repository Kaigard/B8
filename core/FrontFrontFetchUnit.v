module FrontFrontFetchUnit (
    `ifdef TestMode
        output reg [31:0] instAddr_o,
    `endif

    input clk,
    input reset_n,
    input valid_i,
    input ready_i,
    input jumpFlag_i,
    input dataOk_i,
    input [31:0] jumpAddr_i,
    input [31:0] instAddr_i,
    input [31:0] inst_fetch_i,
    output reg ready_o,
    output request_o,
    output [31:0] instAddr_fetch_o,
    output reg [31:0] inst_o
);
    
    assign request_o = valid_i;
    assign instAddr_fetch_o = instAddr_i;

    always @(posedge clk or negedge reset_n) begin
        if(~reset_n) begin
            inst_o <= 32'b0;
            ready_o <= 1'b0;
        end else begin
            if(ready_i && dataOk_i) begin
                inst_o <= inst_fetch_i;
                ready_o <= 1'b1;
            end else begin
                inst_o <= inst_o;
                ready_o <= 1'b0;
            end
        end
    end
    
    `ifdef TestMode
        always @(posedge clk or negedge reset_n) begin
            if(~reset_n)
                instAddr_o <= 32'b0;
            else if(ready_i && dataOk_i)
                instAddr_o <= instAddr_i;
        end
    `endif

endmodule