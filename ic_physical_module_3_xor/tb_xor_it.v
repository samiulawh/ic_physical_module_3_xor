`timescale 1ps/1ps

module tb_xor_it();

reg rst, clk, def_sig, change_defxor;
reg [7:0] data_in, custom_xor, new_def_xor;

wire [7:0] xored;
wire [7:0] active_def_xor;

assign active_def_xor = change_defxor ? new_def_xor : 8'b01010101;

xor_it uut1 (
    .rst(rst),
    .clk(clk),
    .def_sig(def_sig),
    .change_defxor(change_defxor),
    .data_in(data_in),
    .custom_xor(custom_xor),
    .new_def_xor(new_def_xor),
    .xored(xored)
);

// Clock
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Display every XOR calculation
always @(posedge clk) begin
    #1;
    if (def_sig)
        $display("Time:%0t | rst:%b | def_sig:%b | change:%b | data:%b | xor:%b | expected:%b | DUT:%b",
                 $time, rst, def_sig, change_defxor, data_in, active_def_xor, data_in ^ active_def_xor, xored);
    else
        $display("Time:%0t | rst:%b | def_sig:%b | change:%b | data:%b | xor:%b | expected:%b | DUT:%b",
                 $time, rst, def_sig, change_defxor, data_in, custom_xor, data_in ^ custom_xor, xored);
end

// Stimulus
initial begin

    $dumpfile("xor_it.vcd");
    $dumpvars(0, tb_xor_it);

    rst = 1;
    def_sig = 0;
    change_defxor = 0;
    data_in = 8'b00000000;
    custom_xor = 8'b00000000;
    new_def_xor = 8'b00000000;

    #7;

    // Default XOR
    rst = 0;
    def_sig = 1;
    change_defxor = 0;
    data_in = 8'b11111111;

    #10;

    // Custom XOR
    def_sig = 0;
    custom_xor = 8'b11001100;
    data_in = 8'b11110000;

    #10;

    // New default XOR
    def_sig = 1;
    change_defxor = 1;
    new_def_xor = 8'b10101010;
    data_in = 8'b00001111;

    #10;

    $display("\nSimulation complete.");
    $finish;

end

endmodule