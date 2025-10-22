`timescale 1ms/1ms

/*
  here we are doing only for the trafic where the 
   1: East-west = S0;
   2: MR-PMC = S1;
   3: OBH-PMC = S2;
   Green=g; Yellow= y; Red=r or all red;
   */

module state(
	input wire clk,
	input wire [1:0] B,
	input wire [1:0] V,
    input wire [32:0] time32,
	output reg [2:0] S
 		);
	
	reg [2:0] state, nextstate;
	reg [1:0] light, next_light;	// register to store the present and next state;

	
	

	
	always @(posedge clk) begin
		if(B==1)
			state <= S3;
		else if(V==0)
			state <= S3;
		else if(B==0 & V==1)    
			state <= S0;
        else state <= nextstate;
		end

	parameter S0 = 3'b101; 					// defining the states in the binary;
	parameter S1 = 3'b011;
	parameter S2 = 3'b110;

	parameter S3 = 3'b111;					// adding the padesrerian sequence

	parameter G0 = 2'b00;				// this is considering the light colours as a state
	parameter Y0 = 2'b01;
	parameter R0 = 2'b10;

	
	parameter g1 = 20;	//seting the time for green,yellow,red;
	parameter g2 = 10;
	parameter y = 4;
	parameter r = 2;
	
	parameter gp = 10;			// the time sequence for the pedesterian
	parameter yp =6;
	
	initial begin
    state = S0;
    light = G0;
	end

	

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
					end	""
				S3: begin
					case(light)
						G0: begin
						if(time32==gp) begin
							next_light = Y0;
							end	
						end
						Y0: begin
							if(time32==yp) begin
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
	always @(*) begin
        S = state;
    end

endmodule