module PCU_readyControler_way0(
    input logic ready_IFU_i,
    output logic ready_o
);

    assign ready_o = ready_IFU_i;

endmodule