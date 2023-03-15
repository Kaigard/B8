module PCU_readyControler_way0(
    input readyNextStep_i,
    output ready_o
);

    assign ready_o = readyNextStep_i;

endmodule