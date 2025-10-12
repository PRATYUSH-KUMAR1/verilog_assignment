/*
* this module generates the clock and secound timer.
*this clk is assumed to tick every 1ms.
*/
module clk_timer(
		output wire	clk;
		output wire [32:0] time32
		);
// internal resister that store state		
reg r_clk;
reg [32:0] r_time32;
 //initialize resisters
initial begin
	r_clk = 1'b0;
	r_time32 = 32'b0;
end

// assume clk toggles every 1ms for #1.
// hence secound time incement by 1 after every #1000

always #1 r_clk =~r_clk;
always #1000 r_time32= r_time32 + 1;

// wire out the register
assign clk = r_clk;
assign time32 = r_time32;

endmodule


/*
  here we are doing only for the trafic where the 
   1: East-west = S0;
   2: MR-PMC = S1;
   3: OBH-PMC = S2;
   Green=g; Yellow= y; Red=r or all red;
   */

module state(
	input wire clk,
        input wire [32:0] time32,
	output S
 		);
	
	reg [1:0] state, nextstate, light, next_light;	// register to store the present and next state;

	
	
	clk_timer U0(.clk(clk),.time32(time32[32:0]);		 // calling the clock;

	parameter S0 = 3'b101; 					// defining the states in the binary;
	parameter S1 = 3'b011;
	parameter S2 = 3'b110;
	parameter G0 = 2'b00;				// this is considering the light colours as a state
	parameter Y0 = 2'b01;
	parameter R0 = 2'b10;

	
	parameter g1 = 20;	//seting the time for green,yellow,red;
	parameter g2 = 10;
	parameter y = 4;
	parameter r = 2;
	
	
	//* here i have to call the clock that is designed in the module clk_timer.
	always @ (posedge clk, posedge reset)
		if (reset) state <= S0;
		else state <= nextstate;


	always @(*)
		case (state)
			S0: begin
				case(light)
					G0: begin
					if(time32==g1) begin
						next_light = Y0;
						end	
					end
					Y0: begin
						if(time32==y) begin
							next_light = R0;
						end
					    end
					R0: begin
						if(time32==r) begin
			       			nextstate = S1;
						end
					end
				endcase
			end
			S1:begin
				case(light)
					G0: begin
						if(time32==g2) begin
							next_light = Y0;
							end
						end
					Y0: begin
						if(time32==y) begin
							next_light = R0;
							end
						end
					R0: begin
						if(time32==r) begin
						nextstate = S2;
							end
						end
				endcase
			   end
			   S2: begin
				  case(light)
					  G0: begin
						  if(time32==g2) begin
							 next_light = Y0;
						 	end
						end
					Y0: begin 
						if(time32==y) begin
							next_light = R0;
							end
						end
					R0: begin
						if(time32==r) begin
							nextstate = S0;
							end
						end
					endcase
				end	
			default: nextstate = S0;
		endcase
	assign S = (state==S0);

endmodule

























