`timescale 1ms/1ms

/*
  here we are doing for the trafic including the pedesterian 
   1: East-west = S0;
   2: MR-PMC = S1;
   3: OBH-PMC = S2;
   4: Pedesterion = S3;
   Green=g; Yellow= y; Red=r or all red;
*/

module controller(
    input wire clk,
    input wire [1:0] B,
    input wire [2:0] V,
    input wire [32:0] time32,
    output reg [2:0] S
);

    reg [2:0] state, nextstate;
    reg [1:0] light, next_light;
    reg [32:0] entry_time;
    reg ped_request, generated_by_sensor;
    integer elapsed;

    wire ped_btn = |B;

    
    localparam S0 = 3'b101;   // East-west
    localparam S1 = 3'b011;   // MR-PMC
    localparam S2 = 3'b110;   // OBH-PMC
    localparam S3 = 3'b111;   // Pedestria

 
    localparam G0 = 2'b00;
    localparam Y0 = 2'b01;
    localparam R0 = 2'b10;

    localparam g1    = 20;
    localparam g2    = 10;
    localparam y     = 4;
    localparam all_r = 2;

    localparam gp = 10;
    localparam yp = 6;

    initial begin
        state = S0;
        light = G0;
        entry_time = 0;
        ped_request = 0;
        generated_by_sensor = 0;
    end

  
    always @(posedge clk) begin
       
        if (light != R0 && ped_btn)
            ped_request <= 1'b1;

        
        state <= nextstate;
        light <= next_light;

        if ((state != nextstate) || (light != next_light))
            entry_time <= time32;

     
        if (state == S3 && nextstate != S3)
            ped_request <= 1'b0;
    end


    always @(*) begin

        elapsed = time32 - entry_time;
        next_light = light;
        nextstate = state;

        // VEHICLE STATES: S0, S1, S2
        case (state)

        
            S0: begin
                case (light)

                    G0: begin
                        if ((elapsed >= g1) || (generated_by_sensor && V[2] == 0))
                            next_light = Y0;
                    end

                    Y0: begin
                        if (elapsed >= y)
                            next_light = R0;
                    end

                    R0: begin
                        if (elapsed >= all_r) begin
                            if (ped_request) begin
                                nextstate = S3;
                                next_light = G0;
                            end else begin
                                if (V[1]) begin
                                    nextstate = S1; next_light = G0;
                                end else if (V[0]) begin
                                    nextstate = S2; next_light = G0;
                                end else if (V[2]) begin
                                    nextstate = S0; next_light = G0;
                                end else begin
                                    nextstate = S0; next_light = G0;
                                end
                            end
                        end
                    end

                endcase
            end

            S1: begin
                case (light)

                    G0: begin
                        if ((elapsed >= g2) || (generated_by_sensor && V[1] == 0))
                            next_light = Y0;
                    end

                    Y0: begin
                        if (elapsed >= y)
                            next_light = R0;
                    end

                    R0: begin
                        if (elapsed >= all_r) begin
                            if (ped_request) begin
                                nextstate = S3; next_light = G0;
                            end else if (V[0]) begin
                                nextstate = S2; next_light = G0;
                            end else if (V[2]) begin
                                nextstate = S0; next_light = G0;
                            end else begin
                                nextstate = S1; next_light = G0;
                            end
                        end
                    end

                endcase
            end

         
            S2: begin
                case (light)

                    G0: begin
                        if ((elapsed >= g2) || (generated_by_sensor && V[0] == 0))
                            next_light = Y0;
                    end

                    Y0: begin
                        if (elapsed >= y)
                            next_light = R0;
                    end

                    R0: begin
                        if (elapsed >= all_r) begin
                            if (ped_request) begin
                                nextstate = S3; next_light = G0;
                            end else if (V[2]) begin
                                nextstate = S0; next_light = G0;
                            end else if (V[1]) begin
                                nextstate = S1; next_light = G0;
                            end else begin
                                nextstate = S2; next_light = G0;
                            end
                        end
                    end

                endcase
            end

            
            // S3 — PEDESTRIAN SEQUENCE STATE
          
            S3: begin
                case (light)

                    G0: begin
                        if (elapsed >= gp)
                            next_light = Y0;
                    end

                    Y0: begin
                        if (elapsed >= yp)
                            next_light = R0;
                    end

                    R0: begin
                        if (elapsed >= all_r) begin
                            if (V[2]) begin
                                nextstate = S0; next_light = G0;
                            end else if (V[1]) begin
                                nextstate = S1; next_light = G0;
                            end else if (V[0]) begin
                                nextstate = S2; next_light = G0;
                            end else begin
                                nextstate = S0; next_light = G0;
                            end
                        end
                    end

                endcase
            end

            default: nextstate = S0;

        endcase
    end

   
    always @(posedge clk) begin
        if (light != G0 && next_light == G0) begin
            case (nextstate)
                S0: generated_by_sensor <= V[2];
                S1: generated_by_sensor <= V[1];
                S2: generated_by_sensor <= V[0];
                default: generated_by_sensor <= 0;
            endcase
        end
    end

  
    always @(*) begin
        S = state;
    end

endmodule

