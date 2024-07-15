`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.03.2024 16:46:36
// Design Name: 
// Module Name: register_16bit
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


module Register(FunSel,I,E,Q,Clock);
    input wire [2:0] FunSel;
    input wire [15:0] I;
    input wire E;
    input wire Clock;
    output reg [15:0] Q;
    
    
always @(posedge Clock)
begin
    if(E)begin
        case(FunSel)
            3'b000:Q<=Q-1;
            3'b001:Q<=Q+1;
            3'b010:Q<=I;
            3'b011:Q<=16'd0;
            3'b100:Q<={16'b0,I[7:0]};
            3'b101:Q[7:0]<=I[7:0];
            3'b110:Q[15:8]<=I[7:0];
            3'b111:begin
            Q[15:8]<={8{I[7]}};
            Q[7:0]<=I[7:0];
            end
         endcase
    end
            
     
end

endmodule
