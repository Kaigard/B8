module PCU_way1
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
            reg request;
            wire WFull;
            wire REmpty;

            always_ff @(posedge clk or negedge reset_n) begin
                if(~reset_n) begin
                    PC <= 32'h0000_0004;
                    request <= 1'b0;
                end else begin
                    if(ready_i && ~WFull) begin
                        if(jumpFlag_i) begin
                            PC <= jumpAddr_i;
                            request <= 1'b1;
                        end else begin
                            PC <= PC + 8;
                            request <= 1'b1;
                        end
                    end else begin
                        PC <= PC;
                        request <= 1'b0;
                    end
                end
            end

            DataBuffer #( .DataWidth(32) )
            EU_rdAddr_Buffer_way1 ( 
                .Clk( clk ), 
                .Rst( reset_n ), 
                .WData( PC ), 
                .WInc( dataOk_i ), 
                .WFull( WFull ), 
                .RData( instAddr_o ), 
                .RInc( ready_i ), 
                .REmpty( REmpty ), 
                .Jump( jumpFlag_i ) 
            );

            DataBuffer #( .DataWidth(1) )
            EU_request_Buffer_way1 ( 
                .Clk( clk ), 
                .Rst( reset_n ), 
                .WData( request ), 
                .WInc( dataOk_i ), 
                .WFull(  ), 
                .RData( request_o ), 
                .RInc( ready_i ), 
                .REmpty(  ), 
                .Jump( jumpFlag_i ) 
            );

            always_ff @(posedge clk or negedge reset_n) begin
                if(~reset_n) begin
                    valid_o <= 1'b0;
                end else begin
                    if(ready_i && ~jumpFlag_i) begin
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