`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.03.2024 13:43:32
// Design Name: 
// Module Name: part4
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


module Mux2(D,MuxSel,MuxOut,Clock);
input wire[15:0] D;
input wire MuxSel;
input wire Clock;
output reg[7:0] MuxOut;
always @(*) begin
    case(MuxSel) 
        1'b0:MuxOut<=D[7:0];
        1'b1:MuxOut<=D[15:8];       
    endcase 
end

endmodule
module MUX( D0,D1,D2,D3,MuxSel,MuxOut,Clock);
input wire [15:0] D0;
input wire [15:0] D1;
input wire [7:0] D2;
input wire [15:0] D3;
input wire Clock;
input wire[1:0] MuxSel;
output reg[15:0] MuxOut;
always @(*) begin
    case(MuxSel) 
        2'b00:MuxOut<=D0;
        2'b01:MuxOut<=D1;
        2'b10:MuxOut<={8'b0,D2};
        2'b11:MuxOut<={8'b0,D3[7:0]};
    endcase
end
endmodule
module ArithmeticLogicUnitSystem(Clock,RF_OutASel,RF_OutBSel,RF_FunSel,RF_RegSel,RF_ScrSel,ALU_FunSel,ALU_WF,MuxASel,MuxCSel,MuxBSel,ARF_OutCSel,ARF_OutDSel,ARF_FunSel,ARF_RegSel,IR_LH,IR_Write,Mem_WR,Mem_CS );
input wire Clock;
input wire [2:0] RF_OutASel;
input wire [2:0] RF_OutBSel;
input wire [2:0] RF_FunSel;
input wire [3:0] RF_RegSel;
input wire [3:0] RF_ScrSel;
input wire [4:0] ALU_FunSel;
input wire ALU_WF;
input wire MuxCSel;
input wire [1:0] MuxASel;
input wire [1:0] MuxBSel;
input wire[1:0] ARF_OutCSel;
input wire[1:0] ARF_OutDSel;
input wire[2:0] ARF_FunSel;
input wire[2:0] ARF_RegSel;
input wire IR_LH;
input wire IR_Write;
input wire Mem_CS;
input wire Mem_WR;
wire [15:0]MuxAOut;
wire [15:0] OutA;
wire [15:0] OutB;
wire [3:0]Flags;
wire [15:0] ALUOut;
wire [15:0] OutC;
wire [15:0] Address;
wire [15:0] MuxBOut;
wire [7:0] MuxCOut;
wire [7:0] MemOut;
wire [15:0] IROut;
RegisterFile RF(.I(MuxAOut),.OutASel(RF_OutASel),.OutBSel(RF_OutBSel),.FunSel(RF_FunSel),.RegSel(RF_RegSel),.ScrSel(RF_ScrSel),.Clock(Clock),.OutA(OutA),.OutB(OutB));
ArithmeticLogicUnit ALU(.A(OutA),.B(OutB),.FunSel(ALU_FunSel),.WF(ALU_WF),.Clock(Clock),.FlagsOut(Flags),.ALUOut(ALUOut));
Mux2 MUXC (.D(ALUOut),.MuxSel(MuxCSel),.Clock(Clock),.MuxOut(MuxCOut));
Memory MEM(.Address(Address),.Data(MuxCOut),.WR(Mem_WR),.CS(Mem_CS),.Clock(Clock),.MemOut(MemOut));
AddressRegisterFile ARF(.I(MuxBOut),.FunSel(ARF_FunSel),.RegSel(ARF_RegSel),.OutCSel(ARF_OutCSel),.OutDSel(ARF_OutDSel),.Clock(Clock),.OutC(OutC),.OutD(Address));
MUX MuxB(.D0(ALUOut),.D1(OutC),.D2(MemOut),.D3(IROut),.MuxSel(MuxBSel),.Clock(Clock),.MuxOut(MuxBOut));
InstructionRegister IR(.I(MemOut),.LH(IR_LH),.Write(IR_Write),.Clock(Clock),.IROut(IROut));
MUX MuxA(.D0(ALUOut),.D1(OutC),.D2(MemOut),.D3(IROut),.MuxOut(MuxAOut),.MuxSel(MuxASel),.Clock(Clock));
endmodule
