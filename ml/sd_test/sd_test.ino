#include <SPI.h>
#include <SD.h>

const int chipSelect = 4;  // CS pin connected to Arduino pin 4
File myFile;

void setup() {
  Serial.begin(9600);
  while (!Serial) { }

  Serial.println("Initializing SD card...");

  if (!SD.begin(chipSelect)) {
    Serial.println("SD card initialization failed!");
    while (1);  // Halt if SD card fails
  }
  Serial.println("SD card initialized successfully!");

  // Open a file and write to it
  myFile = SD.open("test.txt", FILE_WRITE);

  if (myFile) {
    Serial.println("Writing to test.txt...");
    myFile.println("Hello, SD Card!");
    myFile.println("This is a test.");
    myFile.close();
    Serial.println("Done writing.");
  } else {
    Serial.println("Error opening test.txt!");
  }

  // Read the file back
  myFile = SD.open("test.txt");
  if (myFile) {
    Serial.println("Reading from test.txt:");
    while (myFile.available()) {
      Serial.write(myFile.read());
    }
    myFile.close();
  } else {
    Serial.println("Error opening test.txt for reading!");
  }
}

void loop() {
  // Nothing here (just run once)
}
