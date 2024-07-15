`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.03.2024 20:25:25
// Design Name: 
// Module Name: part2C
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


module AddressRegisterFile (
    input wire[15:0] I,
    input wire[2:0] FunSel,
    input wire[2:0] RegSel,
    input wire[1:0] OutCSel,
    input wire[1:0] OutDSel,
    input wire Clock,
    output reg[15:0] OutC,
    output reg[15:0] OutD
    );
    wire [15:0] OPC,OAR,OSP;
    Register PC (.FunSel(FunSel),.E(!RegSel[2]),.Clock(Clock),.I(I),.Q(OPC));
    Register AR (.FunSel(FunSel),.E(!RegSel[1]),.Clock(Clock),.I(I),.Q(OAR));
    Register SP (.FunSel(FunSel),.E(!RegSel[0]),.Clock(Clock),.I(I),.Q(OSP));
always @(*) begin
    case(OutCSel)
        2'b00:OutC<=OPC;
        2'b01:OutC<=OPC;
        2'b10:OutC<=OAR;
        2'b11:OutC<=OSP;
    endcase
    case(OutDSel)
            2'b00:OutD<=OPC;
            2'b01:OutD<=OPC;
            2'b10:OutD<=OAR;
            2'b11:OutD<=OSP;
        endcase
end
endmodule
