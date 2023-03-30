module RegFile(
    input logic clk,
    input logic reset_n,
    // DU way0
    input logic [4:0] way0_rs1Addr_i,
    input logic [4:0] way0_rs2Addr_i,
    input logic way0_rs1ReadEnable_i,
    input logic way0_rs2ReadEnable_i,
    input logic [1:0] way0_DU_pID_i,
    // DU way1
    input logic [4:0] way1_rs1Addr_i,
    input logic [4:0] way1_rs2Addr_i,
    input logic way1_rs1ReadEnable_i,
    input logic way1_rs2ReadEnable_i,
    input logic [1:0] way1_DU_pID_i,

    // WBU way0
    input logic way0_rdWriteEnable_i,
    input logic [4:0] way0_rdAddr_i,
    input logic [63:0] way0_rdData_i,
    input logic [1:0] way0_WBU_pID_i,
    // WBU way1
    input logic way1_rdWriteEnable_i,
    input logic [4:0] way1_rdAddr_i,
    input logic [63:0] way1_rdData_i,
    input logic [1:0] way1_WBU_pID_i,

    // To DU
    output logic [63:0] way0_rs1ReadData_o,
    output logic [63:0] way0_rs2ReadData_o,
    output logic [63:0] way1_rs1ReadData_o,
    output logic [63:0] way1_rs2ReadData_o,

    // To WBU
    output logic way0_ready_o,
    output logic way1_ready_o
);

    reg [63:0] Register [31:0];
    assign Register[0] = 0;

    `ifdef RegFileTest
        initial begin
            for (integer i = 1; i < 32; i = i + 1) begin
                Register[i] = i;
            end
        end
    `endif 

    /* pID处理逻辑
     * way0的pID前进顺序： 00 -> 10 -> 00
     * way1的pID前进顺序： 01 -> 11 -> 01
     * 当way0_pID为00且way1_pID为01时（初始状态）： 
     * 
    */

    always_comb begin
        case ({way0_WBU_pID_i, way1_WBU_pID_i})
            4'b00_01 : begin
                way0_ready_o = 1'b1;
                way1_ready_o = 1'b1;
            end
            4'b10_11 : begin
                way0_ready_o = 1'b1;
                way1_ready_o = 1'b1;
            end
            4'b10_01 : begin
                way0_ready_o = 1'b0;
                way1_ready_o = 1'b1;
            end
            default : begin
                way0_ready_o = 1'b1;
                way1_ready_o = 1'b1;
            end
        endcase
    end
    

    // 数据寄存不复位
    always_ff @(posedge clk) begin
        case ({way0_WBU_pID_i, way1_WBU_pID_i})
            4'b00_01 : begin
                
            end
            4'b10_11 : begin

            end
            default : begin

            end
        endcase
    end

 


    // RegFile异步读
    assign way0_rs1ReadData_o = way0_rs1ReadEnable_i ? Register[way0_rs1Addr_i] : 64'b0;
    assign way0_rs2ReadData_o = way0_rs2ReadEnable_i ? Register[way0_rs2Addr_i] : 64'b0;
    assign way1_rs1ReadData_o = way1_rs1ReadEnable_i ? Register[way1_rs1Addr_i] : 64'b0;
    assign way1_rs2ReadData_o = way1_rs2ReadEnable_i ? Register[way1_rs2Addr_i] : 64'b0;
    
endmodule