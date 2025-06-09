module alu_rtl #(parameter width=8,parameter CMD_WIDTH = 4)(


                // Port Declaration
                input [width-1:0] OPA,OPB,
                input CLK,RST,CE,MODE,CIN,
                input [CMD_WIDTH-1:0] CMD,
                input [1:0]INP_VALID,
                output reg [2*width:0] RES,
                output reg COUT = 1'b0,
                output reg OFLOW = 1'b0,
                output reg G = 1'b0,
                output reg E = 1'b0,
                output reg L = 1'b0,
                output reg ERR = 1'b0);

// Arithmetic Operation CMD values
localparam [CMD_WIDTH-1:0] CMD_ADD      = 0;
localparam [CMD_WIDTH-1:0] CMD_SUB      = 1;
localparam [CMD_WIDTH-1:0] CMD_ADD_CIN  = 2;
localparam [CMD_WIDTH-1:0] CMD_SUB_CIN  = 3;
localparam [CMD_WIDTH-1:0] CMD_INC_A    = 4;
localparam [CMD_WIDTH-1:0] CMD_DEC_A    = 5;
localparam [CMD_WIDTH-1:0] CMD_INC_B    = 6;
localparam [CMD_WIDTH-1:0] CMD_DEC_B    = 7;
localparam [CMD_WIDTH-1:0] CMD_CMP      = 8;
localparam [CMD_WIDTH-1:0] CMD_INC_MUL  = 9;
localparam [CMD_WIDTH-1:0] CMD_SHIFT_MUL= 10;
localparam [CMD_WIDTH-1:0] CMD_SIGN_ADD = 11;
localparam [CMD_WIDTH-1:0] CMD_SIGN_SUB = 12;
// Logical Operation CMD values
localparam [CMD_WIDTH-1:0] CMD_AND      = 0;
localparam [CMD_WIDTH-1:0] CMD_NAND     = 1;
localparam [CMD_WIDTH-1:0] CMD_OR       = 2;
localparam [CMD_WIDTH-1:0] CMD_NOR      = 3;
localparam [CMD_WIDTH-1:0] CMD_XOR      = 4;
localparam [CMD_WIDTH-1:0] CMD_XNOR     = 5;
localparam [CMD_WIDTH-1:0] CMD_NOT_A    = 6;
localparam [CMD_WIDTH-1:0] CMD_NOT_B    = 7;
localparam [CMD_WIDTH-1:0] CMD_SHR1_A   = 8;
localparam [CMD_WIDTH-1:0] CMD_SHL1_A   = 9;
localparam [CMD_WIDTH-1:0] CMD_SHR1_B   = 10;
localparam [CMD_WIDTH-1:0] CMD_SHL1_B   = 11;
localparam [CMD_WIDTH-1:0] CMD_ROL_A_B  = 12;
localparam [CMD_WIDTH-1:0] CMD_ROR_A_B  = 13;


localparam bits = $clog2(width);        //Maximun numbers of bits to rotate(Used only in rotate command)


//Temporary register declaration
reg [width-1:0] OPA_1, OPB_1;
reg [bits-1:0]temp1;                  //Stores the Number of times to rotate(Used only in Rotate command)
reg signed [width-1:0]signed_OPA, signed_OPB;
reg signed [width:0]signed_RES;

reg [width-1:0] temp_OPA, temp_OPB;
reg [CMD_WIDTH-1:0] temp_CMD;
reg [1:0] temp_INP_VALID;
reg temp_MODE, temp_CIN;
reg [2*width-1:0]temp_res;
reg [2*width:0]temp_RES;
reg temp_COUT;
reg temp_OFLOW;
reg temp_G;
reg temp_E;
reg temp_L;
reg temp_ERR;

        always @(posedge CLK or posedge RST) begin
if(RST)
        begin
        RES=0;
        COUT=0;
        OFLOW=0;
        G=0;
        E=0;
        L=0;
        ERR=0;
        end
        else if (CE) begin
        temp_OPA <= OPA;
        temp_OPB <= OPB;
        temp_CMD <= CMD;
        temp_INP_VALID <= INP_VALID;
        temp_MODE <= MODE;
        temp_CIN <= CIN;
        end

        else
        begin
        temp_OPA <= temp_OPA;
        temp_OPB <= temp_OPB;
        temp_CMD <= temp_CMD;
        temp_INP_VALID <= temp_INP_VALID;
        temp_MODE <= temp_MODE;
        temp_CIN <= temp_CIN;
        end
        end

