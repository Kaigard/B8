module ExecuteUnit_way0(
    `ifdef DebugMode
        output logic [31:0] instAddr_o,
        input logic [31:0] inst_i,
        output logic [31:0] inst_o,
    `endif
    input logic rdWriteEnable_i,
    input logic [4:0] rdAddr_i,
    input logic [31:0] instAddr_i,
    input logic [63:0] rs1ReadData_i,
    input logic [63:0] rs2ReadData_i,
    input logic [63:0] imm_i,
    input logic [6:0] opCode_i,
    input logic [2:0] funct3_i,
    input logic [6:0] funct7_i,
    input logic [5:0] shamt_i,
    input logic valid_i,
    input logic ready_i,
    input logic [1:0] way0_pID_i,
    // To FU
    output logic rdWriteEnable_o,
    output logic [4:0] rdAddr_o,
    output logic [63:0] rdData_o,
    output logic valid_o,
    output logic ready_o,
    output logic [1:0] way0_pID_o,
    output logic [6:0] opCode_o,
    output logic [2:0] funct3_o,
    output logic [31:0] readAddr_o,
    output logic [31:0] writeAddr_o,
    output logic [63:0] writeData_o,
    output logic [3:0] writeMask_o,
    // To PCU
    output logic jumpFlag_o,
    output logic [31:0] jumpAddr_o
);

    `ifdef DebugMode
        assign instAddr_o = instAddr_i;
        assign inst_o = inst_i;
    `endif

    assign valid_o = valid_i;
    assign ready_o = ready_i;
    assign way0_pID_o = way0_pID_i;
    assign rdWriteEnable_o = rdWriteEnable_i;
    assign rdAddr_o = rdAddr_i;
    assign funct3_o = |readAddr_o ? funct3_i : 3'b0;
    assign opCode_o = |readAddr_o ? opCode_i : 3'b0;

    wire [31:0] LoadTypeAddr;
    wire [31:0] StoreTypeAddr;
    wire [63:0] StoreTypeData;
    wire [3:0] StoreTypeMask;

    wire [63:0] Funct3_RV32I_I_TypeOut;
    wire [63:0] Shift_RV32I_Right;
    wire [63:0] Shift_RV32I_Left;
    wire [63:0] ImmShift = imm_i << 12;

    wire [63:0] Funct7_RV32I_R_TypeOut;
    //Funct7   7'b0000000
    wire [63:0] Funct3_RV32I_R_Type_ZeroOut;
    //Funct7   7'b0100000
    wire [63:0] Funct3_RV32I_R_Type_OneOut;
    //Funct7   7'b0110011
    wire [63:0] Funct3_RV32I_R_Type_SixOut;

    wire [63:0] Funct3_RV64I_I_TypeOut;
    wire [63:0] Shift_RV64I_Right;
    wire [63:0] Shift_RV64I_Left;

    wire [63:0] Funct7_RV64I_R_TypeOut;
    //Funct7   7'b0000000
    wire [63:0] Funct3_RV64I_R_Type_ZeroOut;
    //Funct7   7'b0100000
    wire [63:0] Funct3_RV64I_R_Type_OneOut;

    //DPI-C
    `ifdef DebugMode
        localparam RaiseException_Ebreak = 2'b01;
        localparam RaiseException_Ecall = 2'b10;
        wire [1:0] RaiseException;
    `endif

    //ALU
    //Addi           
    wire [63:0] ImmAddRs1ReadData = imm_i + rs1ReadData_i;
    //Add            
    wire [63:0] Rs1ReadDataAddRs2ReadData = rs1ReadData_i + rs2ReadData_i;
    //Sub                              
    wire [63:0] Rs1ReadDataSubRs2ReadData = rs1ReadData_i + (~rs2ReadData_i + 1);
    //And
    wire [63:0] Rs1ReadDataAndRs2ReadData = rs1ReadData_i & rs2ReadData_i;
    //Andi
    wire [63:0] Rs1ReadDataAndImm = rs1ReadData_i & imm_i;
    //Or
    wire [63:0] Rs1ReadDataOrRs2ReadData = rs1ReadData_i | rs2ReadData_i;
    //Ori
    wire [63:0] Rs1ReadDataOrImm = rs1ReadData_i | imm_i;
    //Xor
    wire [63:0] Rs1ReadDataXorRs2ReadData = rs1ReadData_i ^ rs2ReadData_i;
    //Sll
    wire [63:0] Rs1ReadDataSllRs2ReadData = rs1ReadData_i << rs2ReadData_i[5:0];
    //Slli
    wire [63:0] Rs1ReadDataSllImm = rs1ReadData_i << shamt_i;
    //Sra
    wire [63:0] Rs1ReadDataSraRs2ReadData = rs1ReadData_i <<< rs2ReadData_i[5:0];
    //Srai
    wire [63:0] Rs1ReadDataSraImm = rs1ReadData_i >>> shamt_i;
    //Srl
    wire [63:0] Rs1ReadDataSrlRs2ReadData = rs1ReadData_i >> rs2ReadData_i[5:0];
    //Srli
    wire [63:0] Rs1ReadDataSrlImm = rs1ReadData_i >> shamt_i;
    //Sllw
    wire [31:0] Rs1ReadDataSllwRs2ReadData = rs1ReadData_i[31:0] << rs2ReadData_i[4:0];
    //Sraw
    wire [31:0] Rs1ReadDataSrawRs2ReadData = rs1ReadData_i[31:0] >>> rs2ReadData_i[4:0];
    //Srlw
    wire [31:0] Rs1ReadDataSrlwRs2ReadData = rs1ReadData_i[31:0] >> rs2ReadData_i[4:0];

    //RV32I
    //I                  
    MuxKeyWithDefault #(7, 3, 64) Funct3_RV32_I_Type (Funct3_RV32I_I_TypeOut, funct3_i, 64'b0, {
    //Addi
    3'b000, ImmAddRs1ReadData,
    //Andi
    3'b111, Rs1ReadDataAndImm,
    //Ori
    3'b110, Rs1ReadDataOrImm,
    //Slti
    3'b010, (((rs1ReadData_i[63] == 1'b1) && (imm_i[63] == 1'b0)) ? 64'b1 :
            ((rs1ReadData_i[63] == 1'b0) && (imm_i[63] == 1'b1)) ? 64'b0 :
            (Rs1ReadDataAddRs2ReadData[63] == rs1ReadData_i[63]) ? 64'b1 : 64'b0),
    //Sltiu
    3'b011, ((rs1ReadData_i < imm_i) ? 64'b1 : 64'b0),
    //Slli
    3'b001, Shift_RV32I_Left,
    //Srli or srai
    3'b101, Shift_RV32I_Right
    });
        //                                    Funct3            Funct7          
        MuxKeyWithDefault #(2, 6, 64) Shift_RV32I_Right_mux (Shift_RV32I_Right, funct7_i[6:1], 64'b0, {
        6'b000000, Rs1ReadDataSrlImm,
        6'b010000, Rs1ReadDataSraImm
        }); 
        MuxKeyWithDefault #(1, 6, 64) Shift_RV32I_Left_mux (Shift_RV32I_Left, funct7_i[6:1], 64'b0, {
        6'b000000, Rs1ReadDataSllImm
        }); 

    //R             
    MuxKeyWithDefault #(2, 7, 64) Funct7_RV32I_R_Type (Funct7_RV32I_R_TypeOut, funct7_i, 64'b0, {
    //Add or Xor or Or or And or Slt or Sltu or Sll or Srl
    7'b0000000, Funct3_RV32I_R_Type_ZeroOut,
    //Sub or Sra
    7'b0100000, Funct3_RV32I_R_Type_OneOut
    }); 
        //Funct7   7'b0000000
        MuxKeyWithDefault #(8, 3, 64) Funct3_RV32I_R_Type_Zero (Funct3_RV32I_R_Type_ZeroOut, funct3_i, 64'b0, {
        //Add
        3'b000, Rs1ReadDataAddRs2ReadData,
        //Xor
        3'b100, Rs1ReadDataXorRs2ReadData,
        //Or
        3'b110, Rs1ReadDataOrRs2ReadData,
        //And
        3'b111, Rs1ReadDataAndRs2ReadData,
        //Slt
        3'b010, (((rs1ReadData_i[63] == 1'b1) && (rs2ReadData_i[63] == 1'b0)) ? 64'b1 :
                ((rs1ReadData_i[63] == 1'b0) && (rs2ReadData_i[63] == 1'b1)) ? 64'b0 :
                (Rs1ReadDataAddRs2ReadData[63] == rs1ReadData_i[63]) ? 64'b1 : 64'b0),
        //Sltu
        3'b011, ((rs1ReadData_i < rs1ReadData_i) ? 64'b1 : 64'b0),
        //Sll
        3'b001, Rs1ReadDataSllRs2ReadData,
        //Srl
        3'b101, Rs1ReadDataSrlRs2ReadData
        });
        //Funct7   7'b0100000
        MuxKeyWithDefault #(2, 3, 64) Funct3_RV32I_R_Type_One (Funct3_RV32I_R_Type_OneOut, funct3_i, 64'b0, {
        //Sub
        3'b000, Rs1ReadDataSubRs2ReadData,
        //Sra
        3'b101, Rs1ReadDataSraRs2ReadData
        });
        
    //RV64I
    //I                  
    MuxKeyWithDefault #(3, 3, 64) Funct3_RV64I_I_Type (Funct3_RV64I_I_TypeOut, funct3_i, 64'b0, {
    //Addiw
    3'b000, {{32{ImmAddRs1ReadData[31]}}, ImmAddRs1ReadData[31:0]},
    //Slliw
    3'b001, {{32{Shift_RV64I_Left[31]}}, Shift_RV64I_Left[31:0]},
    //Srliw or Sraiw
    3'b101, {{32{Shift_RV64I_Right[31]}}, Shift_RV64I_Right[31:0]}
    });
        //                                    Funct3            Funct7          
        MuxKeyWithDefault #(2, 7, 64) Shift_RV64I_Right_mux (Shift_RV64I_Right, funct7_i, 64'b0, {
        //Srliw
        7'b0000000, Rs1ReadDataSrlImm,
        //Sraiw
        7'b0100000, Rs1ReadDataSraImm
        }); 
        MuxKeyWithDefault #(1, 7, 64) Shift_RV64I_Left_mux (Shift_RV64I_Left, funct7_i, 64'b0, {
        7'b0000000, Rs1ReadDataSllImm
        }); 

    //R                   
    MuxKeyWithDefault #(2, 7, 64) Funct7_RV64I_R_Type (Funct7_RV64I_R_TypeOut, funct7_i, 64'b0, {
    //Addw or Sllw or Srlw
    7'b0000000, Funct3_RV64I_R_Type_ZeroOut,
    //Subw or Sraw
    7'b0100000, Funct3_RV64I_R_Type_OneOut
    });
        MuxKeyWithDefault #(3, 3, 64) Funct3_RV64I_R_Type_Zero (Funct3_RV64I_R_Type_ZeroOut, funct3_i, 64'b0, {
        //Addw
        3'b000, {{32{Rs1ReadDataAddRs2ReadData[31]}}, Rs1ReadDataAddRs2ReadData[31:0]},
        //Sllw
        3'b001, {{32{Rs1ReadDataSllwRs2ReadData[31]}}, Rs1ReadDataSllwRs2ReadData},
        //Srlw
        3'b101, {{32{Rs1ReadDataSrlwRs2ReadData[31]}}, Rs1ReadDataSrlwRs2ReadData}
        });
        MuxKeyWithDefault #(2, 3, 64) Funct3_RV64I_R_Type_One (Funct3_RV64I_R_Type_OneOut, funct3_i, 64'b0, {
        //Subw
        3'b000, {{32{Rs1ReadDataSubRs2ReadData[31]}}, Rs1ReadDataSubRs2ReadData[31:0]},
        //Sraw
        3'b101, {{32{Rs1ReadDataSrawRs2ReadData[31]}}, Rs1ReadDataSrawRs2ReadData}
        });

    wire [63:0] RdWriteDataOutRVI;
    wire [63:0] RdWriteDataOutRVM;
    //Output
    MuxKeyWithDefault #(8, 7, 64) OpOcde_RdWriteDataRV32IOut (RdWriteDataOutRVI, opCode_i, 64'b0, {
    //RV32I
    7'b0010011, Funct3_RV32I_I_TypeOut,
    7'b0110011, Funct7_RV32I_R_TypeOut,
    7'b0010111, (instAddr_i + (imm_i << 12)),                                                    //Auipc
    7'b1101111, (instAddr_i + 4),                                                                //Jar
    7'b1100111, (instAddr_i + 4),                                                                //Jalr
    7'b0110111, {{32{ImmShift[31]}} ,ImmShift[31:0]},                                            //Lui 
    //RV64I
    7'b0011011, Funct3_RV64I_I_TypeOut,
    7'b0111011, Funct7_RV64I_R_TypeOut
    });


    /*
    wire [63:0] Funct3_RV32M_R_Type_SixOut;
    wire [63:0] Funct7_RV32M_R_TypeOut;
    wire [63:0] Funct7_RV32M_R_TypeOut_WithoutInt;
    wire [63:0] Funct3_RV64M_R_Type_SixOut;
    wire [63:0] Funct7_RV64M_R_TypeOut;
    wire [63:0] Funct7_RV64M_R_TypeOut_WithoutInt;
    //RV32M
    //R                  
    MuxKeyWithDefault #(1, 1, 64) Funct7_RV32M_R_Type (Funct7_RV32M_R_TypeOut, (HoldFlagIn == 3'b100), 64'b0, {
    //Mul or Div
    1'b1, Funct7_RV32M_R_TypeOut_WithoutInt
    }); 
    MuxKeyWithDefault #(1, 7, 64) Funct7_RV32M_R_Type_WithoutInt (Funct7_RV32M_R_TypeOut_WithoutInt, MulFunct7ToEx | DivFunct7ToEx, 64'b0, {
        //Mul or Div
        7'b0000001, Funct3_RV32M_R_Type_SixOut
    }); 
    //Funct7   7'b0000001
        MuxKeyWithDefault #(8, 3, 64) Funct3_RV32M_R_Type_One (Funct3_RV32M_R_Type_SixOut, MulFunct3ToEx | DivFunct3ToEx, 64'b0, {
        //Mul
        3'b000, Rs1ReadDataMulRs2ReadData[63:0],
        //Mulh
        3'b001, Rs1ReadDataMulRs2ReadData[127:64],
        //Mulhsu
        3'b010, Rs1ReadDataMulRs2ReadData[127:64],
        //Mulhu
        3'b011, Rs1ReadDataMulRs2ReadData[127:64],
        //Div
        3'b100, Rs1ReadDataDivRs2ReadData,
        //Divu
        3'b101, Rs1ReadDataDivRs2ReadData,
        //Rem
        3'b110, Rs1ReadDataRemRs2ReadData,
        //Remu
        3'b111, Rs1ReadDataRemRs2ReadData
        });
    //R64M
    //R                  
    MuxKeyWithDefault #(1, 1, 64) Funct7_RV64M_R_Type (Funct7_RV64M_R_TypeOut, (HoldFlagIn == 3'b100), 64'b0, {
    //Mul or Div
    1'b1, Funct7_RV64M_R_TypeOut_WithoutInt
    }); 
    MuxKeyWithDefault #(1, 7, 64) Funct7_RV64M_R_Type_WithoutInt (Funct7_RV64M_R_TypeOut_WithoutInt, MulFunct7ToEx | DivFunct7ToEx, 64'b0, {
        //Mulw or Divw
        7'b0000001, Funct3_RV64M_R_Type_SixOut
    }); 
    //Funct7   7'b0000001
        MuxKeyWithDefault #(5, 3, 64) Funct3_RV64M_R_Type_One (Funct3_RV64M_R_Type_SixOut, MulFunct3ToEx | DivFunct3ToEx, 64'b0, {
        //Mulw
        3'b000, {{32{Rs1ReadDataMulRs2ReadData[31]}}, Rs1ReadDataMulRs2ReadData[31:0]},
        //Divuw
        3'b101, {{32{Rs1ReadDataDivRs2ReadData[31]}}, Rs1ReadDataDivRs2ReadData[31:0]},
        //Divw
        3'b100, {{32{Rs1ReadDataDivRs2ReadData[31]}}, Rs1ReadDataDivRs2ReadData[31:0]},
        //Remuw
        3'b111, {{32{Rs1ReadDataRemRs2ReadData[31]}}, Rs1ReadDataRemRs2ReadData[31:0]},
        //Remw
        3'b110, {{32{Rs1ReadDataRemRs2ReadData[31]}}, Rs1ReadDataRemRs2ReadData[31:0]}
        });
    //Output
    MuxKeyWithDefault #(2, 7, 64) OpOcde_RdWriteDataRVMOut (RdWriteDataOutRVM, MulOpCodeToEx | DivOpCodeToEx, 64'b0, {
    //RV32M
    7'b0110011, Funct7_RV32M_R_TypeOut,
    //RV64M
    7'b0111011, Funct7_RV64M_R_TypeOut
    });

    //RV32I   RV32M                                                      
    assign RdWriteDataOut = RdWriteDataOutRVI | RdWriteDataOutRVM | CsrReadDataIn;
    */
    assign rdData_o = RdWriteDataOutRVI;


    //DPI-C
    //Ebreak or Ecall
    `ifdef DebugMode
        MuxKeyWithDefault #(2, 12, 2) Funct_Environment (RaiseException, imm_i[11:0], 2'b0, {
        //Ebreak
        12'b000000000001, RaiseException_Ebreak,
        //Ecall
        12'b000000000000, RaiseException_Ecall
        });

        `ifdef DPI-C 
            import "DPI-C" function void SystemBreak (input wire int Ebreak);
            always @( * ) begin
                if(opCode_i == 7'b1110011 && RaiseException == RaiseException_Ebreak) 
                SystemBreak(1);
                else
                SystemBreak(0);
            end 
        `endif 
    `endif 
   
    //Ebrack or Ecall
    wire BranchFlag;
    //Jump
    MuxKeyWithDefault #(3, 7, 1) JumpFlag_mux (jumpFlag_o, opCode_i, 1'b0, {
    //Jar
    7'b1101111, valid_i,
    //Jalr
    7'b1100111, valid_i,
    //Beq   Bge   Bgeu   Blt   Bltu   Bne
    7'b1100011, (BranchFlag && valid_i)
    });

    MuxKeyWithDefault #(6, 3, 1) BranchFlag_mux (BranchFlag, funct3_i, 1'b0, {
    //Beq
    3'b000, ((rs1ReadData_i == rs2ReadData_i) ? 1'b1 : 1'b0),
    //Bge
    3'b101, (((rs1ReadData_i[63] == 1'b1) && (rs2ReadData_i[63] == 1'b0)) ? 1'b0 :
            ((rs1ReadData_i[63] == 1'b0) && (rs2ReadData_i[63] == 1'b1)) ? 1'b1 :
            ((rs1ReadData_i[63] == rs1ReadData_i[63]) && (Rs1ReadDataSubRs2ReadData[63] == 1)) ? 1'b0 : 1'b1),
    //Bgeu
    3'b111, ((Rs1ReadDataSubRs2ReadData[63] == 1'b1) ? 1'b0 : 1'b1),
    //Blt
    3'b100, (((rs1ReadData_i[63] == 1'b1) && (rs2ReadData_i[63] == 1'b0)) ? 1'b1 :
            ((rs1ReadData_i[63] == 1'b0) && (rs2ReadData_i[63] == 1'b1)) ? 1'b0 :
            ((rs1ReadData_i[63] == rs1ReadData_i[63]) && (Rs1ReadDataSubRs2ReadData[63] == 1)) ? 1'b1 : 1'b0),
    //Bltu
    3'b110, ((Rs1ReadDataSubRs2ReadData[63] == 1'b1) ? 1'b1 : 1'b0),
    //Bne
    3'b001, ((rs1ReadData_i != rs2ReadData_i) ? 1'b1 : 1'b0)
    });

    MuxKeyWithDefault #(2, 7, 1) HoldFlag_mux (HoldFlagToCtrl, opCode_i, 1'b0, {
    //Load
    7'b0000011, 1'b1,
    //Store
    7'b0100011, 1'b1
    });

    /*
    //RV32M         HoldFlag                                       Div   Mul      
    wire [1:0] RV32M_HoldFlagToOpCodeMux;
    wire [1:0] RV64M_HoldFlagToOpCodeMux;
    wire [1:0] RV32M_HoldFlagToFunct7Mux;
    wire [1:0] RV64M_HoldFlagToFunct7Mux;
    //Mul                
    MuxKeyWithDefault #(2, 7, 2) RVM_HoldFlag_mux (RVM_HoldFlagOut, opCode_i, 2'b0, {
    //Mul or Div
    7'b0110011, RV32M_HoldFlagToOpCodeMux,
    //RV64M
    7'b0111011, RV64M_HoldFlagToOpCodeMux
    });
    //RV32M
    MuxKeyWithDefault #(1, 7, 2) RV32M_HoldFlagFunct7_mux (RV32M_HoldFlagToOpCodeMux, funct7_i, 2'b0, {
        7'b0000001, RV32M_HoldFlagToFunct7Mux
    });
        MuxKeyWithDefault #(8, 3, 2) RV32M_HoldFlagFunct3_mux (RV32M_HoldFlagToFunct7Mux, funct3_i, 2'b0, {
        //Mul
        3'b000, 2'b01,
        //Mulh
        3'b001, 2'b01,
        //Mulhsu
        3'b010, 2'b01,
        //Mulhu
        3'b011, 2'b01,
        //Div
        3'b100, 2'b10,
        //Divu
        3'b101, 2'b10,
        //Rem
        3'b110, 2'b10,
        //Remu
        3'b111, 2'b10
        });
    //RV64M
    MuxKeyWithDefault #(1, 7, 2) RV64M_HoldFlagFunct7_mux (RV64M_HoldFlagToOpCodeMux, funct7_i, 2'b0, {
        7'b0000001, RV64M_HoldFlagToFunct7Mux
    });
        MuxKeyWithDefault #(5, 3, 2) RV64M_HoldFlagFunct3_mux (RV64M_HoldFlagToFunct7Mux, funct3_i, 2'b0, {
        //Mulw
        3'b000, 2'b01,
        //Divuw
        3'b101, 2'b10,
        //Divw 
        3'b100, 2'b10,
        //Remuw
        3'b111, 2'b10,
        //Remw
        3'b110, 2'b10
        });
    */

    MuxKeyWithDefault #(3, 7, 64) JumpAddr (jumpAddr_o, opCode_i, 64'b0, {
    //Jar
    7'b1101111, (instAddr_i + imm_i),
    //Jalr
    7'b1100111, ((rs1ReadData_i + imm_i) & ~1),
    //Beq   Bge   Bgeu   Blt   Bltu   Bne
    7'b1100011, (instAddr_i + imm_i)
    });
    

    //Store && Load
    MuxKeyWithDefault #(1, 7, 32) MemRAddr_mux (readAddr_o, opCode_i, 32'b0, {
    //Load
    7'b0000011, LoadTypeAddr
    });
        MuxKeyWithDefault #(7, 3, 32) LoadTypeAddr_mux (LoadTypeAddr, funct3_i, 32'b0, {
        //Ld
        3'b011, ImmAddRs1ReadData[31:0],
        //Lw
        3'b010, ImmAddRs1ReadData[31:0],
        //Lh
        3'b001, ImmAddRs1ReadData[31:0],
        //Lb
        3'b000, ImmAddRs1ReadData[31:0],
        //Lbu
        3'b100, ImmAddRs1ReadData[31:0],
        //Lhu
        3'b101, ImmAddRs1ReadData[31:0],
        //Lwu
        3'b110, ImmAddRs1ReadData[31:0]
        });

    MuxKeyWithDefault #(1, 7, 32) MemWAddr_mux (writeAddr_o, opCode_i, 32'b0, {
    //Store
    7'b0100011, StoreTypeAddr
    });
        MuxKeyWithDefault #(4, 3, 32) StoreTypeAddr_mux (StoreTypeAddr, funct3_i, 32'b0, {
        //Sd
        3'b011, ImmAddRs1ReadData[31:0], 
        //Sw
        3'b010, ImmAddRs1ReadData[31:0],
        //Sh
        3'b001, ImmAddRs1ReadData[31:0],
        //Sb
        3'b000, ImmAddRs1ReadData[31:0]
        });

    MuxKeyWithDefault #(1, 7, 64) MemWData_mux (writeData_o, opCode_i, 64'b0, {
    //Store
    7'b0100011, StoreTypeData
    });
        MuxKeyWithDefault #(4, 3, 64) StoreTypeData_mux (StoreTypeData, funct3_i, 64'b0, {
        //Sd
        3'b011, rs2ReadData_i,
        //Sw
        3'b010, rs2ReadData_i,
        //Sh
        3'b001, rs2ReadData_i,
        //Sb
        3'b000, rs2ReadData_i
        });

    MuxKeyWithDefault #(1, 7, 4) MemMask_mux (writeMask_o, opCode_i, 4'b0, {
    //Store
    7'b0100011, StoreTypeMask
    });
        //Mask output
        MuxKeyWithDefault #(4, 3, 4) StoreTypeMask_mux (StoreTypeMask, funct3_i, 4'b0, {
        //Sd
        3'b011, 4'b1000,
        //Sw
        3'b010, 4'b0100,
        //Sh
        3'b001, 4'b0010,
        //Sb
        3'b000, 4'b0001
        });

endmodule
