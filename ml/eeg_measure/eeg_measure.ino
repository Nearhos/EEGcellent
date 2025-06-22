/***************************************************************************
* Example sketch for the ADS1115_WE library
*
* This sketch shows how to obtain results using different scales / formats.
*  
* Further information can be found on:
* https://wolles-elektronikkiste.de/ads1115 (German)
* https://wolles-elektronikkiste.de/en/ads1115-a-d-converter-with-amplifier (English)
* 
***************************************************************************/

#include <ADS1115_WE.h> 
#include <Wire.h>

#define NUM_SAMPLES 30

#define I2C_ADDRESS_1 0x48
#define I2C_ADDRESS_2 0x49

ADS1115_WE adc_1 = ADS1115_WE(I2C_ADDRESS_1);
ADS1115_WE adc_2 = ADS1115_WE(I2C_ADDRESS_2);

float get_eeg(ADS1115_WE adc, int ch) {
  if (ch == 0) {
    adc.setCompareChannels(ADS1115_COMP_0_GND);
  } else if (ch == 1) {
    adc.setCompareChannels(ADS1115_COMP_1_GND);
  } else if (ch == 2) {
    adc.setCompareChannels(ADS1115_COMP_2_GND);
  } else if (ch == 3) {
    adc.setCompareChannels(ADS1115_COMP_3_GND);
  }
  
  float sum = 0.0;
  for (int i=0; i<NUM_SAMPLES; i++) {
    float mv = adc.getResult_mV();
    sum += mv;
  }
  return sum / NUM_SAMPLES;
}

void setup() {
  Wire.begin();
  Serial.begin(9600);
  if (!adc_1.init()) {
    Serial.println("adcs 1 not connected.");
  }
  if (!adc_2.init()) {
    Serial.println("adcs 2 not connected.");
  }

  adc_1.setVoltageRange_mV(ADS1115_RANGE_6144); //comment line/change parameter to change range
  adc_1.setMeasureMode(ADS1115_CONTINUOUS); //comment line/change parameter to change mode
  adc_2.setVoltageRange_mV(ADS1115_RANGE_6144); //comment line/change parameter to change range
  adc_2.setMeasureMode(ADS1115_CONTINUOUS); //comment line/change parameter to change mode
}

void loop() {
  float ref_mv = get_eeg(adc_1, 0);
  float ch1_mv = get_eeg(adc_1, 1);
  float ch2_mv = get_eeg(adc_1, 2);
  float ch3_mv = get_eeg(adc_1, 3);
  float ch4_mv = get_eeg(adc_2, 1);
  Serial.print(ch1_mv - ref_mv);
  Serial.print(",");
  Serial.print(ch2_mv - ref_mv);
  Serial.print(",");
  Serial.print(ch3_mv - ref_mv);
  Serial.print(",");
  Serial.println(ch4_mv - ref_mv);
  delay(100);
}
