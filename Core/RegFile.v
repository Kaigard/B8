module RegFile(
    input clk,
    input reset_n,
    // way0
    input [4:0] way0_rs1Addr_i,
    input [4:0] way0_rs2Addr_i,
    input way0_rs1ReadEnable_i,
    input way0_rs2ReadEnable_i,
    input way0_pID_i,
    // way1
    input [4:0] way1_rs1Addr_i,
    input [4:0] way1_rs2Addr_i,
    input way1_rs1ReadEnable_i,
    input way1_rs2ReadEnable_i,
    input way1_pID_i,

    // To DU
    output [63:0] way0_rs1ReadData_o,
    output [63:0] way0_rs2ReadData_o,
    output [63:0] way1_rs1ReadData_o,
    output [63:0] way1_rs2ReadData_o
);

    reg [63:0] Register [31:0];

    `ifdef RegFileTest
        initial begin
            for (integer i = 0; i < 32; i = i + 1) begin
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

    // 数据寄存不复位


    // RegFile异步读
    assign way0_rs1ReadData_o = way0_rs1ReadEnable_i ? Register[way0_rs1Addr_i] : 64'b0;
    assign way0_rs2ReadData_o = way0_rs2ReadEnable_i ? Register[way0_rs2Addr_i] : 64'b0;
    assign way1_rs1ReadData_o = way1_rs1ReadEnable_i ? Register[way1_rs1Addr_i] : 64'b0;
    assign way1_rs2ReadData_o = way1_rs2ReadEnable_i ? Register[way1_rs2Addr_i] : 64'b0;
    
endmodule