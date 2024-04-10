`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2024 06:18:37 PM
// Design Name: 
// Module Name: lib
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


module lib(

    );
endmodule

//-----------------------------------------------------------
// Library parts I
// ---------------
// EE382N-14945, Spring 2000.
// (Modified from those provided by Cascade Design Automation Corp).
// All module parts' name are appended with a "$" character.
// This part of the library consists of the following gates and flip flop:
//
// nand2$	-  2 inputs nand
// nand3$	-  3 inputs nand
// nand4$	-  4 inputs nand
// and2$	-  2 inputs and
// and3$	-  3 inputs and
// and4$	-  4 inputs and
// nor2$	-  2 inputs nor 
// nor3$	-  3 inputs nor 
// nor4$	-  4 inputs nor 
// or2$		-  2 inputs or 
// or3$		-  3 inputs or 
// or4$		-  4 inputs or 
// xor2$	-  2 inputs xor 
// xnor2$	-  2 inputs xnor 
// inv1$	-  1 input inverter 
// dff$		-  edge-triggered D-ff with set/reset
//
// Timing specs are taken from page 1-47.
//-----------------------------------------------------------
`celldefine
module  nand2$(out, in0, in1);
	input	in0, in1;
	output	out;

	nand (out, in0, in1);

	specify
            (in0 *> out) = (0.18:0.2:0.22, 0.18:0.2:0.22);
            (in1 *> out) = (0.18:0.2:0.22, 0.18:0.2:0.22);
	endspecify
endmodule
`endcelldefine

`celldefine
module  nand3$(out, in0, in1, in2);
	input	in0, in1, in2;
	output	out;

	nand (out, in0, in1, in2);

	specify
            (in0 *> out) = (0.18:0.2:0.22, 0.18:0.2:0.22);
            (in1 *> out) = (0.18:0.2:0.22, 0.18:0.2:0.22);
            (in2 *> out) = (0.18:0.2:0.22, 0.18:0.2:0.22);
	endspecify
endmodule
`endcelldefine

`celldefine
module  nand4$(out, in0, in1, in2, in3);
	input in0, in1, in2, in3;
	output out;

	nand (out, in0, in1, in2, in3);

	specify
            (in0 *> out) = (0.22:0.25:0.28, 0.22:0.25:0.28);
            (in1 *> out) = (0.22:0.25:0.28, 0.22:0.25:0.28);
            (in2 *> out) = (0.22:0.25:0.28, 0.22:0.25:0.28);
            (in3 *> out) = (0.22:0.25:0.28, 0.22:0.25:0.28);
	endspecify
endmodule
`endcelldefine



//-----------------------------------------------------------
`celldefine
module  and2$(out, in0, in1);
	input in0, in1;
	output out;

	and (out, in0, in1);

	specify
            (in0 *> out) = (0.32:0.35:0.38, 0.32:0.35:0.38);
            (in1 *> out) = (0.32:0.35:0.38, 0.32:0.35:0.38);
	endspecify
endmodule
`endcelldefine

`celldefine
module  and3$(out, in0, in1, in2);
	input	in0, in1, in2;
	output	out;

	and (out, in0, in1, in2);

	specify
            (in0 *> out) = (0.32:0.35:0.38, 0.32:0.35:0.38);
            (in1 *> out) = (0.32:0.35:0.38, 0.32:0.35:0.38);
            (in2 *> out) = (0.32:0.35:0.38, 0.32:0.35:0.38);
	endspecify
endmodule
`endcelldefine

`celldefine
module  and4$(out, in0, in1, in2, in3);
	input in0, in1, in2, in3;
	output out;

	and (out, in0, in1, in2, in3);

	specify
            (in0 *> out) = (0.36:0.40:0.44, 0.36:0.40:0.44);
            (in1 *> out) = (0.36:0.40:0.44, 0.36:0.40:0.44);
            (in2 *> out) = (0.36:0.40:0.44, 0.36:0.40:0.44);
            (in3 *> out) = (0.36:0.40:0.44, 0.36:0.40:0.44);
	endspecify
endmodule
`endcelldefine

   

//-----------------------------------------------------------
`celldefine
module  nor2$(out, in0, in1);
	input in0, in1;
	output out;

	nor (out, in0, in1);

	specify
            (in0 *> out) = (0.18:0.2:0.22, 0.18:0.2:0.22);
            (in1 *> out) = (0.18:0.2:0.22, 0.18:0.2:0.22);
	endspecify
endmodule
`endcelldefine

`celldefine
module  nor3$(out, in0, in1, in2);
	input in0, in1, in2;
	output out;

	nor (out, in0, in1, in2);

	specify
            (in0 *> out) = (0.22:0.25:0.28, 0.22:0.25:0.28);
            (in1 *> out) = (0.22:0.25:0.28, 0.22:0.25:0.28);
            (in2 *> out) = (0.22:0.25:0.28, 0.22:0.25:0.28);
	endspecify
endmodule
`endcelldefine

`celldefine
module  nor4$(out, in0, in1, in2, in3);
	input in0, in1, in2, in3;
	output out;

	nor (out, in0, in1, in2, in3);

	specify
            (in0 *> out) = (0.32:0.35:0.38, 0.32:0.35:0.38);
            (in1 *> out) = (0.32:0.35:0.38, 0.32:0.35:0.38);
            (in2 *> out) = (0.32:0.35:0.38, 0.32:0.35:0.38);
            (in3 *> out) = (0.32:0.35:0.38, 0.32:0.35:0.38);
	endspecify
endmodule
`endcelldefine

                                             
`celldefine
module  or2$(out, in0, in1);
	input in0, in1;
	output out;

	or (out, in0, in1);

	specify
            (in0 *> out) = (0.32:0.35:0.38, 0.32:0.35:0.38);
            (in1 *> out) = (0.32:0.35:0.38, 0.32:0.35:0.38);
	endspecify
endmodule
`endcelldefine


//-----------------------------------------------------------
`celldefine
module  or3$(out, in0, in1, in2);
	input in0, in1, in2;
	output out;

	or (out, in0, in1, in2);

	specify
            (in0 *> out) = (0.36:0.40:0.44, 0.36:0.40:0.44);
            (in1 *> out) = (0.36:0.40:0.44, 0.36:0.40:0.44);
            (in2 *> out) = (0.36:0.40:0.44, 0.36:0.40:0.44);
	endspecify
endmodule
`endcelldefine

`celldefine
module  or4$(out, in0, in1, in2, in3);
	input in0, in1, in2, in3;
	output out;

	or (out, in0, in1, in2, in3);

	specify
            (in0 *> out) = (0.46:0.50:0.54, 0.46:0.50:0.54);
            (in1 *> out) = (0.46:0.50:0.54, 0.46:0.50:0.54);
            (in2 *> out) = (0.46:0.50:0.54, 0.46:0.50:0.54);
            (in3 *> out) = (0.46:0.50:0.54, 0.46:0.50:0.54);
	endspecify
endmodule
`endcelldefine



//-----------------------------------------------------------
`celldefine
module  xor2$ (out, in0, in1);
	input in0, in1;
	output out;

	xor (out, in0, in1);

	specify
            (in0 *> out) = (0.27:0.30:0.33, 0.27:0.30:0.33);
            (in1 *> out) = (0.27:0.30:0.33, 0.27:0.30:0.33);
	endspecify
endmodule
`endcelldefine


//-----------------------------------------------------------
`celldefine
module  xnor2$ (out, in0, in1);
	input in0, in1;
	output out;

	xnor (out, in0, in1);

	specify
            (in0 *> out) = (0.22:0.25:0.28, 0.22:0.25:0.28);
            (in1 *> out) = (0.22:0.25:0.28, 0.22:0.25:0.28);
	endspecify
endmodule
`endcelldefine


//-----------------------------------------------------------
// Timing specs taken from page 1-47.
`celldefine
module  inv1$ (out, in);
	input in;
	output out;

	not (out, in);

	specify
            (in *> out) = (0.13:0.15:0.17, 0.13:0.15:0.17);
	endspecify
endmodule
`endcelldefine


//-----------------------------------------------------------
// Edge-Triggered D-ff
// Timing specs taken from page 1-10.
primitive table_dffq(q, d, clk, s, r);
    input d, clk, s, r;
    output q;
    reg q;

    table
    //  d  clk  s  r : q  : q+
	?   ?   0  0 : ?  : x;

	?   ?   1  0 : ?  : 0; //clear logic
	?   ?   1  * : 0  : 0;

	?   ?   0  1 : ?  : 1; //preset logic
	?   ?   *  1 : 1  : 1;

        1   r   1  1 : ?  : 1; //normal clocking
        0   r   1  1 : ?  : 0;
	?   f   1  1 : ?  : -; //ignore negative edge of clock
	*   ?   1  1 : ?  : -; //ignore data changes on a steady clock
    endtable
endprimitive

`celldefine
module  dff$(clk, d, q, qbar, r, s);
	input  s, d, r, clk;
	output qbar, q;

	table_dffq(q, d, clk, s, r);
	not(qbar, q);

	specify
            (clk *> q)    = (0.06:0.08:0.10);
	    // assume t_plh(Q) = t_plh(QBAR)
	    //        t_phl(Q) = t_phl(QBAR)
            (clk *> qbar) = (0.06:0.08:0.10);
            (s *> q)      = (0.36:0.40:0.44);
            (s *> qbar)   = (0.36:0.40:0.44);
            (r *> q)      = (0.32:0.35:0.38);
            (r *> qbar)   = (0.32:0.35:0.38);
            $setup(d, edge[01,x1] clk,0.18:0.2:0.22);
            $width(edge[01,x1] s,     0.32:0.35:0.38);
            $width(edge[01,x1] r,     0.32:0.35:0.38);
            $width(edge[01,x1] clk,   0.32:0.35:0.38);
	endspecify
