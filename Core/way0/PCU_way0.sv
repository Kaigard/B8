
module PCU_way0 (
    input logic clk,
    input logic reset_n,
    input logic ready_i,
    input logic dataOk_i,
    input logic jumpFlag_i,
    input logic [31:0] jumpAddr_i,
    output logic request_o,
    output logic valid_o,
    output logic [31:0] instAddr_o
);

    //************************************************
    // 数据结构定义
    //************************************************
    typedef enum reg[2:0] { 
        idel,
        bench,
        hold,                                                    // 后级阻塞
        wireMode,                                                  
        fetch,                                                   // 取值阻塞
        sramMode                                                    
    } state;

    //************************************************
    // 例化
    //************************************************
    state currentState, nextState;

    //************************************************
    // 状态机
    //************************************************
    always_ff @(posedge clk or negedge reset_n) begin
        if(~reset_n) 
            currentState <= idel;
        else
            currentState <= nextState;
    end
    always_comb begin
        case (currentState)
            idel : begin
                if(dataOk_i) begin
                    nextState = wireMode;
                end else begin
                    nextState = bench;
                end
            end
            bench : begin
                if(~ready_i) begin
                    nextState = hold;
                end else if(request_o && ~dataOk_i) begin
                    nextState = fetch;
                end else begin
                    nextState = idel;
                end
            end
            hold : begin
                if(ready_i) begin
                    nextState = idel;
                end else begin
                    nextState = hold;
                end
            end
            wireMode : begin
                if(~ready_i) begin
                    nextState = hold;
                end else if(~request_o) begin
                    nextState = idel;
                end else if(~dataOk_i) begin
                    nextState = fetch;
                end else begin
                    nextState = wireMode;
                end
            end
            fetch : begin
                if(dataOk_i) begin
                    nextState = sramMode;
                end else begin
                    nextState = fetch;
                end
            end
            sramMode : begin
                if(~ready_i) begin
                    nextState = hold;
                end else if(request_o && dataOk_i) begin
                    nextState = wireMode;
                end else if(request_o && ~dataOk_i) begin
                    nextState = fetch;
                end else begin
                    nextState = bench;
                end
            end
            default : begin
                nextState = idel;
            end
        endcase
    end
    always_ff @(posedge clk or negedge reset_n) begin
        if(~reset_n) begin
            instAddr_o <= 32'hffff_fffc;
            request_o <= 1'b0;
            valid_o <= 1'b0;
        end else begin
            case (currentState)
                idel : begin
                    request_o <= 1'b1;
                    valid_o <= 1'b0;
                    instAddr_o <= instAddr_o + 4;
                end
                bench : begin
                    request_o <= 1'b0;
                    valid_o <= 1'b0;
                    instAddr_o <= instAddr_o;
                end
                hold : begin
                    request_o <= 1'b0;
                    valid_o <= 1'b0;
                    instAddr_o <= instAddr_o;
                end
                wireMode : begin
                    request_o <= 1'b1;
                    valid_o <= 1'b1;
                    instAddr_o <= instAddr_o + 4;
                end
                fetch : begin
                    request_o <= 1'b0;
                    valid_o <= 1'b0;
                    instAddr_o <= instAddr_o;
                end
                sramMode : begin
                    request_o <= 1'b1;
                    valid_o <= 1'b1;
                    instAddr_o <= instAddr_o + 4;
                end
                default : begin
                    
                end
            endcase
        end
    end

endmodule