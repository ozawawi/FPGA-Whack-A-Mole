`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/10/2022 04:36:08 PM
// Design Name: 
// Module Name: game_top
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


module game_top(
    input clk, rst,
    input up, down, left, right, center,
    input [3:0] r_in, b_in, g_in,
    output [3:0] pix_r, pix_b, pix_g,
    output h_sync, v_sync, a1, b1, c1, d1, e1, f1, g1,
    output [7:0] an
    );
    
    wire clk_out1;
    
    reg top_left, top_center, top_right, bottom_left, bottom_center, bottom_right; // mole locations. When set high, mole is popped up from respective hole. 
    
    reg win = 1'b0;                     // if set high, game stops, user won
    reg lose = 1'b0;                    // if set high, game stops, Computer wins 
    
    reg [21:0] clk2_counter = 22'd0;    
    reg clk_2 = 1'b0;
    
    reg [10:0] blkpos_x = 11'd1010;     // starting hammer positions
    reg [10:0] blkpos_y = 11'd536; 
    
    wire [10:0] draw_x;
    wire [10:0] draw_y;
    
    wire [3:0] r, g, b;
    
    reg [3:0] dig0 = 4'd0;              // has user score
    reg [3:0] dig4 = 4'd0;              // has computer score
    
    
    // module responsible for the seven segments on the board
    multidigit m3 (.dig7(4'd0), .dig6(4'd0), .dig5(4'd0), .dig4(dig4), .dig3(4'd0), .dig2(4'd0), .dig1(4'd0), .dig0(dig0), 
    .clk(clk), .rst(rst), 
    .a(a1), .b(b1), .c(c1), .d(d1), .e(e1), .f(f1), .g(g1), 
    .an(an));
    
    // drawcon does the drawing
    drawcon m2 (.clk(clk_out1), .win(win), .lose(lose),.center(center),.blkpos_x(blkpos_x), .blkpos_y(blkpos_y) ,.draw_x(draw_x), 
    .draw_y(draw_y), .r(r), .g(g), .b(b), .top_left(top_left), .top_center(top_center), .top_right(top_right), .bottom_left(bottom_left), 
    .bottom_center(bottom_center), .bottom_right(bottom_right));   
    
    //vga_out controls the signals going into the vga screen. Also tells us what is currently being drawn.      
    vga_out m1 (.clk(clk_out1), .r_in(r), .b_in(b), .g_in(g), .pix_r(pix_r), .pix_b(pix_b), .pix_g(pix_g), .h_sync(h_sync), .v_sync(v_sync), 
    .curr_x(draw_x), .curr_y(draw_y));
    
    ///////////////////////////////// converting clk_out1 to 20 Hz --> clk_2. enough to capture button inputs ////////////////////////

    always @ (posedge clk_out1)
    begin
        if (clk2_counter == 22'd4173000) begin
            clk_2 <= ~ clk_2;
            clk2_counter <= 22'd0;
        end
        else 
            clk2_counter <= clk2_counter + 22'd1;
            
    end
    

    //////////////////////////////////////////////// Clicking, Moving, & Score Keeping /////////////////////////////////////////////////////////
        
    // six positions:
    // top right, top center, top left
    // down right, down center, down left, passed to drawcon as input where it gets set. 
    always @ (posedge clk_2) 
    begin
    
    if (!win && !lose) begin  // doesn't go on after game ends.  
        if (center) begin // if center is clicked

            // screen width = 1279. height = 799
            // up = 536, down = 136, right = 1010, left = 368, 
        
            if (top_left) begin // meaning, if top left mole is up
                if (blkpos_x == 11'd368 && blkpos_y == 11'd136) begin  // and hammer is hovering on it
                    dig0 <= dig0 + 4'd1; // increase score
                end
                else
                    dig4 <= dig4 + 4'd1; // miss. increase computer score (opponent)
            end
                
            else if (top_center) begin
                if (blkpos_x == 11'd689 && blkpos_y == 11'd136) begin
                    dig0 <= dig0 + 4'd1;
                end
                else
                    dig4 <= dig4 + 4'd1;
            end
                
            else if (top_right) begin
                if (blkpos_x == 11'd1010 && blkpos_y == 11'd136) begin
                    dig0 <= dig0 + 4'd1;
                end
                else
                    dig4 <= dig4 + 4'd1;
            end
                
            else if (bottom_left) begin 
                if (blkpos_x == 11'd368 && blkpos_y == 11'd536) begin
                    dig0 <= dig0 + 4'd1;
                end
                else
                    dig4 <= dig4 + 4'd1;  
            end
                
                
            else if (bottom_center) begin 
                if (blkpos_x == 11'd689 && blkpos_y == 11'd536) begin
                    dig0 <= dig0 + 4'd1;
                end
                else
                    dig4 <= dig4 + 4'd1; 
            end
             
             
            else if (bottom_right) begin 
                if (blkpos_x == 11'd1010 && blkpos_y == 11'd536) begin
                    dig0 <= dig0 + 4'd1;
                end
                else
                    dig4 <= dig4 + 4'd1;
            end 
            
            else
                dig4 <= dig4 + 4'd1;
                
                
            if (dig0 == 4'b1111) begin // win
                win = 1'b1;
            end
            else if (dig4 == 4'b1111) begin // lose
                lose = 1'b1;
            end
            
        end
        else begin // if center is not clicked...
            
            if (up && blkpos_y >= 11'd400) // if up is clicked, and hammer is in lower half of screen
                blkpos_y <= blkpos_y - 11'd400;
                
            if (down && blkpos_y <= 11'd400)  
                blkpos_y <= blkpos_y + 11'd400;
                
            if (right && blkpos_x < 11'd1010)  // if right is clicked and hammer is not on the right side, can go right
                blkpos_x <= blkpos_x + 11'd321;
            
                
            if (left && blkpos_x > 11'd415)  
                blkpos_x <= blkpos_x - 11'd321;
                
        end
    end  
    end
    
    
    ////////////////////////////////////// Moles "random selection" mechanism ////////////////////////////////////////
    
    reg [25:0] clk3_counter = 26'd0; 
    reg clk_3; // one second clock
    reg rst_2 = 1'd0;
    
    // clk for generating when moles pop up.
    always @ (posedge clk_out1)
    begin
        if (clk3_counter == 26'd50_000_000) begin // almost a second. 
            clk_3 <= ~ clk_3;
            clk3_counter <= 26'd0;
        end
        else 
            clk3_counter <= clk3_counter + 26'd1;
        
    end
    
    reg [2:0] temp = 3'b101;
    reg t;
    
    // implementing a linear feedback shift register for randomness 
    always @ (posedge clk_3)
    begin
        if (rst_2 == 1'd0) begin // resets eveyrything for a second every other cycle. 
            top_left <= 1'b0;
            top_center <= 1'b0;
            top_right <= 1'b0;
            bottom_left <= 1'b0;
            bottom_center <= 1'b0;
            bottom_right <= 1'b0;
            
        end
        else begin       
            t <= temp[0] ^ temp[1];
            temp <= temp >> 1;
            temp[2] <= t;
            
            case (temp)
                3'd0: top_left <= 1'b1;
                3'd1: top_center <= 1'b1;
                3'd2: top_right <= 1'b1;
                3'd3: bottom_left <= 1'b1;
                3'd4: bottom_center <= 1'b1;
                3'd5: bottom_right <= 1'b1;
            endcase
                        
        end
        
        rst_2 <= ~rst_2;
    end
    

       
    
// 
// (c) Copyright 2008 - 2013 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
//----------------------------------------------------------------------------
// User entered comments
//----------------------------------------------------------------------------
// None
//
//----------------------------------------------------------------------------
//  Output     Output      Phase    Duty Cycle   Pk-to-Pk     Phase
//   Clock     Freq (MHz)  (degrees)    (%)     Jitter (ps)  Error (ps)
//----------------------------------------------------------------------------
// clk_out1__83.45588______0.000______50.0______299.155____297.220
//
//----------------------------------------------------------------------------
// Input Clock   Freq (MHz)    Input Jitter (UI)
//----------------------------------------------------------------------------
// __primary_________100.000____________0.010

// The following must be inserted into your Verilog file for this
// core to be instantiated. Change the instance name and port connections
// (in parentheses) to your own signal names.

//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG

  clk_wiz_0 instance_1
   (
    // Clock out ports
    .clk_out1(clk_out1),     // output clk_out1
   // Clock in ports
    .clk_in1(clk));      // input clk_in1
    
    

// INST_TAG_END ------ End INSTANTIATION Template ---------
endmodule
