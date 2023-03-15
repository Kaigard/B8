module PCU_readyControler(
    input readyNextStep_i,
    output ready_o
);

    assign ready_o = readyNextStep_i;

endmodule