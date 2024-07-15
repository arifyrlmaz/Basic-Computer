`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.03.2024 15:27:12
// Design Name: 
// Module Name: part2B
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


module RegisterFile (
    input wire [15:0] I,
    input wire [2:0] OutASel,
    input wire [2:0] OutBSel,
    input wire[2:0] FunSel,
    input wire [3:0] RegSel,
    input wire[3:0] ScrSel,
    input wire Clock,
    output reg[15:0] OutA,
    output reg[15:0] OutB
    );
    wire[15:0] OR1,OR2,OR3,OR4,OS1,OS2,OS3,OS4;
    Register R1 (.FunSel(FunSel),.Clock(Clock),.E(!RegSel[3]),.I(I),.Q(OR1));
    Register R2 (.FunSel(FunSel),.I(I),.E(!RegSel[2]),.Clock(Clock),.Q(OR2));
    Register R3 (.FunSel(FunSel),.I(I),.E(!RegSel[1]),.Clock(Clock),.Q(OR3));
    Register R4 (.FunSel(FunSel),.I(I),.E(!RegSel[0]),.Clock(Clock),.Q(OR4));
    Register S1 (.FunSel(FunSel),.I(I),.E(!ScrSel[3]),.Clock(Clock),.Q(OS1));
    Register S2 (.FunSel(FunSel),.I(I),.E(!ScrSel[2]),.Clock(Clock),.Q(OS2));
    Register S3 (.FunSel(FunSel),.I(I),.E(!ScrSel[1]),.Clock(Clock),.Q(OS3));
    Register S4 (.FunSel(FunSel),.I(I),.E(!ScrSel[0]),.Clock(Clock),.Q(OS4));
    
    
    
always @(*)
begin
    case(OutASel)
        3'b000:OutA<=OR1;
        3'b001:OutA<=OR2;
        3'b010:OutA<=OR3;
        3'b011:OutA<=OR4;
        3'b100:OutA<=OS1;
        3'b101:OutA<=OS2;
        3'b110:OutA<=OS3;
        3'b111:OutA<=OS4;
        
    endcase
    case(OutBSel)
            3'b000:OutB<=OR1;
            3'b001:OutB<=OR2;
            3'b010:OutB<=OR3;
            3'b011:OutB<=OR4;
            3'b100:OutB<=OS1;
            3'b101:OutB<=OS2;
            3'b110:OutB<=OS3;
            3'b111:OutB<=OS4;
            
        endcase

end
endmodule