always@(*)
        begin

        temp_RES=0;
        temp_COUT=0;
        temp_OFLOW=0;
        temp_G=0;
        temp_E=0;
        temp_L=0;
        temp_ERR=0;

if(temp_MODE)          // Reset signal is active low. If MODE signal is high, then this is an Arithmetic Operation
        begin
case(temp_CMD)             // CMD is the binary code value of the Arithmetic Operation
        CMD_ADD:             // CMD = 0000: ADD
        begin
if(temp_INP_VALID ==3)
        begin

        temp_RES=temp_OPA+temp_OPB;
        temp_COUT=temp_RES[width]?1:0;
        temp_G=0;
        temp_E=0;
        temp_L=0;
        temp_ERR=0;
        end
        else
        begin
        temp_RES=0;
        temp_COUT=0;
        temp_ERR=1;
        temp_G=0;
        temp_E=0;
        temp_L=0;
        end
        end
        CMD_SUB:             // CMD = 0001: SUB
        begin
if(temp_INP_VALID ==3)
        begin
        temp_OFLOW=(temp_OPA<temp_OPB)?1:0;
        temp_RES=temp_OPA-temp_OPB;
        temp_G=0;
        temp_E=0;
        temp_L=0;
        temp_ERR=0;
        end
        else
        begin
        temp_OFLOW=0;
        temp_RES=0;
        temp_ERR=1;
        temp_G=0;
        temp_E=0;
        temp_L=0;
        end
        end
        CMD_ADD_CIN:             // CMD = 0010: ADD_CIN
        begin
if(temp_INP_VALID ==3)
        begin
        temp_RES=temp_OPA+temp_OPB+temp_CIN;
        temp_COUT=temp_RES[width]?1:0;
        temp_G=0;
        temp_E=0;
        temp_L=0;
        temp_ERR=0;
        end
        else
        begin
        temp_RES=0;
        temp_COUT=0;
        temp_ERR=1;
        temp_G=0;
        temp_E=0;
        temp_L=0;
        end
        end
        CMD_SUB_CIN:             // CMD = 0011: SUB_CIN. Here we set the overflow flag
        begin
if(temp_INP_VALID==3)
        begin
        temp_OFLOW=((temp_OPA<temp_OPB)||((temp_OPA==temp_OPB)&&temp_CIN))?1:0;
        temp_RES=temp_OPA-temp_OPB-temp_CIN;
        temp_ERR=0;
        temp_G=0;
        temp_E=0;
        temp_L=0;
        end
        else
        begin
        temp_RES=0;
        temp_OFLOW=0;
        temp_ERR=1;
        temp_G=0;
        temp_E=0;
        temp_L=0;
        end
        end
        CMD_INC_A:                // CMD = 0100: INC_A
        begin
if(temp_INP_VALID==1)
        begin
        temp_RES=temp_OPA+1;
        temp_OFLOW=temp_RES[width]?1:0;
        temp_ERR=0;
        temp_G=0;
        temp_E=0;
        temp_L=0;
        end
        else
        begin
        temp_RES=0;
        temp_ERR=1;
        temp_COUT=0;
        temp_G=0;
        temp_E=0;
        temp_L=0;
        end
        end
        CMD_DEC_A:               // CMD = 0101: DEC_A
        begin
if(temp_INP_VALID==1)
        begin
        temp_RES=temp_OPA-1;
        temp_OFLOW=temp_RES[width]?1:0;
        temp_G=0;
        temp_E=0;
        temp_L=0;
        end
        else
        begin
        temp_RES=0;
        temp_ERR=1;
        temp_COUT=0;
        temp_G=0;
        temp_E=0;
        temp_L=0;
        end
        end
        CMD_INC_B:                 // CMD = 0110: INC_B
        begin
if(temp_INP_VALID==2)
        begin
        temp_RES=temp_OPB+1;
        temp_OFLOW=temp_RES[width]?1:0;
        temp_G=0;
        temp_E=0;
        temp_L=0;
        end
        else
        begin
        temp_RES=0;
        temp_ERR=1;
        temp_COUT=0;
        temp_G=0;
        temp_E=0;
        temp_L=0;
        end
        end
        CMD_DEC_B:                 // CMD = 0111: DEC_B
        begin
if(temp_INP_VALID==2)
        begin
        temp_RES=temp_OPB-1;
        temp_OFLOW=temp_RES[width]?1:0;
        temp_G=0;
        temp_E=0;
        temp_L=0;
        end
        else
        begin
        temp_RES=0;
        temp_ERR=1;
        temp_G=0;
        temp_E=0;
        temp_L=0;
        temp_COUT=0;
        end
        end
        CMD_CMP:              // CMD = 1000: CMP
        begin
        temp_RES=0;
        temp_COUT=0;
