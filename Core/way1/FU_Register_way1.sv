module FU_Register_way1(
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
    input logic dataOk_i,
    input logic [2:0] writeState_i,
    // To FU
    output logic rdWriteEnable_o,
    output logic [4:0] rdAddr_o,
    output logic [63:0] rdData_o,
    output logic valid_o,
    output logic ready_o,
    output logic [1:0] way1_pID_o,
    output logic [6:0] opCode_o,
    output logic [2:0] funct3_o,
    // To RAM
    output logic [31:0] readAddr_o,
    output logic [31:0] writeAddr_o,
    output logic [63:0] writeData_o,
    output logic [3:0] writeMask_o
);

    wire WFull;
    wire REmpty;
    assign ready_o = ready_i;


	DataBuffer #( .DataWidth(1) )
	FU_rdWriteEnable_Buffer_way1 ( 
		.Clk( clk ), 
		.Rst( reset_n ), 
		.WData( rdWriteEnable_i ), 
		.WInc( valid_i ), 
		.WFull( WFull ), 
		.RData( rdWriteEnable_o ), 
		.RInc( ready_i ), 
		.REmpty( REmpty ), 
		.Jump(  ) 
	);

	DataBuffer #( .DataWidth(5) )
	FU_rdAddr_Buffer_way1 ( 
		.Clk( clk ), 
		.Rst( reset_n ), 
		.WData( rdAddr_i ), 
		.WInc( valid_i ), 
		.WFull(  ), 
		.RData( rdAddr_o ), 
		.RInc( ready_i ), 
		.REmpty(  ), 
		.Jump(  ) 
	);

	DataBuffer #( .DataWidth(64) )
	FU_rdData_Buffer_way1 ( 
		.Clk( clk ), 
		.Rst( reset_n ), 
		.WData( rdData_i ), 
		.WInc( valid_i ), 
		.WFull(  ), 
		.RData( rdData_o ), 
		.RInc( ready_i ), 
		.REmpty(  ), 
		.Jump(  ) 
	);

	DataBuffer #( .DataWidth(2) )
	FU_way1_pID_Buffer_way1 ( 
		.Clk( clk ), 
		.Rst( reset_n ), 
		.WData( way1_pID_i ), 
		.WInc( valid_i ), 
		.WFull(  ), 
		.RData( way1_pID_o ), 
		.RInc( ready_i ), 
		.REmpty(  ), 
		.Jump(  ) 
	);

    DataBuffer #( .DataWidth(7) )
	FU_opCode_Buffer_way1 ( 
		.Clk( clk ), 
		.Rst( reset_n ), 
		.WData( opCode_i ), 
		.WInc( valid_i ), 
		.WFull(  ), 
		.RData( opCode_o ), 
		.RInc( ready_i ), 
		.REmpty(  ), 
		.Jump(  ) 
	);

	DataBuffer #( .DataWidth(3) )
	FU_funct3_Buffer_way1 ( 
		.Clk( clk ), 
		.Rst( reset_n ), 
		.WData( funct3_i ), 
		.WInc( valid_i ), 
		.WFull(  ), 
		.RData( funct3_o ), 
		.RInc( ready_i ), 
		.REmpty(  ), 
		.Jump(  ) 
	);

	DataBuffer #( .DataWidth(32) )
	FU_readAddr_Buffer_way1 ( 
		.Clk( clk ), 
		.Rst( reset_n ), 
		.WData( readAddr_i ), 
		.WInc( valid_i ), 
		.WFull(  ), 
		.RData( readAddr_o ), 
		.RInc( ready_i ), 
		.REmpty(  ), 
		.Jump(  ) 
	);

	DataBuffer #( .DataWidth(32) )
	FU_writeAddr_Buffer_way1 ( 
		.Clk( clk ), 
		.Rst( reset_n ), 
		.WData( writeAddr_i ), 
		.WInc( valid_i ), 
		.WFull(  ), 
		.RData( writeAddr_o ), 
		.RInc( ready_i ), 
		.REmpty(  ), 
		.Jump(  ) 
	);

	DataBuffer #( .DataWidth(64) )
	FU_writeData_Buffer_way1 ( 
		.Clk( clk ), 
		.Rst( reset_n ), 
		.WData( writeData_i ), 
		.WInc( valid_i ), 
		.WFull(  ), 
		.RData( writeData_o ), 
		.RInc( ready_i ), 
		.REmpty(  ), 
		.Jump(  ) 
	);

	DataBuffer #( .DataWidth(4) )
	FU_writeMask_Buffer_way1 ( 
		.Clk( clk ), 
		.Rst( reset_n ), 
		.WData( writeMask_i ), 
		.WInc( valid_i ), 
		.WFull(  ), 
		.RData( writeMask_o ), 
		.RInc( ready_i ), 
		.REmpty(  ), 
		.Jump(  ) 
	);

    always_ff @(posedge clk or negedge reset_n) begin
        if(~reset_n) begin
            valid_o <= 1'b0;
        end else if(ready_i && ~REmpty) begin
            valid_o <= 1'b1;
        end else begin
            valid_o <= 1'b0;
        end 
    end

    // typedef enum reg[1:0] { 
    //     idel,
    //     read,
    //     write
    // } state;

    // state currentState, nextState;

    // // assign ready_o = ready_i;
    // assign readAddr_o = readAddr_i;
    // assign writeAddr_o = writeAddr_i;
    // assign writeData_o = writeData_i;
    // assign writeMask_o = writeMask_i;

    // always_ff @(posedge clk or negedge reset_n) begin
    //     if(~reset_n)
    //         currentState <= idel;
    //     else
    //         currentState <= nextState;
    // end
    // always_comb begin
    //     case (currentState)
    //         idel : begin
    //             if(|readAddr_i)
    //                 nextState = read;
    //             else if(|writeAddr_i)
    //                 nextState = write;
    //             else 
    //                 nextState = idel;
    //         end
    //         read : begin
    //             if(dataOk_i && |readAddr_i && valid_i)
    //                 nextState = read;
    //             else if(dataOk_i)
    //                 nextState = idel;
    //             else
    //                 nextState = read;
    //         end
    //         write : begin
    //             if(&writeState_i && |writeAddr_i && valid_i)
    //                 nextState = write;
    //             else if(&writeState_i)
    //                 nextState = idel;
    //             else
    //                 nextState = write;
    //         end
    //         default : begin
    //             nextState = idel;
    //         end
    //     endcase
    // end
    // always_ff @(posedge clk or negedge reset_n) begin
    //     case (currentState)
    //         idel : begin
    //             if(|readAddr_i || |writeAddr_i)
    //                 ready_o <= 1'b0;
    //             else
    //                 ready_o <= ready_i;
    //         end
    //         read : begin
    //             if(dataOk_i && |readAddr_i && valid_i)
    //                 ready_o <= 1'b0;
    //             else if(dataOk_i)
    //                 ready_o <= ready_i;
    //             else
    //                 ready_o <= 1'b0;
    //         end
    //         write : begin
    //             if(&writeState_i && |writeAddr_i && valid_i)
    //                 ready_o <= 1'b0;
    //             else if(&writeState_i)
    //                 ready_o <= ready_i;
    //             else
    //                 ready_o <= 1'b0;
    //         end
    //         default : begin
    //             ready_o <= 1'b0;
    //         end
    //     endcase 
    // end

    // // 待优化：根据标志信号，使得数据、地址总线可重用
    // always_ff @(posedge clk or negedge reset_n) begin
    //     if(~reset_n) begin
    //         rdWriteEnable_o <= 1'b0;
    //         rdAddr_o <= 5'b0;
    //         rdData_o <= 64'b0;
    //         way1_pID_o <= 2'b0;
    //         funct3_o <= 3'b0;
    //     end else if(ready_i) begin
    //         rdWriteEnable_o <= rdWriteEnable_i;
    //         rdAddr_o <= rdAddr_i;
    //         rdData_o <= rdData_i;
    //         way1_pID_o <= way1_pID_i;
    //         funct3_o <= funct3_i;;
    //     end
    // end

    // // valid只表明数据有效，不具备握手功能
    // always_ff @(posedge clk or negedge reset_n) begin
    //     if(~reset_n) begin
    //         valid_o <= 1'b0;
    //     end else if(ready_i) begin
    //         valid_o <= 1'b1;
    //     end else begin
    //         valid_o <= 1'b0;
    //     end
    // end

    `ifdef DebugMode
	    DataBuffer #( .DataWidth(32) )
        FU_inst_Buffer_way1 ( 
            .Clk( clk ), 
            .Rst( reset_n ), 
            .WData( inst_i ), 
            .WInc( valid_i ), 
            .WFull(  ), 
            .RData( inst_o ), 
            .RInc( ready_i ), 
            .REmpty(  ), 
            .Jump(  ) 
        );

        DataBuffer #( .DataWidth(32) )
        FU_instAddr_Buffer_way1 ( 
            .Clk( clk ), 
            .Rst( reset_n ), 
            .WData( instAddr_i ), 
            .WInc( valid_i ), 
            .WFull(  ), 
            .RData( instAddr_o ), 
            .RInc( ready_i ), 
            .REmpty(  ), 
            .Jump(  ) 
        );
    `endif 

endmodule