module PCU_way0
#(parameter ModeType = 0)
 (
    input logic clk,
    input logic reset_n,
    input logic ready_i,
    input logic dataOk_i,
    input logic jumpFlag_i,
    input logic [31:0] jumpAddr_i,
    output logic request_o,
    output logic valid_o,
    output logic [31:0] instAddr_o
);

    generate
        if(ModeType == 0) begin : BusMode

            reg [31:0] PC;
            wire WFull;
            wire REmpty;

            always_ff @(posedge clk or negedge reset_n) begin
                if(~reset_n) begin
                    PC <= 0;
                    request_o <= 1'b0;
                end else begin
                    if(ready_i && ~WFull) begin
                        PC <= PC + 4;
                        request_o <= 1'b1;
                    end else begin
                        PC <= PC;
                        request_o <= 1'b0;
                    end
                end
            end

            DataBuffer #( .DataWidth(32) )
            EU_rdAddr_Buffer_way0 ( 
                .Clk( clk ), 
                .Rst( reset_n ), 
                .WData( PC ), 
                .WInc( dataOk_i ), 
                .WFull( WFull ), 
                .RData( instAddr_o ), 
                .RInc( ready_i ), 
                .REmpty( REmpty ), 
                .Jump(  ) 
            );

            always_ff @(posedge clk or negedge reset_n) begin
                if(~reset_n) begin
                    valid_o <= 1'b0;
                end else begin
                    if(ready_i) begin
                        valid_o <= 1'b1;
                    end else begin
                        valid_o <= 1'b0;
                    end
                end
            end

        end else if(ModeType == 1) begin : CacheMode
         
        end
    endgenerate

endmodule