endmodule
`endcelldefine



//-----------------------------------------------------------
// Library parts II
// ----------------
// EE382N-14945, Spring 2000.
// (Some are modified from those provided by Cascade Design Automation Corp).
// All module parts' name are appended with a "$" character.
// This part of the library consists of the following gates and flip flop:
//
// dff8$			-  8-bits D-flip flop
// dff16$			-  16-bits D-flip flop
//
// jkff8$			-  8-bits JK-flip flop
// jkff16$			-  16-bits JK-flip flop
//
// buffer$			   -  1-bit  buffer to drive upto 4 gates
// bufferH16$		   -  High load 1-bit non-inv buffer to drive upto 16 gates
// bufferH64$		   -  High load 1-bit non-inv buffer to drive upto 64 gates
// bufferH256$		   -  High load 1-bit non-inv buffer to drive upto 256 gates
// bufferH1024$	   -  High load 1-bit non-inv buffer to drive upto 1024 gates
// bufferHInv16$		-  High load 1-bit inv buffer to drive upto 16 gates
// bufferHInv64$		-  High load 1-bit inv buffer to drive upto 64 gates
// bufferHInv256$		-  High load 1-bit inv buffer to drive upto 256 gates
// bufferHInv1024$	-  High load 1-bit inv buffer to drive upto 1024 gates
//
// buffer8$			-  8-bits buffer
// buffer16$			-  16-bits buffer
//
// latch$			-  1-bit  "transparent" latch
// latch8$			-  8-bits "transparent" latch
// latch16$			-  16-bits "transparent" latch
//
// tristateL$			-  1-bit   lightly loaded tristate buffer
// tristate8L$			-  8-bits  lightly loaded tristate buffer
// tristate16L$			-  16-bits lightly loaded tristate buffer
//
// tristateH$			-  1-bit   heavily loaded tristate buffer
// tristate8H$			-  8-bits  heavily loaded tristate buffer
// tristate16H$			-  16-bits heavily loaded tristate buffer
//
// tristate_bus_driver1$	- 1-bit tristate external bus driver
// tristate_bus_driver8$	- 8-bit tristate external bus driver
// tristate_bus_driver16$	- 16-bits tristate external bus driver
//
// tristatexL$ and tristatexH$ are used to modelthe same tristate logic.
// tristatexL$ are used to model tristate buffers under light loading 
// conditions (less than five receivers).  If the output of the buffer 
// has more than five receivers, then tristatexH$ should be used.
//
// dff16b$			-  16-bits D-flip flop with bit addressable
// dff32b$			-  32-bits D-flip flop with bit addressable
//
// reg64e$			-  64-bits registers with write enable
// reg32e$			-  32-bits register with write enable
// ioreg8$			- 8-bit IO register (D-flip flop)
// ioreg16$			- 16-bits IO register (D-flip flop)
//
//-------------------------------------------------------------
//      Edge triggered   D  flip flip:   8-bits
//
// 	 Timing specs are taken from page 1-10.
//-------------------------------------------------------------
module dff8$(CLK, D, Q, QBAR, CLR, PRE);
  input  CLK;
  input  CLR;
  input [7:0] D;
  input  PRE;
  output [7:0] Q;
  output [7:0] QBAR;
  reg    [7:0] Q;
  reg    [7:0] D_temp;
  wire  CLK_temp;
  wire  CLR_temp;
  wire  PRE_temp;

  assign #(0.28:0.32:0.36) CLK_temp = CLK; //t_plh = t_phl 
	//assuming: t_plh(Q) = t_plh(QBAR) = t_phl(Q) = t_phl(QBAR)
  assign #(0.50:0.54:0.58) PRE_temp = PRE; //t_p(PRE)
  assign #(0.42:0.46:0.50) CLR_temp = CLR; //t_p(CLR)
  assign QBAR = ~Q;
  always@(posedge CLK) D_temp = D;

  always
    @(PRE_temp or CLR_temp)
      begin
      if(((CLR_temp == 1'b0) && (PRE_temp == 1'b1)))
        begin
        Q = 'b0;
        end
      else      if(((PRE_temp == 1'b0) && (CLR_temp == 1'b1)))
        begin
        Q = ( ~ 'b0);
        end
      else      if(((CLR_temp != 1'b1) || (PRE_temp != 1'b1)))
        begin
        Q = 'bx;
        end
      end

  always 
    @(posedge CLK_temp) if (((PRE_temp == 1'b1) && (CLR_temp == 1'b1))) Q = D_temp;

  specify
    specparam
      //t_hold_D = 0,
      t_setup_D   = (0.12:0.14:0.16),
      //t_width_CLK = (0.21:0.24:0.27),
      t_width_PRE = (0.21:0.24:0.27),
      t_width_CLR = (0.21:0.24:0.27);
    //$hold(posedge CLK , D , t_hold_D);
    $setup(D , posedge CLK , t_setup_D);
    //$width(negedge CLK , t_width_CLK);
    $width(negedge PRE , t_width_PRE);
    $width(negedge CLR , t_width_CLR);
  endspecify
endmodule

//-------------------------------------------------------------
//      Edge triggered   D  flip flip:   16-bits
//
// 	 Timing specs are taken from page 1-10.
//-------------------------------------------------------------

module dff16$(CLK, D, Q, QBAR, CLR, PRE);
  input  CLK;
  input  CLR;
  input [15:0] D;
  input  PRE;
  output [15:0] Q;
  output [15:0] QBAR;
  reg    [15:0] Q;
  reg    [15:0] D_temp;
  wire  CLK_temp;
  wire  CLR_temp;
  wire  PRE_temp;

  assign #(0.28:0.32:0.36) CLK_temp = CLK; //t_plh = t_phl 
	//assuming: t_plh(Q) = t_plh(QBAR) = t_phl(Q) = t_phl(QBAR)
  assign #(0.50:0.54:0.58) PRE_temp = PRE; //t_p(PRE)
  assign #(0.42:0.46:0.50) CLR_temp = CLR; //t_p(CLR)
  assign QBAR = ~Q;
  always@(posedge CLK) D_temp = D;

  always
    @(PRE_temp or CLR_temp)
      begin
      if(((CLR_temp == 1'b0) && (PRE_temp == 1'b1)))
        begin
        Q = 'b0;
        end
      else      if(((PRE_temp == 1'b0) && (CLR_temp == 1'b1)))
        begin
        Q = ( ~ 'b0);
        end
      else      if(((CLR_temp != 1'b1) || (PRE_temp != 1'b1)))
        begin
        Q = 'bx;
        end
      end

  always
    @(posedge CLK_temp) if (((PRE_temp == 1'b1) && (CLR_temp == 1'b1))) Q = D_temp;

  specify
    specparam
      //t_hold_D = 0,
      t_setup_D   = (0.12:0.14:0.16),
      //t_width_CLK = (0.21:0.24:0.27),
      t_width_PRE = (0.21:0.24:0.27),
      t_width_CLR = (0.21:0.24:0.27);
    //$hold(posedge CLK , D , t_hold_D);
    $setup(D , posedge CLK , t_setup_D);
    //$width(negedge CLK , t_width_CLK);
    $width(negedge PRE , t_width_PRE);
    $width(negedge CLR , t_width_CLR);
  endspecify
endmodule

//-------------------------------------------------------------
//	J   K      F l i p   F l o p:   8-bits
//
// 	  Timing specs taken from page 1-52.
//-------------------------------------------------------------
module jkff8$(CLK,CLR,J,K,PRE,Q,QBAR);
  input  CLK;
  input  CLR;
  input [7:0] J;
  input [7:0] K;
  input  PRE;
  output [7:0] Q;
  output [7:0] QBAR;
  reg    [7:0] Q;
  reg    [7:0] temp;
  wire  CLK_temp;
  wire  CLR_temp;
  wire  PRE_temp;

  assign #(0.28:0.32:0.36, 0.46:0.50:0.54) 	CLK_temp = CLK;
  assign #(0.23:0.26:0.29) 		PRE_temp = PRE;
  assign #(0.48:0.52:0.56) 		CLR_temp = CLR;
  assign QBAR = ~Q;


  always
    @(PRE_temp or CLR_temp)
      begin
      if(((CLR_temp == 1'b0) && (PRE_temp == 1'b1)))
        Q    = 'b0;
      else      if(((PRE_temp == 1'b0) && (CLR_temp == 1'b1)))
        Q    = ( ~ 'b0);
      else      if(((CLR_temp != 1'b1) || (PRE_temp != 1'b1)))
        Q = 'bx;
      end

  always 
    @(posedge CLK_temp)
      if(((PRE_temp == 1'b1) && (CLR_temp == 1'b1)))
	begin	temp = ((( ~ K) & (J | Q)) | (J & ( ~ Q)));
		Q = temp;
	end

  specify
    specparam
      //t_hold_J = 0,
      t_setup_J = (0.46:0.50:0.54),
      //t_hold_K = 0,
      t_setup_K = (0.44:0.48:0.52),
      //t_width_CLK = (0.16:0.18:0.20),
      t_width_PRE = (0.16:0.18:0.20),
      t_width_CLR = (0.16:0.18:0.20);
    //$hold(posedge CLK , J , t_hold_J);
    $setup(J , posedge CLK , t_setup_J);
    //$hold(posedge CLK , K , t_hold_K);
    $setup(K , posedge CLK , t_setup_K);
    //$width(negedge CLK , t_width_CLK);
    $width(negedge PRE , t_width_PRE);
    $width(negedge CLR , t_width_CLR);
  endspecify
endmodule


//-------------------------------------------------------------
//	J   K      F l i p   F l o p:   16-bits
//
// 	  Timing specs taken from page 1-52.
//-------------------------------------------------------------
module jkff16$(CLK,CLR,J,K,PRE,Q,QBAR);
  input  CLK;
  input  CLR;
  input [15:0] J;
  input [15:0] K;
  input  PRE;
  output [15:0] Q;
  output [15:0] QBAR;
  reg    [15:0] Q;
  reg    [15:0] temp;
  wire  CLK_temp;
  wire  CLR_temp;
  wire  PRE_temp;

  assign #(0.28:0.32:0.36, 0.46:0.50:0.54) 	CLK_temp = CLK;
  assign #(0.23:0.26:0.29) 		PRE_temp = PRE;
  assign #(0.48:0.52:0.56) 		CLR_temp = CLR;
  assign QBAR = ~Q;


  always
    @(PRE_temp or CLR_temp)
      begin
      if(((CLR_temp == 1'b0) && (PRE_temp == 1'b1)))
        Q    = 'b0;
      else      if(((PRE_temp == 1'b0) && (CLR_temp == 1'b1)))
        Q    = ( ~ 'b0);
      else      if(((CLR_temp != 1'b1) || (PRE_temp != 1'b1)))
        Q = 'bx;
      end

  always 
    @(posedge CLK_temp)
      if(((PRE_temp == 1'b1) && (CLR_temp == 1'b1)))
	begin	temp = ((( ~ K) & (J | Q)) | (J & ( ~ Q)));
		Q = temp;
	end

  specify
    specparam
      //t_hold_J = 0,
      t_setup_J = (0.46:0.50:0.54),
      //t_hold_K = 0,
      t_setup_K = (0.44:0.48:0.52),
      //t_width_CLK = (0.16:0.18:0.20),
      t_width_PRE = (0.16:0.18:0.20),
      t_width_CLR = (0.16:0.18:0.20);
    //$hold(posedge CLK , J , t_hold_J);
    $setup(J , posedge CLK , t_setup_J);
    //$hold(posedge CLK , K , t_hold_K);
    $setup(K , posedge CLK , t_setup_K);
    //$width(negedge CLK , t_width_CLK);
    $width(negedge PRE , t_width_PRE);
    $width(negedge CLR , t_width_CLR);
  endspecify
endmodule


//--------------------------------------------------------------------
//	N o n i n v e r t i n g    B u f f e r:   1, 8 and 16 bits
//
//		Timing specs are taken from page 1-6.
//--------------------------------------------------------------------
`celldefine
module  buffer$(out, in);
  input  in;
  output out;
  buf (strong0, strong1) (out, in);
  specify
	(in *> out) = (0.21:0.24:0.27, 0.21:0.24:0.27);
  endspecify
endmodule
`endcelldefine

module  buffer8$(out, in);
 	input  [7:0] in;
	output [7:0] out;
	assign (strong0, strong1) #(0.21:0.24:0.27, 0.21:0.24:0.27) out = in;
endmodule

module  buffer16$(out, in);
 	input  [15:0] in;
	output [15:0] out;
	assign (strong0, strong1) #(0.21:0.24:0.27, 0.21:0.24:0.27) out = in;
endmodule

//--------------------------------------------------------------------
//	H i g h l o a d    N o n i n v e r t i n g    B u f f e r s
//            See top of file for their descriptions
//		
//--------------------------------------------------------------------

`celldefine
module  bufferH16$(out, in);
  input  in;
  output out;
  buf (strong0, strong1) (out, in);
  specify
	(in *> out) = (0.21:0.24:0.27, 0.21:0.24:0.27);
  endspecify
endmodule
`endcelldefine

`celldefine
module  bufferH64$(out, in);
  input  in;
  output out;
  buf (strong0, strong1) (out, in);
  specify
	(in *> out) = (0.26:0.30:0.34, 0.26:0.30:0.34);
  endspecify
endmodule
`endcelldefine

`celldefine
module  bufferH256$(out, in);
  input  in;
  output out;
  buf (strong0, strong1) (out, in);
  specify
	(in *> out) = (0.47:0.54:0.61, 0.47:0.54:0.61);
  endspecify
endmodule
`endcelldefine

`celldefine
module  bufferH1024$(out, in);
  input  in;
  output out;
  buf (strong0, strong1) (out, in);
  specify
	(in *> out) = (0.52:0.60:0.68, 0.52:0.60:0.68);
  endspecify
endmodule
`endcelldefine

`celldefine
module  bufferH4096$(out, in);
  input  in;
  output out;
  buf (strong0, strong1) (out, in);
  specify
	(in *> out) = (0.72:0.80:0.88, 0.72:0.80:0.88);
  endspecify
endmodule
`endcelldefine

//--------------------------------------------------------------------
//	H i g h l o a d    I n v e r t i n g    B u f f e r s
//            See top of file for their descriptions
//		
//--------------------------------------------------------------------

`celldefine
module  bufferHInv16$(out, in);
  input  in;
  output out;
  not (strong0, strong1) (out, in);
  specify
	(in *> out) = (0.13:0.15:0.17, 0.13:0.15:0.17);
  endspecify
endmodule
`endcelldefine

`celldefine
module  bufferHInv64$(out, in);
  input  in;
  output out;
  not (strong0, strong1) (out, in);
  specify
	(in *> out) = (0.34:0.39:0.44, 0.34:0.39:0.44);
  endspecify
endmodule
`endcelldefine

`celldefine
module  bufferHInv256$(out, in);
  input  in;
  output out;
  not (strong0, strong1) (out, in);
  specify
	(in *> out) = (0.39:0.45:0.51, 0.39:0.45:0.51);
  endspecify
endmodule
`endcelldefine

`celldefine
module  bufferHInv1024$(out, in);
  input  in;
  output out;
  not (strong0, strong1) (out, in);
  specify
	(in *> out) = (0.60:0.69:0.78, 0.60:0.69:0.78);
  endspecify
endmodule
`endcelldefine

`celldefine
module  bufferHInv4096$(out, in);
  input  in;
  output out;
  not (strong0, strong1) (out, in);
  specify
	(in *> out) = (0.80:0.89:0.98, 0.80:0.89:0.98);
  endspecify
endmodule
`endcelldefine



//----------------------------------------------------------------------
//		L  a  t  c  h :      1, 8 and 16 bits.
//
// 		Timing specs taken from page 1-56.
//----------------------------------------------------------------------

primitive latch_sr(q,d,en,s,r);
  input   d,en,s,r;
  output  q;
  reg     q;
  table
//  d  en s  r   state  q
    ?  ?  0  0  :  ?  : x ;
    ?  ?  1  0  :  ?  : 0 ;
    ?  ?  0  1  :  ?  : 1 ;
    ?  ?  1  *  :  0  : 0 ;
    ?  ?  *  1  :  1  : 1 ;

    ?  0  1  1  :  ?  : - ;
    1  1  1  1  :  ?  : 1 ;
    0  1  1  1  :  ?  : 0 ;
    0  x  1  1  :  0  : - ;
    1  x  1  1  :  1  : - ;
  endtable
endprimitive

`celldefine
module  latch$(d, en, q, qbar, r, s);
  input   d, en, s, r;
  output  q, qbar;

  latch_sr(q, d, en, s, r);
  not(qbar, q);

    specify
	(d   *> q)    = (0.44:0.48:0.52,0.46:0.50:0.54);
	(d   *> qbar) = (0.44:0.48:0.52,0.46:0.50:0.54);
	(en  *> q)    = (0.42:0.46:0.50,0.50:0.54:0.58);
	(en  *> qbar) = (0.42:0.46:0.50,0.50:0.54:0.58);
	(s   *> q)    = (0.32:0.36:0.40);
	(s   *> qbar) = (0.32:0.36:0.40);
	(r   *> q)    = (0.32:0.36:0.40);
	(r   *> qbar) = (0.32:0.36:0.40);
        $setup(d, edge[10,1x] en, 0.16:0.18:0.20);
        $width(edge[01,x1] s,     0.16:0.18:0.20);
        $width(edge[01,x1] r,     0.16:0.18:0.20);
        $width(edge[01,x1] en,    0.16:0.18:0.20);
    endspecify
