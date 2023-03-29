module WBU_Register_way1(
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
    input logic dataOk_i,
    input logic [2:0] writeState_i,

    output logic rdWriteEnable_o,
    output logic [4:0] rdAddr_o,
    output logic [63:0] rdData_o,
    output logic valid_o,
    output logic ready_o,
    output logic [1:0] way1_pID_o
);

    assign ready_o = ready_i;

	DataBuffer #( .DataWidth(1) )
	WBU_rdWriteEnable_Buffer_way1 ( 
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
	WBU_rdAddr_Buffer_way1 ( 
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
	WBU_rdData_Buffer_way1 ( 
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
	WBU_way1_pID_Buffer_way1 ( 
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

    always_ff @(posedge clk or negedge reset_n) begin
        if(~reset_n) begin
            valid_o <= 1'b0;
        end else if(ready_i && ~REmpty) begin
            valid_o <= 1'b1;
        end else begin
            valid_o <= 1'b0;
        end
    end

    `ifdef DebugMode
        DataBuffer #( .DataWidth(32) )
        WBU_inst_Buffer_way1 ( 
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
        WBU_instAddr_Buffer_way1 ( 
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