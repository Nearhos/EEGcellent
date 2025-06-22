import serial

ser = serial.Serial('/dev/tty.usbserial-1410', 9600)
line = ser.readline().decode('utf-8').strip()
