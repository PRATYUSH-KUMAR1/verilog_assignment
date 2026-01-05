#include <iostream>
// #include <string>
// #include <chronos>
#include <bitset>
#include <cstdint>

enum class STATE{
     S_EW,
     S_MR,
     S_OBH,
     S_PED
};

enum class LIGHT_STATE{
    VCL_GREEN,          // VEHICAL TRAFFIC GREEN LIGHT STATE
    VCL_YELLOW,         // ALL VEHICAL TRAFFIC YELLOW LIGHT STATE
    ALL_RED,            // ALL RED FOR VEHICAL & PEDESTERIAN
    PED_GREEN,          // PEDESTERIAN GREEN LIGHT
    PED_YELLOW,         // PEDESTERIAN YELLOW LIGHT
};

                    class SENSOR_IO {
                    public:
                        std::bitset<3> V;  // vehicle sensors (V[2:0])
                        std::bitset<2> B;  // pedestrian buttons (B[1:0])

                        bool V2, V1, V0;
                        bool B1, B0;

                        // Constructor
                        SENSOR_IO(std::bitset<2> b = 0, std::bitset<3> v = 0)
                            : B(b), V(v)
                        {
                            updateBits();
                        }
                    void updateBits() {
                            V2 = V[2];
                            V1 = V[1];
                            V0 = V[0];

                            B1 = B[1];
                            B0 = B[0];
                        }
                    };

//  class SENSOR_IO{
//                 // VEHIACL SENSORS INPUT
//                 bool V2 = false;            // FROM EW TRAFFIC
//                 bool V1 = false;            // FROM MR TRAFFIC
//                 bool V0 = false;            // FROM OBH TRAFFIC

//                 // PADESTERIAN SENSOR INPUT
//                 bool B = false;            
//             };

void controller(SENSOR_IO &sensor, uint32_t timer){
    
    static STATE state = STATE::S_EW;
    static LIGHT_STATE light = LIGHT_STATE::VCL_GREEN;

    // FOLLOWING IS FOR TIME TRACKING
    static uint32_t state_entery_time = 0;
    uint32_t i = timer - state_entery_time;

    // CREATING THE PEDESTERIAN LATCH THAT NOTE THE BOTTON INPUTS
    static bool ped_latched = false;
    if ((sensor.B.any()) && state != STATE::S_PED)      // IF (ANY PEDESTERIAN BOTTON IS PRESSED "AND" THE PEDESTERIAN SERVICE IS NOT READY);
        ped_latched = true;

    // DEFINING THE LIGHT TIME PERIOD
    int ew_green = 20;
    int green = 10;
    int yellow = 4;
    int green_ped = 10;
    int yellow_ped = 6;
    int all_red = 2;

    switch (state){
        case STATE::S_EW:

            if (!sensor.V2){                        // IF NO VEHICAL THEN MOVE TO NEXT STATE
                state = STATE::S_MR;
                state_entery_time = timer;
                break;
            }

            switch (light){
                case LIGHT_STATE::VCL_GREEN:
                        if((i>= ew_green) || (!sensor.V2))
                        {
                            light = LIGHT_STATE::VCL_YELLOW;
                            state_entery_time = timer;
                        }
                        break;
                case LIGHT_STATE::VCL_YELLOW:
                    if((i>= yellow) || (!sensor.V2))
                    {
                        light = LIGHT_STATE::ALL_RED;
                        state_entery_time = timer;
                    }
                    break;
                case LIGHT_STATE::ALL_RED:
                    if((i>= all_red)){
                        if(ped_latched)
                        {
                            state = STATE::S_PED;
                            light = LIGHT_STATE::PED_GREEN;
                        }
                            else 
                            {
                                state = STATE::S_MR;
                                light = LIGHT_STATE::VCL_GREEN;
                            }
                            break;
                            state_entery_time = timer;
                        }
                    break;
           } 
        break;

        case STATE::S_MR:

           if (!sensor.V1){
                state = STATE::S_OBH;
                state_entery_time = timer;
                break;
           }

            switch (light){
                case LIGHT_STATE::VCL_GREEN:
                        if((i>= green) || (!sensor.V1))
                        {
                            light = LIGHT_STATE::VCL_YELLOW;
                            state_entery_time = timer;
                        }
                        break;
                case LIGHT_STATE::VCL_YELLOW:
                    if((i>= yellow) || (!sensor.V1))
                    {
                        light = LIGHT_STATE::ALL_RED;
                        state_entery_time = timer;
                    }
                    break;
                case LIGHT_STATE::ALL_RED:
                    if((i>= all_red)){
                        if(ped_latched)
                        {
                            state = STATE::S_PED;
                            light = LIGHT_STATE::PED_GREEN;
                        }
                        else 
                            {
                                state = STATE::S_OBH;
                                 light = LIGHT_STATE::VCL_GREEN;
                            }
                            break;
                            state_entery_time = timer;
                        }
                    break;
           }
        break;

        case STATE::S_OBH:
           
           if (!sensor.V0){
            state = STATE::S_EW;
            state_entery_time = timer;
            break;
           }

            switch (light){
                case LIGHT_STATE::VCL_GREEN:
                        if((i>= green) || (!sensor.V0))
                        {
                            light = LIGHT_STATE::VCL_YELLOW;
                            state_entery_time = timer;
                        }
                        break;
                case LIGHT_STATE::VCL_YELLOW:
                    if((i>= yellow) || (!sensor.V0))
                    {
                        light = LIGHT_STATE::ALL_RED;
                        state_entery_time = timer;
                    }
                    break;
                case LIGHT_STATE::ALL_RED:
                    if((i>= all_red)){
                        if(sensor.B1)
                        {
                            state = STATE::S_PED;
                            light = LIGHT_STATE::PED_GREEN;
                        }
                        else 
                            {
                                state = STATE::S_EW;
                                light = LIGHT_STATE::VCL_GREEN;
                            }
                            break;
                            state_entery_time = timer;
                    }
                    break;
           }
        break;

        case STATE::S_PED:

            switch (light){
                case LIGHT_STATE::PED_GREEN:
                        if(i>= green_ped)
                        {
                            light = LIGHT_STATE::PED_YELLOW;
                            state_entery_time = timer;
                        }
                        break;
                case LIGHT_STATE::PED_YELLOW:
                    if((i>= yellow_ped))
                    {
                        light = LIGHT_STATE::ALL_RED;
                        state_entery_time = timer;
                    }
                    break;
                case LIGHT_STATE::ALL_RED:
                    if((i>= all_red)){
                        ped_latched = false;                // RESET THE PEDESTERIAN BOTTON

                            if((!sensor.V2) && (!sensor.V1) && (!sensor.V0))        // IF THERE IS NO VEHICAL AT ANY ROAD THEN
                            {state = STATE::S_PED;
                            light = LIGHT_STATE::PED_GREEN;}
                            else 
                                {
                                    state = STATE::S_EW;
                                    light = LIGHT_STATE::VCL_GREEN;
                                    state_entery_time = timer;
                                }
                            break;
                    }
                    break;
           }
        break;    
   }
}