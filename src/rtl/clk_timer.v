`timescale 1ms/1ms

/*
  here we are doing for the trafic including the pedesterian 
   1: East-west = S_EW;
   2: MR-PMC = S_MR;
   3: OBH-PMC = S_OBH;
   4: Pedesterion = S_PED;
   Green=g; Yellow= y; Red=r or all red;
*/

module controller(
    input wire clk,                     // clk with 1ms toggle
    input wire [1:0] B,                 // input from padesterian button
    input wire [2:0] V,                 // the input from different vehical sensors
    input wire [32:0] time32,           // clk with 1s toggle
    output reg [2:0] S                  // output that show the encoded states of traffic
);

    // FSM registers
    reg [2:0] state, nextstate;   
    reg [1:0] light, next_light;
    reg [32:0] entry_time;                  // track time when we enter the current state
    reg ped_request, generated_by_sensor;   // latch padesreian request , remember current green was granted because of vehical presence
    integer elapsed;

    wire ped_btn_or = |B;  // the or operation is done on input of pedesterian button

    
    localparam S_EW = 3'b101;    // East-west
    localparam S_MR = 3'b011;    // MR-PMC
    localparam S_OBH = 3'b110;   // OBH-PMC
    localparam S_PED = 3'b111;   // Pedestria

 
    localparam GREEN_L_SQS = 2'b00;         // state of green light
    localparam YELLOW_L_SQS = 2'b01;        // state of yellow light
    localparam RED_L_SQS = 2'b10;           // state of all red light

    // Defining time for vehical traffic in sec.
    localparam green_light_ew = 20;         // green light time for EW
    localparam green_light = 10;            // green light for MR-PMC and OBH-PMC
    localparam yellow_light = 4;            // yellow light for all 
    
    // Defining the time for all red traffic for pedesterian & vehical traffic in sec.
    localparam all_red_light = 2;

    // Defining time for padesterian traffic in sec.
    localparam green_light_ped = 10;
    localparam yellow_light_ped = 6;

    // INITILIGATION
    initial begin
        state = S_EW;
        light = GREEN_L_SQS;
        entry_time = 0;
        ped_request = 0;
        generated_by_sensor = 0;
    end

    // sequence to update the state, light on clk
    always @(posedge clk) begin
       
        if (light != RED_L_SQS && ped_btn_or)          // LATCH THE PEDESTERIAN REQUEST
            ped_request <= 1'b1;
        
        state <= nextstate;                         // UPDARE STATE
        light <= next_light;                        // UPDARE LIGHT

        if ((state != nextstate) || (light != next_light))
            entry_time <= time32;

     
        if (state == S_PED && nextstate != S_PED)           // CLEAR PEDESTERIAN REQUEST AFTER PEDESTERIAN SEQUENCE 
            ped_request <= 1'b0;                            
    end


    always @(*) begin

        elapsed = time32 - entry_time;          // DETERMINING NEXT_LIGHT AND NEXTSTATE BASED ON elapsed time
        next_light = light;
        nextstate = state;

        // VEHICLE STATES: S_EW, S_MR, S_OBH
        case (state)

        
            S_EW: begin             // EAST-WEST VEHICAL TRAFFIC SEQUENCE
                case (light)

                    GREEN_L_SQS: begin          // EAST-WEST GERRN LIGHT SEQUENCE
                        if ((elapsed >= green_light_ew) || (generated_by_sensor && V[2] == 0))  // SKIP IF NO VEHICAL
                            next_light = YELLOW_L_SQS;
                    end

                    YELLOW_L_SQS: begin         // EAST-WEST YELLOW LIGHT SEQUENCE
                        if (elapsed >= yellow_light || (generated_by_sensor && V[2] == 0))      // SKIP IF NO VEHICAL
                            next_light = RED_L_SQS;
                    end

                    RED_L_SQS: begin            // ALL RED SEQUENCE AS WELL AS STATE AND NEXT-LIGHT
                        if (elapsed >= all_red_light) begin
                            if (ped_request) begin
                                nextstate = S_PED;
                                next_light = GREEN_L_SQS;
                            end else begin
                                if (V[1]) begin
                                    nextstate = S_MR; next_light = GREEN_L_SQS;
                                end else if (V[0]) begin
                                    nextstate = S_OBH; next_light = GREEN_L_SQS;
                                end else if (V[2]) begin
                                    nextstate = S_EW; next_light = GREEN_L_SQS;
                                end else begin
                                    nextstate = S_EW; next_light = GREEN_L_SQS;
                                end
                            end
                        end
                    end

                endcase
            end

            S_MR: begin             //  MR-PMC VEHICAL TRAFFIC SEQUENCE
                case (light)

                    GREEN_L_SQS: begin              // MR-PMC GREEN LIGHT SEQUENCE
                        if ((elapsed >= green_light) || (generated_by_sensor && V[1] == 0))     // SKIP IF NO VEHICAL
                            next_light = YELLOW_L_SQS;
                    end

                    YELLOW_L_SQS: begin             // MR-PMC YELLOW LIGHT SEQURNCE
                        if (elapsed >= yellow_light || (generated_by_sensor && V[1] == 0))      //SKIP IF NO VEHICAL
                            next_light = RED_L_SQS;
                    end

                    RED_L_SQS: begin                // ALL RED SEQUENCE AS WELL AS STATE AND NEXT-LIGHT
                        if (elapsed >= all_red_light) begin
                            if (ped_request) begin
                                nextstate = S_PED; next_light = GREEN_L_SQS;
                            end else if (V[0]) begin
                                nextstate = S_OBH; next_light = GREEN_L_SQS;
                            end else if (V[2]) begin
                                nextstate = S_EW; next_light = GREEN_L_SQS;
                            end else begin
                                nextstate = S_MR; next_light = GREEN_L_SQS;
                            end
                        end
                    end

                endcase
            end

         
            S_OBH: begin           // OBH-PMC VEHICAL TRAFFIC SEQUENCE
                case (light)

                    GREEN_L_SQS: begin          // OBH-PMC GREEN LIGHT SEQUENCE
                        if ((elapsed >= green_light) || (generated_by_sensor && V[0] == 0))        // SKIP IF NO VEHICAL
                            next_light = YELLOW_L_SQS;
                    end

                    YELLOW_L_SQS: begin         // OBH-PMC YELLOW LIGHT SEQUENCE
                        if (elapsed >= yellow_light || (generated_by_sensor && V[0] == 0))        // SKIP IF NO VEHICAL
                            next_light = RED_L_SQS;
                    end

                    RED_L_SQS: begin           // ALL RED SEQUENCE AS WELL AS STATE AND NEXT-LIGHT
                        if (elapsed >= all_red_light) begin
                            if (ped_request) begin
                                nextstate = S_PED; next_light = GREEN_L_SQS;
                            end else if (V[2]) begin
                                nextstate = S_EW; next_light = GREEN_L_SQS;
                            end else if (V[1]) begin
                                nextstate = S_MR; next_light = GREEN_L_SQS;
                            end else begin
                                nextstate = S_OBH; next_light = GREEN_L_SQS;
                            end
                        end
                    end

                endcase
            end

            
            // S_PED — PEDESTRIAN SEQUENCE STATE
          
            S_PED: begin
                case (light)

                    GREEN_L_SQS: begin          // GREEN LIGHT SEQUENCE
                        if (elapsed >= green_light_ped)
                            next_light = YELLOW_L_SQS;
                    end

                    YELLOW_L_SQS: begin         // YELLOW LIGHT SEQUENCE
                        if (elapsed >= yellow_light_ped)
                            next_light = RED_L_SQS;
                    end

                    RED_L_SQS: begin                // ALL RED SEQUENCE AS WELL AS STATE AND NEXT-LIGHT
                        if (elapsed >= all_red_light) begin
                            if (V[2]) begin
                                nextstate = S_EW; next_light = GREEN_L_SQS;
                            end else if (V[1]) begin
                                nextstate = S_MR; next_light = GREEN_L_SQS;
                            end else if (V[0]) begin
                                nextstate = S_OBH; next_light = GREEN_L_SQS;
                            end else begin
                                nextstate = S_EW; next_light = GREEN_L_SQS;
                            end
                        end
                    end

                endcase
            end

            default: nextstate = S_EW;

        endcase
    end

   
    always @(posedge clk) begin
        if ((light != GREEN_L_SQS) && (next_light == GREEN_L_SQS)) begin
            case (nextstate)
                S_EW: generated_by_sensor <= V[2];          // EAST-WEST VEHICAL SENSOR
                S_MR: generated_by_sensor <= V[1];          // MR-PMC VEHICAL SENSOR
                S_OBH: generated_by_sensor <= V[0];         // OBH-PMC VEHICAL SENSOR
                default: generated_by_sensor <= 0;          // DEFAULT VELUE IF THERE IS NO VEHICAL
            endcase
        end
    end

    // OUTPUT PRESENT STATE
    always @(*) begin
        S = state;
    end

endmodule

