/*
  sensors_to_XBee

  Reads analog input from 4 sEMG sensors and 1 accelerometer.
  Sends sensor data through serial to XBee.

  created by Darrell Huang
  modified 17 January 2020
  By Darrell
*/

#include <SoftwareSerial.h>
#include <Wire.h>
#include <Adafruit_MMA8451.h>
#include <Adafruit_Sensor.h>

const int rxPin = 0; // XBee DataOut
const int txPin = 1; // XBee DataIn

// initialize XBee and analog reading
SoftwareSerial XBee(rxPin, txPin);

// initialize accelerometer
Adafruit_MMA8451 mma = Adafruit_MMA8451();

// initialize payload
String message;
const int num_sensors = 3;
uint16_t sensors[num_sensors];
int sEMG1 = A1;
int sEMG2 = A2;
int sEMG3 = A3;

void setup() {
  // put your setup code here, to run once

  // initialize serial communication at 115200 bits per second:
  XBee.begin(115200);
  String message = "<";

    if (! mma.begin()) {
      XBee.println("Couldnt start");
      while (1);
    }
  
    // initialize accelerometer range
     mma.setRange(MMA8451_RANGE_2_G);
  }

  // the loop routine runs over and over again forever:
  void loop() {
    // put your main code here, to run repeatedly

    // read accelerometer
      mma.read();

    // read the input on analog pins 1-5:
    sensors[0] = analogRead(sEMG1);
    sensors[1] = analogRead(sEMG2);
    sensors[2] = analogRead(sEMG3);


    // Convert the analog reading (which goes from 0 - 1023) to a voltage (0 - 5V):
    // volt = sEMG * (5.0 / 1023.0); // skip this, send sensor data as uint16_t from 0-1023 instead

    // send out the sEMG values read:
    for (int i = 0; i < num_sensors - 1; i++)
    {
      message = message + sensors[i] + ",";
    }

    // append orientation data
    /* This is the "raw count" data from the sensor, its a number from -8192 to 8191 (14 bits) that measures over the set range. The range can be set to 2G, 4G or 8G.
      Convert to m/s^2: sensors_event_t event; mma.getEvent(&event);
      The normalized SI unit data is available in event.acceleration.x, event.acceleration.y and event.acceleration.z */
    message = message + sensors[num_sensors - 1] + "," + mma.x + "," + mma.y + "," + mma.z + ">\n";
    XBee.print(message);
    message = "<";
  }
