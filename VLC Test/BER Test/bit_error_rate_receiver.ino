#include <SoftwareSerial.h>
SoftwareSerial mySerial(7, 8); // Rx, Tx

void setup() {
  // put your setup code here, to run once:
  Serial.begin(2400);
  mySerial.begin(2400);
  delay(1000);
}

void loop() {
  // put your main code here, to run repeatedly:
  char data[9];
  int idx = 0;
  while (mySerial.available() && idx<9){
    data[idx] = mySerial.read();
    Serial.print(data[idx]);
    idx += 1;
  }
}
