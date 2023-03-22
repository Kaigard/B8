module FU_Register_way0(
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
    output logic [1:0] way0_pID_o,
    output logic [2:0] funct3_o,
    // To RAM
    output logic [31:0] readAddr_o,
    output logic [31:0] writeAddr_o,
    output logic [63:0] writeData_o,
    output logic [3:0] writeMask_o
);

    typedef enum reg[1:0] { 
        idel,
        read,
        write
    } state;

    state currentState, nextState;

    // assign ready_o = ready_i;
    assign readAddr_o = readAddr_i;
    assign writeAddr_o = writeAddr_i;
    assign writeData_o = writeData_i;
    assign writeMask_o = writeMask_i;

    always_ff @(posedge clk or negedge reset_n) begin
        if(~reset_n)
            currentState <= idel;
        else
            currentState <= nextState;
    end
    always_comb begin
        case (currentState)
            idel : begin
                if(|readAddr_i)
                    nextState = read;
                else if(|writeAddr_i)
                    nextState = write;
                else 
                    nextState = idel;
            end
            read : begin
                if(dataOk_i && |readAddr_i && valid_i)
                    nextState = read;
                else if(dataOk_i)
                    nextState = idel;
                else
                    nextState = read;
            end
            write : begin
                if(&writeState_i && |writeAddr_i && valid_i)
                    nextState = write;
                else if(&writeState_i)
                    nextState = idel;
                else
                    nextState = write;
            end
            default : begin
                nextState = idel;
            end
        endcase
    end
    always_ff @(posedge clk or negedge reset_n) begin
        case (currentState)
            idel : begin
                if(|readAddr_i || |writeAddr_i)
                    ready_o <= 1'b0;
                else
                    ready_o <= ready_i;
            end
            read : begin
                if(dataOk_i && |readAddr_i && valid_i)
                    ready_o <= 1'b0;
                else if(dataOk_i)
                    ready_o <= ready_i;
                else
                    ready_o <= 1'b0;
            end
            write : begin
                if(&writeState_i && |writeAddr_i && valid_i)
                    ready_o <= 1'b0;
                else if(&writeState_i)
                    ready_o <= ready_i;
                else
                    ready_o <= 1'b0;
            end
            default : begin
                ready_o <= 1'b0;
            end
        endcase 
    end

    // 待优化：根据标志信号，使得数据、地址总线可重用
    always_ff @(posedge clk or negedge reset_n) begin
        if(~reset_n) begin
            rdWriteEnable_o <= 1'b0;
            rdAddr_o <= 5'b0;
            rdData_o <= 64'b0;
            way0_pID_o <= 2'b0;
            funct3_o <= 3'b0;
            // readAddr_o <= 32'b0;
            // writeAddr_o <= 32'b0;
            // writeData_o <= 64'b0;
            // writeMask_o <= 4'b0;
        end else if(ready_i) begin
            rdWriteEnable_o <= rdWriteEnable_i;
            rdAddr_o <= rdAddr_i;
            rdData_o <= rdData_i;
            way0_pID_o <= way0_pID_i;
            funct3_o <= funct3_i;
            // readAddr_o <= readAddr_i;
            // writeAddr_o <= writeAddr_i;
            // writeData_o <= writeData_i;
            // writeMask_o <= writeMask_i;
        end
    end

    // valid只表明数据有效，不具备握手功能
    always_ff @(posedge clk or negedge reset_n) begin
        if(~reset_n) begin
            valid_o <= 1'b0;
        end else if(ready_i) begin
            valid_o <= 1'b1;
        end else begin
            valid_o <= 1'b0;
        end
    end


    `ifdef DebugMode
        always_ff @(posedge clk or negedge reset_n) begin
            if(~reset_n) begin
                inst_o <= 32'b0;
                instAddr_o <= 32'b0;
            end else if(ready_i) begin
                inst_o <= inst_i;
                instAddr_o <= instAddr_i;
            end
        end
    `endif 

endmodule