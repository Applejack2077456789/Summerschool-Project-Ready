`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/29 14:44:42
// Design Name: 
// Module Name: rgb_transform
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


module rgb_transform(
input               PClk,
input [23:0]        RGB24,
input [10:0]        HCnt,
input [9:0]        VCnt,
input [3:0]         num,
output reg [23:0]   RGB_render,
output         gray_data
    );

grey_transform grey(.clk(PClk),
                   .RGB24(RGB24),
                   .Y(gray_data));

wire num_rom;

hdmi_num_test num_show(
                   . clk(PClk),
                    .vc(VCnt),
                    .hc(HCnt),
                    .data (num),
                    .rom_data(num_rom));
                    

wire num_rgb24 = num_rom?24'hffffff:0;                    

always@(posedge PClk) begin
    if(HCnt==640-100 | HCnt==640+100 | VCnt==360-133 | VCnt==360+133)
        RGB_render <= 24'b11111111_00000000_00000000;
   else if((HCnt > 30 && HCnt <= 50) && (VCnt > 40 && VCnt <= 80))
        RGB_render<= num_rgb24;
    else if(VCnt>0 && VCnt<3)
      RGB_render <= 24'b11111111_11111111_00000000;    
    else
         RGB_render<={24{gray_data}};

end
 
endmodule
