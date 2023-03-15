module testRom (
    input clk,
    input reset_n,
    input request_i,
    input [31:0] instAddr_i,
    output reg [31:0] inst_o,
    output reg dataOk_o
);

    reg [7:0] romReg [10'h3FF * 4 : 0];

    initial begin
        $readmemh("code.mem", romReg);
    end

    always @(posedge clk or negedge reset_n) begin
        if(~reset_n) begin
            inst_o <= 32'b0;
            dataOk_o <= 1'b0;
        end else if(request_i) begin
            inst_o <= {romReg[instAddr_i + 3], romReg[instAddr_i + 2], romReg[instAddr_i + 1], romReg[instAddr_i]};
            dataOk_o <= 1'b1;
        end else begin
            dataOk_o <= 1'b0;
        end
    end

    /*
    assign dataOk_o = request_i;
    assign inst_o = {romReg[instAddr_i + 3], romReg[instAddr_i + 2], romReg[instAddr_i + 1], romReg[instAddr_i]};
    */
endmodule