`timescale 1ps/1ps

module xor_it (
    input wire rst, clk, def_sig, change_defxor,
    input wire [7:0] data_in, custom_xor, new_def_xor, 
    output reg [7:0] xored
);
wire [7:0] default_xor;

assign default_xor = change_defxor ? new_def_xor : 8'b0101_0101;

always @(posedge clk or posedge rst) begin

    if(rst) xored <= 8'b00000000;
    else begin
        if (def_sig) xored <= data_in ^ default_xor;
        else xored <= data_in ^ custom_xor;
    end
end

    
endmodule