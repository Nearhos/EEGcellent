void setup() {
  Serial.begin(9600);
  pinMode(3, OUTPUT);
  pinMode(A0, INPUT);
  analogWrite(3, 20);
}

void loop() {
  int analog_1 = analogRead(A0);
  float value_1 = analog_1 * 5.0 / 1023.0;
  int analog_2 = analogRead(A0);
  float value_2 = analog_2 * 5.0 / 1023.0;
  Serial.println(value_1 - value_2);
  delay(100);
}