endmodule
`endcelldefine

module latch8$(CLR,D,EN,PRE,Q);
  input  CLR;
  input [7:0] D;
  input  EN;
  input  PRE;
  output [7:0] Q;
  reg    [7:0] Q;
  wire  CLR_temp;
  wire [7:0] D_temp;
  wire  EN_temp;
  wire  PRE_temp;
  assign #(0.44:0.48:0.52, 0.46:0.50:0.54) D_temp = D;
  assign #(0.42:0.46:0.50, 0.50:0.54:0.58) EN_temp = EN;
  assign #(0.32:0.36:0.40) PRE_temp = PRE;
  assign #(0.32:0.36:0.40) CLR_temp = CLR;
  always
    @(CLR_temp or PRE_temp or EN_temp or D_temp)
      begin
      if(((CLR_temp == 1'b0) && (PRE_temp == 1'b1)))
        Q = 'b0;
      else      if(((PRE_temp == 1'b0) && (CLR_temp == 1'b1)))
        Q = ( ~ 'b0);
      else      if(((CLR_temp != 1'b1) || (PRE_temp != 1'b1)))
        Q = 'bx;
      else      if((EN_temp == 1'b1))
        Q = D_temp;
//      else      if((EN_temp != 1'b0))
//      Q = 'bx;
      end
  specify
    specparam
      t_hold_D = 0,
      t_setup_D   = (0.16:0.18:0.20),
      t_width_PRE = (0.16:0.18:0.20),
      t_width_CLR = (0.16:0.18:0.20),
      t_width_EN  = (0.16:0.18:0.20);
    //$hold(negedge EN , D , t_hold_D);
    $setup(D , negedge EN , t_setup_D);
    $width(posedge EN  , t_width_EN);
    $width(negedge CLR , t_width_CLR);
    $width(negedge PRE , t_width_PRE);
  endspecify
endmodule

module latch16$(CLR,D,EN,PRE,Q);
  input  CLR;
  input [15:0] D;
  input  EN;
  input  PRE;
  output [15:0] Q;
  reg    [15:0] Q;
  wire  CLR_temp;
  wire [15:0] D_temp;
  wire  EN_temp;
  wire  PRE_temp;
  assign #(0.44:0.48:0.52, 0.46:0.50:0.54) D_temp = D;
  assign #(0.42:0.46:0.50, 0.50:0.54:0.58) EN_temp = EN;
  assign #(0.32:0.36:0.40) PRE_temp = PRE;
  assign #(0.32:0.36:0.40) CLR_temp = CLR;
  always
    @(CLR_temp or PRE_temp or EN_temp or D_temp)
      begin
      if(((CLR_temp == 1'b0) && (PRE_temp == 1'b1)))
        Q = 'b0;
      else      if(((PRE_temp == 1'b0) && (CLR_temp == 1'b1)))
        Q = ( ~ 'b0);
      else      if(((CLR_temp != 1'b1) || (PRE_temp != 1'b1)))
        Q = 'bx;
      else      if((EN_temp == 1'b1))
        Q = D_temp;
//      else      if((EN_temp != 1'b0))
//        Q = 'bx;
      end
  specify
    specparam
      t_hold_D = 0,
      t_setup_D   = (0.16:0.18:0.20),
      t_width_PRE = (0.16:0.18:0.20),
      t_width_CLR = (0.16:0.18:0.20),
      t_width_EN  = (0.16:0.18:0.20);
    //$hold(negedge EN , D , t_hold_D);
    $setup(D , negedge EN , t_setup_D);
    $width(posedge EN  , t_width_EN);
    $width(negedge CLR , t_width_CLR);
    $width(negedge PRE , t_width_PRE);
  endspecify
endmodule


//---------------------------------------------------------------------
//    T r i s t a t e    N o n i n v e r t i n g   B u f f e r 
//		 (light load): 1, 8 and 16-bits
//
// 		Timing specs taken from page 1-62.
//----------------------------------------------------------------------
`celldefine
module  tristateL$(enbar, in, out);
	input  in, enbar;
	output out;
	supply1 vdd;

	bufif0(outi, in, enbar);
	nmos (out, outi, vdd);

	specify
	    (in    *> out) = (0.23:0.26:0.29, 0.23:0.26:0.29);
	    (enbar *> out) = (0.23:0.26:0.29, 0.23:0.26:0.29);
	endspecify
endmodule
`endcelldefine

module  tristate8L$(enbar, in, out);
	input enbar;
	wire  enbar_temp;
 	input  [7:0] in;
 	wire   [7:0] in_temp;
	output [7:0] out;

	assign(strong0,strong1)#(0.23:0.26:0.29, 0.23:0.26:0.29) in_temp = in;
	assign #(0.23:0.26:0.29, 0.23:0.26:0.29) enbar_temp = enbar;
	assign out = (enbar_temp)? 64'bz:in_temp;
endmodule

module  tristate16L$(enbar, in, out);
	input enbar;
	wire  enbar_temp;
 	input  [15:0] in;
 	wire   [15:0] in_temp;
	output [15:0] out;

	assign(strong0,strong1)#(0.23:0.26:0.29, 0.23:0.26:0.29) in_temp = in;
	assign #(0.23:0.26:0.29, 0.23:0.26:0.29) enbar_temp = enbar;
	assign out = (enbar_temp)? 64'bz:in_temp;
endmodule


//---------------------------------------------------------------------
//    T r i s t a t e    N o n i n v e r t i n g   B u f f e r 
//		   (heavy load): 1, 8, and 16-bits
//
//---------------------------------------------------------------------
`celldefine
module  tristateH$(enbar, in, out);
	input  in, enbar;
	output out;
	supply1 vdd;

	bufif0(out, in, enbar);

	specify
	    (in    *> out) = (0.42:0.46:0.50, 0.42:0.46:0.50);
	    (enbar *> out) = (0.42:0.46:0.50, 0.42:0.46:0.50);
	endspecify
