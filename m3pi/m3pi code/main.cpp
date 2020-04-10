// Finite-State Machine for m3pi motor control
// Description: Control m3pi robot using action and magnitude
// By: Darrell Huang
// Created: 1/17/2020
// Last Edited:  1/24/2020

#include "mbed.h"
#include "m3pi.h"
#include <string>
#include <iostream>

// Minimum and maximum motor speeds
#define MAX 0.6
#define MIN 0

m3pi m3pi; 

int main() 
{ 
    // receive signal from xbee
    Serial device(p28, p27);  // tx, rx,these two pins are used for XBee wireless communication
    device.baud(115200); // Baud rate
    std::string command;
    
    std::string action_str;
    std::string magnitude_str;
    int action;
    float magnitude;
    
    m3pi.cls();
    m3pi.locate(0,0);
    m3pi.printf("Ready");
    while(1){
        if(device.readable())
        {
            m3pi.cls();
            m3pi.locate(0,0);
            m3pi.printf("readable");   
                    
        // receive command
            // scanf doesn't take whitespaces
            device.scanf("%s", command); 
            sscanf(command.c_str(), "a:%i,m:%f", &action, &magnitude);
            // magnitude = magnitude * MAX;
            switch(action)
            {
                case 0: // stop
                    m3pi.stop();
                    wait(0.3);
                    break;
                case 1: // forward
                    m3pi.forward(magnitude);
                    wait(0.3);
                    break;
                case 2: // backward
                    m3pi.backward(magnitude);
                    wait(0.3);
                    break;
                case 3: // clockwise
                    m3pi.left_motor(-magnitude);
                    m3pi.right_motor(magnitude);
                    wait(0.3);
                    break;
                case 4: // counterclockwise
                    m3pi.left_motor(magnitude);
                    m3pi.right_motor(-magnitude);
                    wait(0.3);
                    break;
                default: // idle
                    m3pi.stop();
                    break;
            }
        }
        else
        {
            m3pi.cls();
            m3pi.locate(0,1);
            m3pi.printf("unread");
            m3pi.stop();
            wait(0.3);
        }  
    }
}

