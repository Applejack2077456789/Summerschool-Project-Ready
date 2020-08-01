`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/29 14:16:20
// Design Name: 
// Module Name: num_recognition
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


module num_recognition(
input pclk,
input [10:0] HCnt,
input [9:0] VCnt,
input Binary,
output reg [3:0] digital
    );
    
parameter 
           CENTER_H = 640,
           CENTER_V = 360,
           VCnt_max = 266,
           HCnt_max = 200,
           HCnt_l=CENTER_H-100,
           HCnt_r=CENTER_H+100,
		   VCnt_u=CENTER_V-133,      
		   VCnt_d=CENTER_V+133,
		   X1 = (CENTER_V-(VCnt_max>>1))+((VCnt_max*410)>>10),
		   X2 = (CENTER_V-(VCnt_max>>1))+((VCnt_max*683)>>10);

reg        x1_l,x1_r;
reg        x2_l,x2_r;
reg  [1:0] y,x1,x2;

wire posedge_sig;

rise_check checking(
   .clk(pclk),
   .i_data_in(Binary),
   .o_rising_edge(posedge_sig)
);

always@(posedge pclk) begin
	if(HCnt==HCnt_l && VCnt==VCnt_u) 
	   x1_l<= 0;      
    else if(HCnt>HCnt_l && HCnt<CENTER_H && VCnt==X1)  
	   x1_l<= x1_l + posedge_sig;
    else
       x1_l<=x1_l; end 

always@(posedge pclk) begin
	if(HCnt==HCnt_l && VCnt==VCnt_u) 
	   x1_r<= 0;      
    else if(HCnt<HCnt_r && HCnt>CENTER_H && VCnt==X1)  
	   x1_r<= x1_r + posedge_sig;
    else
       x1_r<=x1_r; end 

always@(posedge pclk) begin
	if(HCnt==HCnt_l && VCnt==VCnt_u) 
	   x2_l<= 0;      
    else if(HCnt>HCnt_l && HCnt<CENTER_H && VCnt==X2)  
	   x2_l<= x2_l + posedge_sig;
    else
       x2_l<=x2_l; end 

always@(posedge pclk) begin
	if(HCnt==HCnt_l && VCnt==VCnt_u) 
	   x2_r<= 0;      
    else if(HCnt<HCnt_r && HCnt>CENTER_H && VCnt==X2)  
	   x2_r<= x2_r + posedge_sig;
    else
       x2_r<=x2_r; end

reg y_in1,y_in0; wire yposedge_sig;
assign yposedge_sig = ~y_in1 & y_in0;
always@(posedge pclk) begin
       if(HCnt==HCnt_l && VCnt==VCnt_u) begin
       y_in0<=0;
       y_in1<=0;end
       else if(VCnt>VCnt_u && VCnt<VCnt_d && HCnt==CENTER_H )begin
          y_in0<=y_in1;
          y_in1<=Binary;end
       else begin
          y_in0<=y_in0;
          y_in1<=y_in1; end 
end

always@(posedge pclk) begin
       if(HCnt==HCnt_l && VCnt==VCnt_u)
        y<=0;
       else if(VCnt>VCnt_u && VCnt<VCnt_d && HCnt==CENTER_H )
        y<=y+yposedge_sig;
       else
            y<=y;
end

always @(posedge pclk) begin
x1 <= x1_r + x1_l;
x2 <= x2_r + x2_l;
end

always @(posedge pclk)
begin 
   if(y==2 && x1==2 && x2==2)
           digital<=4'b0000;
   else if(y==1 && x1==1 && x2==1)
           digital<=4'b0001;
   else if(y==3 && x1==1 && x2==1) begin
           if(x1_r==1 && x2_l==1)
                 digital<=4'b0010;  
           else if (x1_r==1 && x2_r==1)	
                 digital<=4'b0011; 	
           else if(x1_l==1 && x2_r==1)
                 digital<=4'b0101;   
           else
                 digital<=4'b1010; end 
    else if(y==2 && x1==2 && x2==1)				
            digital<=4'b0100;
    else if(y==3 && x1==1 && x2==2)
            digital<=4'b0110;
    else if(y==2 && x1==1 && x2==1)
            digital<=4'b0111;
    else if(y==3 && x1==2 && x2==2)
           digital<=4'b1000;
    else if(y==3 && x1==2 && x2==1)
           digital<=4'b1001;
    else
           digital<=4'b1111;
end
          
    
endmodule
