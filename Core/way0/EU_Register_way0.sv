module EU_Register_way0(
    `ifdef DebugMode
        input logic [31:0] inst_i,
        output logic [31:0] inst_o,
    `endif
    input logic clk,
    input logic reset_n,
    input logic [4:0] rdAddr_i,
    input logic rdWriteEnable_i,
    input logic [31:0] instAddr_i,
    input logic [63:0] rs1ReadData_i,
    input logic [63:0] rs2ReadData_i,
    input logic [63:0] imm_i,
    input logic [6:0] opCode_i,
    input logic [2:0] funct3_i,
    input logic [6:0] funct7_i,
    input logic [5:0] shamt_i,
    input logic [1:0] way0_pID_i,
    input logic valid_i,
    input logic ready_i,
    input logic jumpFlag_i,
    input logic [31:0] jumpAddr_i,
    output logic [4:0] rdAddr_o,
    output logic rdWriteEnable_o,
    output logic [31:0] instAddr_o,
    output logic [63:0] rs1ReadData_o,
    output logic [63:0] rs2ReadData_o,
    output logic [63:0] imm_o,
    output logic [6:0] opCode_o,
    output logic [2:0] funct3_o,
    output logic [6:0] funct7_o,
    output logic [5:0] shamt_o,
    output logic [1:0] way0_pID_o,
    output logic valid_o,
    output logic ready_o
);

    wire WFull;
    wire REmpty;
    reg ready_reg;

    assign ready_o = ready_i;
    // assign valid_o = ~REmpty;

	DataBuffer #( .DataWidth(5) )
	EU_rdAddr_Buffer_way0 ( 
		.Clk( clk ), 
		.Rst( reset_n ), 
		.WData( rdAddr_i ), 
		.WInc( valid_i ), 
		.WFull( WFull ), 
		.RData( rdAddr_o ), 
		.RInc( ready_i ), 
		.REmpty( REmpty ), 
		.Jump( jumpFlag_i ) 
	);

	DataBuffer #( .DataWidth(1) )
	EU_rdWriteEnable_Buffer_way0 ( 
		.Clk( clk ), 
		.Rst( reset_n ), 
		.WData( rdWriteEnable_i ), 
		.WInc( valid_i ), 
		.WFull(  ), 
		.RData( rdWriteEnable_o ), 
		.RInc( ready_i ), 
		.REmpty(  ), 
		.Jump( jumpFlag_i ) 
	);

	DataBuffer #( .DataWidth(32) )
	EU_instAddr_Buffer_way0 ( 
		.Clk( clk ), 
		.Rst( reset_n ), 
		.WData( instAddr_i ), 
		.WInc( valid_i ), 
		.WFull(  ), 
		.RData( instAddr_o ), 
		.RInc( ready_i && ~REmpty ), 
		.REmpty(  ), 
		.Jump( jumpFlag_i ) 
	);

	DataBuffer #( .DataWidth(64) )
	EU_rs1ReadData_Buffer_way0 ( 
		.Clk( clk ), 
		.Rst( reset_n ), 
		.WData( rs1ReadData_i ), 
		.WInc( valid_i ), 
		.WFull(  ), 
		.RData( rs1ReadData_o ), 
		.RInc( ready_i ), 
		.REmpty(  ), 
		.Jump( jumpFlag_i ) 
	);

	DataBuffer #( .DataWidth(64) )
	EU_rs2ReadData_Buffer_way0 ( 
		.Clk( clk ), 
		.Rst( reset_n ), 
		.WData( rs2ReadData_i ), 
		.WInc( valid_i ), 
		.WFull(  ), 
		.RData( rs2ReadData_o ), 
		.RInc( ready_i ), 
		.REmpty(  ), 
		.Jump( jumpFlag_i ) 
	);

	DataBuffer #( .DataWidth(64) )
	EU_imm_Buffer_way0 ( 
		.Clk( clk ), 
		.Rst( reset_n ), 
		.WData( imm_i ), 
		.WInc( valid_i ), 
		.WFull(  ), 
		.RData( imm_o ), 
		.RInc( ready_i ), 
		.REmpty(  ), 
		.Jump( jumpFlag_i ) 
	);

	DataBuffer #( .DataWidth(7) )
	EU_opCode_Buffer_way0 ( 
		.Clk( clk ), 
		.Rst( reset_n ), 
		.WData( opCode_i ), 
		.WInc( valid_i ), 
		.WFull(  ), 
		.RData( opCode_o ), 
		.RInc( ready_i ), 
		.REmpty(  ), 
		.Jump( jumpFlag_i ) 
	);

	DataBuffer #( .DataWidth(3) )
	EU_funct3_Buffer_way0 ( 
		.Clk( clk ), 
		.Rst( reset_n ), 
		.WData( funct3_i ), 
		.WInc( valid_i ), 
		.WFull(  ), 
		.RData( funct3_o ), 
		.RInc( ready_i ), 
		.REmpty(  ), 
		.Jump( jumpFlag_i ) 
	);

	DataBuffer #( .DataWidth(7) )
	EU_funct7_Buffer_way0 ( 
		.Clk( clk ), 
		.Rst( reset_n ), 
		.WData( funct7_i ), 
		.WInc( valid_i ), 
		.WFull(  ), 
		.RData( funct7_o ), 
		.RInc( ready_i ), 
		.REmpty(  ), 
		.Jump( jumpFlag_i ) 
	);

	DataBuffer #( .DataWidth(6) )
	EU_shamt_Buffer_way0 ( 
		.Clk( clk ), 
		.Rst( reset_n ), 
		.WData( shamt_i ), 
		.WInc( valid_i ), 
		.WFull(  ), 
		.RData( shamt_o ), 
		.RInc( ready_i ), 
		.REmpty(  ), 
		.Jump( jumpFlag_i ) 
	);

	DataBuffer #( .DataWidth(2) )
	EU_way0_pID_Buffer_way0 ( 
		.Clk( clk ), 
		.Rst( reset_n ), 
		.WData( way0_pID_i ), 
		.WInc( valid_i ), 
		.WFull(  ), 
		.RData( way0_pID_o ), 
		.RInc( ready_i ), 
		.REmpty(  ), 
		.Jump( jumpFlag_i ) 
	);

    always_ff @(posedge clk or negedge reset_n) begin
        if(~reset_n) begin
            valid_o <= 1'b0;
        end else if(ready_i && ~REmpty && ~jumpFlag_i) begin
            valid_o <= 1'b1;
        end else begin
            valid_o <= 1'b0;
        end 
    end

    `ifdef DebugMode
        DataBuffer #(.DataWidth(32))
        EU_inst_Buffer_way0 (
            .Clk(clk),
            .Rst(reset_n),
            .WData(inst_i),
            .WInc(valid_i),
            .WFull(),
            .RData(inst_o),
            .RInc(ready_i),
            .REmpty(),
            .Jump(jumpFlag_i)
        );
    `endif

endmodule