endmodule
`endcelldefine

module  tristate8H$(enbar, in, out);
	input enbar;
	wire  enbar_temp;
 	input  [7:0] in;
 	wire   [7:0] in_temp;
	output [7:0] out;

	assign(strong0,strong1)#(0.42:0.46:0.50, 0.42:0.46:0.50) in_temp = in;
	assign #(0.42:0.46:0.50, 0.42:0.46:0.50) enbar_temp = enbar;
	assign out = (enbar_temp)? 8'bz:in_temp;
endmodule

module  tristate16H$(enbar, in, out);
	input enbar;
	wire  enbar_temp;
 	input  [15:0] in;
 	wire   [15:0] in_temp;
	output [15:0] out;

	assign(strong0,strong1)#(0.42:0.46:0.50, 0.42:0.46:0.50) in_temp = in;
	assign #(0.42:0.46:0.50, 0.42:0.46:0.50) enbar_temp = enbar;
	assign out = (enbar_temp)? 16'bz:in_temp;
endmodule

module  tristate_bus_driver1$(enbar, in, out);
	input enbar;
	wire  enbar_temp;
 	input  in;
 	wire   in_temp;
	output out;

	assign(strong0,strong1)#5 in_temp = in;
	assign #5 enbar_temp = enbar;
	assign out = (enbar_temp)? 1'bz:in_temp;
endmodule

module  tristate_bus_driver8$(enbar, in, out);
	input enbar;
	wire  enbar_temp;
 	input  [7:0] in;
 	wire   [7:0] in_temp;
	output [7:0] out;

	assign(strong0,strong1)#5 in_temp = in;
	assign #5 enbar_temp = enbar;
	assign out = (enbar_temp)? 8'bz:in_temp;
endmodule

module  tristate_bus_driver16$(enbar, in, out);
	input enbar;
	wire  enbar_temp;
 	input  [15:0] in;
 	wire   [15:0] in_temp;
	output [15:0] out;

	assign(strong0,strong1)#5 in_temp = in;
	assign #5 enbar_temp = enbar;
	assign out = (enbar_temp)? 16'bz:in_temp;
endmodule


//-------------------------------------------------------------
// Edge triggered   D  flip flip:   16-bits with individual bit addressable
//
// 	 Timing specs are taken from page 1-10.
//-------------------------------------------------------------

module dff16b$(CLK, D, Q, QBAR, CLR, PRE, A);
  input  CLK;
  input  CLR;
  input [15:0] D;
  input  PRE;
  output [15:0] Q;
  output [15:0] QBAR;
  input [3:0] A;
  reg    [15:0] Q;
  reg    [15:0] D_temp;
  wire  CLK_temp;
  wire  CLR_temp;
  wire  PRE_temp;

  assign #(0.28:0.32:0.36) CLK_temp = CLK; //t_plh = t_phl 
	//assuming: t_plh(Q) = t_plh(QBAR) = t_phl(Q) = t_phl(QBAR)
  assign #(0.50:0.54:0.58) PRE_temp = PRE; //t_p(PRE)
  assign #(0.42:0.46:0.50) CLR_temp = CLR; //t_p(CLR)
  assign QBAR = ~Q;
  always@(posedge CLK) D_temp = D;

  always
    @(PRE_temp or CLR_temp)
      begin
      if(((CLR_temp == 1'b0) && (PRE_temp == 1'b1)))
        begin
        Q = 'b0;
        end
      else      if(((PRE_temp == 1'b0) && (CLR_temp == 1'b1)))
        begin
        Q = ( ~ 'b0);
        end
      else      if(((CLR_temp != 1'b1) || (PRE_temp != 1'b1)))
        begin
        Q = 'bx;
        end
      end

  always
    @(posedge CLK_temp) if (((PRE_temp == 1'b1) && (CLR_temp == 1'b1))) Q[A] = D_temp[A];

  specify
    specparam
      //t_hold_D = 0,
      t_setup_D   = (0.12:0.14:0.16),
      //t_width_CLK = (0.21:0.24:0.27),
      t_width_PRE = (0.21:0.24:0.27),
      t_width_CLR = (0.21:0.24:0.27);
    //$hold(posedge CLK , D , t_hold_D);
    $setup(D , posedge CLK , t_setup_D);
    //$width(negedge CLK , t_width_CLK);
    $width(negedge PRE , t_width_PRE);
    $width(negedge CLR , t_width_CLR);
  endspecify
endmodule

//-------------------------------------------------------------
// Edge triggered   D  flip flip:   32-bits with individual bit addressable
//
// 	 Timing specs are taken from page 1-10.
//-------------------------------------------------------------

module dff32b$(CLK, D, Q, QBAR, CLR, PRE, A);
  input  CLK;
  input  CLR;
  input [31:0] D;
  input  PRE;
  output [31:0] Q;
  output [31:0] QBAR;
  input [4:0] A;
  reg    [31:0] Q;
  reg    [31:0] D_temp;
  wire  CLK_temp;
  wire  CLR_temp;
  wire  PRE_temp;

  assign #(0.28:0.32:0.36) CLK_temp = CLK; //t_plh = t_phl 
	//assuming: t_plh(Q) = t_plh(QBAR) = t_phl(Q) = t_phl(QBAR)
  assign #(0.50:0.54:0.58) PRE_temp = PRE; //t_p(PRE)
  assign #(0.42:0.46:0.50) CLR_temp = CLR; //t_p(CLR)
  assign QBAR = ~Q;
  always@(posedge CLK) D_temp = D;

  always
    @(PRE_temp or CLR_temp)
      begin
      if(((CLR_temp == 1'b0) && (PRE_temp == 1'b1)))
        begin
        Q = 'b0;
        end
      else      if(((PRE_temp == 1'b0) && (CLR_temp == 1'b1)))
        begin
        Q = ( ~ 'b0);
        end
      else      if(((CLR_temp != 1'b1) || (PRE_temp != 1'b1)))
        begin
        Q = 'bx;
        end
      end

  always
    @(posedge CLK_temp) if (((PRE_temp == 1'b1) && (CLR_temp == 1'b1))) Q[A] = D_temp[A];
 
 specify
    specparam
      //t_hold_D = 0,
      t_setup_D   = (0.12:0.14:0.16),
      //t_width_CLK = (0.21:0.24:0.27),
      t_width_PRE = (0.21:0.24:0.27),
      t_width_CLR = (0.21:0.24:0.27);
    //$hold(posedge CLK , D , t_hold_D);
    $setup(D , posedge CLK , t_setup_D);
    //$width(negedge CLK , t_width_CLK);
    $width(negedge PRE , t_width_PRE);
    $width(negedge CLR , t_width_CLR);
  endspecify
endmodule

//-------------------------------------------------------------
// R e g i s t e r s :   64-bits register with enable
//
// 	 Timing specs are taken from page 1-10.
//-------------------------------------------------------------
module reg64e$(CLK, Din, Q, QBAR, CLR, PRE,en);
  input  CLK;
  input  CLR;
  input [63:0] Din;
  wire  [63:0] D;
  input  PRE;
  input  en;
  output [63:0] Q;
  output [63:0] QBAR;
  reg    [63:0] Q;
  reg    [63:0] D_temp;
  wire  CLK_temp;
  wire  CLR_temp;
  wire  PRE_temp;
  assign #0.34 D = (en==1'b1)? Din:Q;

  assign #(0.28:0.32:0.36) CLK_temp = CLK; //t_plh = t_phl 
	//assuming: t_plh(Q) = t_plh(QBAR) = t_phl(Q) = t_phl(QBAR)
  assign #(0.50:0.54:0.58) PRE_temp = PRE; //t_p(PRE)
  assign #(0.42:0.46:0.50) CLR_temp = CLR; //t_p(CLR)
  assign QBAR = ~Q;
  always@(posedge CLK) D_temp = D;

  always
    @(PRE_temp or CLR_temp)
      begin
      if(((CLR_temp == 1'b0) && (PRE_temp == 1'b1)))
        begin
        Q = 'b0;
        end
      else      if(((PRE_temp == 1'b0) && (CLR_temp == 1'b1)))
        begin
        Q = ( ~ 'b0);
        end
      else      if(((CLR_temp != 1'b1) || (PRE_temp != 1'b1)))
        begin
        Q = 'bx;
        end
      end

  always
    @(posedge CLK_temp) if (((PRE_temp == 1'b1) && (CLR_temp == 1'b1))) Q = D_temp;

  specify
    specparam
      //t_hold_D = 0,
      t_setup_D   = (0.12:0.14:0.16),
      //t_width_CLK = (0.21:0.24:0.27),
      t_width_PRE = (0.21:0.24:0.27),
      t_width_CLR = (0.21:0.24:0.27);
    //$hold(posedge CLK , D , t_hold_D);
    $setup(D , posedge CLK , t_setup_D);
    //$width(negedge CLK , t_width_CLK);
    $width(negedge PRE , t_width_PRE);
    $width(negedge CLR , t_width_CLR);
  endspecify
endmodule

//-------------------------------------------------------------
// R e g i s t e r s :   32-bits register with enable
//
// 	 Timing specs are taken from page 1-10.
//-------------------------------------------------------------
module reg32e$(CLK, Din, Q, QBAR, CLR, PRE,en);
  input  CLK;
  input  CLR;
  input [31:0] Din;
  wire  [31:0] D;
  input  PRE;
  input  en;
  output [31:0] Q;
  output [31:0] QBAR;
  reg    [31:0] Q;
  reg    [31:0] D_temp;
  wire  CLK_temp;
  wire  CLR_temp;
  wire  PRE_temp;
  assign #0.34 D = (en==1'b1)? Din:Q;

  assign #(0.28:0.32:0.36) CLK_temp = CLK; //t_plh = t_phl 
	//assuming: t_plh(Q) = t_plh(QBAR) = t_phl(Q) = t_phl(QBAR)
  assign #(0.50:0.54:0.58) PRE_temp = PRE; //t_p(PRE)
  assign #(0.42:0.46:0.50) CLR_temp = CLR; //t_p(CLR)
  assign QBAR = ~Q;
  always@(posedge CLK) D_temp = D;

  always
    @(PRE_temp or CLR_temp)
      begin
      if(((CLR_temp == 1'b0) && (PRE_temp == 1'b1)))
        begin
        Q = 'b0;
        end
      else      if(((PRE_temp == 1'b0) && (CLR_temp == 1'b1)))
        begin
        Q = ( ~ 'b0);
        end
      else      if(((CLR_temp != 1'b1) || (PRE_temp != 1'b1)))
        begin
        Q = 'bx;
        end
      end

  always
    @(posedge CLK_temp) if (((PRE_temp == 1'b1) && (CLR_temp == 1'b1))) Q = D_temp;

  specify
    specparam
      //t_hold_D = 0,
      t_setup_D   = (0.12:0.14:0.16),
      //t_width_CLK = (0.21:0.24:0.27),
      t_width_PRE = (0.21:0.24:0.27),
      t_width_CLR = (0.21:0.24:0.27);
    //$hold(posedge CLK , D , t_hold_D);
    $setup(D , posedge CLK , t_setup_D);
    //$width(negedge CLK , t_width_CLK);
    $width(negedge PRE , t_width_PRE);
    $width(negedge CLR , t_width_CLR);
  endspecify
endmodule

//-------------------------------------------------------------
//      I O    R e g i s t e r (D-flip flop):   8-bits
//
// 	 Timing specs are taken from page 1-10.
//-------------------------------------------------------------
module ioreg8$(CLK, D, Q, QBAR, CLR, PRE);
  input  CLK;
  input  CLR;
  input [7:0] D;
  input  PRE;
  output [7:0] Q;
  output [7:0] QBAR;
  reg    [7:0] Q;
  reg    [7:0] D_temp;
  wire  CLK_temp;
  wire  CLR_temp;
  wire  PRE_temp;

  assign #5 CLK_temp = CLK; //t_plh = t_phl 
	//assuming: t_plh(Q) = t_plh(QBAR) = t_phl(Q) = t_phl(QBAR)
  assign #5 PRE_temp = PRE; //t_p(PRE)
  assign #5 CLR_temp = CLR; //t_p(CLR)
  assign QBAR = ~Q;
  always@(posedge CLK) D_temp = D;

  always
    @(PRE_temp or CLR_temp)
      begin
      if(((CLR_temp == 1'b0) && (PRE_temp == 1'b1)))
        begin
        Q = 'b0;
        end
      else      if(((PRE_temp == 1'b0) && (CLR_temp == 1'b1)))
        begin
        Q = ( ~ 'b0);
        end
      else      if(((CLR_temp != 1'b1) || (PRE_temp != 1'b1)))
        begin
        Q = 'bx;
        end
      end

  always 
    @(posedge CLK_temp) if (((PRE_temp == 1'b1) && (CLR_temp == 1'b1))) Q = D_temp;

  specify
    specparam
      t_setup_D   = 10,
      t_width_CLK = 5,
      t_width_PRE = 5,
      t_width_CLR = 5;
    $setup(D , posedge CLK , t_setup_D);
    $width(negedge CLK , t_width_CLK);
    $width(negedge PRE , t_width_PRE);
    $width(negedge CLR , t_width_CLR);
  endspecify
endmodule

//-------------------------------------------------------------
//      I O    R e g i s t e r (D-flip flop):   16-bits
//
// 	 Timing specs are taken from page 1-10.
//-------------------------------------------------------------

module ioreg16$(CLK, D, Q, QBAR, CLR, PRE);
  input  CLK;
  input  CLR;
  input [15:0] D;
  input  PRE;
  output [15:0] Q;
  output [15:0] QBAR;
  reg    [15:0] Q;
  reg    [15:0] D_temp;
  wire  CLK_temp;
  wire  CLR_temp;
  wire  PRE_temp;

  assign #5 CLK_temp = CLK; //t_plh = t_phl 
	//assuming: t_plh(Q) = t_plh(QBAR) = t_phl(Q) = t_phl(QBAR)
  assign #5 PRE_temp = PRE; //t_p(PRE)
  assign #5 CLR_temp = CLR; //t_p(CLR)
  assign QBAR = ~Q;
  always@(posedge CLK) D_temp = D;

  always
    @(PRE_temp or CLR_temp)
      begin
      if(((CLR_temp == 1'b0) && (PRE_temp == 1'b1)))
        begin
        Q = 'b0;
        end
      else      if(((PRE_temp == 1'b0) && (CLR_temp == 1'b1)))
        begin
        Q = ( ~ 'b0);
        end
      else      if(((CLR_temp != 1'b1) || (PRE_temp != 1'b1)))
        begin
        Q = 'bx;
        end
      end

  always
    @(posedge CLK_temp) if (((PRE_temp == 1'b1) && (CLR_temp == 1'b1))) Q = D_temp;

  specify
    specparam
      t_setup_D   = 10,
      t_width_CLK = 5,
      t_width_PRE = 5,
      t_width_CLR = 5;
    $setup(D , posedge CLK , t_setup_D);
    $width(negedge CLK , t_width_CLK);
    $width(negedge PRE , t_width_PRE);
    $width(negedge CLR , t_width_CLR);
  endspecify
endmodule

//--------------------------------------------------------
// Library parts III
// -----------------
// EE382N-14945, Spring 2000.
// (Some are modified from those provided by Cascade Design Automation Corp).
// All module parts' name are appended with a "$" character.
// This part of the library consists of the following parts:
//
// regfile$		16x8bits double-read port register files
// regfile8x8$		8x8bits  double-read port register files
// ram16b8w$ 		16-bits x 8 words RAM
// ram8b8w$ 		8-bits x 8 words RAM
// ram8b4w$ 		8-bits x 4 words RAM
// rom4b32w$		4-bits x 32 words ROM
// rom32b32w$		32-bits x 32 words ROM
// rom64b32w$		64-bits x 32 words ROM
//
//---------------------------------------------------------
//       r e g i s t e r      f i l e :    16 x 8-bits 
//		     (two read ports only)
//           (timing specs taken from page 2-95)
//---------------------------------------------------------
  module regfile$(IN0,R1,R2,RE1,RE2,W,WE,OUT1,OUT2,CLOCK);
//module regfile$(IN0,R1,   RE1,    W,WE,OUT1,     CLOCK);
  input [7:0] IN0;
  input [3:0] R1;
  input [3:0] R2;
  //   wire [3:0] R2;
  input  RE1;
  input  RE2;
  //   wire  RE2;
  input [3:0] W;
  input  WE;
  input CLOCK;
  output [7:0] OUT1;
  output [7:0] OUT2;
  //    wire [7:0] OUT2;
  wire [7:0] IN0_temp;
  wire [3:0] R1_temp;
  wire [3:0] R2_temp;
  wire  RE1_temp;
  wire  RE2_temp;
  wire [3:0] W_temp;
  wire  WE_temp;
  reg [7:0] OUT1_temp;
  reg [7:0] OUT2_temp;
  reg  flag1;
  reg  flag2;
  reg [7:0] mem_array[15:0];
  assign IN0_temp = IN0;
  assign #(0.8:0.86:0.92) R1_temp = R1;
  assign #(0.8:0.86:0.92) R2_temp = R2;
  assign #(0.18:0.20:0.22) RE1_temp = RE1;
  assign #(0.18:0.20:0.22) RE2_temp = RE2;
  assign W_temp = W;
  assign WE_temp = WE;
  assign OUT1 = OUT1_temp;
  assign OUT2 = OUT2_temp;
  initial
    begin
    flag1 = 1'b0;
    flag2 = 1'b0;
    end
  always
    @(posedge CLOCK)
    //@(W_temp or WE_temp or IN0_temp)
      begin
      if((WE_temp == 1'b1))
        begin
        if(((W_temp >= 0) && (W_temp < 16)))
          begin
          mem_array[W_temp] = IN0_temp;
          if((W_temp == R1_temp))
            flag1 = ( ~ flag1);
          if((W_temp == R2_temp))
            flag2 = ( ~ flag2);
          end
        else
          begin
          $display("(Error) Illegal value on W pin of regfile");
          end
        end
      end
  always
    @(flag1 or RE1_temp or R1_temp)
      begin
      if((RE1_temp == 1'b1))
        if(((R1_temp >= 0) && (R1_temp < 16)))
          #(0.18:0.20:0.22) OUT1_temp = mem_array[R1_temp];
        else
          #(0.18:0.20:0.22) OUT1_temp = 'bx;
      else
        #(0.18:0.20:0.22) OUT1_temp = 'bz;
      end
  always
    @(flag2 or RE2_temp or R2_temp)
      begin
      if((RE2_temp == 1'b1))
        if(((R2_temp >= 0) && (R2_temp < 16)))
          #(0.18:0.20:0.22) OUT2_temp = mem_array[R2_temp];
        else
          #(0.18:0.20:0.22) OUT2_temp = 'bx;
      else
        #(0.18:0.20:0.22) OUT2_temp = 'bz;
      end
  specify
    $setup(W , posedge CLOCK,  0.46:0.50:0.54);
    $setup(WE, posedge CLOCK,  0.46:0.50:0.54);
    $setup(IN0,posedge CLOCK,  0.46:0.50:0.54);
    //$setup(R1, edge[01,x1] RE1,1.1:1.4:1.8);//read operations are not clocked.
    //$setup(R2, edge[01,x1] RE2,1.1:1.4:1.8);
  endspecify
endmodule


//---------------------------------------------------------
//       r e g i s t e r      f i l e :    8 x 8-bits 
//		     (two read ports only)
//           (timing specs taken from page 2-95)
//---------------------------------------------------------
 module regfile8x8$(IN0,R1,R2,RE1,RE2,W,WE,OUT1,OUT2,CLOCK);
 // module regfile8x8$(IN0,R1,   RE1,    W,WE,OUT1,     CLOCK);
  input [7:0] IN0;
  input [2:0] R1;
  input [2:0] R2;
  //   wire [2:0] R2;
  input  RE1;
  input  RE2;
  //   wire  RE2;
  input [2:0] W;
  input  WE;
  input CLOCK;
  output [7:0] OUT1;
  output [7:0] OUT2;
  //    wire [7:0] OUT2;
  wire [7:0] IN0_temp;
  wire [2:0] R1_temp;
  wire [2:0] R2_temp;
  wire  RE1_temp;
  wire  RE2_temp;
  wire [2:0] W_temp;
  wire  WE_temp;
  reg [7:0] OUT1_temp;
  reg [7:0] OUT2_temp;
  reg  flag1;
  reg  flag2;
  reg [7:0] mem_array[7:0];

  wire [7:0] REG0;
  wire [7:0] REG1;
  wire [7:0] REG2;
  wire [7:0] REG3;
  wire [7:0] REG4;
  wire [7:0] REG5;
  wire [7:0] REG6;
  wire [7:0] REG7;

  assign REG0 = mem_array[0];
  assign REG1 = mem_array[1];
  assign REG2 = mem_array[2];
  assign REG3 = mem_array[3];
  assign REG4 = mem_array[4];
  assign REG5 = mem_array[5];
  assign REG6 = mem_array[6];
  assign REG7 = mem_array[7];

  assign IN0_temp = IN0;
  assign #(0.9:1.1:1.3) R1_temp = R1;
  assign #(0.9:1.1:1.3) R2_temp = R2;
  assign #(0.18:0.20:0.22) RE1_temp = RE1;
  assign #(0.18:0.20:0.22) RE2_temp = RE2;
  assign W_temp = W;
  assign WE_temp = WE;
  assign OUT1 = OUT1_temp;
  assign OUT2 = OUT2_temp;
  initial
    begin
    flag1 = 1'b0;
    flag2 = 1'b0;
    end
  always
    @(posedge CLOCK)
    //@(W_temp or WE_temp or IN0_temp)
      begin
      if((WE_temp == 1'b1))
        begin
        if(((W_temp >= 0) && (W_temp < 16)))
          begin
          mem_array[W_temp] = IN0_temp;
          if((W_temp == R1_temp))
            flag1 = ( ~ flag1);
          if((W_temp == R2_temp))
            flag2 = ( ~ flag2);
          end
        else
          begin
          $display("(Error) Illegal value on W pin of regfile");
          end
        end
      end
  always
    @(flag1 or RE1_temp or R1_temp)
      begin
      if((RE1_temp == 1'b1))
        if(((R1_temp >= 0) && (R1_temp < 8)))
          #(0.18:0.20:0.22) OUT1_temp = mem_array[R1_temp];
        else
          #(0.18:0.20:0.22) OUT1_temp = 'bx;
      else
        #(0.18:0.20:0.22) OUT1_temp = 'bz;
      end
  always
    @(flag2 or RE2_temp or R2_temp)
      begin
      if((RE2_temp == 1'b1))
        if(((R2_temp >= 0) && (R2_temp < 8)))
          #(0.18:0.20:0.22) OUT2_temp = mem_array[R2_temp];
        else
          #(0.18:0.20:0.22) OUT2_temp = 'bx;
      else
        #(0.18:0.20:0.22) OUT2_temp = 'bz;
      end
  specify
    $setup(W , posedge CLOCK,  0.46:0.50:0.54);
    $setup(WE, posedge CLOCK,  0.46:0.50:0.54);
    $setup(IN0,posedge CLOCK,  0.46:0.50:0.54);
    //$setup(R1, edge[01,x1] RE1,1.1:1.4:1.8);//read operations are not clocked.
    //$setup(R2, edge[01,x1] RE2,1.1:1.4:1.8);
  endspecify
endmodule


//---------------------------------------------------------
//            R    A    M    :  8-bits x 8 words
//
//           (timing specs taken from page 3-11)
//---------------------------------------------------------
module  ram8b8w$ (A,DIN,OE,WR, DOUT);

	`define  access_dly    1.7:2.0:2.3	// t_acc(A)
	`define  din_dout_dly  0.7:0.8:0.9	// t_d(DIN-DOUT)
	`define  wr_dout_dly   0.7:0.8:0.9	// t_d(WR-DOUT)
	`define  wr_to_ramcell  0		// Time to toggle ramcell()
	`define  valid2z_dly	0		// t_pvz
	`define  z2valid_dly 	0		// t_pzv


	input [2:0] A;
	input [7:0] DIN;
	input WR,OE;
	output [7:0] DOUT;

	reg  [7:0] DOUT,ramout;
	reg  [2:0] lastread_addr,lastwrite_addr;
	reg wr_cycle_check;
	reg read_cycle_check;
	reg addr_hold_flag,addr_setup_flag;
	reg data_hold_flag,data_setup_flag;
	reg din_changed,a_changed;
	reg output_enable;
	reg [7:0] mem [7:0];
	event addr_unstable_memory;

always @(negedge WR)
 begin: write_block
  mem[A] = 'bx;

  fork
   begin: wr_dout
     ramout = #(`wr_dout_dly) DIN;
   end
   begin: wr_mem
     mem[A] = #(`wr_to_ramcell) DIN;
   end
   forever @(DIN)
    begin
     disable wr_dout;
     disable wr_mem;
     disable in_dout;
     disable din_mem;
     mem[A] = 'bx;
     din_changed =1;
    end
   forever
     begin: in_dout
      wait (din_changed);
      ramout = #(`din_dout_dly) DIN;
      din_changed = 0;
     end
   forever
     begin: din_mem
      wait (din_changed);
      mem[A] = #(`wr_to_ramcell) DIN;
      din_changed = 0;
     end
    forever @(posedge WR or A)
     disable write_block;
   join
