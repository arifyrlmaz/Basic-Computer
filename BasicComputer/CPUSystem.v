
module CPUSystem (Clock,Reset,T);
    input wire Clock;
    input wire Reset;
    output reg [7:0] T;
    reg [2:0] RF_OutASel;
    reg [2:0] RF_OutBSel;
    reg [2:0] RF_FunSel;
    reg [3:0] RF_RegSel;
    reg [3:0] RF_ScrSel;
    reg [4:0] ALU_FunSel;
    reg ALU_WF;
    reg MuxCSel;
    reg [1:0] MuxASel;
    reg [1:0] MuxBSel;
    reg[1:0] ARF_OutCSel;
    reg[1:0] ARF_OutDSel;
    reg[2:0] ARF_FunSel;
    reg[2:0] ARF_RegSel;
    reg IR_LH;
    reg IR_Write;
    reg Mem_CS;
    reg Mem_WR;
    reg SCReset;
    wire [2:0] out;
    reg [5:0] OPCODE;
        reg [1:0] RSEL;
        reg [7:0] Address;
        reg S;
        reg [2:0] DSTREG, SREG1, SREG2;
    ArithmeticLogicUnitSystem _ALUSystem(Clock,RF_OutASel,RF_OutBSel,RF_FunSel,RF_RegSel,RF_ScrSel,ALU_FunSel,ALU_WF,MuxASel,MuxCSel,MuxBSel,ARF_OutCSel,ARF_OutDSel,ARF_FunSel,ARF_RegSel,IR_LH,IR_Write,Mem_WR,Mem_CS );

    initial begin
        _ALUSystem.RF.R1.Q = 0;
        _ALUSystem.RF.R2.Q = 0;
        _ALUSystem.RF.R3.Q = 0;
        _ALUSystem.RF.R4.Q = 0;
        _ALUSystem.RF.S1.Q = 0;
        _ALUSystem.RF.S2.Q = 0;
        _ALUSystem.RF.S3.Q = 0;
        _ALUSystem.RF.S4.Q = 0;
        _ALUSystem.ARF.PC.Q = 0;
        _ALUSystem.ARF.AR.Q = 0;
        _ALUSystem.ARF.SP.Q = 0;
        
        IR_Write = 1'b0;
        Mem_CS = 1'b0;
        Mem_WR = 1'b0;
        ALU_WF = 1'b0;
    end
    
    always@(*) begin
        if(!Reset) begin 
            ARF_RegSel = 3'b000;
            RF_RegSel = 4'b0000;
            RF_ScrSel = 4'b0000;
            ARF_FunSel = 3'b011;
            RF_FunSel = 3'b011;
            IR_Write = 1'b0;
            Mem_CS = 1'b0;
            Mem_WR = 1'b0;
            ALU_WF = 1'b0;
            T=8'd1;
        end
    end
    always @(posedge Clock) begin
            if (SCReset) begin
                
                RF_RegSel = 4'b1111;
                RF_ScrSel = 4'b1111;
                ARF_RegSel = 3'b111;
                ALU_WF = 1'b0;
                Mem_CS = 1'b1;
                T = 8'd1;
                SCReset = 1'b0;
            end
            else begin
                if (!T[7]) T = T << 1;
                else if (T[7]) T = 1;
            end
        end
    
    
    always@(*) begin
        if(T[0] ) begin
        ALU_WF=1'b0;
            Mem_CS=1'b0;
            ARF_OutDSel=2'b00;
            Mem_WR=1'b0;
            IR_Write=1'b1;
            IR_LH=1'b0;
            ARF_FunSel=3'b001;
            ARF_RegSel=3'b011;
            RF_RegSel=4'b1111;
            RF_ScrSel=4'b1111;
            
            SCReset=1'b0;
        end
    end
    always@(*)begin
        if(T[1] )begin
            ARF_OutDSel=2'b00;
            Mem_WR=1'b0;
            IR_Write=1'b1;
            IR_LH=1'b1;
            ARF_FunSel=3'b001;
            ARF_RegSel=3'b011;
            
        end 
    end
    always@(*) begin
        if(T[2]||T[3]||T[4]||T[5]||T[6]||T[7])begin
        if(T[2]) begin 
        IR_Write=1'b0;
        end
        case(_ALUSystem.IROut[15:10]) 
            6'b000000: begin
            if(T[2]) begin
                ARF_RegSel=3'b111;
                ARF_OutCSel=2'b00;
                MuxASel=2'b01;
                RF_FunSel=3'b010;
                RF_ScrSel=4'b0111;
            end
            if(T[3]) begin
                MuxASel=2'b11;
                RF_FunSel=3'b010;
                RF_ScrSel=4'b1011;
            end 
            if(T[4])begin
                ALU_FunSel=5'b10100;
                RF_OutBSel=3'b101;
                RF_OutASel=3'b100;
                MuxBSel=2'b00;
                ARF_FunSel=3'b010;
                ARF_RegSel=3'b011;
                RF_ScrSel=4'b1111;
                SCReset=1'b1;
            end
        end
        6'b000001: begin
            if(T[2]) begin
                ARF_OutCSel=2'b00;
                MuxASel=2'b01;
                RF_FunSel=3'b010;
                RF_ScrSel=4'b0111;
                ARF_RegSel=3'b111;
            end
            if(T[3]) begin
                
                MuxASel=2'b11;
                RF_FunSel=3'b010;
                RF_ScrSel=4'b1011;
            end 
            if(T[4])begin
                ALU_FunSel=5'b10100;
                RF_OutBSel=3'b101;
                RF_OutASel=3'b100;
                RF_ScrSel=4'b1111;
                if(!_ALUSystem.Flags[0])begin
                MuxBSel=2'b00;
                ARF_FunSel=3'b010;
                ARF_RegSel=3'b011;
                end
                SCReset=1'b1;
            end
        end
        6'b000010: begin
        if(T[2]) begin
            ARF_OutCSel=2'b00;
            MuxASel=2'b01;
            RF_FunSel=3'b010;
            RF_ScrSel=4'b0111;
            ARF_RegSel=3'b111;
        end
        if(T[3]) begin
            
            MuxASel=2'b11;
            RF_FunSel=3'b010;
            RF_ScrSel=4'b1011;
        end 
        if(T[4])begin
            RF_OutBSel=3'b101;
            RF_OutASel=3'b100;
            ALU_FunSel=5'b10100;
            RF_ScrSel=4'b1111;
            if(_ALUSystem.Flags[0])begin
            MuxBSel=2'b00;
            ARF_FunSel=3'b010;
            ARF_RegSel=3'b011;
            end
            SCReset=1'b1;
        end         
        end   
        6'b000011: begin
            if(T[2]) begin
                ARF_RegSel=3'b110;
                ARF_FunSel=3'b001;
            end
            if(T[3]) begin
                ARF_OutDSel=2'b11;
                Mem_WR=0;
                MuxASel=2'b10;
                if(_ALUSystem.IROut[9:8]==2'b00) RF_RegSel=4'b0111;
                if(_ALUSystem.IROut[9:8]==2'b01) RF_RegSel=4'b1011;
                if(_ALUSystem.IROut[9:8]==2'b10) RF_RegSel=4'b1101;
                if(_ALUSystem.IROut[9:8]==2'b11) RF_RegSel=4'b1110;
                RF_FunSel=3'b101;
                ARF_FunSel=3'b001;
                ARF_RegSel=3'b110;
                
            end
            if(T[4]) begin
                RF_FunSel=3'b110;
                ARF_RegSel=3'b111;
                SCReset=1'b1;
            end
        end
        6'b000100:begin
            if(T[2]) begin
                ARF_RegSel=3'b110;
                ARF_FunSel=3'b000;
                if(_ALUSystem.IROut[9:8]==2'b00)  RF_OutASel=3'b000;
                if(_ALUSystem.IROut[9:8]==2'b01) RF_OutASel=3'b001;
                if(_ALUSystem.IROut[9:8]==2'b10) RF_OutASel=3'b010;
                if(_ALUSystem.IROut[9:8]==2'b11) RF_OutASel=3'b011;  
                ALU_FunSel=5'b10000;
                MuxCSel=1'b0;
                Mem_WR=1'b1;
                ARF_OutDSel=2'b11;
                
                
             end
             if(T[3])begin
                MuxCSel=1'b1;
                SCReset=1'b1;
                              
             end
        end
        6'b000101:begin
        
            if(T[2]) begin
            ALU_WF=_ALUSystem.IROut[9];
                if(_ALUSystem.IROut[5])begin
                    if(_ALUSystem.IROut[8])begin
                        RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                        ALU_FunSel=5'b10000;
                        MuxASel=2'b00;
                        RF_FunSel=3'b010;
                        ARF_RegSel=3'b111;
                        if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                        if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                        if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                        if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                    end
                    if(!_ALUSystem.IROut[8])begin
                        RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                        ALU_FunSel=5'b10000;
                        MuxBSel=2'b00;      
                        if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                        if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                        if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                        if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                        ARF_FunSel=3'b010;          
                    end
                end
                if(!_ALUSystem.IROut[5])begin
                    if(_ALUSystem.IROut[8])begin
                        if(_ALUSystem.IROut[4:3]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[4:3]==2'b11) ARF_OutCSel=2'b10;
                        MuxASel=2'b01;
                        RF_FunSel=3'b010;
                        if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                        if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                        if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                        if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                        ARF_RegSel=3'b111;
                    end
                    if(!_ALUSystem.IROut[8])begin
                        
                        if(_ALUSystem.IROut[4:3]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[4:3]==2'b11) ARF_OutCSel=2'b10;
                        MuxBSel=2'b01;
                        ARF_FunSel=3'b010;
                        if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                        if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                        if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                        if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                    end
                end
            end
            if(T[3]) begin
                    if(_ALUSystem.IROut[8])begin
                        if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                        if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                        if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                        if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                        RF_FunSel=3'b001;
                    end
                    if(!_ALUSystem.IROut[8])begin
                        if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                        if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                        if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                        if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                        ARF_FunSel=3'b001;     
                    end
                    SCReset=1'b1;
            end
        end
        6'b000110: begin
        
            if(T[2]) begin
            ALU_WF=_ALUSystem.IROut[9];
            if(_ALUSystem.IROut[5])begin
                if(_ALUSystem.IROut[8])begin
                    RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                    ALU_FunSel=5'b10000;
                    MuxASel=2'b00;
                    ARF_RegSel=3'b111;
                    RF_FunSel=3'b010;
                    if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                    if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                    if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                    if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                end
                if(!_ALUSystem.IROut[8])begin
                    RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                    ALU_FunSel=5'b10000;
                    MuxBSel=2'b00;      
                    if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                    if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                    ARF_FunSel=3'b010;          
                end
            end
            if(!_ALUSystem.IROut[5])begin
                if(_ALUSystem.IROut[8])begin
                                            
                    if(_ALUSystem.IROut[4:3]==2'b00) ARF_OutCSel=2'b00;
                    if(_ALUSystem.IROut[4:3]==2'b01) ARF_OutCSel=2'b00;
                    if(_ALUSystem.IROut[4:3]==2'b10) ARF_OutCSel=2'b11;
                    if(_ALUSystem.IROut[4:3]==2'b11) ARF_OutCSel=2'b10;
                    MuxASel=2'b01;
                    RF_FunSel=3'b010;
                    if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                    if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                    if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                    if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                    ARF_RegSel=3'b111;
                end
                if(!_ALUSystem.IROut[8])begin
                                            
                    if(_ALUSystem.IROut[4:3]==2'b00) ARF_OutCSel=2'b00;
                    if(_ALUSystem.IROut[4:3]==2'b01) ARF_OutCSel=2'b00;
                    if(_ALUSystem.IROut[4:3]==2'b10) ARF_OutCSel=2'b11;
                    if(_ALUSystem.IROut[4:3]==2'b11) ARF_OutCSel=2'b10;
                    MuxBSel=2'b01;
                    ARF_FunSel=3'b010;
                    if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                    if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                end
            end
        end
        if(T[3]) begin
                if(_ALUSystem.IROut[8])begin
                    if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                    if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                    if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                    if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                    RF_FunSel=3'b000;
                end
                if(!_ALUSystem.IROut[8])begin
                    if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                    if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                    ARF_FunSel=3'b000;     
                end
                SCReset=1'b1;
        end 

        end
        6'b000111: begin
        
            if(T[2]) begin
            ALU_WF=_ALUSystem.IROut[9];
        if(_ALUSystem.IROut[5])begin
            if(_ALUSystem.IROut[8])begin
                RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                ALU_FunSel=5'b11011;
                MuxASel=2'b00;
                RF_FunSel=3'b010;
                if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                ARF_RegSel=3'b111;
                if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
            end
            if(!_ALUSystem.IROut[8])begin
                RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                ALU_FunSel=5'b11011;
                MuxBSel=2'b00;      
                if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                ARF_FunSel=3'b010;          
            end
            SCReset=1'b1;
        end
        if(!_ALUSystem.IROut[5])begin
            if(_ALUSystem.IROut[8])begin
                        
                if(_ALUSystem.IROut[4:3]==2'b00) ARF_OutCSel=2'b00;
                if(_ALUSystem.IROut[4:3]==2'b01) ARF_OutCSel=2'b00;
                if(_ALUSystem.IROut[4:3]==2'b10) ARF_OutCSel=2'b11;
                if(_ALUSystem.IROut[4:3]==2'b11) ARF_OutCSel=2'b10;
                MuxASel=2'b01;
                RF_FunSel=3'b010;
                if(_ALUSystem.IROut[7:6]==2'b00) RF_ScrSel=4'b0111;
                if(_ALUSystem.IROut[7:6]==2'b01) RF_ScrSel=4'b1011;
                if(_ALUSystem.IROut[7:6]==2'b10) RF_ScrSel=4'b1101;
                if(_ALUSystem.IROut[7:6]==2'b11) RF_ScrSel=4'b1110;
                ARF_RegSel=3'b111;
            end
            if(!_ALUSystem.IROut[8])begin
                        
                if(_ALUSystem.IROut[4:3]==2'b00) ARF_OutCSel=2'b00;
                if(_ALUSystem.IROut[4:3]==2'b01) ARF_OutCSel=2'b00;
                if(_ALUSystem.IROut[4:3]==2'b10) ARF_OutCSel=2'b11;
                if(_ALUSystem.IROut[4:3]==2'b11) ARF_OutCSel=2'b10;
                MuxASel=2'b01;
                RF_FunSel=3'b010;
                if(_ALUSystem.IROut[7:6]==2'b00) RF_ScrSel=4'b0111;
                if(_ALUSystem.IROut[7:6]==2'b01) RF_ScrSel=4'b1011;
                if(_ALUSystem.IROut[7:6]==2'b10) RF_ScrSel=4'b1101;
                if(_ALUSystem.IROut[7:6]==2'b11) RF_ScrSel=4'b1110;
                ARF_RegSel=3'b111;
            end
        end
    end  
    if(T[3]&&!_ALUSystem.IROut[5])begin 
    RF_ScrSel=4'b1111;
            if(_ALUSystem.IROut[8])begin
                RF_OutASel={1'b1,_ALUSystem.IROut[7:6]};
                ALU_FunSel=5'b11011;
                MuxASel=2'b00;
                RF_FunSel=3'b010;
                if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
            end
            if(!_ALUSystem.IROut[8])begin
                RF_OutASel={1'b1,_ALUSystem.IROut[7:6]};
                ALU_FunSel=5'b11011;
                MuxBSel=2'b00;      
                if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                ARF_FunSel=3'b010;          
            end        
            SCReset=1'b1;
    end          
        end
        6'b001000: begin
        
            if(T[2]) begin
            ALU_WF=_ALUSystem.IROut[9];
                if(_ALUSystem.IROut[5])begin
                    if(_ALUSystem.IROut[8])begin
                        RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                        ALU_FunSel=5'b11100;
                        MuxASel=2'b00;
                        RF_FunSel=3'b010;
                        if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                        if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                        if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                        if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                        ARF_RegSel=3'b111;
                    end
                    if(!_ALUSystem.IROut[8])begin
                        RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                        ALU_FunSel=5'b11100;
                        MuxBSel=2'b00;      
                        if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                        if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                        if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                        if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                        ARF_FunSel=3'b010;          
                    end
                    SCReset=1'b1;
                 end
                if(!_ALUSystem.IROut[5])begin
                    if(_ALUSystem.IROut[8])begin
                        if(_ALUSystem.IROut[4:3]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[4:3]==2'b11) ARF_OutCSel=2'b10;
                        MuxASel=2'b01;
                        RF_FunSel=3'b010;
                        if(_ALUSystem.IROut[7:6]==2'b00) RF_ScrSel=4'b0111;
                        if(_ALUSystem.IROut[7:6]==2'b01) RF_ScrSel=4'b1011;
                        if(_ALUSystem.IROut[7:6]==2'b10) RF_ScrSel=4'b1101;
                        if(_ALUSystem.IROut[7:6]==2'b11) RF_ScrSel=4'b1110;
                        ARF_RegSel=3'b111;
                    end
                    if(!_ALUSystem.IROut[8])begin     
                        if(_ALUSystem.IROut[4:3]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[4:3]==2'b11) ARF_OutCSel=2'b10;
                        MuxASel=2'b01;
                        RF_FunSel=3'b010;
                        if(_ALUSystem.IROut[7:6]==2'b00) RF_ScrSel=4'b0111;
                        if(_ALUSystem.IROut[7:6]==2'b01) RF_ScrSel=4'b1011;
                        if(_ALUSystem.IROut[7:6]==2'b10) RF_ScrSel=4'b1101;
                        if(_ALUSystem.IROut[7:6]==2'b11) RF_ScrSel=4'b1110;
                        ARF_RegSel=3'b111;
                    end
                end
            end  
            if(T[3]&&!_ALUSystem.IROut[5])begin 
                RF_ScrSel=4'b1111;
                if(_ALUSystem.IROut[8])begin
                    RF_OutASel={1'b1,_ALUSystem.IROut[7:6]};
                    ALU_FunSel=5'b11100;
                    MuxASel=2'b00;
                    RF_FunSel=3'b010;
                    if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                    if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                    if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                    if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                end
                if(!_ALUSystem.IROut[8])begin
                    RF_OutASel={1'b1,_ALUSystem.IROut[7:6]};
                    ALU_FunSel=5'b11100;
                    MuxBSel=2'b00;      
                    if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                    if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                    ARF_FunSel=3'b010;          
                end     
                SCReset=1'b1;   
            end          
        end
        6'b001001: begin
        
            if(T[2]) begin
            ALU_WF=_ALUSystem.IROut[9];
                if(_ALUSystem.IROut[5])begin
                    if(_ALUSystem.IROut[8])begin
                        RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                        ALU_FunSel=5'b11101;
                        MuxASel=2'b00;
                        RF_FunSel=3'b010;
                        if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                        if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                        if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                        if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                        ARF_RegSel=3'b111;
                    end
                    if(!_ALUSystem.IROut[8])begin
                        RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                        ALU_FunSel=5'b11101;
                        MuxBSel=2'b00;      
                        if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                        if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                        if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                        if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                        ARF_FunSel=3'b010;          
                    end
                    SCReset=1'b1;
                end
                if(!_ALUSystem.IROut[5])begin
                    if(_ALUSystem.IROut[8])begin
                                                
                        if(_ALUSystem.IROut[4:3]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[4:3]==2'b11) ARF_OutCSel=2'b10;
                        MuxASel=2'b01;
                        RF_FunSel=3'b010;
                        if(_ALUSystem.IROut[7:6]==2'b00) RF_ScrSel=4'b0111;
                        if(_ALUSystem.IROut[7:6]==2'b01) RF_ScrSel=4'b1011;
                        if(_ALUSystem.IROut[7:6]==2'b10) RF_ScrSel=4'b1101;
                        if(_ALUSystem.IROut[7:6]==2'b11) RF_ScrSel=4'b1110;
                        ARF_RegSel=3'b111;
                    end
                    if(!_ALUSystem.IROut[8])begin
                        if(_ALUSystem.IROut[4:3]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[4:3]==2'b11) ARF_OutCSel=2'b10;
                        MuxASel=2'b01;
                        RF_FunSel=3'b010;
                        if(_ALUSystem.IROut[7:6]==2'b00) RF_ScrSel=4'b0111;
                        if(_ALUSystem.IROut[7:6]==2'b01) RF_ScrSel=4'b1011;
                        if(_ALUSystem.IROut[7:6]==2'b10) RF_ScrSel=4'b1101;
                        if(_ALUSystem.IROut[7:6]==2'b11) RF_ScrSel=4'b1110;
                        ARF_RegSel=3'b111;
                    end
                end
            end  
            if(T[3]&&!_ALUSystem.IROut[5])begin 
            RF_ScrSel=4'b1111;
                if(_ALUSystem.IROut[8])begin
                    RF_OutASel={1'b1,_ALUSystem.IROut[7:6]};
                    ALU_FunSel=5'b11101;
                    MuxASel=2'b00;
                    RF_FunSel=3'b010;
                    if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                    if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                    if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                    if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                end
                if(!_ALUSystem.IROut[8])begin
                    RF_OutASel={1'b1,_ALUSystem.IROut[7:6]};
                    ALU_FunSel=5'b11101;
                    MuxBSel=2'b00;      
                    if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                    if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                    ARF_FunSel=3'b010;          
                end  
                SCReset=1'b1;      
            end          
        end
        6'b001010: begin
        
            if(T[2]) begin
            ALU_WF=_ALUSystem.IROut[9];
                if(_ALUSystem.IROut[5])begin
                    if(_ALUSystem.IROut[8])begin
                        RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                        ALU_FunSel=5'b11110;
                        MuxASel=2'b00;
                        
                        if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                        if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                        if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                        if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                        RF_FunSel=3'b010;
                        ARF_RegSel=3'b111;
                    end
                    if(!_ALUSystem.IROut[8])begin
                        RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                        ALU_FunSel=5'b11110;
                        MuxBSel=2'b00;      
                        if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                        if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                        if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                        if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                        ARF_FunSel=3'b010;          
                    end
                    SCReset=1'b1;
                end
                if(!_ALUSystem.IROut[5])begin
                    if(_ALUSystem.IROut[8])begin
                    
                        if(_ALUSystem.IROut[4:3]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[4:3]==2'b11) ARF_OutCSel=2'b10;
                        MuxASel=2'b01;
                        RF_FunSel=3'b010;
                        if(_ALUSystem.IROut[7:6]==2'b00) RF_ScrSel=4'b0111;
                        if(_ALUSystem.IROut[7:6]==2'b01) RF_ScrSel=4'b1011;
                        if(_ALUSystem.IROut[7:6]==2'b10) RF_ScrSel=4'b1101;
                        if(_ALUSystem.IROut[7:6]==2'b11) RF_ScrSel=4'b1110;
                        ARF_RegSel=3'b111;
                    end
                    if(!_ALUSystem.IROut[8])begin
                    
                        if(_ALUSystem.IROut[4:3]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[4:3]==2'b11) ARF_OutCSel=2'b10;
                        MuxASel=2'b01;
                        RF_FunSel=3'b010;
                        if(_ALUSystem.IROut[7:6]==2'b00) RF_ScrSel=4'b0111;
                        if(_ALUSystem.IROut[7:6]==2'b01) RF_ScrSel=4'b1011;
                        if(_ALUSystem.IROut[7:6]==2'b10) RF_ScrSel=4'b1101;
                        if(_ALUSystem.IROut[7:6]==2'b11) RF_ScrSel=4'b1110;
                        ARF_RegSel=3'b111;
                    end
                end
            end  
            if(T[3]&&!_ALUSystem.IROut[5])begin 
            RF_ScrSel=4'b1111;
            
                if(_ALUSystem.IROut[8])begin
                    RF_OutASel={1'b1,_ALUSystem.IROut[7:6]};
                    ALU_FunSel=5'b11110;
                    MuxASel=2'b00;
                    RF_FunSel=3'b010;
                    if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                    if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                    if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                    if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                end
                if(!_ALUSystem.IROut[8])begin
                    RF_OutASel={1'b1,_ALUSystem.IROut[7:6]};
                    ALU_FunSel=5'b11110;
                    MuxBSel=2'b00;      
                    RF_RegSel=4'b1111;
                    if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                    if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                    ARF_FunSel=3'b010;          
                end   
                SCReset=1'b1;     
            end          
        end
        6'b001011: begin
       
            if(T[2]) begin
             ALU_WF=_ALUSystem.IROut[9];
                if(_ALUSystem.IROut[5])begin
                    if(_ALUSystem.IROut[8])begin
                        RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                        ALU_FunSel=5'b11111;
                        MuxASel=2'b00;
                        RF_FunSel=3'b010;
                        if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                        if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                        if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                        if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                        ARF_RegSel=3'b111;
                    end
                    if(!_ALUSystem.IROut[8])begin
                        RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                        ALU_FunSel=5'b11111;
                        MuxBSel=2'b00;      
                        if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                        if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                        if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                        if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                        ARF_FunSel=3'b010;          
                    end
                    SCReset=1'b1;
                end
                if(!_ALUSystem.IROut[5])begin
                    if(_ALUSystem.IROut[8])begin
                    
                        if(_ALUSystem.IROut[4:3]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[4:3]==2'b11) ARF_OutCSel=2'b10;
                        MuxASel=2'b01;
                        RF_FunSel=3'b010;
                        if(_ALUSystem.IROut[7:6]==2'b00) RF_ScrSel=4'b0111;
                        if(_ALUSystem.IROut[7:6]==2'b01) RF_ScrSel=4'b1011;
                        if(_ALUSystem.IROut[7:6]==2'b10) RF_ScrSel=4'b1101;
                        if(_ALUSystem.IROut[7:6]==2'b11) RF_ScrSel=4'b1110;
                        ARF_RegSel=3'b111;
                    end
                    if(!_ALUSystem.IROut[8])begin
                    
                        if(_ALUSystem.IROut[4:3]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[4:3]==2'b11) ARF_OutCSel=2'b10;
                        MuxASel=2'b01;
                        RF_FunSel=3'b010;
                        if(_ALUSystem.IROut[7:6]==2'b00) RF_ScrSel=4'b0111;
                        if(_ALUSystem.IROut[7:6]==2'b01) RF_ScrSel=4'b1011;
                        if(_ALUSystem.IROut[7:6]==2'b10) RF_ScrSel=4'b1101;
                        if(_ALUSystem.IROut[7:6]==2'b11) RF_ScrSel=4'b1110;
                        ARF_RegSel=3'b111;
                    end
                end
            end  
            if(T[3]&&!_ALUSystem.IROut[5])begin 
            RF_ScrSel=4'b1111;
                if(_ALUSystem.IROut[8])begin
                    RF_OutASel={1'b1,_ALUSystem.IROut[7:6]};
                    ALU_FunSel=5'b11111;
                    MuxASel=2'b00;
                    RF_FunSel=3'b010;
                    if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                    if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                    if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                    if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                end
                if(!_ALUSystem.IROut[8])begin
                    RF_OutASel={1'b1,_ALUSystem.IROut[7:6]};
                    ALU_FunSel=5'b11111;
                    MuxBSel=2'b00;      
                    if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                    if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                    ARF_FunSel=3'b010;          
                end 
                SCReset=1'b1;       
            end          
        end
        6'b001100: begin
        
            if(T[2])begin
            ALU_WF=_ALUSystem.IROut[9];
                if(_ALUSystem.IROut[5])begin 
                    if(_ALUSystem.IROut[2])begin
                        if(_ALUSystem.IROut[8])begin
                            RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                            RF_OutBSel={1'b0,_ALUSystem.IROut[1:0]};
                            ALU_FunSel=5'b10111;
                            MuxASel=2'b00;
                            if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                            if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                            if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                            if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                            ARF_RegSel=3'b111;
                            RF_FunSel=3'b010;

                        end
                        if(!_ALUSystem.IROut[8])begin
                            RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                            RF_OutBSel={1'b0,_ALUSystem.IROut[1:0]};
                            ALU_FunSel=5'b10111;
                            MuxBSel=2'b00;
                            if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                            if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                            if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                            if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                            ARF_FunSel=3'b010;
                        end
                        SCReset=1'b1; 
                    end
                    if(!_ALUSystem.IROut[2])begin
                        if(_ALUSystem.IROut[1:0]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[1:0]==2'b11) ARF_OutCSel=2'b10;
                        
                        MuxASel=2'b01;
                        RF_FunSel=3'b010;
                        RF_ScrSel=4'b0111;
                        RF_RegSel=4'b1111;
                        ARF_RegSel=3'b111;
                    end
                end
                if(!_ALUSystem.IROut[5])begin
                    if(_ALUSystem.IROut[2])begin
                        
                    
                        if(_ALUSystem.IROut[4:3]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[4:3]==2'b11) ARF_OutCSel=2'b10;
                        MuxASel=2'b01;
                        RF_FunSel=3'b010;
                        RF_ScrSel=4'b0111;
                        ARF_RegSel=3'b111;
                    end
                    if(!_ALUSystem.IROut[2])begin
                    
                        if(_ALUSystem.IROut[4:3]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[4:3]==2'b11) ARF_OutCSel=2'b10;
                        MuxASel=2'b01;
                        RF_FunSel=3'b010;
                        RF_ScrSel=4'b0111;
                        ARF_RegSel=3'b111;
                    end
                end
            end
            if(T[3]&&(_ALUSystem.IROut[5]^_ALUSystem.IROut[2]))begin 
                if(_ALUSystem.IROut[8])begin
                    if(_ALUSystem.IROut[5])begin 
                        RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                        RF_OutBSel=3'b100;
                    end
                    if(_ALUSystem.IROut[2])begin
                        RF_OutASel={1'b0,_ALUSystem.IROut[1:0]};
                        RF_OutBSel=3'b100;
                    end
                    ALU_FunSel=5'b10111;
                    MuxASel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                    if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                    if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                    if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                    RF_FunSel=3'b010;
                    
                    RF_ScrSel=4'b1111;
                    ARF_RegSel=3'b111;
                end
                if(!_ALUSystem.IROut[8])begin
                    if(_ALUSystem.IROut[5])begin 
                        RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                        RF_OutBSel=3'b100;
                    end
                    if(_ALUSystem.IROut[2])begin
                        RF_OutASel={1'b0,_ALUSystem.IROut[1:0]};
                        RF_OutBSel=3'b100;
                    end
                    ALU_FunSel=5'b10111;
                    MuxBSel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                    if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                    ARF_FunSel=3'b010;
                    RF_RegSel=4'b1111;
                    RF_ScrSel=4'b1111;
                    
                end
                SCReset=1'b1; 
            end
            if(T[3]&&!_ALUSystem.IROut[5]&&!_ALUSystem.IROut[2])begin
                if(_ALUSystem.IROut[1:0]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[1:0]==2'b11) ARF_OutCSel=2'b10;
                        
                MuxASel=2'b01;
                RF_FunSel=3'b010;
                RF_ScrSel=4'b1011;
                RF_RegSel=4'b1111;
           
                ARF_RegSel=3'b111;
            end
            if(T[4]&&!_ALUSystem.IROut[5]&&!_ALUSystem.IROut[2])begin
                if(_ALUSystem.IROut[8])begin
                    RF_OutASel=3'b100;
                    RF_OutBSel=3'b101;
                    ALU_FunSel=5'b10111;
                    MuxASel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                    if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                    if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                    if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                    RF_FunSel=3'b010;
                    
                    RF_ScrSel=4'b1111;
                    ARF_RegSel=3'b111;

                end
                if(!_ALUSystem.IROut[8])begin
                    RF_OutASel=3'b100;
                    RF_OutBSel=3'b101;
                    ALU_FunSel=5'b10111;
                    MuxBSel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                    if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                    ARF_FunSel=3'b010;
                    RF_RegSel=4'b1111;
                    RF_ScrSel=4'b1111;
                    
                end  
                SCReset=1'b1;               
            end
        end
        6'b001101: begin
        
            if(T[2])begin
            ALU_WF=_ALUSystem.IROut[9];
                if(_ALUSystem.IROut[5])begin 
                    if(_ALUSystem.IROut[2])begin
                        if(_ALUSystem.IROut[8])begin
                            RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                            RF_OutBSel={1'b0,_ALUSystem.IROut[1:0]};
                            ALU_FunSel=5'b11000;
                            MuxASel=2'b00;
                            if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                            if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                            if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                            if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                            ARF_RegSel=3'b111;
                            RF_FunSel=3'b010;

                        end
                        if(!_ALUSystem.IROut[8])begin
                            RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                            RF_OutBSel={1'b0,_ALUSystem.IROut[1:0]};
                            ALU_FunSel=5'b11000;
                            MuxBSel=2'b00;
                            if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                            if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                            if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                            if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                            ARF_FunSel=3'b010;
                        end
                        SCReset=1'b1; 
                    end
                    if(!_ALUSystem.IROut[2])begin
                        
                        if(_ALUSystem.IROut[1:0]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[1:0]==2'b11) ARF_OutCSel=2'b10;
                        
                        MuxASel=2'b01;
                        RF_FunSel=3'b010;
                        RF_ScrSel=4'b0111;
                        ARF_RegSel=3'b111;
                    
                    end
                end
                if(!_ALUSystem.IROut[5])begin
                    if(_ALUSystem.IROut[2])begin
                        
                    
                        if(_ALUSystem.IROut[4:3]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[4:3]==2'b11) ARF_OutCSel=2'b10;
                        MuxASel=2'b01;
                        RF_FunSel=3'b010;
                        RF_ScrSel=4'b0111;
                        ARF_RegSel=3'b111;
                    end
                    if(!_ALUSystem.IROut[2])begin
                        
                    
                        if(_ALUSystem.IROut[4:3]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[4:3]==2'b11) ARF_OutCSel=2'b10;
                        MuxASel=2'b01;
                        RF_FunSel=3'b010;
                        RF_ScrSel=4'b0111;
                        ARF_RegSel=3'b111;
                        
                        
                    end
                end
            end
            if(T[3]&&(_ALUSystem.IROut[5]^_ALUSystem.IROut[2]))begin 
                if(_ALUSystem.IROut[8])begin
                    if(_ALUSystem.IROut[5])begin 
                        RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                        RF_OutBSel=3'b100;
                    end
                    if(_ALUSystem.IROut[2])begin
                        RF_OutASel={1'b0,_ALUSystem.IROut[1:0]};
                        RF_OutBSel=3'b100;
                    end
                    ALU_FunSel=5'b11000;
                    MuxASel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                    if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                    if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                    if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                    RF_FunSel=3'b010;
                    
                    RF_ScrSel=4'b1111;
                    ARF_RegSel=3'b111;
                end
                if(!_ALUSystem.IROut[8])begin
                    if(_ALUSystem.IROut[5])begin 
                        RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                        RF_OutBSel=3'b100;
                    end
                    if(_ALUSystem.IROut[2])begin
                        RF_OutASel={1'b0,_ALUSystem.IROut[1:0]};
                        RF_OutBSel=3'b100;
                    end
                    ALU_FunSel=5'b11000;
                    MuxBSel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                    if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                    ARF_FunSel=3'b010;
                    RF_RegSel=4'b1111;
                    RF_ScrSel=4'b1111;
            
                end
                SCReset=1'b1; 
            end
            if(T[3]&&!_ALUSystem.IROut[5]&&!_ALUSystem.IROut[2])begin
                if(_ALUSystem.IROut[1:0]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[1:0]==2'b11) ARF_OutCSel=2'b10;
                        
                MuxASel=2'b01;
                RF_FunSel=3'b010;
                RF_ScrSel=4'b1011;
                RF_RegSel=4'b1111;
            
                ARF_RegSel=3'b111;
            end
            if(T[4]&&!_ALUSystem.IROut[5]&&!_ALUSystem.IROut[2])begin
                if(_ALUSystem.IROut[8])begin
                    RF_OutASel=3'b100;
                    RF_OutBSel=3'b101;
                    ALU_FunSel=5'b11000;
                    MuxASel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                    if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                    if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                    if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                    RF_FunSel=3'b010;
                    
                    RF_ScrSel=4'b1111;
                    ARF_RegSel=3'b111;

                end
                if(!_ALUSystem.IROut[8])begin
                    RF_OutASel=3'b100;
                    RF_OutBSel=3'b101;
                    ALU_FunSel=5'b11000;
                    MuxBSel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                    if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                    ARF_FunSel=3'b010;
                    RF_RegSel=4'b1111;
                    RF_ScrSel=4'b1111;
            
                end   
                SCReset=1'b1;              
            end
        end
        6'b001110: begin
        
            if(T[2]) begin
            ALU_WF=_ALUSystem.IROut[9];
                if(_ALUSystem.IROut[5])begin
                    if(_ALUSystem.IROut[8])begin
                        RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                        ALU_FunSel=5'b10010;
                        MuxASel=2'b00;
                        RF_FunSel=3'b010;
                        if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                        if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                        if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                        if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                        ARF_RegSel=3'b111;
                    end
                    if(!_ALUSystem.IROut[8])begin
                        RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                        ALU_FunSel=5'b10010;
                        MuxBSel=2'b00;      
                        if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                        if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                        if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                        if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                        ARF_FunSel=3'b010;          
                    end
                    SCReset=1'b1; 
                 end
                if(!_ALUSystem.IROut[5])begin
                    if(_ALUSystem.IROut[8])begin
                    
                        if(_ALUSystem.IROut[4:3]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[4:3]==2'b11) ARF_OutCSel=2'b10;
                        MuxASel=2'b01;
                        RF_FunSel=3'b010;
                        if(_ALUSystem.IROut[7:6]==2'b00) RF_ScrSel=4'b0111;
                        if(_ALUSystem.IROut[7:6]==2'b01) RF_ScrSel=4'b1011;
                        if(_ALUSystem.IROut[7:6]==2'b10) RF_ScrSel=4'b1101;
                        if(_ALUSystem.IROut[7:6]==2'b11) RF_ScrSel=4'b1110;
                        ARF_RegSel=3'b111;
                    end
                    if(!_ALUSystem.IROut[8])begin
                    
                        if(_ALUSystem.IROut[4:3]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[4:3]==2'b11) ARF_OutCSel=2'b10;
                        MuxASel=2'b01;
                        RF_FunSel=3'b010;
                        if(_ALUSystem.IROut[7:6]==2'b00) RF_ScrSel=4'b0111;
                        if(_ALUSystem.IROut[7:6]==2'b01) RF_ScrSel=4'b1011;
                        if(_ALUSystem.IROut[7:6]==2'b10) RF_ScrSel=4'b1101;
                        if(_ALUSystem.IROut[7:6]==2'b11) RF_ScrSel=4'b1110;
                        ARF_RegSel=3'b111;
                    end
                end
            end  
            if(T[3]&&!_ALUSystem.IROut[5])begin 
                RF_ScrSel=4'b1111;
                if(_ALUSystem.IROut[8])begin
                    RF_OutASel={1'b1,_ALUSystem.IROut[7:6]};
                    ALU_FunSel=5'b10010;
                    MuxASel=2'b00;
                    RF_FunSel=3'b010;
                    if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                    if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                    if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                    if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                    
                    RF_ScrSel=4'b1111;
                    ARF_RegSel=3'b111;
                end
                if(!_ALUSystem.IROut[8])begin
                    RF_OutASel={1'b1,_ALUSystem.IROut[7:6]};
                    ALU_FunSel=5'b10010;
                    MuxBSel=2'b00;      
                    if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                    if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                    ARF_FunSel=3'b010;    
                    RF_RegSel=4'b1111;
                    RF_ScrSel=4'b1111;
                 
                end   
                SCReset=1'b1;      
            end  
        end
        6'b001111: begin
        
            if(T[2])begin
                ALU_WF=_ALUSystem.IROut[9];
                if(_ALUSystem.IROut[5])begin 
                    if(_ALUSystem.IROut[2])begin
                        if(_ALUSystem.IROut[8])begin
                            RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                            RF_OutBSel={1'b0,_ALUSystem.IROut[1:0]};
                            ALU_FunSel=5'b11001;
                            MuxASel=2'b00;
                            if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                            if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                            if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                            if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                            ARF_RegSel=3'b111;
                            RF_FunSel=3'b010;

                        end
                        if(!_ALUSystem.IROut[8])begin
                            RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                            RF_OutBSel={1'b0,_ALUSystem.IROut[1:0]};
                            ALU_FunSel=5'b11001;
                            MuxBSel=2'b00;
                            if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                            if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                            if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                            if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                            ARF_FunSel=3'b010;
                        end
                        SCReset=1'b1; 
                    end
                    if(!_ALUSystem.IROut[2])begin
                        
                        if(_ALUSystem.IROut[1:0]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[1:0]==2'b11) ARF_OutCSel=2'b10;
                        
                        MuxASel=2'b01;
                        RF_FunSel=3'b010;
                        RF_ScrSel=4'b0111;
                        RF_RegSel=4'b1111;
                        ARF_RegSel=3'b111;
                    end
                end
                if(!_ALUSystem.IROut[5])begin
                    if(_ALUSystem.IROut[2])begin
                    
                        if(_ALUSystem.IROut[4:3]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[4:3]==2'b11) ARF_OutCSel=2'b10;
                        MuxASel=2'b01;
                        RF_FunSel=3'b010;
                        RF_ScrSel=4'b0111;
                        RF_RegSel=4'b1111;
                        ARF_RegSel=3'b111;
                    end
                    if(!_ALUSystem.IROut[2])begin
                    
                        if(_ALUSystem.IROut[4:3]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[4:3]==2'b11) ARF_OutCSel=2'b10;
                        MuxASel=2'b01;
                        RF_FunSel=3'b010;
                        RF_ScrSel=4'b0111;
                        RF_RegSel=4'b1111;
                        ARF_RegSel=3'b111;
                    end
                end
            end
            if(T[3]&&(_ALUSystem.IROut[5]^_ALUSystem.IROut[2]))begin 
                if(_ALUSystem.IROut[8])begin
                    if(_ALUSystem.IROut[5])begin 
                        RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                        RF_OutBSel=3'b100;
                    end
                    if(_ALUSystem.IROut[2])begin
                        RF_OutASel={1'b0,_ALUSystem.IROut[1:0]};
                        RF_OutBSel=3'b100;
                    end
                    ALU_FunSel=5'b11001;
                    MuxASel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                    if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                    if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                    if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                    RF_FunSel=3'b010;
                    
                    RF_ScrSel=4'b1111;
                    ARF_RegSel=3'b111;
                end
                if(!_ALUSystem.IROut[8])begin
                    if(_ALUSystem.IROut[5])begin 
                        RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                        RF_OutBSel=3'b100;
                    end
                    if(_ALUSystem.IROut[2])begin
                        RF_OutASel={1'b0,_ALUSystem.IROut[1:0]};
                        RF_OutBSel=3'b100;
                    end
                    ALU_FunSel=5'b11001;
                    MuxBSel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                    if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                    ARF_FunSel=3'b010;
                    RF_RegSel=4'b1111;
                    RF_ScrSel=4'b1111;
            
                end
                SCReset=1'b1; 
            end
            if(T[3]&&!_ALUSystem.IROut[5]&&!_ALUSystem.IROut[2])begin
                if(_ALUSystem.IROut[1:0]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[1:0]==2'b11) ARF_OutCSel=2'b10;
                        
                MuxASel=2'b01;
                RF_FunSel=3'b010;
                RF_ScrSel=4'b1011;
                RF_RegSel=4'b1111;
            
                ARF_RegSel=3'b111;
            end
            if(T[4]&&!_ALUSystem.IROut[5]&&!_ALUSystem.IROut[2])begin
                if(_ALUSystem.IROut[8])begin
                    RF_OutASel=3'b100;
                    RF_OutBSel=3'b101;
                    ALU_FunSel=5'b11001;
                    MuxASel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                    if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                    if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                    if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                    RF_FunSel=3'b010;
                    RF_ScrSel=4'b1111;
                    ARF_RegSel=3'b111;

                end
                if(!_ALUSystem.IROut[8])begin
                    RF_OutASel=3'b100;
                    RF_OutBSel=3'b101;
                    ALU_FunSel=5'b11001;
                    MuxBSel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                    if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                    ARF_FunSel=3'b010;
                    RF_RegSel=4'b1111;
                    RF_ScrSel=4'b1111;
                end 
                SCReset=1'b1;                
            end
        end
        6'b010000: begin
        
            if(T[2])begin
            ALU_WF=_ALUSystem.IROut[9];
                if(_ALUSystem.IROut[5])begin 
                    if(_ALUSystem.IROut[2])begin
                        if(_ALUSystem.IROut[8])begin
                            RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                            RF_OutBSel={1'b0,_ALUSystem.IROut[1:0]};
                            ALU_FunSel=5'b11010;
                            MuxASel=2'b00;
                            if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                            if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                            if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                            if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                            ARF_RegSel=3'b111;
                            RF_FunSel=3'b010;

                        end
                        if(!_ALUSystem.IROut[8])begin
                            RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                            RF_OutBSel={1'b0,_ALUSystem.IROut[1:0]};
                            ALU_FunSel=5'b11010;
                            MuxBSel=2'b00;
                            if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                            if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                            if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                            if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                            ARF_FunSel=3'b010;
                        end
                        SCReset=1'b1; 
                    end
                    if(!_ALUSystem.IROut[2])begin
                        
                        if(_ALUSystem.IROut[1:0]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[1:0]==2'b11) ARF_OutCSel=2'b10;

                        
                        MuxASel=2'b01;
                        RF_FunSel=3'b010;
                        RF_ScrSel=4'b0111;
                        ARF_RegSel=3'b111;
                    
                    end
                end
                if(!_ALUSystem.IROut[5])begin
                    if(_ALUSystem.IROut[2])begin
                        
                    
                        if(_ALUSystem.IROut[4:3]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[4:3]==2'b11) ARF_OutCSel=2'b10;
                        MuxASel=2'b01;
                        RF_FunSel=3'b010;
                        RF_ScrSel=4'b0111;
                        ARF_RegSel=3'b111;
                    end
                    if(!_ALUSystem.IROut[2])begin
                        
                    
                        if(_ALUSystem.IROut[4:3]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[4:3]==2'b11) ARF_OutCSel=2'b10;
                        MuxASel=2'b01;
                        RF_FunSel=3'b010;
                        RF_ScrSel=4'b0111;
                        ARF_RegSel=3'b111;
                        
                        
                    end
                end
            end
            if(T[3]&&(_ALUSystem.IROut[5]^_ALUSystem.IROut[2]))begin 
                if(_ALUSystem.IROut[8])begin
                    if(_ALUSystem.IROut[5])begin 
                        RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                        RF_OutBSel=3'b100;
                    end
                    if(_ALUSystem.IROut[2])begin
                        RF_OutASel={1'b0,_ALUSystem.IROut[1:0]};
                        RF_OutBSel=3'b100;
                    end
                    ALU_FunSel=5'b11010;
                    MuxASel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                    if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                    if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                    if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                    RF_FunSel=3'b010;
                    
                    RF_ScrSel=4'b1111;
                    ARF_RegSel=3'b111;
                end
                if(!_ALUSystem.IROut[8])begin
                    if(_ALUSystem.IROut[5])begin 
                        RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                        RF_OutBSel=3'b100;
                    end
                    if(_ALUSystem.IROut[2])begin
                        RF_OutASel={1'b0,_ALUSystem.IROut[1:0]};
                        RF_OutBSel=3'b100;
                    end
                    ALU_FunSel=5'b11010;
                    MuxBSel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                    if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                    ARF_FunSel=3'b010;
                    RF_RegSel=4'b1111;
                    RF_ScrSel=4'b1111;
            
                end
                SCReset=1'b1; 
            end
            if(T[3]&&!_ALUSystem.IROut[5]&&!_ALUSystem.IROut[2])begin
                if(_ALUSystem.IROut[1:0]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[1:0]==2'b11) ARF_OutCSel=2'b10;
                        
                MuxASel=2'b01;
                RF_FunSel=3'b010;
                RF_ScrSel=4'b1011;
                RF_RegSel=4'b1111;
            
                ARF_RegSel=3'b111;
            end
            if(T[4]&&!_ALUSystem.IROut[5]&&!_ALUSystem.IROut[2])begin
                if(_ALUSystem.IROut[8])begin
                    RF_OutASel=3'b100;
                    RF_OutBSel=3'b101;
                    ALU_FunSel=5'b11010;
                    MuxASel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                    if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                    if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                    if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                    RF_FunSel=3'b010;
                   
                    RF_ScrSel=4'b1111;
                    ARF_RegSel=3'b111;

                end
                if(!_ALUSystem.IROut[8])begin
                    RF_OutASel=3'b100;
                    RF_OutBSel=3'b101;
                    ALU_FunSel=5'b11010;
                    MuxBSel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                    if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                    ARF_FunSel=3'b010;
                    RF_RegSel=4'b1111;
                    RF_ScrSel=4'b1111;
                end   
                SCReset=1'b1;              
            end
        end 
        6'b010001: begin
            if(T[2])begin 
                
                    
                    MuxASel=2'b11;
                    if(_ALUSystem.IROut[9:8]==2'b00) RF_RegSel=4'b0111;
                    if(_ALUSystem.IROut[9:8]==2'b01) RF_RegSel=4'b1011;
                    if(_ALUSystem.IROut[9:8]==2'b10) RF_RegSel=4'b1101;
                    if(_ALUSystem.IROut[9:8]==2'b11) RF_RegSel=4'b1110;
                    ARF_RegSel=3'b111;
                    RF_FunSel=3'b110;
                    SCReset=1'b1; 
                    

            end
        end
        6'b010010: begin
            if(T[2]) begin
                ARF_OutDSel=2'b10;
                Mem_WR=0;
                MuxASel=2'b10;
                if(_ALUSystem.IROut[9:8]==2'b00) RF_RegSel=4'b0111;
                if(_ALUSystem.IROut[9:8]==2'b01) RF_RegSel=4'b1011;
                if(_ALUSystem.IROut[9:8]==2'b10) RF_RegSel=4'b1101;
                if(_ALUSystem.IROut[9:8]==2'b11) RF_RegSel=4'b1110;
                ARF_RegSel=3'b101;
                ARF_FunSel=3'b001;
                RF_FunSel=3'b101;
                
            end
            if(T[3]) begin
                ARF_RegSel=3'b111;
                ARF_FunSel=3'b110;
                SCReset=1'b1; 
            end
            
        end
        6'b010011: begin
            if(T[2])begin
            RF_OutASel={1'b0,_ALUSystem.IROut[9:8]};
            ALU_FunSel=5'b10000;
            MuxCSel=1'b0;
            Mem_WR=1;
            ARF_OutDSel=2'b10;
            ARF_RegSel=3'b101;
            ARF_FunSel=3'b001;
            
            end
            if(T[3]) begin
                MuxCSel=1'b1;
                ARF_RegSel=3'b111;
                SCReset=1'b1; 
            end
        end
        6'b010100: begin
        
            if(T[2])begin 
                
                    MuxASel=2'b11;
                    if(_ALUSystem.IROut[9:8]==2'b00) RF_RegSel=4'b0111;
                    if(_ALUSystem.IROut[9:8]==2'b01) RF_RegSel=4'b1011;
                    if(_ALUSystem.IROut[9:8]==2'b10) RF_RegSel=4'b1101;
                    if(_ALUSystem.IROut[9:8]==2'b11) RF_RegSel=4'b1110;
                    ARF_RegSel=3'b111;
                    RF_FunSel=3'b101;
                    SCReset=1'b1; 
                
            end
        end 
        6'b010101: begin
        
            if(T[2])begin
            ALU_WF=_ALUSystem.IROut[9];
                if(_ALUSystem.IROut[5])begin 
                    if(_ALUSystem.IROut[2])begin
                        if(_ALUSystem.IROut[8])begin
                            RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                            RF_OutBSel={1'b0,_ALUSystem.IROut[1:0]};
                            ALU_FunSel=5'b10100;
                            MuxASel=2'b00;
                            if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                            if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                            if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                            if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                            ARF_RegSel=3'b111;
                            RF_FunSel=3'b010;

                        end
                        if(!_ALUSystem.IROut[8])begin
                            RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                            RF_OutBSel={1'b0,_ALUSystem.IROut[1:0]};
                            ALU_FunSel=5'b10100;
                            MuxBSel=2'b00;
                            if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                            if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                            if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                            if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                            ARF_FunSel=3'b010;
                        end
                        SCReset=1'b1; 
                    end
                    if(!_ALUSystem.IROut[2])begin
                        
                        if(_ALUSystem.IROut[1:0]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[1:0]==2'b11) ARF_OutCSel=2'b10;
                        
                        MuxASel=2'b00;
                        RF_FunSel=3'b010;
                        RF_ScrSel=4'b0111;
                        ARF_RegSel=3'b111;
                    
                    end
                end
                if(!_ALUSystem.IROut[5])begin
                    if(_ALUSystem.IROut[2])begin
                        
                    
                        if(_ALUSystem.IROut[4:3]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[4:3]==2'b11) ARF_OutCSel=2'b10;
                        MuxASel=2'b00;
                        RF_FunSel=3'b010;
                        RF_ScrSel=4'b0111;
                        ARF_RegSel=3'b111;
                    end
                    if(!_ALUSystem.IROut[2])begin
                        
                    
                        if(_ALUSystem.IROut[4:3]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[4:3]==2'b11) ARF_OutCSel=2'b10;
                        MuxASel=2'b00;
                        RF_FunSel=3'b010;
                        RF_ScrSel=4'b0111;
                        ARF_RegSel=3'b111;
                        
                        
                    end
                end
            end
            if(T[3]&&(_ALUSystem.IROut[5]^_ALUSystem.IROut[2]))begin 
                if(_ALUSystem.IROut[8])begin
                    if(_ALUSystem.IROut[5])begin 
                        RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                        RF_OutBSel=3'b100;
                    end
                    if(_ALUSystem.IROut[2])begin
                        RF_OutASel={1'b0,_ALUSystem.IROut[1:0]};
                        RF_OutBSel=3'b100;
                    end
                    ALU_FunSel=5'b10100;
                    MuxASel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                    if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                    if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                    if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                    RF_FunSel=3'b010;
                    
                    RF_ScrSel=4'b1111;
                    ARF_RegSel=3'b111;
                end
                if(!_ALUSystem.IROut[8])begin
                    if(_ALUSystem.IROut[5])begin 
                        RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                        RF_OutBSel=3'b100;
                    end
                    if(_ALUSystem.IROut[2])begin
                        RF_OutASel={1'b0,_ALUSystem.IROut[1:0]};
                        RF_OutBSel=3'b100;
                    end
                    ALU_FunSel=5'b10100;
                    MuxBSel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                    if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                    ARF_FunSel=3'b010;
                    RF_RegSel=4'b1111;
                    RF_ScrSel=4'b1111;
                    
                end
                SCReset=1'b1; 
            end
            if(T[3]&&!_ALUSystem.IROut[5]&&!_ALUSystem.IROut[2])begin
                if(_ALUSystem.IROut[1:0]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[1:0]==2'b11) ARF_OutCSel=2'b10;
                        
                MuxASel=2'b00;
                RF_FunSel=3'b010;
                RF_ScrSel=4'b1011;
                RF_RegSel=4'b1111;
                ARF_RegSel=3'b111;
            end
            if(T[4]&&!_ALUSystem.IROut[5]&&!_ALUSystem.IROut[2])begin
                if(_ALUSystem.IROut[8])begin
                    RF_OutASel=3'b100;
                    RF_OutBSel=3'b101;
                    ALU_FunSel=5'b10100;
                    MuxASel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                    if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                    if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                    if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                    RF_FunSel=3'b010;
                    
                    RF_ScrSel=4'b1111;
                    ARF_RegSel=3'b111;

                end
                if(!_ALUSystem.IROut[8])begin
                    RF_OutASel=3'b100;
                    RF_OutBSel=3'b101;
                    ALU_FunSel=5'b10100;
                    MuxBSel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                    if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                    ARF_FunSel=3'b010;
                    RF_RegSel=4'b1111;
                    RF_ScrSel=4'b1111;
                    
                end
                SCReset=1'b1;                 
            end

        end 
        6'b010110: begin
        
            if(T[2])begin
            ALU_WF=_ALUSystem.IROut[9];
                if(_ALUSystem.IROut[5])begin 
                    if(_ALUSystem.IROut[2])begin
                        if(_ALUSystem.IROut[8])begin
                            RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                            RF_OutBSel={1'b0,_ALUSystem.IROut[1:0]};
                            ALU_FunSel=5'b10101;
                            MuxASel=2'b00;
                            if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                            if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                            if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                            if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                            ARF_RegSel=3'b111;
                            RF_FunSel=3'b010;

                        end
                        if(!_ALUSystem.IROut[8])begin
                            RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                            RF_OutBSel={1'b0,_ALUSystem.IROut[1:0]};
                            ALU_FunSel=5'b10101;
                            MuxBSel=2'b00;
                            if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                            if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                            if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                            if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                            ARF_FunSel=3'b010;
                        end
                        SCReset=1'b1; 
                    end
                    if(!_ALUSystem.IROut[2])begin
                        
                        if(_ALUSystem.IROut[1:0]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[1:0]==2'b11) ARF_OutCSel=2'b10;
                        
                        MuxASel=2'b00;
                        RF_FunSel=3'b010;
                        RF_ScrSel=4'b0111;
                        ARF_RegSel=3'b111;
                    
                    end
                end
                if(!_ALUSystem.IROut[5])begin
                    if(_ALUSystem.IROut[2])begin
                        if(_ALUSystem.IROut[4:3]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[4:3]==2'b11) ARF_OutCSel=2'b10;
                        MuxASel=2'b00;
                        RF_FunSel=3'b010;
                        RF_ScrSel=4'b0111;
                        ARF_RegSel=3'b111;
                    end
                    if(!_ALUSystem.IROut[2])begin
                        if(_ALUSystem.IROut[4:3]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[4:3]==2'b11) ARF_OutCSel=2'b10;
                        MuxASel=2'b00;
                        RF_FunSel=3'b010;
                        RF_ScrSel=4'b0111;
                        ARF_RegSel=3'b111;
                    end
                end
            end
            if(T[3]&&(_ALUSystem.IROut[5]^_ALUSystem.IROut[2]))begin 
                if(_ALUSystem.IROut[8])begin
                    if(_ALUSystem.IROut[5])begin 
                        RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                        RF_OutBSel=3'b100;
                    end
                    if(_ALUSystem.IROut[2])begin
                        RF_OutASel={1'b0,_ALUSystem.IROut[1:0]};
                        RF_OutBSel=3'b100;
                    end
                    ALU_FunSel=5'b10101;
                    MuxASel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                    if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                    if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                    if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                    RF_FunSel=3'b010;
                    
                    RF_ScrSel=4'b1111;
                    ARF_RegSel=3'b111;
                end
                if(!_ALUSystem.IROut[8])begin
                    if(_ALUSystem.IROut[5])begin 
                        RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                        RF_OutBSel=3'b100;
                    end
                    if(_ALUSystem.IROut[2])begin
                        RF_OutASel={1'b0,_ALUSystem.IROut[1:0]};
                        RF_OutBSel=3'b100;
                    end
                    ALU_FunSel=5'b10101;
                    MuxBSel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                    if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                    ARF_FunSel=3'b010;
                    RF_RegSel=4'b1111;
                    RF_ScrSel=4'b1111;
                    
                end
                SCReset=1'b1; 
            end
            if(T[3]&&!_ALUSystem.IROut[5]&&!_ALUSystem.IROut[2])begin
                if(_ALUSystem.IROut[1:0]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[1:0]==2'b11) ARF_OutCSel=2'b10;
                        
                MuxASel=2'b00;
                RF_FunSel=3'b010;
                RF_ScrSel=4'b1011;
                RF_RegSel=4'b1111;
                ARF_RegSel=3'b111;
            end
            if(T[4]&&!_ALUSystem.IROut[5]&&!_ALUSystem.IROut[2])begin
                if(_ALUSystem.IROut[8])begin
                    RF_OutASel=3'b100;
                    RF_OutBSel=3'b101;
                    ALU_FunSel=5'b10101;
                    MuxASel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                    if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                    if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                    if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                    RF_FunSel=3'b010;
                    
                    RF_ScrSel=4'b1111;
                    ARF_RegSel=3'b111;

                end
                if(!_ALUSystem.IROut[8])begin
                    RF_OutASel=3'b100;
                    RF_OutBSel=3'b101;
                    ALU_FunSel=5'b10101;
                    MuxBSel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                    if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                    ARF_FunSel=3'b010;
                    RF_RegSel=4'b1111;
                    RF_ScrSel=4'b1111;
                    
                end   
                SCReset=1'b1;              
            end
        end
        6'b010111: begin
        
            if(T[2])begin
            ALU_WF=_ALUSystem.IROut[9];
                if(_ALUSystem.IROut[5])begin 
                    if(_ALUSystem.IROut[2])begin
                        if(_ALUSystem.IROut[8])begin
                            RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                            RF_OutBSel={1'b0,_ALUSystem.IROut[1:0]};
                            ALU_FunSel=5'b10110;
                            MuxASel=2'b00;
                            if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                            if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                            if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                            if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                            ARF_RegSel=3'b111;
                            RF_FunSel=3'b010;

                        end
                        if(!_ALUSystem.IROut[8])begin
                            RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                            RF_OutBSel={1'b0,_ALUSystem.IROut[1:0]};
                            ALU_FunSel=5'b10110;
                            MuxBSel=2'b00;
                            if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                            if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                            if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                            if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                            ARF_FunSel=3'b010;
                        end
                        SCReset=1'b1; 
                    end
                    if(!_ALUSystem.IROut[2])begin
                        
                        if(_ALUSystem.IROut[1:0]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[1:0]==2'b11) ARF_OutCSel=2'b10;
                        
                        MuxASel=2'b00;
                        RF_FunSel=3'b010;
                        RF_ScrSel=4'b0111;
                        ARF_RegSel=3'b111;
                    
                    end
                end
                if(!_ALUSystem.IROut[5])begin
                    if(_ALUSystem.IROut[2])begin
                        
                    
                        if(_ALUSystem.IROut[4:3]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[4:3]==2'b11) ARF_OutCSel=2'b10;
                        MuxASel=2'b00;
                        RF_FunSel=3'b010;
                        RF_ScrSel=4'b0111;
                        ARF_RegSel=3'b111;
                    end
                    if(!_ALUSystem.IROut[2])begin
                        
                    
                        if(_ALUSystem.IROut[4:3]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[4:3]==2'b11) ARF_OutCSel=2'b10;
                        MuxASel=2'b00;
                        RF_FunSel=3'b010;
                        RF_ScrSel=4'b0111;
                        ARF_RegSel=3'b111;
                        
                        
                    end
                end
            end
            if(T[3]&&(_ALUSystem.IROut[5]^_ALUSystem.IROut[2]))begin 
                if(_ALUSystem.IROut[8])begin
                    if(_ALUSystem.IROut[5])begin 
                        RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                        RF_OutBSel=3'b100;
                    end
                    if(_ALUSystem.IROut[2])begin
                        RF_OutBSel={1'b0,_ALUSystem.IROut[1:0]};
                        RF_OutASel=3'b100;
                    end
                    ALU_FunSel=5'b10110;
                    MuxASel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                    if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                    if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                    if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                    RF_FunSel=3'b010;
                    
                    RF_ScrSel=4'b1111;
                    ARF_RegSel=3'b111;
                end
                if(!_ALUSystem.IROut[8])begin
                    if(_ALUSystem.IROut[5])begin 
                        RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                        RF_OutBSel=3'b100;
                    end
                    if(_ALUSystem.IROut[2])begin
                        RF_OutBSel={1'b0,_ALUSystem.IROut[1:0]};
                        RF_OutASel=3'b100;
                    end
                    ALU_FunSel=5'b10110;
                    MuxBSel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                    if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                    ARF_FunSel=3'b010;
                    RF_RegSel=4'b1111;
                    RF_ScrSel=4'b1111;
                    
                end
                SCReset=1'b1; 
            end
            if(T[3]&&!_ALUSystem.IROut[5]&&!_ALUSystem.IROut[2])begin
                if(_ALUSystem.IROut[1:0]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[1:0]==2'b11) ARF_OutCSel=2'b10;
                        
                MuxASel=2'b00;
                RF_FunSel=3'b010;
                RF_ScrSel=4'b1011;
                RF_RegSel=4'b1111;
                ARF_RegSel=3'b111;
            end
            if(T[4]&&!_ALUSystem.IROut[5]&&!_ALUSystem.IROut[2])begin
                if(_ALUSystem.IROut[8])begin
                    RF_OutASel=3'b100;
                    RF_OutBSel=3'b101;
                    ALU_FunSel=5'b10110;
                    MuxASel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                    if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                    if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                    if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                    RF_FunSel=3'b010;
                    RF_ScrSel=4'b1111;
                    ARF_RegSel=3'b111;

                end
                if(!_ALUSystem.IROut[8])begin
                    RF_OutASel=3'b100;
                    RF_OutBSel=3'b101;
                    ALU_FunSel=5'b10110;
                    MuxBSel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                    if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                    ARF_FunSel=3'b010;
                    RF_RegSel=4'b1111;
                    RF_ScrSel=4'b1111;
                end     
                SCReset=1'b1;            
            end
        end
        6'b011000: begin 
            
            if(T[2]) begin
            ALU_WF=_ALUSystem.IROut[9];
                if(_ALUSystem.IROut[5])begin
                    if(_ALUSystem.IROut[8])begin
                        RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                        ALU_FunSel=5'b10000;
                        MuxASel=2'b00;
                        RF_FunSel=3'b010;
                        if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                        if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                        if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                        if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                        ARF_RegSel=3'b111;
                    end
                    if(!_ALUSystem.IROut[8])begin
                        RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                        ALU_FunSel=5'b10000;
                        MuxBSel=2'b00;      
                        if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                        if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                        if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                        if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                        ARF_FunSel=3'b010;          
                    end
                    
                end
                if(!_ALUSystem.IROut[5])begin
                    if(_ALUSystem.IROut[8])begin
                    
                        if(_ALUSystem.IROut[4:3]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[4:3]==2'b11) ARF_OutCSel=2'b10;
                        MuxASel=2'b01;
                        RF_FunSel=3'b010;
                        if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                        if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                        if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                        if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                        ARF_RegSel=3'b111;
                    end
                    if(!_ALUSystem.IROut[8])begin
                    
                        if(_ALUSystem.IROut[4:3]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[4:3]==2'b11) ARF_OutCSel=2'b10;
                        MuxBSel=2'b01;
                        ARF_FunSel=3'b010;
                        if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                        if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                        if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                        if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                    end
                end
                SCReset=1'b1; 
            end
        end
        6'b011001: begin
            
            if(T[2])begin
            ALU_WF=_ALUSystem.IROut[9];
                if(_ALUSystem.IROut[5])begin 
                    if(_ALUSystem.IROut[2])begin
                        if(_ALUSystem.IROut[8])begin
                            RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                            RF_OutBSel={1'b0,_ALUSystem.IROut[1:0]};
                            ALU_FunSel=5'b10100;
                            MuxASel=2'b00;
                            if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                            if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                            if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                            if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                            ARF_RegSel=3'b111;
                            RF_FunSel=3'b010;

                        end
                        if(!_ALUSystem.IROut[8])begin
                            RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                            RF_OutBSel={1'b0,_ALUSystem.IROut[1:0]};
                            ALU_FunSel=5'b10100;
                            MuxBSel=2'b00;
                            if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                            if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                            if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                            if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                            ARF_FunSel=3'b010;
                        end
                        SCReset=1'b1; 
                    end
                    if(!_ALUSystem.IROut[2])begin
                        
                        if(_ALUSystem.IROut[1:0]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[1:0]==2'b11) ARF_OutCSel=2'b10;
                        
                        MuxASel=2'b00;
                        RF_FunSel=3'b010;
                        RF_ScrSel=4'b0111;
                        ARF_RegSel=3'b111;
                    
                    end
                end
                if(!_ALUSystem.IROut[5])begin
                    if(_ALUSystem.IROut[2])begin
                        
                    
                        if(_ALUSystem.IROut[4:3]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[4:3]==2'b11) ARF_OutCSel=2'b10;
                        MuxASel=2'b00;
                        RF_FunSel=3'b010;
                        RF_ScrSel=4'b0111;
                        ARF_RegSel=3'b111;
                    end
                    if(!_ALUSystem.IROut[2])begin
                        
                    
                        if(_ALUSystem.IROut[4:3]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[4:3]==2'b11) ARF_OutCSel=2'b10;
                        MuxASel=2'b00;
                        RF_FunSel=3'b010;
                        RF_ScrSel=4'b0111;
                        ARF_RegSel=3'b111;
                        
                        
                    end
                end
            end
            if(T[3]&&(_ALUSystem.IROut[5]^_ALUSystem.IROut[2]))begin 
                if(_ALUSystem.IROut[8])begin
                    if(_ALUSystem.IROut[5])begin 
                        RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                        RF_OutBSel=3'b100;
                    end
                    if(_ALUSystem.IROut[2])begin
                        RF_OutASel={1'b0,_ALUSystem.IROut[1:0]};
                        RF_OutBSel=3'b100;
                    end
                    ALU_FunSel=5'b10100;
                    MuxASel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                    if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                    if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                    if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                    RF_FunSel=3'b010;
                    RF_ScrSel=4'b1111;
                    ARF_RegSel=3'b111;
                end
                if(!_ALUSystem.IROut[8])begin
                    if(_ALUSystem.IROut[5])begin 
                        RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                        RF_OutBSel=3'b100;
                    end
                    if(_ALUSystem.IROut[2])begin
                        RF_OutASel={1'b0,_ALUSystem.IROut[1:0]};
                        RF_OutBSel=3'b100;
                    end
                    ALU_FunSel=5'b10100;
                    MuxBSel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                    if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                    ARF_FunSel=3'b010;
                    RF_RegSel=4'b1111;
                    RF_ScrSel=4'b1111;
                    
                end
                SCReset=1'b1; 
            end
            if(T[3]&&!_ALUSystem.IROut[5]&&!_ALUSystem.IROut[2])begin
                if(_ALUSystem.IROut[1:0]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[1:0]==2'b11) ARF_OutCSel=2'b10;
                        
                MuxASel=2'b00;
                RF_FunSel=3'b010;
                RF_ScrSel=4'b1011;
                RF_RegSel=4'b1111;
                ARF_RegSel=3'b111;
            end
            if(T[4]&&!_ALUSystem.IROut[5]&&!_ALUSystem.IROut[2])begin
                if(_ALUSystem.IROut[8])begin
                    RF_OutASel=3'b100;
                    RF_OutBSel=3'b101;
                    ALU_FunSel=5'b10100;
                    MuxASel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                    if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                    if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                    if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                    RF_FunSel=3'b010;
                    RF_ScrSel=4'b1111;
                    ARF_RegSel=3'b111;

                end
                if(!_ALUSystem.IROut[8])begin
                    RF_OutASel=3'b100;
                    RF_OutBSel=3'b101;
                    ALU_FunSel=5'b10100;
                    MuxBSel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                    if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                    ARF_FunSel=3'b010;
                    RF_RegSel=4'b1111;
                    RF_ScrSel=4'b1111;
                    
                end                
                SCReset=1'b1; 
            end
        end
        6'b011010:begin
            
            if(T[2])begin
            ALU_WF=_ALUSystem.IROut[9];
                if(_ALUSystem.IROut[5])begin 
                    if(_ALUSystem.IROut[2])begin
                        if(_ALUSystem.IROut[8])begin
                            RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                            RF_OutBSel={1'b0,_ALUSystem.IROut[1:0]};
                            ALU_FunSel=5'b10110;
                            MuxASel=2'b00;
                            if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                            if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                            if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                            if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                            ARF_RegSel=3'b111;
                            RF_FunSel=3'b010;

                        end
                        if(!_ALUSystem.IROut[8])begin
                            RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                            RF_OutBSel={1'b0,_ALUSystem.IROut[1:0]};
                            ALU_FunSel=5'b10110;
                            MuxBSel=2'b00;
                            if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                            if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                            if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                            if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                            ARF_FunSel=3'b010;
                        end
                        SCReset=1'b1; 
                    end
                    if(!_ALUSystem.IROut[2])begin
                        
                        if(_ALUSystem.IROut[1:0]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[1:0]==2'b11) ARF_OutCSel=2'b10;
                        
                        MuxASel=2'b00;
                        RF_FunSel=3'b010;
                        RF_ScrSel=4'b0111;
                        ARF_RegSel=3'b111;
                        
                    
                    end
                end
                if(!_ALUSystem.IROut[5])begin
                    if(_ALUSystem.IROut[2])begin
                        
                    
                        if(_ALUSystem.IROut[4:3]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[4:3]==2'b11) ARF_OutCSel=2'b10;
                        MuxASel=2'b00;
                        RF_FunSel=3'b010;
                        RF_ScrSel=4'b0111;
                        ARF_RegSel=3'b111;
                    end
                    if(!_ALUSystem.IROut[2])begin
                        
                    
                        if(_ALUSystem.IROut[4:3]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[4:3]==2'b11) ARF_OutCSel=2'b10;
                        MuxASel=2'b00;
                        RF_FunSel=3'b010;
                        RF_ScrSel=4'b0111;
                        ARF_RegSel=3'b111;
                        
                        
                    end
                end
            end
            if(T[3]&&(_ALUSystem.IROut[5]^_ALUSystem.IROut[2]))begin 
                if(_ALUSystem.IROut[8])begin
                    if(_ALUSystem.IROut[5])begin 
                        RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                        RF_OutBSel=3'b100;
                    end
                    if(_ALUSystem.IROut[2])begin
                        RF_OutBSel={1'b0,_ALUSystem.IROut[1:0]};
                        RF_OutASel=3'b100;
                    end
                    ALU_FunSel=5'b10110;
                    MuxASel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                    if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                    if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                    if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                    RF_FunSel=3'b010;
                    RF_ScrSel=4'b1111;
                    ARF_RegSel=3'b111;
                end
                if(!_ALUSystem.IROut[8])begin
                    if(_ALUSystem.IROut[5])begin 
                        RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                        RF_OutBSel=3'b100;
                    end
                    if(_ALUSystem.IROut[2])begin
                        RF_OutBSel={1'b0,_ALUSystem.IROut[1:0]};
                        RF_OutASel=3'b100;
                    end
                    ALU_FunSel=5'b10110;
                    MuxBSel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                    if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                    ARF_FunSel=3'b010;
                    RF_RegSel=4'b1111;
                    RF_ScrSel=4'b1111;
                end
                SCReset=1'b1; 
            end
            if(T[3]&&!_ALUSystem.IROut[5]&&!_ALUSystem.IROut[2])begin
                if(_ALUSystem.IROut[1:0]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[1:0]==2'b11) ARF_OutCSel=2'b10;
                        
                MuxASel=2'b00;
                RF_FunSel=3'b010;
                RF_ScrSel=4'b1011;
                RF_RegSel=4'b1111;
                ARF_RegSel=3'b111;
            end
            if(T[4]&&!_ALUSystem.IROut[5]&&!_ALUSystem.IROut[2])begin
                if(_ALUSystem.IROut[8])begin
                    RF_OutASel=3'b100;
                    RF_OutBSel=3'b101;
                    ALU_FunSel=5'b10110;
                    MuxASel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                    if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                    if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                    if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                    RF_FunSel=3'b010;
                    RF_ScrSel=4'b1111;
                    ARF_RegSel=3'b111;

                end
                if(!_ALUSystem.IROut[8])begin
                    RF_OutASel=3'b100;
                    RF_OutBSel=3'b101;
                    ALU_FunSel=5'b10110;
                    MuxBSel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                    if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                    ARF_FunSel=3'b010;
                    RF_RegSel=4'b1111;
                    RF_ScrSel=4'b1111;
                end 
                SCReset=1'b1;                
            end
        end
        6'b011011:begin
            
            if(T[2])begin
            ALU_WF=_ALUSystem.IROut[9];
                if(_ALUSystem.IROut[5])begin 
                    if(_ALUSystem.IROut[2])begin
                        if(_ALUSystem.IROut[8])begin
                            RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                            RF_OutBSel={1'b0,_ALUSystem.IROut[1:0]};
                            ALU_FunSel=5'b10111;
                            MuxASel=2'b00;
                            if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                            if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                            if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                            if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                            ARF_RegSel=3'b111;
                            RF_FunSel=3'b010;

                        end
                        if(!_ALUSystem.IROut[8])begin
                            RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                            RF_OutBSel={1'b0,_ALUSystem.IROut[1:0]};
                            ALU_FunSel=5'b10111;
                            MuxBSel=2'b00;
                            if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                            if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                            if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                            if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                            ARF_FunSel=3'b010;
                        end
                        SCReset=1'b1; 
                    end
                    if(!_ALUSystem.IROut[2])begin
                        
                        if(_ALUSystem.IROut[1:0]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[1:0]==2'b11) ARF_OutCSel=2'b10;
                        
                        MuxASel=2'b00;
                        RF_FunSel=3'b010;
                        RF_ScrSel=4'b0111;
                        ARF_RegSel=3'b111;
                    
                    end
                end
                if(!_ALUSystem.IROut[5])begin
                    if(_ALUSystem.IROut[2])begin
                        
                    
                        if(_ALUSystem.IROut[4:3]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[4:3]==2'b11) ARF_OutCSel=2'b10;
                        MuxASel=2'b00;
                        RF_FunSel=3'b010;
                        RF_ScrSel=4'b0111;
                        ARF_RegSel=3'b111;
                    end
                    if(!_ALUSystem.IROut[2])begin
                        
                    
                        if(_ALUSystem.IROut[4:3]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[4:3]==2'b11) ARF_OutCSel=2'b10;
                        MuxASel=2'b00;
                        RF_FunSel=3'b010;
                        RF_ScrSel=4'b0111;
                        ARF_RegSel=3'b111;
                        
                        
                    end
                end
            end
            if(T[3]&&(_ALUSystem.IROut[5]^_ALUSystem.IROut[2]))begin 
                if(_ALUSystem.IROut[8])begin
                    if(_ALUSystem.IROut[5])begin 
                        RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                        RF_OutBSel=3'b100;
                    end
                    if(_ALUSystem.IROut[2])begin
                        RF_OutASel={1'b0,_ALUSystem.IROut[1:0]};
                        RF_OutBSel=3'b100;
                    end
                    ALU_FunSel=5'b10111;
                    MuxASel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                    if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                    if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                    if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                    RF_FunSel=3'b010;
                    RF_ScrSel=4'b1111;
                    ARF_RegSel=3'b111;
                end
                if(!_ALUSystem.IROut[8])begin
                    if(_ALUSystem.IROut[5])begin 
                        RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                        RF_OutBSel=3'b100;
                    end
                    if(_ALUSystem.IROut[2])begin
                        RF_OutASel={1'b0,_ALUSystem.IROut[1:0]};
                        RF_OutBSel=3'b100;
                    end
                    ALU_FunSel=5'b10111;
                    MuxBSel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                    if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                    ARF_FunSel=3'b010;
                    RF_RegSel=4'b1111;
                    RF_ScrSel=4'b1111;
                end
                SCReset=1'b1; 
            end
            if(T[3]&&!_ALUSystem.IROut[5]&&!_ALUSystem.IROut[2])begin
                if(_ALUSystem.IROut[1:0]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[1:0]==2'b11) ARF_OutCSel=2'b10;
                        
                MuxASel=2'b00;
                RF_FunSel=3'b010;
                RF_ScrSel=4'b1011;
                RF_RegSel=4'b1111;
                ARF_RegSel=3'b111;
            end
            if(T[4]&&!_ALUSystem.IROut[5]&&!_ALUSystem.IROut[2])begin
                if(_ALUSystem.IROut[8])begin
                    RF_OutASel=3'b100;
                    RF_OutBSel=3'b101;
                    ALU_FunSel=5'b10111;
                    MuxASel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                    if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                    if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                    if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                    RF_FunSel=3'b010;
                    RF_ScrSel=4'b1111;
                    ARF_RegSel=3'b111;
                end
                if(!_ALUSystem.IROut[8])begin
                    RF_OutASel=3'b100;
                    RF_OutBSel=3'b101;
                    ALU_FunSel=5'b10111;
                    MuxBSel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                    if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                    ARF_FunSel=3'b010;
                    RF_RegSel=4'b1111;
                    RF_ScrSel=4'b1111;
                    
                end     
                SCReset=1'b1;          
            end
        end
        6'b011100: begin
            
            if(T[2])begin
                ALU_WF=_ALUSystem.IROut[9];
                if(_ALUSystem.IROut[5])begin 
                    if(_ALUSystem.IROut[2])begin
                        if(_ALUSystem.IROut[8])begin
                            RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                            RF_OutBSel={1'b0,_ALUSystem.IROut[1:0]};
                            ALU_FunSel=5'b11000;
                            MuxASel=2'b00;
                            if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                            if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                            if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                            if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                            ARF_RegSel=3'b111;
                            RF_FunSel=3'b010;

                        end
                        if(!_ALUSystem.IROut[8])begin
                            RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                            RF_OutBSel={1'b0,_ALUSystem.IROut[1:0]};
                            ALU_FunSel=5'b11000;
                            MuxBSel=2'b00;
                            if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                            if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                            if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                            if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                            ARF_FunSel=3'b010;
                        end
                        SCReset=1'b1; 
                    end
                    if(!_ALUSystem.IROut[2])begin
                        
                        if(_ALUSystem.IROut[1:0]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[1:0]==2'b11) ARF_OutCSel=2'b10;
                        
                        MuxASel=2'b00;
                        RF_FunSel=3'b010;
                        RF_ScrSel=4'b0111;
                        ARF_RegSel=3'b111;
                    
                    end
                end
                if(!_ALUSystem.IROut[5])begin
                    if(_ALUSystem.IROut[2])begin
                        
                    
                        if(_ALUSystem.IROut[4:3]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[4:3]==2'b11) ARF_OutCSel=2'b10;
                        MuxASel=2'b00;
                        RF_FunSel=3'b010;
                        RF_ScrSel=4'b0111;
                        ARF_RegSel=3'b111;
                    end
                    if(!_ALUSystem.IROut[2])begin
                        
                    
                        if(_ALUSystem.IROut[4:3]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[4:3]==2'b11) ARF_OutCSel=2'b10;
                        MuxASel=2'b00;
                        RF_FunSel=3'b010;
                        RF_ScrSel=4'b0111;
                        ARF_RegSel=3'b111;
                        
                        
                    end
                end
            end
            if(T[3]&&(_ALUSystem.IROut[5]^_ALUSystem.IROut[2]))begin 
                if(_ALUSystem.IROut[8])begin
                    if(_ALUSystem.IROut[5])begin 
                        RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                        RF_OutBSel=3'b100;
                    end
                    if(_ALUSystem.IROut[2])begin
                        RF_OutASel={1'b0,_ALUSystem.IROut[1:0]};
                        RF_OutBSel=3'b100;
                    end
                    ALU_FunSel=5'b11000;
                    MuxASel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                    if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                    if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                    if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                    RF_FunSel=3'b010;
                    RF_ScrSel=4'b1111;
                    ARF_RegSel=3'b111;
                end
                if(!_ALUSystem.IROut[8])begin
                    if(_ALUSystem.IROut[5])begin 
                        RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                        RF_OutBSel=3'b100;
                    end
                    if(_ALUSystem.IROut[2])begin
                        RF_OutASel={1'b0,_ALUSystem.IROut[1:0]};
                        RF_OutBSel=3'b100;
                    end
                    ALU_FunSel=5'b11000;
                    MuxBSel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                    if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                    ARF_FunSel=3'b010;
                    RF_RegSel=4'b1111;
                    RF_ScrSel=4'b1111;
                end
                SCReset=1'b1; 
            end
            if(T[3]&&!_ALUSystem.IROut[5]&&!_ALUSystem.IROut[2])begin
                if(_ALUSystem.IROut[1:0]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[1:0]==2'b11) ARF_OutCSel=2'b10;
                        
                MuxASel=2'b00;
                RF_FunSel=3'b010;
                RF_ScrSel=4'b1011;
                RF_RegSel=4'b1111;
                ARF_RegSel=3'b111;
            end
            if(T[4]&&!_ALUSystem.IROut[5]&&!_ALUSystem.IROut[2])begin
                if(_ALUSystem.IROut[8])begin
                    RF_OutASel=3'b100;
                    RF_OutBSel=3'b101;
                    ALU_FunSel=5'b11000;
                    MuxASel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                    if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                    if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                    if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                    RF_FunSel=3'b010;
                    RF_ScrSel=4'b1111;
                    ARF_RegSel=3'b111;

                end
                if(!_ALUSystem.IROut[8])begin
                    RF_OutASel=3'b100;
                    RF_OutBSel=3'b101;
                    ALU_FunSel=5'b11000;
                    MuxBSel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                    if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                    ARF_FunSel=3'b010;
                    RF_RegSel=4'b1111;
                    RF_ScrSel=4'b1111;
                end     
                SCReset=1'b1;            
            end
        end
        6'b011101:begin
            
            if(T[2])begin
                ALU_WF=_ALUSystem.IROut[9];
                if(_ALUSystem.IROut[5])begin 
                    if(_ALUSystem.IROut[2])begin
                        if(_ALUSystem.IROut[8])begin
                            RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                            RF_OutBSel={1'b0,_ALUSystem.IROut[1:0]};
                            ALU_FunSel=5'b11001;
                            MuxASel=2'b00;
                            if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                            if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                            if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                            if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                            ARF_RegSel=3'b111;
                            RF_FunSel=3'b010;

                        end
                        if(!_ALUSystem.IROut[8])begin
                            RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                            RF_OutBSel={1'b0,_ALUSystem.IROut[1:0]};
                            ALU_FunSel=5'b11001;
                            MuxBSel=2'b00;
                            if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                            if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                            if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                            if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                            ARF_FunSel=3'b010;
                        end
                        SCReset=1'b1; 
                    end
                    if(!_ALUSystem.IROut[2])begin
                        
                        if(_ALUSystem.IROut[1:0]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[1:0]==2'b11) ARF_OutCSel=2'b10;
                        
                        MuxASel=2'b00;
                        RF_FunSel=3'b010;
                        RF_ScrSel=4'b0111;
                        ARF_RegSel=3'b111;
                    
                    end
                end
                if(!_ALUSystem.IROut[5])begin
                    if(_ALUSystem.IROut[2])begin
                        
                    
                        if(_ALUSystem.IROut[4:3]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[4:3]==2'b11) ARF_OutCSel=2'b10;
                        MuxASel=2'b00;
                        RF_FunSel=3'b010;
                        RF_ScrSel=4'b0111;
                        ARF_RegSel=3'b111;
                    end
                    if(!_ALUSystem.IROut[2])begin
                        
                    
                        if(_ALUSystem.IROut[4:3]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[4:3]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[4:3]==2'b11) ARF_OutCSel=2'b10;
                        MuxASel=2'b00;
                        RF_FunSel=3'b010;
                        RF_ScrSel=4'b0111;
                        ARF_RegSel=3'b111;
                        
                        
                    end
                end
            end
            if(T[3]&&(_ALUSystem.IROut[5]^_ALUSystem.IROut[2]))begin 
                if(_ALUSystem.IROut[8])begin
                    if(_ALUSystem.IROut[5])begin 
                        RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                        RF_OutBSel=3'b100;
                    end
                    if(_ALUSystem.IROut[2])begin
                        RF_OutASel={1'b0,_ALUSystem.IROut[1:0]};
                        RF_OutBSel=3'b100;
                    end
                    ALU_FunSel=5'b11001;
                    MuxASel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                    if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                    if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                    if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                    RF_FunSel=3'b010;
                    RF_ScrSel=4'b1111;
                    ARF_RegSel=3'b111;
                end
                if(!_ALUSystem.IROut[8])begin
                    if(_ALUSystem.IROut[5])begin 
                        RF_OutASel={1'b0,_ALUSystem.IROut[4:3]};
                        RF_OutBSel=3'b100;
                    end
                    if(_ALUSystem.IROut[2])begin
                        RF_OutASel={1'b0,_ALUSystem.IROut[1:0]};
                        RF_OutBSel=3'b100;
                    end
                    ALU_FunSel=5'b11001;
                    MuxBSel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                    if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                    ARF_FunSel=3'b010;
                    RF_RegSel=4'b1111;
                    RF_ScrSel=4'b1111;
                end
                SCReset=1'b1; 
            end
            if(T[3]&&!_ALUSystem.IROut[5]&&!_ALUSystem.IROut[2])begin
                if(_ALUSystem.IROut[1:0]==2'b00) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b01) ARF_OutCSel=2'b00;
                        if(_ALUSystem.IROut[1:0]==2'b10) ARF_OutCSel=2'b11;
                        if(_ALUSystem.IROut[1:0]==2'b11) ARF_OutCSel=2'b10;
                        
                MuxASel=2'b00;
                RF_FunSel=3'b010;
                RF_ScrSel=4'b1011;
                RF_RegSel=4'b1111;
                ARF_RegSel=3'b111;
            end
            if(T[4]&&!_ALUSystem.IROut[5]&&!_ALUSystem.IROut[2])begin
                if(_ALUSystem.IROut[8])begin
                    RF_OutASel=3'b100;
                    RF_OutBSel=3'b101;
                    ALU_FunSel=5'b11001;
                    MuxASel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) RF_RegSel=4'b0111;
                    if(_ALUSystem.IROut[7:6]==2'b01) RF_RegSel=4'b1011;
                    if(_ALUSystem.IROut[7:6]==2'b10) RF_RegSel=4'b1101;
                    if(_ALUSystem.IROut[7:6]==2'b11) RF_RegSel=4'b1110;
                    RF_FunSel=3'b010;
                    RF_ScrSel=4'b1111;
                    ARF_RegSel=3'b111;

                end
                if(!_ALUSystem.IROut[8])begin
                    RF_OutASel=3'b100;
                    RF_OutBSel=3'b101;
                    ALU_FunSel=5'b11001;
                    MuxBSel=2'b00;
                    if(_ALUSystem.IROut[7:6]==2'b00) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b01) ARF_RegSel=3'b011;
                    if(_ALUSystem.IROut[7:6]==2'b11) ARF_RegSel=3'b101;
                    if(_ALUSystem.IROut[7:6]==2'b10) ARF_RegSel=3'b110;
                    ARF_FunSel=3'b010;
                    RF_RegSel=4'b1111;
                    RF_ScrSel=4'b1111;
                end    
                SCReset=1'b1;             
            end
        end
        6'b011110: begin
            if(T[2]) begin 
                ARF_OutCSel=2'b00;
                MuxASel=2'b01;
                RF_ScrSel=4'b0111;
                RF_FunSel=3'b010;
                RF_OutASel={1'b0,_ALUSystem.IROut[9:8]};
                ALU_FunSel=5'b10000;
                MuxBSel=2'b00;
                ARF_FunSel=3'b010;
                ARF_RegSel=3'b011;
            end 
            if(T[3]) begin
                ARF_OutDSel=2'b11;
                Mem_WR=1'b1;
                RF_OutASel=3'b100;
                ALU_FunSel=5'b10000;
                MuxCSel=1'b0;
                RF_RegSel=4'b1111;
                RF_ScrSel=4'b1111;
                ARF_RegSel=3'b110;
                ARF_FunSel=3'b001;
                
            end
            if(T[4]) begin
                MuxCSel=1'b1;
                ARF_RegSel=3'b111;
                SCReset=1'b1; 
            end
        end
        6'b011111: begin
            if(T[2]) begin
                ARF_OutDSel=2'b11;
                Mem_WR=1'b0;
                MuxBSel=2'b10;
                ARF_FunSel=3'b101;
                ARF_RegSel=3'b011;
               
            end
            if(T[3] ) begin
                ARF_FunSel=3'b001;
                ARF_RegSel=3'b110;
            end
            if(T[4]) begin
                ARF_FunSel=3'b110;
                ARF_RegSel=3'b011;
                SCReset=1'b1; 
                
            end
            
        end
        6'b100000: begin
            if(T[2])begin
                
                MuxASel=2'b11;
                if(_ALUSystem.IROut[9:8]==2'b00) RF_RegSel=4'b0111;
                if(_ALUSystem.IROut[9:8]==2'b01) RF_RegSel=4'b1011;
                if(_ALUSystem.IROut[9:8]==2'b10) RF_RegSel=4'b1101;
                if(_ALUSystem.IROut[9:8]==2'b11) RF_RegSel=4'b1110;
                ARF_RegSel=3'b111;
                RF_FunSel=3'b100;
                SCReset=1'b1; 
                
            end
        end
        6'b100001: begin
            if(T[2]) begin
                ARF_OutCSel=2'b10;
                MuxASel=2'b01;
                RF_ScrSel=4'b0111;
                RF_FunSel=3'b010;
                ARF_RegSel=3'b111;
            end
            if(T[3]) begin
                
                MuxASel=2'b11;
                RF_ScrSel=4'b1011;
                RF_FunSel=3'b010;
            end
            if(T[4]) begin
                ARF_RegSel=3'b101;
                RF_OutASel=3'b100;
                RF_OutBSel=3'b101;
                ALU_FunSel=5'b10100;
                MuxBSel=2'b00;
                ARF_FunSel=3'b010;
                RF_ScrSel=3'b111;
            end
            if(T[5])begin
                ARF_OutDSel=2'b10;
                Mem_WR=1'b1;
                MuxCSel=1'b0;
                RF_OutASel={1'b0,_ALUSystem.IROut[9:8]};
                ALU_FunSel=5'b10000;
                ARF_RegSel=3'b101;
                ARF_FunSel=3'b001;
                
            end
            
            if(T[6]) begin
                MuxCSel=1'b1;
                ARF_RegSel=3'b111;
                SCReset=1'b1; 
            end
        end
        endcase 
        end
    end
endmodule