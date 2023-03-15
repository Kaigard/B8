module FrontFetchUnit (
    `ifdef TestMode
        input [31:0] instAddr_i,
        output reg [31:0] instAddr_o,
    `endif

    input clk,
    input reset_n,
    input valid_i,
    input ready_i,
    input jumpFlag_i,
    input [31:0] jumpAddr_i,
    input [31:0] inst_i,
    input [31:0] inst_fetch_i,
    output reg valid_o,
    output ready_o,
    output [31:0] instAddrForFetch_o,
    output reg [31:0] inst_o
);

    assign instAddrForFetch_o = jumpFlag_i ? (jumpAddr_i + 4) : 32'b0; 
    assign ready_o = ready_i;

    always @(posedge clk or negedge reset_n) begin
        if(~reset_n) begin
            inst_o <= 32'b0;
            valid_o <= 1'b0;
        end else begin
            if(jumpFlag_i) begin
                inst_o <= inst_fetch_i;
                valid_o <= 1'b1;
            end else if(valid_i && ready_o) begin
                inst_o <= inst_i;
                valid_o <= 1'b1;
            end else
                valid_o <= 1'b0;
        end
    end 

    `ifdef TestMode
        always @(posedge clk or negedge reset_n) begin
            if(~reset_n) 
                instAddr_o <= 32'b0;
            else
                instAddr_o <= instAddr_i;
        end
    `endif

endmodule