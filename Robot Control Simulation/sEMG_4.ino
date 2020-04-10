/*
  sensors_to_XBee

  Reads analog input from 4 sEMG sensors.

  created by Darrell Huang
  modified 3 March 2020
  By Darrell
*/

// initialize payload
String message;
const int num_sensors = 4;
uint16_t sensors[num_sensors];
int sEMG1 = A1;
int sEMG2 = A2;
int sEMG3 = A3;
int sEMG4 = A4;

void setup() {
  // put your setup code here, to run once
  
  // initialize serial communication at 115200 bits per second:
  Serial.begin(115200);
  String message = "<";

}

// the loop routine runs over and over again forever:
void loop() {
  // put your main code here, to run repeatedly
  
  // read the input on analog pins 1-4:
  sensors[0] = analogRead(sEMG1);
  sensors[1] = analogRead(sEMG2);
  sensors[2] = analogRead(sEMG3);
  sensors[3] = analogRead(sEMG4);

  // send out the sEMG values read:
  for (int i = 0; i < num_sensors-1; i++)
  {
    message = message + sensors[i] + ",";
  }

  message = message + sensors[num_sensors-1] + ">\n"; 
  Serial.print(message);
  message = "<";
}
