module DataBuffer
#(
    parameter DataWidth = 64,
    parameter ModeType = 0
)
(
    input logic Clk,
    input logic Rst,
    input logic [DataWidth - 1 : 0] WData,
    input logic WInc,
    output logic WFull,
    output logic [DataWidth - 1 : 0] RData, 
    input logic RInc,
    output logic REmpty,
    input logic Jump
);
    
    reg [DataWidth:0] dataRegister;
    
    // ModeTyep :
    //           0                      含无间断流水buffer
    //           1                      不含无间断流水buffer
    generate 
        if(ModeType == 0) begin : PipelineMode
            wire isPipeline = WInc && RInc;

            assign WFull = isPipeline ? 1'b0 : dataRegister[DataWidth];
            assign REmpty = isPipeline ? 1'b0 : ~WFull;

            //****************************logic****************************
            // if(WInc && RInc) RData <= WData; dataRegister[DataWidth] <= 1'b1;
            // if(WInc && ~RInc) dataRegister[DataWidth:0] <= {1'b1, WData};  
            // if(~WInc && RInc) RData <= dataRegister[DataWidth-1:0]; dataRegister[DataWidth] <= 1'b0;
            //*************************************************************
            always_ff @(posedge Clk or negedge Rst) begin
                if(~Rst) begin
                    RData <= 'b0;
                    dataRegister <= 'b0;
                end else if(Jump) begin
                    RData <= 'b0;
                    dataRegister <= 'b0;
                end else begin
                    case ({WInc, RInc})
                        2'b11 : begin
                            RData <= WData;
                            dataRegister[DataWidth] <= 1'b0;
                            dataRegister[DataWidth-1:0] <= 'b0;
                        end
                        2'b01 : begin
                            RData <= dataRegister[DataWidth-1:0];
                            dataRegister[DataWidth] <= 1'b0;
                        end
                        2'b10 : begin
                            RData <= RData;
                            dataRegister[DataWidth:0] <= {1'b1, WData};
                        end
                        2'b00 : begin
                            RData <= RData;
                            dataRegister <= dataRegister;
                        end
                        default : begin
                            
                        end
                    endcase
                end
            end
        end else if(ModeType == 1) begin
            assign WFull = dataRegister[DataWidth];
            assign REmpty = ~WFull;

            //****************************logic****************************
            // if(WInc && RInc) RData <= WData; dataRegister[DataWidth] <= 1'b1;
            // if(WInc && ~RInc) dataRegister[DataWidth:0] <= {1'b1, WData};  
            // if(~WInc && RInc) RData <= dataRegister[DataWidth-1:0]; dataRegister[DataWidth] <= 1'b0;
            //*************************************************************
            always_ff @(posedge Clk or negedge Rst) begin
                if(~Rst) begin
                    RData <= 'b0;
                    dataRegister <= 'b0;
                end else begin
                    case ({WInc, RInc})
                        2'b01 : begin
                            RData <= dataRegister[DataWidth-1:0];
                            dataRegister[DataWidth] <= 1'b0;
                        end
                        2'b10 : begin
                            RData <= RData;
                            dataRegister[DataWidth:0] <= {1'b1, WData};
                        end
                        2'b00, 2'b11 : begin
                            RData <= RData;
                            dataRegister <= dataRegister;
                        end
                        default : begin
                            
                        end
                    endcase
                end
            end
        end
    endgenerate

endmodule