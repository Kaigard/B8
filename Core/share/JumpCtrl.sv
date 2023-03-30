module JumpCtrl(
    input logic way0_jumpFlag_i,
    input logic [31:0] way0_jumpAddr_i,
    input logic [1:0] way0_EU_pID_i,
    input logic way1_jumpFlag_i,
    input logic [31:0] way1_jumpAddr_i,
    input logic [1:0] way1_EU_pID_i,
    output logic way0_jumpFlag_o,
    output logic [31:0] way0_jumpAddr_o,
    output logic way1_jumpFlag_o,
    output logic [31:0] way1_jumpAddr_o
);

    // assign way0_jumpFlag_o = way0_jumpFlag_i || way1_jumpFlag_i;
    // assign way1_jumpFlag_o = way0_jumpFlag_i || way1_jumpFlag_i;

    always_comb begin
        case({way0_EU_pID_i, way0_jumpFlag_i, way1_EU_pID_i, way1_jumpFlag_i})
            // 双路同时发射，way1要比way0晚
            6'b00_1_01_0 : begin
                way0_jumpFlag_o = way0_jumpFlag_i;
                way0_jumpAddr_o = way0_jumpAddr_i;
                way1_jumpFlag_o = way0_jumpFlag_i;
                way1_jumpAddr_o = way0_jumpAddr_i + 4;
            end
            6'b00_0_01_1 : begin
                way0_jumpFlag_o = way1_jumpFlag_i;
                way0_jumpAddr_o = way1_jumpAddr_i;
                way1_jumpFlag_o = way1_jumpFlag_i;
                way1_jumpAddr_o = way1_jumpAddr_i + 4;
            end
            6'b00_1_01_1 : begin
                way0_jumpFlag_o = way0_jumpFlag_i;
                way0_jumpAddr_o = way0_jumpAddr_i;
                way1_jumpFlag_o = way0_jumpFlag_i;
                way1_jumpAddr_o = way0_jumpAddr_i + 4;
            end
            // // 
            // 4'b00_11 : begin
            //     way0_jumpFlag_o = way0_jumpFlag_i;
            //     way0_jumpAddr_o = way0_jumpAddr_i;
            //     way1_jumpFlag_o = way0_jumpFlag_i;
            //     way1_jumpAddr_o = way0_jumpAddr_i + 4;
            // end
            6'b10_1_01_0 : begin
                way0_jumpFlag_o = way0_jumpFlag_i;
                way0_jumpAddr_o = way0_jumpAddr_i;
                way1_jumpFlag_o = way0_jumpFlag_i;
                way1_jumpAddr_o = way0_jumpAddr_i + 4;
            end
            6'b10_0_01_1 : begin
                way0_jumpFlag_o = way1_jumpFlag_i;
                way0_jumpAddr_o = way1_jumpAddr_i + 4;
                way1_jumpFlag_o = way1_jumpFlag_i;
                way1_jumpAddr_o = way1_jumpAddr_i;
            end
            6'b10_1_01_1 : begin
                way0_jumpFlag_o = way1_jumpFlag_i;
                way0_jumpAddr_o = way1_jumpAddr_i + 4;
                way1_jumpFlag_o = way1_jumpFlag_i;
                way1_jumpAddr_o = way1_jumpAddr_i;
            end

            // 同样同时双发射
            6'b10_1_11_0 : begin
                way0_jumpFlag_o = way0_jumpFlag_i;
                way0_jumpAddr_o = way0_jumpAddr_i;
                way1_jumpFlag_o = way0_jumpFlag_i;
                way1_jumpAddr_o = way0_jumpAddr_i + 4;
            end
            6'b10_0_11_1 : begin
                way0_jumpFlag_o = way1_jumpFlag_i;
                way0_jumpAddr_o = way1_jumpAddr_i;
                way1_jumpFlag_o = way1_jumpFlag_i;
                way1_jumpAddr_o = way1_jumpAddr_i + 4;
            end
            6'b10_1_11_1 : begin
                way0_jumpFlag_o = way0_jumpFlag_i;
                way0_jumpAddr_o = way0_jumpAddr_i;
                way1_jumpFlag_o = way0_jumpFlag_i;
                way1_jumpAddr_o = way0_jumpAddr_i + 4;
            end
            default : begin
                way0_jumpFlag_o = 1'b0;
                way0_jumpAddr_o = 32'b0;
                way1_jumpFlag_o = 1'b0;
                way1_jumpAddr_o = 32'b0;
            end
        endcase
    end

endmodule