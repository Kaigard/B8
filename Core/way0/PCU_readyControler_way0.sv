module PCU_readyControler_way0(
    input logic readyNextStep_i,
    output logic ready_o
);

    assign ready_o = readyNextStep_i;

endmodule