if(temp_INP_VALID==3)
        begin
if(temp_OPA==temp_OPB)
        begin
        temp_E=1'b1;
        temp_G=1'b0;
        temp_L=1'b0;
        end
else if(temp_OPA>temp_OPB)
        begin
        temp_E=1'b0;
        temp_G=1'b1;
        temp_L=1'b0;
        end
        else begin
        temp_E=1'b0;
        temp_G=1'b0;
        temp_L=1'b1;
        end

        end
        else
        begin
        temp_E=1'b0;
        temp_G=1'b0;
        temp_L=1'b0;
        temp_ERR=1;
        end
        end
        CMD_SHIFT_MUL:           //Shift and multiply
        begin
        if (temp_INP_VALID == 3) begin
        temp_res= (temp_OPA << 1) * temp_OPB;
        temp_COUT=0;
        temp_ERR = 0;
        temp_G=0;
        temp_E=0;
        temp_L=0;
        end
        else
        begin
        temp_res = 0;
        temp_ERR = 1;
        temp_G=0;
        temp_E=0;
        temp_L=0;
        end
        end

        CMD_INC_MUL:             //Increment and multipy
        begin
        if (temp_INP_VALID == 3) begin
        temp_res = (temp_OPA + 1) * (temp_OPB + 1);
        temp_COUT=0;
        temp_ERR = 0;
        temp_G=0;
        temp_E=0;
        temp_L=0;
        end
        else
        begin
        temp_res = 0;
        temp_ERR = 1;
        temp_COUT=0;
        temp_G=0;
        temp_E=0;
        temp_L=0;
        end
        end

        CMD_SIGN_ADD:                                   //Signed add
        begin
if (temp_INP_VALID == 3)
        begin
        signed_OPA = $signed (temp_OPA);
        signed_OPB = $signed (temp_OPB);
        signed_RES = signed_OPA + signed_OPB;

        temp_RES = signed_RES;
        temp_OFLOW = (~signed_OPA[width-1] & ~signed_OPB[width-1] & temp_RES[width-1]) | (signed_OPA[width-1] & signed_OPB[width-1] & ~temp_RES[width-1]);

        temp_E = (signed_OPA == signed_OPB);
        temp_G = (signed_OPA > signed_OPB);
        temp_L = (signed_OPA < signed_OPB);
        temp_ERR = 1'b0;
        end
        else
        begin
        temp_RES  = 0;
        temp_COUT = 0;
        temp_OFLOW = 0;
        temp_G = 0;
        temp_E = 0;
        temp_L = 0;
        temp_ERR = 1;
        end
        end

        CMD_SIGN_SUB:                           //Signed Subtraction
        begin
if (temp_INP_VALID == 3)
        begin
        signed_OPA = $signed(temp_OPA);
        signed_OPB = $signed(temp_OPB);
        signed_RES = signed_OPA - signed_OPB;
        temp_RES = signed_RES;
        temp_OFLOW = (signed_OPA[width-1] != signed_OPB[width-1]) && (signed_RES[width-1] != signed_OPA[width-1]);
        temp_E = (signed_RES == 0);
        temp_G = (signed_OPA > signed_OPB);
        temp_L = (signed_OPA < signed_OPB);
        temp_ERR = 0;
        end
        else
        begin
        RES  = 0;
        COUT = 0;
        OFLOW = 0;
        G = 0;
        E = 0;
        L = 0;
        ERR = 1;
        end
        end


        default:   // For any other case send 0 value
        begin
        temp_RES=0;
        temp_COUT=0;
        temp_OFLOW=0;
        temp_G=0;
        temp_E=0;
        temp_L=0;
        temp_ERR=1;
        end
        endcase
        end

        else          // MODE signal is low, then this is a Logical Operation
        begin

case(temp_CMD)    // CMD is the binary code value of the Logical Operation
        CMD_AND:                       // CMD = 0000: AND
        begin
