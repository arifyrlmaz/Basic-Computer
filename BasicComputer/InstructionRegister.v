`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.03.2024 14:40:30
// Design Name: 
// Module Name: part2A
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


module InstructionRegister (I,LH,Write,Clock,IROut);
    input wire [7:0] I;
    input wire LH;
    input wire Write;
    input wire Clock;
    output reg [15:0] IROut;
    always @(posedge Clock) begin 
        if(Write) begin
            case(LH)
                1'b0:IROut[7:0]<=I;
                1'b1:IROut[15:8]<=I;
            endcase
        end
    end

endmodule

