module EU_Register_way0(
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
    input logic [1:0] way0_pID_i,
    
    output logic rdWriteEnable_o,
    output logic [4:0] rdAddr_o,
    output logic [63:0] rdData_o,
    output logic valid_o,
    output logic ready_o,
    output logic [1:0] way0_pID_o
);
    
    assign ready_o = ready_i;

    always_ff @(posedge clk or negedge reset_n) begin
        if(~reset_n) begin
            rdWriteEnable_o <= 1'b0;
            rdAddr_o <= 5'b0;
            rdData_o <= 64'b0;
            way0_pID_o <= 2'b0;
        end else if(ready_o) begin
            rdWriteEnable_o <= rdWriteEnable_i;
            rdAddr_o <= rdAddr_i;
            rdData_o <= rdData_i;
            way0_pID_o <= way0_pID_i;
        end
    end

    `ifdef DebugMode
        always_ff @(posedge clk or negedge reset_n) begin
            if(~reset_n) begin
                inst_o <= 32'b0;
                instAddr_o <= 32'b0;
            end else if(ready_o) begin
                inst_o <= inst_i;
                instAddr_o <= instAddr_i;
            end
        end
    `endif 

endmodule