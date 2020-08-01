`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/29 14:37:05
// Design Name: 
// Module Name: grey_transform
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


module grey_transform(
input clk,
input [23:0] RGB24,
output reg Y
    );
    
wire [7:0] R;
wire [7:0] G;
wire [7:0] B;
assign R = RGB24[23:16];
assign G = RGB24[15:8];
assign B = RGB24[7:0];

reg [15:0] Ry;
reg [15:0] Gy;   
reg [15:0] By;   
reg [15:0]Adder;
reg [7:0]gray;

always@(posedge clk)
begin
Ry<=R*8'd76;
Gy<=G*8'd150;
By<=B*8'd30;
end

always@(posedge clk)
begin
Adder<=Ry+Gy+By;
end

always@(posedge clk)
begin
gray<=Adder[15:8];
end

always@(posedge clk)
begin
Y<=(gray>8'd100)?1'b1:1'b0;
end
    
endmodule
