

#include <SoftwareSerial.h>
SoftwareSerial mySerial(8, 5); // Rx, Tx

unsigned int rand_byte;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(2400);
  mySerial.begin(2400);
  delay(1000);
}

void loop() {
  if (Serial.available()) {
    rand_byte = Serial.read();
    // sends as ascii
    mySerial.println(rand_byte);
  }
}
