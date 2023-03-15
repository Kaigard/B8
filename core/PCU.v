
module PCU (
    input clk,
    input reset_n,
    input ready_i,
    input jumpFlag_i,
    input [31:0] jumpAddr_i,
    output reg valid_o,
    output reg [31:0] instAddr_o
);

    wire WFull;
    wire REmpty;
    wire [31:0] jumpAddr_buffer;

    DataBuffer #(.DataWidth(32)) 
    PCU_DataBuffer
    (
        .Clk(clk),
        .Rst(reset_n),
        .WData(jumpAddr_i),
        .WInc(jumpFlag_i),
        .WFull(WFull),
        .RData(jumpAddr_buffer),
        .RInc(WFull && ready_i),
        .REmpty(REmpty)
    );

    always @(posedge clk or negedge reset_n) begin
        if(~reset_n) begin
            instAddr_o <= 32'b0;
            valid_o <= 1'b1;
        end else begin
            if(~ready_i) begin
                instAddr_o <= instAddr_o;
                valid_o <= 1'b0;
            end else begin
                if(~REmpty) begin
                    instAddr_o <= jumpAddr_buffer;
                    valid_o <= 1'b1;
                end else begin
                    instAddr_o <= instAddr_o + 4;
                    valid_o <= 1'b1;
                end
            end
        end
    end

endmodule