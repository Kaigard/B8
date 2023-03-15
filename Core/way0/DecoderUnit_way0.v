module DecoderUnit_way0(
    `ifdef TestMode 
        input [31:0] instAddr_i,
        output [31:0] instAddr_o,
    `endif
    input [31:0] inst_i,
    input [63:0] rs1ReadData_i,
    input [63:0] rs2ReadData_i,
    // To Regfile
    output [4:0] way0_rs1Addr_o,
    output [4:0] way0_rs2Addr_o,
    output way0_rs1ReadEnable_o,
    output way0_rs2ReadEnabel_o,
    // To Ex
    output [4:0] rdAddr_o,
    output rdWriteEnable_o,
    output [63:0] rs1ReadData_o,
    output [63:0] rs2ReadData_o,
    output [63:0] imm_o,
    output [6:0] opCode_o,
    output [2:0] funct3_o,
    output [6:0] funct7_o,
    output [5:0] shamt_o
);

    `ifdef TestMode 
        assign instAddr_o = instAddr_i;
    `endif

    assign rs1ReadData_o = rs1ReadData_i;
    assign rs2ReadData_o = rs2ReadData_o;

    // 通用译码
    assign opCode_o = inst_i[6:0];
    assign funct3_o = inst_i[14:12];
    assign funct7_o = inst_i[31:25];
    
    wire [5:0] Shamt = inst_i[25:20];
    //I-Type译码
    wire [11:0] Imm_I_Type = inst_i[31:20];
    //S-Type译码
    wire [11:0] Imm_S_Type = {inst_i[31:25], inst_i[11:7]};
    //B-Type译码
    wire [12:1] Imm_B_Type = {inst_i[31], inst_i[7], inst_i[30:25], inst_i[11:8]};
    //U-Type译码
    wire [31:12] Imm_U_Type = inst_i[31:12];
    //J-Type译码
    wire [20:1] Imm_J_Type = {inst_i[31], inst_i[19:12], inst_i[20], inst_i[30:21]};

    //wire of Shamt come out
    wire [5:0] Shamtfunct3_o_00;
    wire [5:0] Shamtfunct3_o_01; 
    wire [5:0] Shamtfunct7_o;

    //Shamt在移位操作时输出至ex+
    MuxKeyWithDefault #(1, 7, 6) Shamt_mux (shamt_o, opCode_o, 6'b0, {
    7'b0010011, Shamtfunct7_o
    });

    MuxKeyWithDefault #(2, 6, 6) Shamtfunct7_o_mux (Shamtfunct7_o, inst_i[31:26], 6'b0, {
    6'b000000, Shamtfunct3_o_00,
    6'b010000, Shamtfunct3_o_01
    });

    MuxKeyWithDefault #(2, 3, 6) Shamtfunct3_o_00_mux (Shamtfunct3_o_00, funct3_o, 6'b0, {
    3'b001, Shamt,
    3'b101, Shamt
    });

    MuxKeyWithDefault #(1, 3, 6) Shamtfunct3_o_01_mux (Shamtfunct3_o_01, funct3_o, 6'b0, {
    3'b101, Shamt
    });

    wire csrRs1ReadEnable;
    //Warning!!!部分扩展指令集也做了译码实现，但是不一定正确！！！
    MuxKeyWithDefault #(14, 7, 1) Id_rs1ReadEnable_mux (rs1ReadEnable, opCode_o, 1'b0, {
    //RV32
    7'b0110111, 1'b0,
    7'b0010111, 1'b0,
    7'b1101111, 1'b0,
    7'b1100111, 1'b1,
    7'b1100011, 1'b1,
    7'b0000011, 1'b1,
    7'b0100011, 1'b1,
    7'b0010011, 1'b1,
    7'b0110011, 1'b1,
    //7'b0001111, 1'b1,
    7'b1110011, csrRs1ReadEnable,
    //RV64增加
    7'b0011011, 1'b1,
    7'b0111011, 1'b1,
    7'b0101111, 1'b1,
    7'b1010011, 1'b1
    });
    MuxKeyWithDefault #(6, 3, 1) Id_csrRs1ReadEnable_mux (csrRs1ReadEnable, funct3_o, 1'b0, {
        //Csrrc
        3'b011, 1'b1,
        //Csrrci
        3'b111, 1'b1,
        //Csrrs
        3'b010, 1'b1,
        //Csrrsi
        3'b110, 1'b1,
        //Csrrw
        3'b001, 1'b1,
        //Csrrwi
        3'b101, 1'b1
    });

    MuxKeyWithDefault #(14, 7, 5) Id_Rs1AddrOut (Rs1AddrOut, opCode_o, 5'b0, {
    7'b0110111, 5'b0,
    7'b0010111, 5'b0,
    7'b1101111, 5'b0,
    7'b1100111, inst_i[19:15],
    7'b1100011, inst_i[19:15],
    7'b0000011, inst_i[19:15],
    7'b0100011, inst_i[19:15],
    7'b0010011, inst_i[19:15],
    7'b0110011, inst_i[19:15],
    //7'b0001111, inst_i[19:15],
    7'b1110011, inst_i[19:15],
    //RV64增加
    7'b0011011, inst_i[19:15],
    7'b0111011, inst_i[19:15],
    7'b0101111, inst_i[19:15],
    7'b1010011, inst_i[19:15]
    });

    MuxKeyWithDefault #(14, 7, 1) Id_Rs2ReadEnable (Rs2ReadEnable, opCode_o, 1'b0, {
    7'b0110111, 1'b0,
    7'b0010111, 1'b0,
    7'b1101111, 1'b0,
    7'b1100111, 1'b0,
    7'b1100011, 1'b1,
    7'b0000011, 1'b0,
    7'b0100011, 1'b1,
    7'b0010011, 1'b0,
    7'b0110011, 1'b1,
    //7'b0001111, 1'b1,
    7'b1110011, 1'b0,
    //RV64增加
    7'b0011011, 1'b0,
    7'b0111011, 1'b1,
    7'b0101111, 1'b1,
    7'b1010011, 1'b1
    });

    MuxKeyWithDefault #(14, 7, 5) Id_Rs2AddrOut (Rs2AddrOut, opCode_o, 5'b0, {
    7'b0110111, 5'b0,
    7'b0010111, 5'b0,
    7'b1101111, 5'b0,
    7'b1100111, 5'b0,
    7'b1100011, inst_i[24:20],
    7'b0000011, 5'b0,
    7'b0100011, inst_i[24:20],
    7'b0010011, 5'b0,
    7'b0110011, inst_i[24:20],
    //7'b0001111, inst_i[24:20],
    7'b1110011, 5'b0,
    //RV64增加
    7'b0011011, 5'b0,
    7'b0111011, inst_i[24:20],
    7'b0101111, inst_i[24:20],
    7'b1010011, inst_i[24:20]
    });

    wire RV32M_MulRdWriteEnable;
    wire RV64M_MulRdWriteEnable;
    wire CsrRdWriteEnable;
    MuxKeyWithDefault #(14, 7, 1) Id_RdWriteEnable (RdWriteEnable, opCode_o, 1'b0, {
    7'b0110111, 1'b1,
    7'b0010111, 1'b1,
    7'b1101111, 1'b1,
    7'b1100111, 1'b1,
    7'b1100011, 1'b0,
    //Load，Rd写应该使能，但由于数据前推，Rd并不能在Ex环节被赋予数据，因此RdEn也同样放到Mem中
    7'b0000011, 1'b0,
    7'b0100011, 1'b0,
    7'b0010011, 1'b1,
    7'b0110011, RV32M_MulRdWriteEnable,
    //7'b0001111, 1'b1,
    7'b1110011, CsrRdWriteEnable,
    //RV64增加
    7'b0011011, 1'b1,
    7'b0111011, RV64M_MulRdWriteEnable,
    7'b0101111, 1'b1,
    7'b1010011, 1'b1
    });
    MuxKeyWithDefault #(1, 7, 1) Id_RV32M_MulRdWriteEnableEnable (RV32M_MulRdWriteEnable, funct7_o, 1'b1, {
        7'b0000001, 1'b0
    });
    MuxKeyWithDefault #(1, 7, 1) Id_RV64M_MulRdWriteEnableEnable (RV64M_MulRdWriteEnable, funct7_o, 1'b1, {
        7'b0000001, 1'b0
    });
    MuxKeyWithDefault #(6, 3, 1) Id_CsrRdWriteEnable_mux (CsrRdWriteEnable, funct3_o, 1'b0, {
        //Csrrc
        3'b011, 1'b1,
        //Csrrci
        3'b111, 1'b1,
        //Csrrs
        3'b010, 1'b1,
        //Csrrsi
        3'b110, 1'b1,
        //Csrrw
        3'b001, 1'b1,
        //Csrrwi
        3'b101, 1'b1
    });

    MuxKeyWithDefault #(14, 7, 5) Id_RdAddrOut (RdAddrOut, opCode_o, 5'b0, {
    7'b0110111, inst_i[11:7],
    7'b0010111, inst_i[11:7],
    7'b1101111, inst_i[11:7],
    //Jalr rd默认1
    7'b1100111, 5'b00001,
    7'b1100011, 5'b0,
    7'b0000011, inst_i[11:7],
    7'b0100011, 5'b0,
    7'b0010011, inst_i[11:7],
    7'b0110011, inst_i[11:7],
    //7'b0001111, inst_i[11:7],
    7'b1110011, inst_i[11:7],
    //RV64增加
    7'b0011011, inst_i[11:7],
    7'b0111011, inst_i[11:7],
    7'b0101111, inst_i[11:7],
    7'b1010011, inst_i[11:7]
    });

    MuxKeyWithDefault #(14, 7, 64) Id_Imm (imm_o, opCode_o, 64'b0, {
    //??????????
    7'b0110111, {{44{Imm_U_Type[19]}}, Imm_U_Type},
    //??????????
    7'b0010111, {{44{Imm_U_Type[19]}}, Imm_U_Type},
    7'b1101111, {{43{Imm_J_Type[20]}}, Imm_J_Type, {1'b0}},
    7'b1100111, {{52{Imm_I_Type[11]}}, Imm_I_Type},
    7'b1100011, {{51{Imm_B_Type[12]}}, Imm_B_Type, {1'b0}},
    7'b0000011, {{52{Imm_I_Type[11]}}, Imm_I_Type},
    7'b0100011, {{52{Imm_S_Type[11]}}, Imm_S_Type},
    7'b0010011, {{52{Imm_I_Type[11]}}, Imm_I_Type},
    7'b0110011, 64'b0,
    //7'b0001111, {{52{Imm_I_Type[11]}}, Imm_I_Type},
    7'b1110011, {{52{Imm_I_Type[11]}}, Imm_I_Type},
    //RV64增加
    7'b0011011, {{52{Imm_I_Type[11]}}, Imm_I_Type},
    7'b0111011, 64'b0,
    7'b0101111, 64'b0,
    7'b1010011, 64'b0
    });


endmodule