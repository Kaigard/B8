module FetchUnit_way1(
    `ifdef DebugMode
        input logic [31:0] instAddr_i,
        input logic [31:0] inst_i,
        output logic [31:0] instAddr_o,
        output logic [31:0] inst_o, 
    `endif
    input logic clk,
    input logic reset_n,  
    input logic rdWriteEnable_i,
    input logic [4:0] rdAddr_i,
    input logic [63:0] rdData_i,
    input logic valid_i,
    input logic ready_i,
    input logic [1:0] way1_pID_i,
    input logic [6:0] opCode_i,
    input logic [2:0] funct3_i,
    input logic [31:0] readAddr_i,
    input logic [31:0] writeAddr_i,
    input logic [63:0] writeData_i,
    input logic [3:0] writeMask_i, 
    // From RAM
    input logic [63:0] readData_i,
    input logic dataOk_i,
    input logic [2:0] writeState_i,
    // To WBU
    output logic rdWriteEnable_o,
    output logic [4:0] rdAddr_o,
    output logic [63:0] rdData_o,
    output logic valid_o,
    output logic ready_o,
    output logic [1:0] way1_pID_o,
    // output logic dataOk_o,
    // output logic [2:0] writeState_o
    // To RAM
    output logic [31:0] readAddr_o,
    output logic [31:0] writeAddr_o,
    output logic [63:0] writeData_o,
    output logic [3:0] writeMask_o
);
    
    wire [63:0] readData;
    wire WFull_writeReady;
    wire WFull_readReady;
    wire REmpty_writeReady;
    wire REmpty_readReady;
    wire [63:0] rdWriteData_o_reg;
    reg valid_read_ready_o;

    assign rdData_o = rdWriteData_o_reg;
    assign rdWriteEnable_o = rdWriteEnable_i;
    assign rdAddr_o = rdAddr_i;
    assign valid_o = valid_i && ~|readAddr_i || dataOk_i;
    assign way1_pID_o = way1_pID_i;
    assign readAddr_o = valid_i ? readAddr_i : 32'b0;
    assign writeAddr_o = valid_i ? writeAddr_i : 32'b0;
    assign writeData_o = valid_i ? writeData_i : 64'b0;
    assign writeMask_o = valid_i ? writeMask_i : 4'b0;
    assign ready_o =  ~WFull_writeReady && ~WFull_readReady &&
                      ~|writeAddr_i && ~|readAddr_i && ready_i ||
                      dataOk_i || &writeState_i;

    DataBuffer #( .DataWidth(1), .ModeType(1) )
	FU_way1_write_ready_way1 ( 
		.Clk( clk ), 
		.Rst( reset_n ), 
		.WData( 1'b0 ), 
		.WInc( valid_i && |writeAddr_i ), 
		.WFull( WFull_writeReady ), 
		.RData(  ), 
		.RInc( &writeState_i && ~REmpty_writeReady ), 
		.REmpty( REmpty_writeReady ), 
		.Jump(  ) 
	);

    DataBuffer #( .DataWidth(1), .ModeType(1) )
	FU_way1_read_ready_way1 ( 
		.Clk( clk ), 
		.Rst( reset_n ), 
		.WData( 1'b0 ), 
		.WInc( valid_i && |readAddr_i ), 
		.WFull( WFull_readReady ), 
		.RData(  ), 
		.RInc( dataOk_i && ~REmpty_readReady ), 
		.REmpty( REmpty_readReady ), 
		.Jump(  ) 
	);

    MuxKeyWithDefault #(1, 7, 64) rdWriteData_mux (rdWriteData_o_reg, (dataOk_i ? opCode_i : 7'b0), rdData_i, {
    //Load
    7'b0000011, readData
    });
        MuxKeyWithDefault #(7, 3, 64) readData_mux (readData, funct3_i, 64'b0, {
            //Ld
            3'b011, readData_i,
            //Lw
            3'b010, {{32{readData_i[31]}}, readData_i[31:0]},
            //Lh
            3'b001, {{48{readData_i[31]}}, readData_i[15:0]},
            //Lb
            3'b000, {{56{readData_i[31]}}, readData_i[7:0]},
            //Lbu
            3'b100, {{56{1'b0}}, readData_i[7:0]},
            //Lhu
            3'b101, {{48{1'b0}}, readData_i[15:0]},
            //Lwu
            3'b110, {{32{1'b0}}, readData_i[31:0]}
        });

    `ifdef DebugMode
        assign instAddr_o = instAddr_i;
        assign inst_o = inst_i;
    `endif

endmodule