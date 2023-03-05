`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/10/2022 05:41:26 PM
// Design Name: 
// Module Name: drawcon
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


module drawcon(
    input clk, center, win, lose,
    input [10:0] blkpos_x, draw_x,
    input [10:0] blkpos_y, draw_y,
    output [3:0] r, g, b,
    input top_left, top_center, top_right, bottom_left, bottom_center, bottom_right
    );

    
    reg [3:0] bg_r, bg_g, bg_b, blk_r, blk_g, blk_b;
    
    assign r = (blk_r != 4'd0) ? blk_r : bg_r; 
    assign g = (blk_g != 4'd0) ? blk_g : bg_g;
    assign b = (blk_b != 4'd0) ? blk_b : bg_b;
    
    // declerations for wires/regs used for memory blocks. 
    reg [13:0] address_mole_under;
    reg [13:0] address_mole_up;
    reg [13:0] address_hammer_up;
    reg [13:0] address_hammer_up1;
    reg [13:0] address_hammer_down;
    reg [13:0] address_hammer_down1;
    reg [16:0] address_win;
    reg [16:0] address_lose;
    wire [11:0] mem_mole_under;
    wire [11:0] mem_mole_up;
    wire [11:0] mem_hammer_up;
    wire [11:0] mem_hammer_up1;
    wire [11:0] mem_hammer_down;
    wire [11:0] mem_hammer_down1;
    wire [11:0] mem_win;
    wire [11:0] mem_lose;
    
    // memory blocks    
    mole_under mole_under_0 (.clka(clk), .addra(address_mole_under), .douta(mem_mole_under));
    mole_up mole_up_0 (.clka(clk), .addra(address_mole_up), .douta(mem_mole_up));
    hammer_up hammer_up_0 (.clka(clk), .addra(address_hammer_up), .douta(mem_hammer_up));
    hammer_up1 hammer_up_1 (.clka(clk), .addra(address_hammer_up1), .douta(mem_hammer_up1)); // blue background included
    hammer_down hammer_down_0 (.clka(clk), .addra(address_hammer_down), .douta(mem_hammer_down));
    hammer_down1 hammer_down_1 (.clka(clk), .addra(address_hammer_down1), .douta(mem_hammer_down1)); // blue background included 
    win win_0 (.clka(clk), .addra(address_win), .douta(mem_win));
    lose lose_0 (.clka(clk), .addra(address_lose), .douta(mem_lose));
    
    // this block handles the moles and background drawings, and the "you win" and "you lose" drawings
    always @ * 
    begin 
    
        // draw the boarders
        if ((draw_x > 11'd0 && draw_x < 11'd10) || (draw_x < 11'd1279 && draw_x > 11'd1269) || (draw_y > 11'd0 && draw_y < 11'd10) || (draw_y < 11'd799 && draw_y > 11'd789)) begin
            bg_r = 4'b1111; // white boardess
            bg_g = 4'b1111;
            bg_b = 4'b1111;
        end 
        
         ///////////////////////////// Drawing the Moles ////////////////////////////////////////
        
        // Either inside the hole, or out. Depending on whether the signals top_left, top_right, ...., are set. 
        else if(draw_x > 11'd287 && draw_x <= 11'd387 && draw_y > 11'd168 && draw_y <= 11'd248) begin 
            if (!top_left) begin 
                address_mole_under = (draw_y - 11'd169)*11'd100 + (draw_x - 11'd288);
                bg_r = mem_mole_under[11:8];
                bg_g = mem_mole_under[7:4];
                bg_b = mem_mole_under[3:0];   
            end
            else begin
                address_mole_up = (draw_y - 11'd169)*11'd100 + (draw_x - 11'd288);  
                bg_r = mem_mole_up[11:8];
                bg_g = mem_mole_up[7:4];
                bg_b = mem_mole_up[3:0];
            end
            
        end
        
        else if(draw_x > 11'd608 && draw_x <= 11'd708 && draw_y > 11'd168 && draw_y <= 11'd248) begin 
            if (!top_center) begin 
                address_mole_under = (draw_y- 11'd169)*11'd100 + (draw_x - 11'd609); 
                bg_r = mem_mole_under[11:8];
                bg_g = mem_mole_under[7:4];
                bg_b = mem_mole_under[3:0];   
            end
            else begin
                address_mole_up = (draw_y- 11'd169)*11'd100 + (draw_x - 11'd609);    
                bg_r = mem_mole_up[11:8];
                bg_g = mem_mole_up[7:4];
                bg_b = mem_mole_up[3:0];
            end
        end
        else if(draw_x > 11'd928 && draw_x <= 11'd1028 && draw_y > 11'd168 && draw_y <= 11'd248) begin // upper right box
            if (!top_right) begin 
                address_mole_under = (draw_y - 11'd169)*11'd100 + (draw_x - 11'd929);
                bg_r = mem_mole_under[11:8];
                bg_g = mem_mole_under[7:4];
                bg_b = mem_mole_under[3:0];   
            end
            else begin
                address_mole_up = (draw_y - 11'd169)*11'd100 + (draw_x - 11'd929);  
                bg_r = mem_mole_up[11:8];
                bg_g = mem_mole_up[7:4];
                bg_b = mem_mole_up[3:0];
            end
        end
        else if(draw_x > 11'd287 && draw_x <= 11'd387 && draw_y > 11'd568 && draw_y <= 11'd648) begin // lower left box
            if (!bottom_left) begin 
                address_mole_under = (draw_y - 11'd569)*11'd100 + (draw_x - 11'd288);
                bg_r = mem_mole_under[11:8];
                bg_g = mem_mole_under[7:4];
                bg_b = mem_mole_under[3:0];   
            end
            else begin
                address_mole_up = (draw_y - 11'd569)*11'd100 + (draw_x - 11'd288);  
                bg_r = mem_mole_up[11:8];
                bg_g = mem_mole_up[7:4];
                bg_b = mem_mole_up[3:0];
            end
        end
        else if(draw_x > 11'd608 && draw_x <= 11'd708 && draw_y > 11'd568 && draw_y <= 11'd648) begin // lower center box
            if (!bottom_center) begin 
                address_mole_under = (draw_y - 11'd569)*11'd100 + (draw_x - 11'd609);
                bg_r = mem_mole_under[11:8];
                bg_g = mem_mole_under[7:4];
                bg_b = mem_mole_under[3:0];   
            end
            else begin
                address_mole_up = (draw_y - 11'd569)*11'd100 + (draw_x - 11'd609);  
                bg_r = mem_mole_up[11:8];
                bg_g = mem_mole_up[7:4];
                bg_b = mem_mole_up[3:0];
            end
        end
        else if(draw_x > 11'd928 && draw_x <= 11'd1028 && draw_y > 11'd568 && draw_y <= 11'd648) begin // lower right box
            if (!bottom_right) begin 
                address_mole_under = (draw_y - 11'd569)*11'd100 + (draw_x - 11'd929);
                bg_r = mem_mole_under[11:8];
                bg_g = mem_mole_under[7:4];
                bg_b = mem_mole_under[3:0];   
            end
            else begin
                address_mole_up = (draw_y - 11'd569)*11'd100 + (draw_x - 11'd929);  
                bg_r = mem_mole_up[11:8];
                bg_g = mem_mole_up[7:4];
                bg_b = mem_mole_up[3:0];
            end
        end
        
        
        /////////////////////////// Drawing the Win/Lose Messages /////////////////////////////////

        else if(draw_x > 11'd325 && draw_x <= 11'd875 && draw_y > 11'd295 && draw_y <= 11'd505) begin
            if (win) begin
                address_win = (draw_y - 11'd296)*11'd550 + (draw_x - 11'd326);
                bg_r = mem_win[11:8];
                bg_g = mem_win[7:4];
                bg_b = mem_win[3:0]; 
            end
            else if (lose) begin
                address_lose = (draw_y - 11'd296)*11'd550 + (draw_x - 11'd326);
                bg_r = mem_lose[11:8];
                bg_g = mem_lose[7:4];
                bg_b = mem_lose[3:0]; 
            end
        end
        
        ////////////////////////////// Drawing the Background //////////////////////////////////////

        else begin // if draw_xy is not on a mole's location then it's the background. 
            if (draw_y > 160) begin // boundry that seperates sky and land
                bg_r = 4'h9; // light green grass
                bg_g = 4'hE;
                bg_b = 4'h5;
            end
            else begin
                bg_r = 4'hB; // light blue skies. 
                bg_g = 4'hF;
                bg_b = 4'hF;
            end
        end
         
    end 
  
    ////////////////////////////// Drawing the Hammer //////////////////////////////////////
    always @ *
    begin

        // draw hammer in neutral state
        // if center is not clicked, and draw_xy are on hammer's location
        if (!center && draw_x > blkpos_x && draw_x <= blkpos_x + 11'd80 && draw_y > blkpos_y - 11'd50 && draw_y <= blkpos_y + 11'd50) begin
            if (blkpos_y > 11'd400) begin
                address_hammer_up = (draw_y - (blkpos_y - 11'd51))*11'd80 + (draw_x - blkpos_x +11'd1);
                blk_r = mem_hammer_up[11:8]; 
                blk_g = mem_hammer_up[7:4];
                blk_b = mem_hammer_up[3:0];
            end
            else begin
                address_hammer_up1 = (draw_y - (blkpos_y - 11'd51))*11'd80 + (draw_x - blkpos_x +11'd1);
                blk_r = mem_hammer_up1[11:8]; 
                blk_g = mem_hammer_up1[7:4];
                blk_b = mem_hammer_up1[3:0];
            end
        end

        // draw hammer on whacking state
        else if (center && draw_x > blkpos_x && draw_x <= blkpos_x + 11'd100 && draw_y > blkpos_y - 11'd40 && draw_y <= blkpos_y + 11'd40) begin
            if (blkpos_y > 11'd400) begin
                address_hammer_down = (draw_y - (blkpos_y - 11'd41))*11'd100 + (draw_x - blkpos_x +11'd1);
                blk_r = mem_hammer_down[11:8]; 
                blk_g = mem_hammer_down[7:4];
                blk_b = mem_hammer_down[3:0];
            end
            else begin
                address_hammer_down1 = (draw_y - (blkpos_y - 11'd41))*11'd100 + (draw_x - blkpos_x +11'd1);
                blk_r = mem_hammer_down1[11:8]; 
                blk_g = mem_hammer_down1[7:4];
                blk_b = mem_hammer_down1[3:0];
            end
        end 
        else begin
            blk_r = 4'b0000;  // when zero, then background color is used. 
            blk_g = 4'b0000;
            blk_b = 4'b0000;
        end
         
    end
    
endmodule
