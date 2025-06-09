`include "design.v"

module alu_testbench;

parameter DATA_WIDTH = 8, CMD_WIDTH = 4;

reg CLK, CE, RESET, MODE, CIN;

reg [CMD_WIDTH-1 : 0]CMD;

reg [1:0] IN_VALID;

reg [(DATA_WIDTH-1) : 0]OPA;

reg [(DATA_WIDTH-1) : 0]OPB;

wire ERR, OFLOW, COUT, G, L,E;

wire [2*DATA_WIDTH-1 : 0]RESULT;


alu_rtl #(DATA_WIDTH, CMD_WIDTH)dut(.CLK(CLK), .CE(CE), .RST(RESET), .INP_VALID(IN_VALID), .MODE(MODE), .CMD(CMD), .OPA(OPA), .OPB(OPB), .CIN(CIN), .RES(RESULT), .ERR(ERR), .OFLOW(OFLOW), .COUT(COUT), .G(G), .L(L), .E(E));

initial begin

        $dumpfile("alu_wave.vcd");

        $dumpvars(0,alu_testbench);

end

initial begin

CLK = 0; CE = 1;

RESET = 1;

MODE = 1;

CMD = 'b00;

IN_VALID = 2'b0;

OPA = 'b0;

OPB = 'b0;

CIN = 0;

end

always #5 CLK = ~CLK;

initial begin

$monitor("[%0t] OPA = %d | OPB = %d | CIN = %d | IN_VALID =%b | MODE =%b | CMD =%b\nRESULT =%d| COUT =%b | OFLOW =%b | ERR =%b",$time,OPA, OPB, CIN, IN_VALID, MODE, CMD, RESULT, COUT, OFLOW, ERR);
OPA = 'd217; OPB = 'd117; CIN = 1; MODE = 1;
#10 RESET =0;


IN_VALID = 2'b11;

#20;


#20 CMD = 'b 0001;

#20 CMD = 'b0010;

#20 CMD = 'b0011;

#20 CMD = 'b0100;

#20 CMD = 'b0101;

#20 CMD = 'b0110;

#20 CMD = 'b0111;

#20 CMD = 'b1000;

#20 CMD = 'b1001;

#20 CMD = 'b1010;

#20;

CMD = 'b1011;

OPA = 'b0111_1000; OPB = 'b0111_1000; //120,120

#20; OPA = 'b0; OPB = 'b0;

#20 OPA = 'b0110_0010; OPB = 'b00001111;//98,15

#20; OPA = 'b0; OPB = 'b0;

#20 OPA = 'b1001_1110; OPB = 'b00001111;//-98,15

#20; OPA = 'b0; OPB = 'b0;

#20 OPA = 'b0110_0010; OPB = 'b11110001;//98,-15

#20; OPA = 'b0; OPB = 'b0;

#20 OPA = 'b0110_0100; OPB = 'b10001000;//100,-120

#20; OPA = 'b0; OPB = 'b0;

#20 OPA = 'b1001_1110; OPB = 'b11110001;//-98,-15

#20; OPA = 'b0; OPB = 'b0;

#20;

CMD = 'b1100;

OPA = 'b0111_1000; OPB = 'b0111_1000; //120,120

#20; OPA = 'b0; OPB = 'b0;

#20 OPA = 'b0110_0010; OPB = 'b00001111;//98,15

#20; OPA = 'b0; OPB = 'b0;

#20 OPA = 'b1001_1110; OPB = 'b00001111;//-98,15

#20; OPA = 'b0; OPB = 'b0;

#20 OPA = 'b0110_0010; OPB = 'b11110001;//98,-15

#20; OPA = 'b0; OPB = 'b0;

#20 OPA = 'b0110_0100; OPB = 'b10001000;//100,-120

#20; OPA = 'b0; OPB = 'b0;

#20 OPA = 'b1001_1110; OPB = 'b11110001;//-98,-15

#20; OPA = 'b0; OPB = 'b0;

#20; MODE = 0;

#20 CMD = 'b0000;

#20 CMD = 'b0001;

#20 CMD = 'b0010;

#20 CMD = 'b0011;

#20 CMD = 'b0100;

#20 CMD = 'b0101;

#20 CMD = 'b0110;

#20 CMD = 'b0111;

#20 CMD = 'b1000;

#20 CMD = 'b1001;

#20 CMD = 'b1010;

#20 CMD = 'b1011;

#20 OPA = 'd15; OPB = 'd3;

#20 CMD = 'b1100;

#20 CMD = 'b1101;

#50 $finish;

end


endmodule

