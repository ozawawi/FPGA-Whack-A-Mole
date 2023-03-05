`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/06/2022 01:04:24 AM
// Design Name: 
// Module Name: vga_out
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




module vga_out(
    input clk,
    input [3:0] r_in, b_in, g_in,
    output [3:0] pix_r, pix_b, pix_g,
    output h_sync, v_sync,
    output [10:0] curr_x,
    output [9:0] curr_y
    );
    
    reg [10:0] hcount = 11'd0;
    reg [9:0] vcount = 10'd0;
        
    assign h_sync = (hcount <= 11'd135) ? 1'b0 : 1'b1;
    assign v_sync = (vcount <= 10'd2)   ? 1'b1 : 1'b0;
    
    //if it is in the valid region, use the inputted color. Otherwise, black. 
    assign pix_r = (hcount >= 11'd336 && hcount <= 11'd1615 && vcount >= 10'd27 && vcount <= 10'd826) ? r_in : 4'd0;
    assign pix_b = (hcount >= 11'd336 && hcount <= 11'd1615 && vcount >= 10'd27 && vcount <= 10'd826) ? b_in : 4'd0;
    assign pix_g = (hcount >= 11'd336 && hcount <= 11'd1615 && vcount >= 10'd27 && vcount <= 10'd826) ? g_in : 4'd0;
    
    // assign the current position with respect to the visibile region 
    assign curr_x = (hcount >= 11'd336 && hcount <= 11'd1615 && vcount >= 10'd27 && vcount <= 10'd826) ? hcount - 11'd336 : 11'd0;
    assign curr_y = (hcount >= 11'd336 && hcount <= 11'd1615 && vcount >= 10'd27 && vcount <= 10'd826) ? vcount - 10'd27 : 10'd0;

    
    
    always @ (posedge clk) begin
     
        if (hcount == 11'd1679)  begin
            hcount <= 11'd0;
            if (vcount == 10'd827)
                vcount <= 10'd0;
            else
                vcount <= vcount + 10'd1;
        end
        else 
            hcount <= hcount +1; 
                    
    end     
endmodule
