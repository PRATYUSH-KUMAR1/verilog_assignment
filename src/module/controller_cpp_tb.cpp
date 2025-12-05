#include <iostream>
#include <string>
// #include <chronos>
#include <bitset>
// #include 

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

void controller(SENSOR_IO &sensor){
    
    STATE state = STATE::S_EW;
    LIGHT_STATE light = LIGHT_STATE::VCL_GREEN;

    int i=0; 
    // DEFINING THE LIGHT TIME PERIOD
    int ew_green = 20;
    int green = 10;
    int yellow = 4;
    int green_ped = 10;
    int yellow_ped = 6;
    int all_red = 2;

    switch (state){
        case STATE::S_EW:

            switch (light){
                case LIGHT_STATE::VCL_GREEN:
                        if((i>= ew_green) || (sensor.V2 == 0))
                        {light = LIGHT_STATE::VCL_YELLOW;}
                        break;
                case LIGHT_STATE::VCL_YELLOW:
                    if((i>= yellow) || (sensor.V2 == 0))
                    {light = LIGHT_STATE::ALL_RED;}
                    break;
                case LIGHT_STATE::ALL_RED:
                    if((i>= all_red))
                        if(sensor.B1)
                        {state = STATE::S_PED;
                        light = LIGHT_STATE::PED_GREEN;}
                            else 
                            {state = STATE::S_MR;
                            light = LIGHT_STATE::VCL_GREEN;}
                    break;
           } 
        break;

        case STATE::S_MR:

            switch (light){
                case LIGHT_STATE::VCL_GREEN:
                        if((i>= green) || (sensor.V1 == 0))
                        {light = LIGHT_STATE::VCL_YELLOW;}
                        break;
                case LIGHT_STATE::VCL_YELLOW:
                    if((i>= yellow) || (sensor.V1 == 0))
                    {light = LIGHT_STATE::ALL_RED;}
                    break;
                case LIGHT_STATE::ALL_RED:
                    if((i>= all_red))
                        if(sensor.B1)
                        {state = STATE::S_PED;
                        light = LIGHT_STATE::PED_GREEN;}
                        else 
                            {state = STATE::S_OBH;
                            light = LIGHT_STATE::VCL_GREEN;}
                    break;
           }
        break;

        case STATE::S_OBH:

            switch (light){
                case LIGHT_STATE::VCL_GREEN:
                        if((i>= green) || (sensor.V0 == 0))
                        {light = LIGHT_STATE::VCL_YELLOW;}
                        break;
                case LIGHT_STATE::VCL_YELLOW:
                    if((i>= yellow) || (sensor.V0 == 0))
                    {light = LIGHT_STATE::ALL_RED;}
                    break;
                case LIGHT_STATE::ALL_RED:
                    if((i>= all_red))
                        if(sensor.B1)
                        {state = STATE::S_PED;
                        light = LIGHT_STATE::PED_GREEN;}
                        else 
                            {state = STATE::S_EW;
                            light = LIGHT_STATE::VCL_GREEN;}
                    break;
           }
        break;

        case STATE::S_PED:

            switch (light){
                case LIGHT_STATE::PED_GREEN:
                        if((i>= green_ped) || (sensor.V2==0) || (sensor.V1==0) || (sensor.V0==0))
                        {light = LIGHT_STATE::PED_YELLOW;}
                        else 
                            {light = LIGHT_STATE::PED_GREEN;}
                        break;
                case LIGHT_STATE::PED_YELLOW:
                    if((i>= yellow_ped))
                    {light = LIGHT_STATE::ALL_RED;}
                    break;
                case LIGHT_STATE::ALL_RED:
                    if((i>= all_red))
                        if((sensor.V2==0) || (sensor.V1==0) || (sensor.V0==0))
                        {state = STATE::S_PED;
                        light = LIGHT_STATE::PED_GREEN;}
                        else 
                            {state = STATE::S_EW;
                            light = LIGHT_STATE::VCL_GREEN;}
                    break;
           }
        break;    
   }
}

