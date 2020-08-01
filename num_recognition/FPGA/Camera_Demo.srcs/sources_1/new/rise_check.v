`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/29 14:14:24
// Design Name: 
// Module Name: rise_check
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module rise_check(
input  clk,
input  i_data_in,
output o_rising_edge
    );

reg r_data_in0=0;
reg r_data_in1=0;

assign o_rising_edge = ~r_data_in1 & r_data_in0;
 
always@(posedge clk) 
begin
r_data_in0 <= r_data_in1;
r_data_in1 <= i_data_in;
end   
    
endmodule