if(temp_INP_VALID == 3)
        temp_RES={1'b0,temp_OPA & temp_OPB};
else
begin
temp_RES=0;
temp_ERR=1;
end
end
CMD_NAND:                       // CMD = 0001: NAND
        begin
if(temp_INP_VALID == 3)
        temp_RES={1'b0,~(temp_OPA&temp_OPB)};
else
begin
temp_RES=0;
temp_ERR=1;
end
end
CMD_OR:
        begin                         // CMD = 0010: OR
if(temp_INP_VALID == 3)
        temp_RES={1'b0,temp_OPA|temp_OPB};
else
begin
temp_RES=0;
temp_ERR=1;
end
end
CMD_NOR:                           // CMD = 0011: NOR
        begin
if(temp_INP_VALID == 3)
        temp_RES={1'b0,~(temp_OPA|temp_OPB)};
else
begin
temp_RES=0;
temp_ERR=1;
end
end
CMD_XOR:                       // CMD = 0100: XOR
        begin
if(temp_INP_VALID == 3)
        temp_RES={1'b0,temp_OPA^temp_OPB};
else
begin
temp_RES=0;
temp_ERR=1;
end
end
CMD_XNOR:                       // CMD = 0101: XNOR
        begin
if(temp_INP_VALID == 3)
        temp_RES={1'b0,~(temp_OPA^temp_OPB)};
else
begin
temp_RES=0;
temp_ERR=1;
end
end
CMD_NOT_A:                        // CMD = 0110: NOT_A
        begin
if(temp_INP_VALID ==1)
        temp_RES={1'b0,~temp_OPA};
else
begin
temp_RES=0;
temp_ERR=1;
end
end
CMD_NOT_B:                         // CMD = 0111: NOT_B
        begin
if(temp_INP_VALID ==2)
        temp_RES={1'b0,~temp_OPB};
else
begin
temp_RES=0;
temp_ERR=1;
end
end
CMD_SHR1_A:                          // CMD = 1000: SHR1_A
        begin
if(temp_INP_VALID ==1)
        temp_RES={1'b0,temp_OPA>>1};
else
begin
temp_RES=0;
temp_ERR=1;
end
end
CMD_SHL1_A:                         // CMD = 1001: SHL1_A
        begin
if(temp_INP_VALID ==1)
        temp_RES={1'b0,temp_OPA<<1};
else
begin
temp_RES=0;
temp_ERR=1;
end
end
CMD_SHR1_B:                         // CMD = 1010: SHR1_B
        begin
if(temp_INP_VALID ==2)
        temp_RES={1'b0,temp_OPB>>1};
else
begin
temp_RES=0;
temp_ERR=1;
end
end
CMD_SHL1_B:                         // CMD = 1011: SHL1_B
        begin
if(temp_INP_VALID ==2)
        temp_RES={1'b0,temp_OPB<<1};
else
begin
temp_RES=0;
temp_ERR=1;
end
end
CMD_ROL_A_B:                        // CMD = 1100: ROL_A_B
        begin
if(temp_INP_VALID==3)
        begin
        temp1 = temp_OPB[bits-1:0];
        temp_RES = {1'b0,(temp_OPA<<temp1)|(temp_OPA>>((width)-temp1))};
temp_ERR = (temp_OPB>width-1)?1:0;
end
else
begin
temp_RES=0;
temp_ERR=1;
end
end
CMD_ROR_A_B:                        // CMD = 1101: ROR_A_B
        begin
if(temp_INP_VALID==3)
        begin
        temp1 = temp_OPB[bits-1:0];
        temp_RES = {1'b0,(temp_OPA>>temp1)|(temp_OPA<<((width)-temp1))};
temp_ERR = (temp_OPB>width-1)?1:0;
end
else
begin
temp_RES=0;
temp_ERR=1;
end
end
default:    // For any other case send 0 value
begin
temp_RES=0;
temp_COUT=0;
temp_OFLOW=0;
temp_G=1'b0;
temp_E=1'b0;
temp_L=1'b0;
temp_ERR=1'b0;
end
endcase
end
        end
always@(posedge CLK or posedge RST)
        begin
if(RST)
        begin

        RES=0;
        COUT=0;
        OFLOW=0;
        G=0;
        E=0;
        L=0;
        ERR=0;
        end
else if(CE)
        begin
if((temp_CMD == 9 || temp_CMD == 10)&&(temp_MODE == 1))
        begin
        temp_RES <= {1'b0,temp_res};
RES <= temp_RES;
COUT<=temp_COUT;
OFLOW<=temp_OFLOW;
G<=temp_G;
E<=temp_E;
L<=temp_L;
ERR<=temp_ERR;

end
else
begin
RES<=temp_RES;
COUT<=temp_COUT;
OFLOW<=temp_OFLOW;
G<=temp_G;
E<=temp_E;
L<=temp_L;
ERR<=temp_ERR;
end
end
else
begin
temp_RES<=temp_RES;
temp_COUT<=temp_COUT;
temp_OFLOW<=temp_OFLOW;
temp_G<=temp_G;
temp_E<=temp_E;
temp_L<=temp_L;
temp_ERR<=temp_ERR;
end
end
endmodule

