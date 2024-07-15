`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.03.2024 22:06:27
// Design Name: 
// Module Name: part3a
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


module ArithmeticLogicUnit(A,B,FunSel,WF,Clock,FlagsOut,ALUOut);
input wire[15:0] A;
input wire[15:0] B;
input wire[4:0] FunSel;
input wire WF;
input wire Clock;
output reg[3:0] FlagsOut;
output reg[15:0] ALUOut;
reg Z=0;
reg C=0;
reg O=0;
reg N=0;
reg tmp=0;
always @(posedge Clock)begin

	if(WF)begin
		FlagsOut={Z,C,N,O};
	end 
end
always @(*) begin
    Z=FlagsOut[3];
    C=FlagsOut[2];
    N=FlagsOut[1];
    O=FlagsOut[0];
    case(FunSel)
        
        // 5'b0xxxx: 8-bit
        // 5'b1xxxx: 16-bit

        5'b00000: // ALUOut: A
            begin 
                ALUOut <= {8'b0, A[7:0]};
                
                if (ALUOut[7] == 1) begin
                    N = 1;
                end else begin
                    N = 0;
                end
            end

        5'b00001: // ALUOut: B
            begin
                ALUOut <= {8'b0, B[7:0]};

                if (ALUOut[7] == 1) begin
                    N = 1;
                end else begin
                    N = 0;
                end             
            end

        5'b00010: // ALUOut: NOT A 
            begin
                ALUOut <= {8'b0, ~A[7:0]};

                if (ALUOut[7] == 1) begin
                    N = 1;
                end else begin
                    N = 0;
                end                
            end

        5'b00011: // ALUOut: NOT B
            begin
                ALUOut <= {8'b0, ~B[7:0]};

                if (ALUOut[7] == 1) begin
                    N = 1;
                end else begin
                    N = 0;
                end              
            end

        5'b00100: // ALUOut: A + B
            begin
                O = 0;
                {C, ALUOut[7:0]} <= {1'b0, A[7:0]} + {1'b0, B[7:0]};
                ALUOut[15:8]<=8'b0;
                if ((A[7] == B[7]) && (B[7] != ALUOut[7])) begin
                    O = 1;   
                end          
                if (ALUOut[7] == 1) begin
                    N = 1;
                end else begin
                    N = 0;
                end              
            end         
        
        5'b00101: // ALUOut: A + B + Carry
            begin
                O = 0;
                {C, ALUOut[7:0]} <= {1'b0, A[7:0]} + {1'b0, B[7:0]} + {8'b0, FlagsOut[2]};
                ALUOut[15:8]<=8'b0;
                if ((A[7] == B[7]) && (B[7] != ALUOut[7])) begin
                    O=1;   
                end
                if (ALUOut[7] == 1) begin
                    N = 1;
                end else begin
                    N = 0;
                end
            end 

        5'b00110: // ALUOut: A - B
            begin
                O = 0;
                {tmp, ALUOut[7:0]} = {1'b0, A[7:0]} + {1'b0 , (~B[7:0] + 8'd1)};
                C=~tmp;
                ALUOut[15:8]=8'b0;
                if ((A[7] != B[7]) && (B[7] == ALUOut[7])) begin    
                    O = 1;   
                end    
                  
                if (ALUOut[7] == 1) begin
                    N = 1;
                end else begin
                    N = 0;
                end              
            end        
        
        5'b00111: // ALUOut: A AND B
            begin
                ALUOut[7:0] <= A[7:0] & B[7:0];
                ALUOut[15:8]<=8'b0;
                if (ALUOut[7] == 1) begin
                    N = 1;
                end else begin
                    N = 0;
                end               
            end

        5'b01000: // ALUOut: A OR B
            begin
                ALUOut[7:0] <= A[7:0] | B[7:0];
                ALUOut[15:8]<=8'b0;
                if (ALUOut[7] == 1) begin
                   N = 1;
                end else begin
                   N = 0;
                end               
            end  

        5'b01001: // ALUOut: A XOR B
            begin
                ALUOut[7:0] <= A[7:0] ^ B[7:0];
                ALUOut[15:8]<=8'b0;
                if (ALUOut[7] == 1) begin
                    N = 1;
                end else begin
                    N = 0;
                end               
            end

        5'b01010: // ALUOut: A NAND B
            begin
                ALUOut[7:0] <= ~(A[7:0] & B[7:0]);
                ALUOut[15:8]<=8'b0;
                if (ALUOut[7] == 1) begin
                    N = 1;
                end else begin
                    N = 0;
                end               
            end 

        5'b01011: // ALUOut: LSL A
            begin
                {C, ALUOut[7:0]} <= {1'b0, A[7:0]} << 1;
                ALUOut[15:8]<=8'b0;
                if (ALUOut[7] == 1) begin
                     N = 1;
                end else begin
                     N = 0;
                end  
            end

        5'b01100: // ALUOut: LSR A
            begin
                {ALUOut[7:0], C} <= {A[7:0], 1'b0} >> 1;
                ALUOut[15:8]<=8'b0;
                if (ALUOut[7] == 1) begin
                     N = 1;
                end else begin
                     N = 0;
                end  
            end 

        5'b01101: // ALUOut: ASR A
            begin
                {ALUOut[7:0], C} = {A[7:0], 1'b0} >> 1;
                ALUOut[7] = ALUOut[6];
                ALUOut[15:8]<=8'b0;
            end

        5'b01110: // ALUOut: CSL A
            begin
                ALUOut[7:0] = {A[6:0], FlagsOut[2]};
                C = A[7];
                ALUOut[15:8]<=8'b0;
                if (ALUOut[7] == 1) begin
                    N = 1;
                end else begin
                    N = 0;
                end  
            end   

        5'b01111: // ALUOut: CSR A
            begin
                ALUOut = {FlagsOut[2], A[7:1]};
                C = A[0];
                ALUOut[15:8]<=8'b0;
                if (ALUOut[7] == 1) begin
                    N = 1;
                end else begin
                    N = 0;
                end  
            end

        //--------------------------

        5'b10000: // ALUOut: A
            begin
                ALUOut <= {A[15:0]};
            
                if (ALUOut[15] == 1) begin
                    N = 1;
                end else begin
                    N = 0;
                end    
            end

        5'b10001: // ALUOut: B
            begin
                ALUOut <= {B[15:0]};
                          
                if (ALUOut[15] == 1) begin
                    N = 1;
                 end else begin
                    N = 0;
                end             
            end

        5'b10010: // ALUOut: NOT A
            begin
                ALUOut <= {~A[15:0]};
                         
                if (ALUOut[15] == 1) begin
                    N = 1;
                end else begin
                    N = 0;
                end                   
            end

        5'b10011: // ALUOut: NOT B
            begin
                ALUOut <= { ~B[15:0]};
                         
                if (ALUOut[15] == 1) begin
                    N = 1;
                end else begin
                    N = 0;
                end              
            end

        5'b10100: // ALUOut: A + B
            begin
                O = 0;
                {C, ALUOut} <= {1'b0, A[15:0]} + {1'b0, B[15:0]};

                if ((A[15] == B[15]) && (B[15] != ALUOut[15])) begin
                    O = 1;   
                end          
                if (ALUOut[15] == 1) begin
                    N = 1;
                end else begin
                    N = 0;
                end              
            end         
        
        5'b10101: // ALUOut: A + B + Carry
            begin
                O = 0;
                {C, ALUOut[15:0]} <= {1'b0, A[15:0]} + {1'b0, B[15:0]} + {16'b0, FlagsOut[2]};
                
                if ((A[15] == B[15]) && (B[15] != ALUOut[15])) begin
                    O = 1;   
                end          
                if (ALUOut[15] == 1) begin
                    N = 1;
                end else begin
                    N = 0;
                end              
            end  

        5'b10110: // ALUOut: A - B
            begin
                O = 0;
                {tmp, ALUOut[15:0]} = {1'b0, A[15:0]} + {1'b0 , (~B[15:0] + 16'd1)};
                C = ~tmp;
                if ((A[15] != B[15]) && (B[15] == ALUOut[15])) begin
                    O = 1;   
                end  
                        
                if (ALUOut[15] == 1) begin
                    N = 1;
                end else begin
                    N = 0;
                end              
            end        
        
        5'b10111: // ALUOut: A AND B
            begin
                ALUOut[15:0] <= A[15:0] & B[15:0];
                         
                if (ALUOut[15] == 1) begin
                    N = 1;
                end else begin
                    N = 0;
                end               
            end

        5'b11000: // ALUOut: A OR B
            begin
                ALUOut[15:0] <= A[15:0] | B[15:0];
                          
                if (ALUOut[15] == 1) begin
                    N = 1;
                end else begin
                    N = 0;
                end               
            end   

        5'b11001: // ALUOut: A XOR B
            begin
                ALUOut[15:0] <= A[15:0] ^ B[15:0];
                         
                if (ALUOut[15] == 1) begin
                    N = 1;
                end else begin
                    N = 0;
                end               
            end

        5'b11010: // ALUOut: A NAND B
            begin
                ALUOut[15:0] <= ~(A[15:0] & B[15:0]);
                          
                if (ALUOut[15] == 1) begin
                    N = 1;
                end else begin
                    N = 0;
                end               
            end 

        5'b11011: // ALUOut: LSL A
            begin
                {C, ALUOut[15:0]} <= {1'b0, A[15:0]} << 1;

                if (ALUOut[15] == 1) begin
                    N = 1;
                end else begin
                    N = 0;
                end  
            end

        5'b11100: // ALUOut: LSR A
            begin
                {ALUOut[15:0], C} <= {A[15:0], 1'b0} >> 1;

                if (ALUOut[15] == 1) begin
                    N = 1;
                end else begin
                    N = 0;
                end  
            end 

        5'b11101: // ALUOut: ASR A
            begin
                {ALUOut[15:0], C} = {A[15:0], 1'b0} >> 1;
                ALUOut[15] = ALUOut[14];
            end

        5'b11110: // ALUOut: CSL A
            begin
                ALUOut[15:0] = {A[14:0], FlagsOut[2]};
                C = A[15];

                if (ALUOut[15] == 1) begin
                    N = 1;
                end else begin
                    N = 0;
                end  
            end 

        5'b11111: // ALUOut: CSR A
            begin
                ALUOut = {FlagsOut[2], A[15:1]};
                C = A[0];

                if (ALUOut[15] == 1) begin
                    N = 1;
                end else begin
                    N = 0;
                end  
            end
                                                
    endcase
	if (ALUOut == 16'b0) begin
            Z = 1'b1; 
        end else begin
            Z = 1'b0; 
        end 
        
	  
	
end

endmodule