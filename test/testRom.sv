module testRom (
    input logic clk,
    input logic reset_n,
    input logic request_i,
    input logic [31:0] instAddr_i,
    output logic [31:0] inst_o,
    output logic dataOk_o
);

    reg [7:0] romReg [10'h3FF * 4 : 0];
    reg [2:0] a;
    bit b = 1;
    reg dataOk_inside;
    reg [31:0] inst_inside;

    initial begin
        $readmemh("code.mem", romReg);
    end

    class test;
       rand reg[2:0] randseed;
       rand bit mode;
    endclass // 
    test test1, test2;

    // always_ff @(posedge clk or negedge reset_n) begin
    //     if(~reset_n) begin
    //         test2 = new();
    //     end else begin
    //         test2.randomize(mode);
    //         b = test2.mode;
    //     end
    // end

    always @(posedge clk or negedge reset_n) begin
        if(~reset_n) begin
            inst_inside <= 32'b0;
            dataOk_inside <= 1'b0;
            test1 = new();
        end else if(request_i) begin
            test1.randomize(randseed);
            a = test1.randseed;
            repeat (a) begin
                @(posedge clk);
            end
            inst_inside <= {romReg[instAddr_i], romReg[instAddr_i + 1], romReg[instAddr_i + 2], romReg[instAddr_i + 3]};
            dataOk_inside <= 1'b1;
        end else begin
            dataOk_inside <= 1'b0;
        end
    end
    
    assign dataOk_o = b ? 1'b1 : dataOk_inside;
    assign inst_o = b ? {romReg[instAddr_i], romReg[instAddr_i + 1], romReg[instAddr_i + 2], romReg[instAddr_i + 3]} : inst_inside;
     
endmodule