end
always @(A)
  begin
     if (WR ==1)
      begin
       disable a_dout;
       a_changed =1;
      end
     else if (WR ==0)
      begin
       $display("(WARNING) %m:Address A changed when WR was low at time ",$time);
        -> addr_unstable_memory;
        ramout = 'bx;
      end
     else if (WR==1'bx)
      begin
       disable a_dout;
       a_changed =1;
       $display("(WARNING) %m:Address A changed when WR was low at time ",$time);
        -> addr_unstable_memory;
      end
  end

always @(posedge WR)
  lastwrite_addr = A;

always @(addr_unstable_memory)
     begin
       mem[lastread_addr] ='bx;
       mem[A] = 'bx;
     end


  always
     begin: a_dout
       wait(a_changed);
        ramout = #(`access_dly) mem[A];
        a_changed = 0;
        lastread_addr = A;
     end

always @(posedge addr_hold_flag )
  begin
     mem[lastwrite_addr] = 'bx;
     #0.2 addr_hold_flag = 0;
   end
always @(posedge addr_setup_flag)
   begin
     disable write_block;
     mem[A] = 'bx;
     #0.2 addr_setup_flag = 0;
   end
always @(posedge data_hold_flag)
   begin
      mem[lastwrite_addr] = 'bx;
      #0.2 data_hold_flag =0;
   end
always @(posedge data_setup_flag)
   begin
      mem[A] = 'bx;
      ramout = 'bx;
      #0.2 data_setup_flag =0;
   end
always @(ramout)
   begin
       if (OE == 0 )
        begin
         disable output_something;
         DOUT = ramout;
        end
  end
always @(OE)
       begin
          disable output_something;
          output_enable =1 ;
       end
always
     begin: output_something
      wait(output_enable);
      output_enable = 0;
      if (OE == 0)
        DOUT = #(`z2valid_dly) ramout;
      else if (OE == 1)
        DOUT = #(`valid2z_dly) 'bz;
      else
        DOUT = #(0.5*`valid2z_dly+0.5*`z2valid_dly) 'bx;
end

specify
        specparam
          addr_hold_time =0, addr_setup_time=1.0:1.2:1.4,//t_setup(A)
          data_hold_time=0, data_setup_time=0.04:0.06:0.08,//t_setup(DIN)
          write_pulse_low=1.0:1.2:1.4,			//t_wpl
	  write_pulse_high=1.0:1.2:1.4;		//t_rc(WR)
	$setup(A, negedge WR, addr_setup_time); 	//address setup check
	$setup(DIN, posedge WR,data_setup_time);	//data setup check
	$width(negedge WR, write_pulse_low); 		//WR low width check
	$width(posedge WR, write_pulse_high);		//read cycle check
	$setup(A, posedge WR, 1.1:1.3:1.7);		//t_wc(WR)

   endspecify
endmodule
//---------------------------------------------------------
//            R    A    M    :  16-bits x 8 words
//
//           (timing specs taken from page 3-11)
//---------------------------------------------------------
module	ram16b8w$ (A, DIN, OE, WRH, WRL, DOUT);

	input [2:0] A;
	input [15:0] DIN;
	input WRH, WRL, OE;
	output [15:0] DOUT;
	wire [7:0] DOUT1;
	wire [7:0] DOUT2;

	ram8b8w$	ram1(A, DIN[15:8], OE, WRH, DOUT1),
			ram2(A, DIN[7:0], OE, WRL, DOUT2);

assign	DOUT = ({DOUT1, DOUT2});
endmodule



//---------------------------------------------------------
//            R    A    M    :  8-bits x 4 words
//
//           (timing specs taken from page 3-11)
//---------------------------------------------------------
module  ram8b4w$ (A,DIN,OE,WR, DOUT);

	`define  access_dly    1.7:2.0:2.3	// t_acc(A)
	`define  din_dout_dly  0.7:0.8:0.9	// t_d(DIN-DOUT)
	`define  wr_dout_dly   0.7:0.8:0.9	// t_d(WR-DOUT)
	`define  wr_to_ramcell  0		// Time to toggle ramcell()
	`define  valid2z_dly	0		// t_pvz
	`define  z2valid_dly 	0		// t_pzv


	input [1:0] A;
	input [7:0] DIN;
	input WR,OE;
	output [7:0] DOUT;

	reg  [7:0] DOUT,ramout;
	reg  [1:0] lastread_addr,lastwrite_addr;
	reg wr_cycle_check;
	reg read_cycle_check;
	reg addr_hold_flag,addr_setup_flag;
	reg data_hold_flag,data_setup_flag;
	reg din_changed,a_changed;
	reg output_enable;
	reg [7:0] mem [3:0];
	event addr_unstable_memory;

always @(negedge WR)
 begin: write_block
  mem[A] = 'bx;

  fork
   begin: wr_dout
     ramout = #(`wr_dout_dly) DIN;
   end
   begin: wr_mem
     mem[A] = #(`wr_to_ramcell) DIN;
   end
   forever @(DIN)
    begin
     disable wr_dout;
     disable wr_mem;
     disable in_dout;
     disable din_mem;
     mem[A] = 'bx;
     din_changed =1;
    end
   forever
     begin: in_dout
      wait (din_changed);
      ramout = #(`din_dout_dly) DIN;
      din_changed = 0;
     end
   forever
     begin: din_mem
      wait (din_changed);
      mem[A] = #(`wr_to_ramcell) DIN;
      din_changed = 0;
     end
    forever @(posedge WR or A)
     disable write_block;
   join
end

always @(A)
  begin
     if (WR ==1)
      begin
       disable a_dout;
       a_changed =1;
      end
     else if (WR ==0)
      begin
       $display("(WARNING) %m:Address A changed when WR was low at time ",$time);
        -> addr_unstable_memory;
        ramout = 'bx;
      end
     else if (WR==1'bx)
      begin
       disable a_dout;
       a_changed =1;
       $display("(WARNING) %m:Address A changed when WR was low at time ",$time);
        -> addr_unstable_memory;
      end
  end
always @(posedge WR)
  lastwrite_addr = A;

always @(addr_unstable_memory)
     begin
       mem[lastread_addr] ='bx;
       mem[A] = 'bx;
     end


  always
     begin: a_dout
       wait(a_changed);
        ramout = #(`access_dly) mem[A];
        a_changed = 0;
        lastread_addr = A;
     end

always @(posedge addr_hold_flag )
  begin
     mem[lastwrite_addr] = 'bx;
     #0.2 addr_hold_flag = 0;
   end
always @(posedge addr_setup_flag)
   begin
     disable write_block;
     mem[A] = 'bx;
     #0.2 addr_setup_flag = 0;
   end
always @(posedge data_hold_flag)
   begin
      mem[lastwrite_addr] = 'bx;
      #0.2 data_hold_flag =0;
   end
always @(posedge data_setup_flag)
   begin
      mem[A] = 'bx;
      ramout = 'bx;
      #0.2 data_setup_flag =0;
   end
always @(ramout)
   begin
       if (OE == 0 )
        begin
         disable output_something;
         DOUT = ramout;
        end
  end
always @(OE)
       begin
          disable output_something;
          output_enable =1 ;
       end
always
     begin: output_something
      wait(output_enable);
      output_enable = 0;
      if (OE == 0)
        #(0.3:0.4:0.5) DOUT = #(`z2valid_dly) ramout;
      else if (OE == 1)
        #(0.3:0.4:0.5) DOUT = #(`valid2z_dly) 'bz;
      else
        #(0.3:0.4:0.5) DOUT = #(0.5*`valid2z_dly+0.5*`z2valid_dly) 'bx;
end

specify
        specparam
          addr_hold_time =0, addr_setup_time=1.0:1.2:1.4,//t_setup(A)
          data_hold_time=0, data_setup_time=0.04:0.06:0.08,//t_setup(DIN)
          write_pulse_low=1.0:1.2:1.4,			//t_wpl
	  write_pulse_high=1.0:1.2:1.4;		//t_rc(WR)
	$setup(A, negedge WR, addr_setup_time); 	//address setup check
	$setup(DIN, posedge WR,data_setup_time);	//data setup check
	$width(negedge WR, write_pulse_low); 		//WR low width check
	$width(posedge WR, write_pulse_high);		//read cycle check
	$setup(A, posedge WR, 1.1:1.3:1.7);		//t_wc(WR)

   endspecify
endmodule


//---------------------------------------------------------
//            R    O    M    :  4-bits x 32 words
//
//---------------------------------------------------------
// You will need to "stack" the ROM up to satisfy the "length"
// and "width" requirements.  For instance:
//
// rom4b32w$  ROM11 (....);
// rom4b32w$  ROM12 (....);
//		:
// rom4b32w$  ROM21 (....);
// rom4b32w$  ROM22 (....);
//		:
// where ROMij is the ith row, jth column ROM.
//
// You will need to initialize the ROMs using the initial 
// statement.  For example:
//
// initial readmemh("rom/rom12.data", ROM12.mem);
//		:
// where all romxx.data files are placed in the "rom" 
// subdirectory.
//---------------------------------------------------------
module rom4b32w$(A,OE,DOUT);
  input [4:0] A;
  input  OE;
  output [3:0] DOUT;
  wire [4:0] A_temp;
  wire  OE_temp;

  `define d_A     1.0
  `define d_OE_r  1.0
  `define d_OE_f  1.0
  `define d_DOUT  0

  reg [3:0] DOUT_temp;
  reg [3:0] mem[31:0];
  assign #(`d_A) A_temp = A;
  assign #(`d_OE_r,`d_OE_f) OE_temp = OE;
  assign #(`d_DOUT) DOUT = DOUT_temp;
  always
    @(A_temp or OE_temp)
      begin
      if((OE_temp == 1'b1))
        DOUT_temp = mem[A_temp];
      else      if((OE_temp == 1'b0))
        DOUT_temp = 4'bz;
      else
        DOUT_temp = 4'bx;
      end
endmodule


module rom32b32w$(A,OE,DOUT);
  input [4:0] A;
  input  OE;
  output [31:0] DOUT;
  wire [4:0] A_temp;
  wire  OE_temp;

  `define d_A     1.0
  `define d_OE_r  1.0
  `define d_OE_f  1.0
  `define d_DOUT  0

  reg [31:0] DOUT_temp;
  reg [31:0] mem[31:0];
  assign #(`d_A) A_temp = A;
  assign #(`d_OE_r,`d_OE_f) OE_temp = OE;
  assign #(`d_DOUT) DOUT = DOUT_temp;
  always
    @(A_temp or OE_temp)
      begin
      if((OE_temp == 1'b1))
        DOUT_temp = mem[A_temp];
      else      if((OE_temp == 1'b0))
        DOUT_temp = 32'bz;
      else
        DOUT_temp = 32'bx;
      end
endmodule



module rom64b32w$(A,OE,DOUT);
  input [4:0] A;
  input  OE;
  output [63:0] DOUT;
  wire [4:0] A_temp;
  wire  OE_temp;

  `define d_A     1.0
  `define d_OE_r  1.0
  `define d_OE_f  1.0
  `define d_DOUT  0

  reg [63:0] DOUT_temp;
  reg [63:0] mem[31:0];
  assign #(`d_A) A_temp = A;
  assign #(`d_OE_r,`d_OE_f) OE_temp = OE;
  assign #(`d_DOUT) DOUT = DOUT_temp;
  always
    @(A_temp or OE_temp)
      begin
      if((OE_temp == 1'b1))
        DOUT_temp = mem[A_temp];
      else      if((OE_temp == 1'b0))
        DOUT_temp = 64'bz;
      else
        DOUT_temp = 64'bx;
      end
endmodule

//--------------------------------------------------------
// Library parts IV
// -----------------
// EE382N-14945, Spring 2000.
// (Some are modified from those provided by Cascade Design Automation Corp).
// All module parts' name are appended with a "$" character.
// This part of the library consists of the following parts:
//
// mux2$	-  1-bit 2-1 multiplexer
// mux3$	-  1-bit 3-1 multiplexer
// mux4$	-  1-bit 4-1 multiplexer
//
// mux2_8$	-  8-bits 2-1 multiplexer
// mux2_16$	-  16-bits 2-1 multiplexer
// mux3_8$	-  8-bits 3-1 multiplexer
// mux3_16$	-  16-bits 3-1 multiplexer
// mux4_8$	-  8-bits 4-1 multiplexer
// mux4_16$	-  16-bits 4-1 multiplexer
//
// Timing specs are taken from page 1-60.
//
//--------------------------------------------------------
primitive table_imux2(out, s0, in0, in1);
    input s0, in0, in1;
    output out;
    //  inverting 2:1 multiplexer

    table
    //  s0  in0 in1 : out
	 0   1   ?  :  0 ;
	 0   0   ?  :  1 ;
	 1   ?   1  :  0 ;
	 1   ?   0  :  1 ;

	 x   0   0  :  1 ;
	 x   1   1  :  0 ;
    endtable
endprimitive

primitive table_imux3(out, s1, s0, in0, in1, in2);
    input s1, s0, in0, in1, in2;
    output out;

    // 3:1 inverting multiplexer
    table
    //  s1 s0 in0 in1 in2 : out
	0  0  1   ?   ?   : 0 ;
	0  0  0   ?   ?   : 1 ;
	0  1  ?   1   ?   : 0 ;
	0  1  ?   0   ?   : 1 ;
	1  ?  ?   ?   1   : 0 ;
	1  ?  ?   ?   0   : 1 ;

	x  x  1   1   1   : 0 ;
	x  x  0   0   0   : 1 ;
	0  x  1   1   ?   : 0 ;
	0  x  0   0   ?   : 1 ;
	x  0  1   ?   1   : 0 ;
	x  0  0   ?   0   : 1 ;
	x  1  ?   1   1   : 0 ;
	x  1  ?   0   0   : 1 ;
	
    endtable
endprimitive

primitive table_imux4(out, s1, s0, in0, in1, in2, in3);
    input s1, s0, in0, in1, in2, in3;
    output out;

    // 4:1 inverting multiplexer
    table
    //  s1 s0 in0 in1 in2 in3 : out
	0  0  1   ?   ?   ?   : 0 ;
	0  0  0   ?   ?   ?   : 1 ;
	0  1  ?   1   ?   ?   : 0 ;
	0  1  ?   0   ?   ?   : 1 ;
	1  0  ?   ?   1   ?   : 0 ;
	1  0  ?   ?   0   ?   : 1 ;
	1  1  ?   ?   ?   1   : 0 ;
	1  1  ?   ?   ?   0   : 1 ;

	x  x  1   1   1   1   : 0 ;
	x  x  0   0   0   0   : 1 ;
	0  x  1   1   ?   ?   : 0 ;
	0  x  0   0   ?   ?   : 1 ;
	1  x  ?   ?   1   1   : 0 ;
	1  x  ?   ?   0   0   : 1 ;
	x  0  1   ?   1   ?   : 0 ;
	x  0  0   ?   0   ?   : 1 ;
	x  1  ?   1   ?   1   : 0 ;
	x  1  ?   0   ?   0   : 1 ;
	
    endtable
endprimitive

`celldefine
module  mux2$(outb, in0, in1, s0);
	input in0, in1, s0;
	output outb;

	table_imux2(temp, s0, in0, in1);
	not (outb, temp);

	specify
	    (s0  *> outb) = (0.27:0.3:0.33);
	    (in0 *> outb) = (0.18:0.2:0.22);
	    (in1 *> outb) = (0.18:0.2:0.22);
	endspecify
endmodule
`endcelldefine

`celldefine
module  mux3$(outb, in0, in1, in2, s0, s1);
	input in0, in1, in2, s0, s1;
	output outb;

	table_imux3(temp, s1, s0, in0, in1, in2);
	not(outb, temp);

	specify
	    (s0  *> outb) = (0.46:0.5:0.54);
	    (s1  *> outb) = (0.46:0.5:0.54);
	    (in0 *> outb) = (0.20:0.22:0.24);
	    (in1 *> outb) = (0.20:0.22:0.24);
	    (in2 *> outb) = (0.20:0.22:0.24);
	endspecify
endmodule
`endcelldefine

`celldefine
module  mux4$(outb, in0, in1, in2, in3, s0, s1);
	input in0, in1, in2, in3, s0, s1;
	output outb;

	table_imux4(temp, s1, s0, in0, in1, in2, in3);
	not(outb, temp);

	specify
	    (s0  *> outb) = (0.46:0.5:0.54);
	    (s1  *> outb) = (0.46:0.5:0.54);
	    (in0 *> outb) = (0.20:0.22:0.24);
	    (in1 *> outb) = (0.20:0.22:0.24);
	    (in2 *> outb) = (0.20:0.22:0.24);
	    (in3 *> outb) = (0.20:0.22:0.24);
	endspecify
endmodule
`endcelldefine

//--------------------  2 - i n p u t     M U X   --------------------
// 
module mux2_8$(Y,IN0,IN1,S0);
  input [7:0] IN0;
  input [7:0] IN1;
  input  S0;
  output [7:0] Y;
  reg    [7:0] Y;
  wire [7:0] IN0_temp;
  wire [7:0] IN1_temp;
  wire  S0_temp;
  assign #(0.18:0.2:0.22) IN0_temp = IN0;
  assign #(0.18:0.2:0.22) IN1_temp = IN1;
  assign #(0.27:0.3:0.33) S0_temp = S0;
  always
    @(IN0_temp or IN1_temp or S0_temp)
      begin
      if((S0_temp == 1'b0))
        Y = IN0_temp;
      else  if((S0_temp == 1'b1))
        Y = IN1_temp;
      else
        Y = 'bx;
      end
endmodule

module mux2_16$(Y,IN0,IN1,S0);
  input [15:0] IN0;
  input [15:0] IN1;
  input  S0;
  output [15:0] Y;
  reg    [15:0] Y;
  wire [15:0] IN0_temp;
  wire [15:0] IN1_temp;
  wire  S0_temp;
  assign #(0.18:0.2:0.22) IN0_temp = IN0;
  assign #(0.18:0.2:0.22) IN1_temp = IN1;
  assign #(0.27:0.3:0.33) S0_temp = S0;
  always
    @(IN0_temp or IN1_temp or S0_temp)
      begin
      if((S0_temp == 1'b0))
        Y = IN0_temp;
      else  if((S0_temp == 1'b1))
        Y = IN1_temp;
      else
        Y = 'bx;
      end
endmodule


//--------------------  3 - i n p u t     M U X   --------------------
module mux3_8$(Y,IN0,IN1,IN2,S0,S1);
  input [7:0] IN0;
  input [7:0] IN1;
  input [7:0] IN2;
  input  S0;
  input  S1;
  output [7:0] Y;
  reg    [7:0] Y;
  wire [7:0] IN0_temp;
  wire [7:0] IN1_temp;
  wire [7:0] IN2_temp;
  wire  S0_temp;
  wire  S1_temp;
  assign #(0.46:0.5:0.54) S0_temp = S0;
  assign #(0.46:0.5:0.54) S1_temp = S1;
  assign #(0.20:0.22:0.24) IN0_temp = IN0;
  assign #(0.20:0.22:0.24) IN1_temp = IN1;
  assign #(0.20:0.22:0.24) IN2_temp = IN2;
  always
    @(IN0_temp or IN1_temp or IN2_temp or S0_temp or S1_temp)
      begin
      if(((S1_temp == 1'b0) && (S0_temp == 1'b0)))
        Y = IN0_temp;
      else      if(((S1_temp == 1'b0) && (S0_temp == 1'b1)))
        Y = IN1_temp;
      else      if((S1_temp == 1'b1))
        Y = IN2_temp;
      else
        Y = 'bx;
      end
endmodule

module mux3_16$(Y,IN0,IN1,IN2,S0,S1);
  input [15:0] IN0;
  input [15:0] IN1;
  input [15:0] IN2;
  input  S0;
  input  S1;
  output [15:0] Y;
  reg    [15:0] Y;
  wire [15:0] IN0_temp;
  wire [15:0] IN1_temp;
  wire [15:0] IN2_temp;
  wire  S0_temp;
  wire  S1_temp;
  assign #(0.46:0.5:0.54) S0_temp = S0;
  assign #(0.46:0.5:0.54) S1_temp = S1;
  assign #(0.20:0.22:0.24) IN0_temp = IN0;
  assign #(0.20:0.22:0.24) IN1_temp = IN1;
  assign #(0.20:0.22:0.24) IN2_temp = IN2;
  always
    @(IN0_temp or IN1_temp or IN2_temp or S0_temp or S1_temp)
      begin
      if(((S1_temp == 1'b0) && (S0_temp == 1'b0)))
        Y = IN0_temp;
      else      if(((S1_temp == 1'b0) && (S0_temp == 1'b1)))
        Y = IN1_temp;
      else      if((S1_temp == 1'b1))
        Y = IN2_temp;
      else
        Y = 'bx;
      end
endmodule

//--------------------  4 - i n p u t     M U X   --------------------
module mux4_8$(Y,IN0,IN1,IN2,IN3,S0,S1);
  input [7:0] IN0;
  input [7:0] IN1;
  input [7:0] IN2;
  input [7:0] IN3;
  input  S0;
  input  S1;
  output [7:0] Y;
  reg    [7:0] Y;
  wire [7:0] IN0_temp;
  wire [7:0] IN1_temp;
  wire [7:0] IN2_temp;
  wire [7:0] IN3_temp;
  wire  S0_temp;
  wire  S1_temp;
  assign #(0.20:0.22:0.24) IN0_temp = IN0;
  assign #(0.20:0.22:0.24) IN1_temp = IN1;
  assign #(0.20:0.22:0.24) IN2_temp = IN2;
  assign #(0.20:0.22:0.24) IN3_temp = IN3;
  assign #(0.46:0.5:0.54) S0_temp = S0;
  assign #(0.46:0.5:0.54) S1_temp = S1;
  always
    @(IN0_temp or IN1_temp or IN2_temp or IN3_temp or S0_temp or S1_temp)
      begin
      if(((S1_temp == 1'b0) && (S0_temp == 1'b0)))
        Y = IN0_temp;
      else      if(((S1_temp == 1'b0) && (S0_temp == 1'b1)))
        Y = IN1_temp;
      else      if(((S1_temp == 1'b1) && (S0_temp == 1'b0)))
        Y = IN2_temp;
      else      if(((S1_temp == 1'b1) && (S0_temp == 1'b1)))
        Y = IN3_temp;
      else
        Y = 'bx;
      end
endmodule

module mux4_16$(Y,IN0,IN1,IN2,IN3,S0,S1);
  input [15:0] IN0;
  input [15:0] IN1;
  input [15:0] IN2;
  input [15:0] IN3;
  input  S0;
  input  S1;
  output [15:0] Y;
  reg    [15:0] Y;
  wire [15:0] IN0_temp;
  wire [15:0] IN1_temp;
  wire [15:0] IN2_temp;
  wire [15:0] IN3_temp;
  wire  S0_temp;
  wire  S1_temp;
  assign #(0.20:0.22:0.24) IN0_temp = IN0;
  assign #(0.20:0.22:0.24) IN1_temp = IN1;
  assign #(0.20:0.22:0.24) IN2_temp = IN2;
  assign #(0.20:0.22:0.24) IN3_temp = IN3;
  assign #(0.46:0.5:0.54) S0_temp = S0;
  assign #(0.46:0.5:0.54) S1_temp = S1;
  always
    @(IN0_temp or IN1_temp or IN2_temp or IN3_temp or S0_temp or S1_temp)
      begin
      if(((S1_temp == 1'b0) && (S0_temp == 1'b0)))
        Y = IN0_temp;
      else      if(((S1_temp == 1'b0) && (S0_temp == 1'b1)))
        Y = IN1_temp;
      else      if(((S1_temp == 1'b1) && (S0_temp == 1'b0)))
        Y = IN2_temp;
      else      if(((S1_temp == 1'b1) && (S0_temp == 1'b1)))
        Y = IN3_temp;
      else
        Y = 'bx;
      end
endmodule


//-----------------------------------------------------------
// Library parts V
// ---------------
// EE382N-14945, Spring 2000.
// (Some are modified from those provided by Cascade Design Automation Corp).
// All module parts' name are appended with a "$" character.
// This part of the library consists of the following parts:
//
// decoder2_4$	- 2 to 4 decoder
// decoder3_8$	- 3 to 8 decoder
// syn_cntr8$	- synchronuous up/down counter with preset/parallel load
// pencoder8_3$ - priority encoder, 8-lines to 3-lines
// pencoder8_3v$- priority encoder with valid output, 8-lines to 3-lines
// mag_comp8$	- 8-bits magnitude comparator

//             IMPORTANT
//
//	The first four functions of the ALU will not work properly
// 	when cascading multiple ALU slices together. Also the implementation of
//	A minus B and A minus B minus 1 are interchanged here from the sheet
//	handed to you in class.
//
// alu4$	- 4-bit ALU slice
// 
//
//------------------------------------------------------
//   D  e  c  o  d  e  r :       2 select inputs
//
//       Timing specs taken from page 2-37
//------------------------------------------------------
module decoder2_4$(SEL,Y,YBAR);
  input [1:0] SEL;
  output [3:0] Y;
  output [3:0] YBAR;
  reg [3:0] Y_temp;
  reg [3:0] YBAR_temp;
  integer i;
  assign #(0.36:0.40:0.44) Y = Y_temp;
  assign #(0.36:0.40:0.44) YBAR = YBAR_temp;

  always
    @(SEL)
      begin
      for(i = 0;(i <= 3);i = (i + 1))
        if(i == SEL)
	begin
          Y_temp[i] = 1'b1;
          YBAR_temp[i] = 1'b0;
	end
        else
	begin
          Y_temp[i] = 1'b0;
          YBAR_temp[i] = 1'b1;
	end
      end
endmodule

//------------------------------------------------------
//   D  e  c  o  d  e  r :       3 select inputs
//
//       Timing specs taken from page 2-37
//------------------------------------------------------
module decoder3_8$(SEL,Y,YBAR);
  input [2:0] SEL;
  output [7:0] Y;
  output [7:0] YBAR;
  reg [7:0] Y_temp;
  reg [7:0] YBAR_temp;
  integer i;
  assign #(0.36:0.40:0.44) Y = Y_temp;
  assign #(0.36:0.40:0.44) YBAR = YBAR_temp;

  always
    @(SEL)
      begin
      for(i = 0;(i <= 7);i = (i + 1))
        if(i == SEL)
	begin
          Y_temp[i] = 1'b1;
          YBAR_temp[i] = 1'b0;
	end
        else
	begin
          Y_temp[i] = 1'b0;
          YBAR_temp[i] = 1'b1;
	end
      end
endmodule

//------------------------------------------------------
//  S y n c h r o n u o u s     C o u n t e r:   8-bits
//
//	   Timing specs taken from page 2-118.
//------------------------------------------------------
module syn_cntr8$(CLK,CLR,D,EN,PRE,PL,UP,COUT,Q);
  input  CLK;
  input  CLR;
  input [7:0] D;
  input  EN;
  input  PRE;
  input  PL;
  input  UP;
  output  COUT;
  output [7:0] Q;
  wire  COUT_temp;
  wire   [7:0] Q_temp;
  assign #(0.48:0.52:0.56, 0.42:0.46:0.50) Q = Q_temp;
  assign #(0.85:0.90:0.95)           COUT = COUT_temp;

  syn_cntr syn_cntr(CLK,CLR,D,EN,PRE,PL,UP,COUT_temp,Q_temp);

  specify
	$setup(EN, edge[01,x1] CLK, 0.40:0.44:0.48);
	$setup(PL, edge[01,x1] CLK, 0.32:0.36:0.40);
	$setup(UP, edge[01,x1] CLK, 0.42:0.46:0.50);
	$setup(D,  edge[01,x1] CLK, 0.34:0.38:0.42);
	$width(edge[01,x1] CLR, 0.10:0.12:0.14);
	$width(edge[01,x1] PRE, 0.10:0.12:0.14);
  endspecify
endmodule

module syn_cntr(CLK,CLR,D,EN,PRE,PL,UP,COUT,Q);
  input  CLK;
  input  CLR;
  input [7:0] D;
  input  EN;
  input  PRE;
  input  PL;
  input  UP;
  output  COUT;
  output [7:0] Q;
  wire  SCANIN = 'b0;
  wire  TEST = 'b0;
  reg  COUT_reg;
  reg [7:0] Q_reg;
  reg  couttemp;
  reg [7:0] temp;

  assign Q = Q_reg;
  assign COUT = COUT_reg;

  always
    @(PRE or CLR)
      begin
      if(((CLR == 1'b0) && (PRE == 1'b1)))
        begin
        temp = 'b0;
        Q_reg = temp;
        COUT_reg = 'b0;
        end
      else      if(((PRE == 1'b0) && (CLR == 1'b1)))
        begin
        temp = ( ~ 'b0);
        Q_reg = temp;
        COUT_reg = 'b0;
        end
      else      if(((CLR != 1'b1) || (PRE != 1'b1)))
        begin
        Q_reg = 'bx;
        COUT_reg = 'b0;
        end
      end
  always
    @(posedge CLK)
      if(((PRE == 1'b1) && (CLR == 1'b1)))
        begin
        temp = 'bx;
//        if(((( ^ Q) === 1'bx) && (EN == 1'b1)))
//          couttemp = 1'bx;
//        else
//          couttemp = 1'b0;
        if((TEST == 1'b0))
          begin
          if((PL == 1'b0))
            begin
            if((EN == 1'b1))
              begin
              if((UP == 1'b1))
                begin
//                if(( Q == 8'b11111110 ))
//                  couttemp = 1'b1;
                temp = (Q_reg + 1'b1);
                end
              else              if((UP == 1'b0))
                begin
//                if(( Q == 8'b00000001 ))
//                  couttemp = 1'b1;
                temp = (Q_reg - 1'b1);
                end

end
            else            if((EN == 1'b0))
              begin
              temp = Q_reg;
              end
            end
          else          if((PL == 1'b1))
            temp = D;
          end
        else        if((TEST == 1'b1))
          begin
          temp = Q_reg;
          temp = (temp << 1);
          temp[0] = SCANIN;
        end
        Q_reg = temp;
//        COUT = couttemp;
        end


  always @(EN or UP or Q)
      if(((PRE == 1'b1) && (CLR == 1'b1)))
        begin
        if(((( ^ Q_reg) === 1'bx) && (EN == 1'b1)))
          couttemp = 1'bx;
        else
          couttemp = 1'b0;
        if((TEST == 1'b0))
          begin
          if((PL == 1'b0))
            begin
            if((EN == 1'b1))
              begin
              if((UP == 1'b1))
                begin
                if((( ~ Q_reg ) == 1'b0 ))
                  couttemp = 1'b1;
                end
              else              if((UP == 1'b0))
                begin
                if(( Q_reg == 1'b0 ))
                  couttemp = 1'b1;
                end
              end
	    end	
	  end
        COUT_reg = couttemp;
	end

endmodule


//---------------------------------------------------------------------------
//      P r i o r i t y     E n c o d e r :  8-lines to 3-lines
//
//---------------------------------------------------------------------------
// Truth table for a 8-to-3 priority endcoder:
//
// enbar                    inputs                        outputs      valid
//         X[7] X[6] X[5] X[4] X[3] X[2] X[1] X[0]     Y[2] Y[1] Y[0] 
//---------------------------------------------------------------------------
//  H       x    x    x    x    x    x    x    x        z    z    z      z
//  L       L    L    L    L    L    L    L    H        L    L    L      H
//  L       L    L    L    L    L    L    H    x        L    L    H      H
//  L       L    L    L    L    L    L    x    x        L    H    L      H
//  L       L    L    L    L    H    x    x    x        L    H    H      H
//  L       L    L    L    H    x    x    x    x        H    L    L      H
//  L       L    L    H    x    x    x    x    x        H    L    H      H
//  L       L    H    x    x    x    x    x    x        H    H    L      H
//  L       H    x    x    x    x    x    x    x        H    H    H      H
//
//  L       L    L    L    L    L    L    L    L        L    L    L      L

module pencoder8_3v$(enbar,X,Y,valid);
  input enbar;
  input [7:0] X;
  output [2:0] Y;
  output valid;
  wire   valid;
  reg    valid_temp;
  reg [2:0] Y_temp;
  assign #(0.71:0.76:0.81) Y = Y_temp;
  assign #(0.71:0.76:0.81) valid = valid_temp;

  always @(enbar or X)
	begin
  	valid_temp = 1;
        if (enbar) begin Y_temp = 3'bz; valid_temp = 1'bz; end
        else if (X[7]==1'b1) Y_temp=7;
	else if (X[6]==1'b1) Y_temp=6;
	else if (X[5]==1'b1) Y_temp=5;
	else if (X[4]==1'b1) Y_temp=4;
	else if (X[3]==1'b1) Y_temp=3;
	else if (X[2]==1'b1) Y_temp=2;
	else if (X[1]==1'b1) Y_temp=1;
	else if (X[0]==1'b1) Y_temp=0;
	else if (X==0) begin Y_temp=0; valid_temp=0; end
	else begin Y_temp = 3'bx; valid_temp=1'bx; end
	end
endmodule

//--------------------------------------------------------------------
//      P r i o r i t y     E n c o d e r :  8-lines to 3-lines
//
//--------------------------------------------------------------------
// Truth table for a 8-to-3 priority endcoder:
//
// enbar                    inputs                        outputs
//         X[0] X[1] X[2] X[3] X[4] X[5] X[6] X[7]     Y[2] Y[1] Y[0] 
//--------------------------------------------------------------------
//  H       x    x    x    x    x    x    x    x        z    z    z
//  L       x    x    x    x    x    x    x    L        L    L    L 
//  L       x    x    x    x    x    x    L    H        L    L    H 
//  L       x    x    x    x    x    L    H    H        L    H    L 
//  L       x    x    x    x    L    H    H    H        L    H    H 
//  L       x    x    x    L    H    H    H    H        H    L    L 
//  L       x    x    L    H    H    H    H    H        H    L    H 
//  L       x    L    H    H    H    H    H    H        H    H    L
//  L       L    H    H    H    H    H    H    H        H    H    H 
//  L       H    H    H    H    H    H    H    H        z    z    z
//
module pencoder8_3$(enbar,X,Y);
  input enbar;
  input [7:0] X;
  output [2:0] Y;
  reg [2:0] Y_temp;
  assign #(0.71:0.76:0.81) Y = Y_temp;

  always @(enbar or X)
        if (enbar) Y_temp = 3'bz;
        else if (X[7]==1'b0) Y_temp=0;
	else if (X[6]==1'b0) Y_temp=1;
	else if (X[5]==1'b0) Y_temp=2;
	else if (X[4]==1'b0) Y_temp=3;
	else if (X[3]==1'b0) Y_temp=4;
	else if (X[2]==1'b0) Y_temp=5;
	else if (X[1]==1'b0) Y_temp=6;
	else if (X[0]==1'b0) Y_temp=7;
	else if (X==255)    Y_temp=3'bz;
	else Y_temp = 3'bx;
endmodule


//------------------------------------------------------
//   M a g n i t u d e     C o m p a r a t o r:   8-bits
//
//       Timing specs taken from page 2-29
//------------------------------------------------------
module mag_comp8$(A, B, AGB, BGA);
  input [7:0] A,B;
  output AGB,BGA;
  reg    AGB_temp,BGA_temp;

  assign #(1.4:1.46:1.52, 1.2:1.34:1.5) AGB = AGB_temp;
  assign #(1.4:1.46:1.52, 1.2:1.34:1.5) BGA = BGA_temp;

  always
    @(A or B)
      begin
	AGB_temp = (A>B)? 1:0;
	BGA_temp = (B>A)? 1:0;
      end
endmodule

//------------------------------------------------------
//   M a g n i t u d e     C o m p a r a t o r:   4-bits
//
//
//------------------------------------------------------
module mag_comp4$(A, B, AGB, BGA);
  input [3:0] A,B;
  output AGB,BGA;
  reg    AGB_temp,BGA_temp;

  assign #(1.1:1.16:1.22, 1.0:1.14:1.3) AGB = AGB_temp;
  assign #(1.1:1.16:1.22, 1.0:1.14:1.3) BGA = BGA_temp;

  always
    @(A or B)
      begin
	AGB_temp = (A>B)? 1:0;
	BGA_temp = (B>A)? 1:0;
      end
endmodule

//------------------------------------------------------
//    A    L   U     S l i c e:     4-bits
//
//       Timing specs taken from page 2-7
//------------------------------------------------------
module alu4$(a,b,cin,m,s,cout,out);
  input [3:0] a;
  input [3:0] b;
  input  cin;
  input  m;
  input [3:0] s;
  output  cout;
  output [3:0] out;
  reg  cout;
  reg [3:0] out;
  reg [3:0] logic;
  reg [4:0] pr;
  reg [3:0] pr1;
  reg [4:0] arith;
  reg  cinbar;
  wire [3:0] #(0.68:0.72:0.76, 0.9:0.94:1.0) s_temp = s;//Let t_p(S-COUT)=t_p(S-F)
  wire [3:0] #(0.68:0.72:0.76, 0.9:0.94:1.0) m_temp = m;//   =t_p(M-COUT)=t_p(M-F)
  wire [3:0] #(0.9:1.0:1.1) a_temp = a;    //Let t_p(AB-COUT)=t_p(AB-F)
  wire [3:0] #(0.9:1.0:1.1) b_temp = b;    //Let t_p(AB-COUT)=t_p(AB-F)
  wire #(0.55:0.6:0.65, 0.62:0.68:0.74)cin_temp = cin;//t_p(Cin-COUT)=t_p(Cin-F)

  always
    @(a_temp or b_temp or cin_temp or s_temp or m_temp)
      begin
      cinbar = ( ~ cin_temp);
      if((s_temp == 4'd0))
        begin
        logic = ( ~ a_temp);
        arith = ({1'b0,a_temp} - cinbar);
        end
      else      if((s_temp == 4'd1))
        begin
        logic = ( ~ (a_temp & b_temp));
        pr = (a_temp & b_temp);
        arith = ({1'b0,pr} - cinbar);
        end
      else      if((s_temp == 4'd2))
        begin
        logic = (( ~ a_temp) | b_temp);
        pr = ( ~ logic);
        arith = ({1'b0,pr} - cinbar);
        end
      else      if((s_temp == 4'd3))
        begin
        logic = ( ~ 'b0);
        arith = ({1'b0,logic} + cin_temp);
        end
      else      if((s_temp == 4'd4))
        begin
        logic = ( ~ (a_temp | b_temp));
        pr = (a_temp | ( ~ b_temp));
        arith = (a_temp + ({1'b0,pr} + cin_temp));
        end
      else      if((s_temp == 4'd5))
        begin
        logic = ( ~ b_temp);
        pr = (a_temp & b_temp);
        pr1 = (a_temp | ( ~ b_temp));
        arith = (pr + ({1'b0,pr1} + cin_temp));
        end
      else      if((s_temp == 4'd6))
        begin
        logic = ( ~ (a_temp ^ b_temp));
        //pr = (( ~ (b_temp + cinbar)) + 1'b1);
        //arith = ({1'b0,a_temp} + pr);
        arith = a - b - cin;
        cout = arith[4];
        end
      else      if((s_temp == 4'd7))
        begin
        logic = (a_temp | ( ~ b_temp));
        arith = ({1'b0,logic} + cin_temp);
        end
      else      if((s_temp == 4'd8))
        begin
        logic = (( ~ a_temp) & b_temp);
        pr = (a_temp | b_temp);
        arith = (a_temp + ({1'b0,pr} + cin_temp));
        end
      else      if((s_temp == 4'd9))
        begin
        logic = (a_temp ^ b_temp);
        arith = (a_temp + ({1'b0,b_temp} + cin_temp));
        end
      else      if((s_temp == 4'd10))
        begin
        logic = b_temp;
        pr = (a_temp & ( ~ b_temp));
        pr1 = (a_temp | b_temp);
        arith = (pr + ({1'b0,pr1} + cin_temp));
        end
      else      if((s_temp == 4'd11))
        begin
        logic = (a_temp | b_temp);
        arith = ({1'b0,logic} + cin_temp);
        end
      else      if((s_temp == 4'd12))
        begin
        logic = 'b0;
        arith = (a_temp + ({1'b0,a_temp} + cin_temp));
        end
      else      if((s_temp == 4'd13))
        begin
        logic = (a_temp & ( ~ b_temp));
        pr = (a_temp & b_temp);
        arith = (pr + ({1'b0,a_temp} + cin_temp));
        end
      else      if((s_temp == 4'd14))
        begin
        logic = (a_temp & b_temp);
        pr = (a_temp & ( ~ b_temp));
        arith = (pr + ({1'b0,a_temp} + cin_temp));
        end
      else      if((s_temp == 4'd15))
        begin
        logic = a_temp;
        arith = ({1'b0,a_temp} + cin_temp);
        end
      else
        begin
        logic = 'bX;
        arith = 'bX;
        end
      if((m_temp == 1'b0))
        begin
        cout = 1'b0;
        out = logic;
        end
      else      if((m_temp == 1'b1))
        begin
        cout = arith[4];
        out = arith[3:0];
        end
      else
        begin
        cout = 1'bX;
        out = 'bX;
        end
      end
endmodule
//--------------------------------------------------------
// Library parts VI
// -----------------
// EE382N-14945, Spring 2000.
// (Some are modified from those provided by Cascade Design Automation Corp).
// All module parts' name are appended with a "$" character.
// This part of the library consists of the following parts:
//
// sram128x8$ 		128 x 8-bit SRAM
// sram32x16$ 		32 x 16-bit SRAM
// sram32x32$ 		32 x 32-bit SRAM
//
//---------------------------------------------------------
//          S    R    A    M    :  128 x 8 bits
//
// Timing specs taken from CY7C128(55), Cypress Semiconductor.
//---------------------------------------------------------
module  sram128x8$ (A,DIO,OE,WR, CE);

	`define  t_DOE		25
	`define  t_HZ		17.5
        // t_HZCE = t_HZOE = t_HZWE = 17.5


	input [6:0] A;
	inout [7:0] DIO;
	input WR,OE;
	input CE;

	reg   [6:0] A_temp;
	reg   CE_temp;
	reg  [6:0] lastread_addr;
	reg din_changed,a_changed;
	reg [7:0] mem [127:0];
	event addr_unstable_memory;

always @(negedge WR or CE)
 if ((CE==0)&&(WR==0))
 begin: write_block
  mem[A] = 'bx;

  fork
   begin: wr_mem
     mem[A] = DIO;
   end
   forever @(DIO)
    begin
     disable wr_mem;
     mem[A] = DIO;
    end
    forever @(posedge WR or A)
     disable write_block;
   join
end

always @(A)
  begin
     if ((WR ==1)&&(CE==0))
      begin
       disable a_dout;
       a_changed =1;
      end
     else
     if (CE==0)
      begin
       $display("(WARNING) Address changed when WR was low at time %t",$realtime);
        -> addr_unstable_memory;
      end
  end

always @(addr_unstable_memory)
     begin
       mem[lastread_addr] ='bx;
       mem[A] = 'bx;
     end

always
     begin: a_dout
       wait(a_changed);
        a_changed = 0;
        lastread_addr = A;
     end

always@(CE)
   if ((WR==1)&&(OE==0)&&(CE==0))
	#35 CE_temp = CE;    
   else
	CE_temp = CE;

always@(A)
   if ((WR==1)&&(OE==0)&&(CE==0))
	#35 A_temp = A;   //t_AA = 35 + t_DOE = 60
   else
	A_temp = A;


assign #(`t_DOE,`t_DOE,`t_HZ) 
	DIO= ((WR==1)&&(OE==0)&&(CE_temp==0))?mem[A_temp]:8'bzzzz;
assign  #(`t_HZ)              DIO= (WR)? 8'bzzzz:8'bzzzz;

specify
        specparam
          //addr_hold_time =0, data_hold_time=0, 
	  address_setup_time=25,			//t_AW  = 25
	  data_setup_time=25,				//t_SD  = 25
	  CE_setup_time=35,				//t_SCE = 35
          write_pulse_low=25,				//t_PWE = 25
	  cycle_time=75;				//t_RC  = 75
	$setup(A, negedge WR, address_setup_time);	//address setup check
	$setup(DIO, posedge WR, data_setup_time);	//data setup check
	$setup(negedge CE, posedge WR, CE_setup_time);	//CE setup check
	$width(negedge WR, write_pulse_low); 		//WR low width check
	$period(posedge WR, cycle_time);		//cycle time check
   endspecify
endmodule

//---------------------------------------------------------
//          S    R    A    M    :  32 x 8 bits
//
// Timing specs taken from CY7C128(55), Cypress Semiconductor.
//---------------------------------------------------------
module  sram32x8$ (A,DIO,OE,WR, CE);

	
	`define  t_DOE		25
	`define  t_HZ		17.5
        // t_HZCE = t_HZOE = t_HZWE = 17.5


	input [4:0] A;
	inout [7:0] DIO;
	input WR,OE;
	input CE;

	reg   [4:0] A_temp;
	reg   CE_temp;
	reg  [4:0] lastread_addr;
	reg din_changed,a_changed;
	reg [7:0] mem [31:0];
	event addr_unstable_memory;

always @(negedge WR or CE)
 if ((CE==0)&&(WR==0))
 begin: write_block
  mem[A] = 'bx;

  fork
   begin: wr_mem
     mem[A] = DIO;
   end
   forever @(DIO)
    begin
     disable wr_mem;
     mem[A] = DIO;
    end
    forever @(posedge WR or A)
     disable write_block;
   join
end

always @(A)
  begin
     if ((WR ==1)&&(CE==0))
      begin
       disable a_dout;
       a_changed =1;
      end
     else
     if (CE==0)
      begin
       $display("(WARNING) Address changed when WR was low at time %t",$realtime);
        -> addr_unstable_memory;
      end
  end

always @(addr_unstable_memory)
     begin
       mem[lastread_addr] ='bx;
       mem[A] = 'bx;
     end

always
     begin: a_dout
       wait(a_changed);
        a_changed = 0;
        lastread_addr = A;
     end

always@(CE)
   if ((WR==1)&&(OE==0)&&(CE==0))
	#35 CE_temp = CE;    
   else
	CE_temp = CE;

always@(A)
   if ((WR==1)&&(OE==0)&&(CE==0))
	#35 A_temp = A;   
   else
	A_temp = A;


assign #(`t_DOE,`t_DOE,`t_HZ) 
	DIO= ((WR==1)&&(OE==0)&&(CE_temp==0))?mem[A_temp]:8'bzzzz;
assign  #(`t_HZ)              DIO= (WR)? 8'bzzzz:8'bzzzz;

specify
        specparam
          //addr_hold_time =0, data_hold_time=0, 
	  address_setup_time=25,			//t_AW  = 25
	  data_setup_time=25,				//t_SD  = 25
	  CE_setup_time=37.5,				//t_SCE = 37.5
          write_pulse_low=25,				//t_PWE = 25
	  cycle_time=75;				//t_RC  = 75
	$setup(A, negedge WR, address_setup_time);	//address setup check
	$setup(DIO, posedge WR, data_setup_time);	//data setup check
	$setup(negedge CE, posedge WR, CE_setup_time);	//CE setup check
	$width(negedge WR, write_pulse_low); 		//WR low width check
	$period(posedge WR, cycle_time);		//cycle time check
   endspecify
endmodule

module	sram32x16$(A,DIO,OE,WRH,WRL,CE);

	input [4:0] A;
	inout [15:0] DIO;
	input WRH, WRL, OE, CE;
	
	sram32x8$	ram1(A, DIO[15:8], OE, WRH, CE),
			ram2(A, DIO[7:0], OE, WRL, CE);

endmodule
/*------------------------------------------------------------------
module sram_test;

reg [6:0] A;
tri [7:0] DIO;
reg [7:0] DIO_reg;
reg WR,OE;
reg CE;
reg en;

bufif1 buffer0(DIO[0], DIO_reg[0], en);
bufif1 buffer1(DIO[1], DIO_reg[1], en);
bufif1 buffer2(DIO[2], DIO_reg[2], en);
bufif1 buffer3(DIO[3], DIO_reg[3], en);
bufif1 buffer4(DIO[4], DIO_reg[4], en);
bufif1 buffer5(DIO[5], DIO_reg[5], en);
bufif1 buffer6(DIO[6], DIO_reg[6], en);
bufif1 buffer7(DIO[7], DIO_reg[7], en);

sram128x8$ ram(A,DIO,OE,WR, CE);

//initial $readmemh("mem.data",ram.mem);

initial ram.mem[0] = 0;

initial 
$monitor("%t A=%h, en=%b, DIO=%h, OE=%h, WR=%h, CE=%h, ram.mem[0]=%h",
	$time, A, en, DIO, OE, WR, CE, ram.mem[0]);


initial
begin 
	WR=1;
	CE=1;
	OE=1;
	en=1;
	A=0;
	#10 
	CE=0;
	DIO_reg = 'hf;
	#50 
	WR=0;
	#100 
	WR=1;
	CE=1;
	#100
$strobe("end of write cycle, ram.mem[0]=%h",ram.mem[0]);

	#100
	en=0;
	CE=0;
	OE=0;
	#150
//read the valid data here, before CE=1;
	CE=1;
	#100
$strobe("end of read cycle, DIO = %h,ram.mem[0]=%h",DIO, ram.mem[0]);

	#100
	CE=0;
	en=1;
	A=0;
	DIO_reg = 'h8;
	#50 
	WR=0;
	#100 
	WR=1;
	CE=1;
	en=0;
	#100
$strobe("end of write cycle, ram.mem[0]=%h",ram.mem[0]);

	#100
	CE=0;
	#150
//read the valid data here, before CE=1;
	CE=1;
	#100
$strobe("end of read cycle, DIO=%h, ram.mem[0]=%h",DIO, ram.mem[0]);
	#100
	$stop;

end
endmodule
*/

/*------------------------------------------------------------------
New traces:

VERILOG-XL 1.6   Mar 12, 1993  15:36:51
  * Copyright Cadence Design Systems, Inc. 1985, 1988.    *
  *     All Rights Reserved.       Licensed Software.     *
  * Confidential and proprietary information which is the *
  *      property of Cadence Design Systems, Inc.         *
Compiling source file "lib6"
Highest level modules:
sram_test

                   0 A=00, en=1, DIO=xx, OE=1, WR=1, CE=1, ram.mem[0]=00
                  10 A=00, en=1, DIO=xx, OE=1, WR=1, CE=0, ram.mem[0]=00
                  35 A=00, en=1, DIO=0f, OE=1, WR=1, CE=0, ram.mem[0]=00
                  60 A=00, en=1, DIO=0f, OE=1, WR=0, CE=0, ram.mem[0]=0f
                 160 A=00, en=1, DIO=0f, OE=1, WR=1, CE=1, ram.mem[0]=0f
end of write cycle, ram.mem[0]=0f
                 360 A=00, en=0, DIO=zz, OE=0, WR=1, CE=0, ram.mem[0]=0f
                 480 A=00, en=0, DIO=0f, OE=0, WR=1, CE=0, ram.mem[0]=0f
                 510 A=00, en=0, DIO=0f, OE=0, WR=1, CE=1, ram.mem[0]=0f
                 545 A=00, en=0, DIO=zz, OE=0, WR=1, CE=1, ram.mem[0]=0f
end of read cycle, DIO = zz,ram.mem[0]=0f
                 710 A=00, en=1, DIO=08, OE=0, WR=1, CE=0, ram.mem[0]=0f
                 760 A=00, en=1, DIO=08, OE=0, WR=0, CE=0, ram.mem[0]=08
                 860 A=00, en=0, DIO=zz, OE=0, WR=1, CE=1, ram.mem[0]=08
end of write cycle, ram.mem[0]=08
                1060 A=00, en=0, DIO=zz, OE=0, WR=1, CE=0, ram.mem[0]=08
                1180 A=00, en=0, DIO=08, OE=0, WR=1, CE=0, ram.mem[0]=08
                1210 A=00, en=0, DIO=08, OE=0, WR=1, CE=1, ram.mem[0]=08
                1245 A=00, en=0, DIO=zz, OE=0, WR=1, CE=1, ram.mem[0]=08
end of read cycle, DIO=zz, ram.mem[0]=08
L199 "lib6": $stop at simulation time 1410
Type ? for help
C1 > 
C1 > 308 simulation events + 85 accelerated events + 115 timing check events
CPU time: 0 secs to compile + 0 secs to link + 0 secs in simulation
End of VERILOG-XL 1.6   Mar 12, 1993  15:37:36

------------------------------------------------------------------*/

//---------------------------------------------------------
//          S    R    A    M    :  32 x 32 bits
//
// Timing specs taken from CY7C128(55), Cypress Semiconductor.
//---------------------------------------------------------
module  sram32x32$ (A,DIO,OE,WR, CE);

	`define  t_DOE		25
	`define  t_HZ		17.5
	// t_HZCE = t_HZOE = t_HZWE = 17.5


	input [4:0] A;
	inout [31:0] DIO;
	input WR,OE;
	input CE;
	//output [31:0] DOUT;

	//reg  [31:0] DOUT,ramout;
	reg   [4:0] A_temp;
	reg   CE_temp;
	reg  [4:0] lastread_addr;
	reg din_changed,a_changed;
	reg [31:0] mem [31:0];
	event addr_unstable_memory;

always @(negedge WR or CE)
 if ((CE==0)&&(WR==0))
 begin: write_block
  mem[A] = 'bx;

  fork
   begin: wr_mem
     mem[A] = DIO;
   end
   forever @(DIO)
    begin
     disable wr_mem;
     mem[A] = DIO;
    end
    forever @(posedge WR or A)
     disable write_block;
   join
end

always @(A)
  begin
     if ((WR ==1)&&(CE==0))
      begin
       disable a_dout;
       a_changed =1;
      end
     else
     if (CE==0)
      begin
       $display("(WARNING) Address changed when WR was low at time %t",$realtime);
        -> addr_unstable_memory;
      end
  end

always @(addr_unstable_memory)
     begin
       mem[lastread_addr] ='bx;
       mem[A] = 'bx;
     end

always
     begin: a_dout
       wait(a_changed);
        a_changed = 0;
        lastread_addr = A;
     end

always@(CE)
   if ((WR==1)&&(OE==0)&&(CE==0))
	#35 CE_temp = CE;   //t_ACE = 70 + t_DOE = 120 
   else
	CE_temp = CE;

always@(A)
   if ((WR==1)&&(OE==0)&&(CE==0))
	#35 A_temp = A;   
   else
	A_temp = A;


assign #(`t_DOE,`t_DOE,`t_HZ) 
	DIO= ((WR==1)&&(OE==0)&&(CE_temp==0))?mem[A_temp]:32'bzzzz;
assign  #(`t_HZ)              DIO= (WR)? 32'bzzzz:32'bzzzz;

specify
        specparam
          //addr_hold_time =0, data_hold_time=0, 
	  address_setup_time=25,			//t_AW  = 25
	  data_setup_time=25,				//t_SD  = 25
	  CE_setup_time=37.5,				//t_SCE = 37.5
          write_pulse_low=25,				//t_PWE = 25
	  cycle_time=75;				//t_RC  = 75
	$setup(A, negedge WR, address_setup_time);	//address setup check
	$setup(DIO, posedge WR, data_setup_time);	//data setup check
	$setup(negedge CE, posedge WR, CE_setup_time);	//CE setup check
	$width(negedge WR, write_pulse_low); 		//WR low width check
	$period(posedge WR, cycle_time);		//cycle time check
   endspecify
endmodule







