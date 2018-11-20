void setupAccel() {
  //ADXL345
  // i2c bus SDA = D2; SCL = D1
  Wire.begin(D2, D1);
  //Wire.begin(D5,D6);      
  
  // Put the ADXL345 into +/- 2G range by writing the value 0x01 to the DATA_FORMAT register.
  // FYI: 0x00 = 2G, 0x01 = 4G, 0x02 = 8G, 0x03 = 16G
  writeTo(DATA_FORMAT, 0x00);
  
  // Put the ADXL345 into Measurement Mode by writing 0x08 to the POWER_CTL register.
  writeTo(POWER_CTL, 0x08);

  for(int i=0; i<11; i++)
  {
    //uint8_t howManyBytesToRead = 6;
    //readFrom( DATAX0, howManyBytesToRead, _buff);
    float calib_x = (((short)_buff[1]) << 8) | _buff[0];
    float calib_y = (((short)_buff[3]) << 8) | _buff[2];
    float calib_z = (((short)_buff[5]) << 8) | _buff[4];
  //  calib_x = readAccel();
    //if(i==0)
    // cal_x = x;
    if(i>0) {
     cal_x = cal_x + calib_x;
     cal_y = cal_y + calib_y;
     cal_z = cal_z + calib_z;
    }
    //Serial.println(calib_x);
    delay(100);
  }

  cal_x = cal_x/10;
  cal_y = cal_y/10;
  cal_z = cal_z/10;
  Serial.print("XCal = ");Serial.print(cal_x);Serial.print(" YCal = ");Serial.print(cal_y);Serial.print(" ZCal = ");Serial.println(cal_z);
}
String getAccel() {
  String out = "";
 // Serial.print("readAccel");
  uint8_t howManyBytesToRead = 6; //6 for all axes
  readFrom( DATAX0, howManyBytesToRead, _buff); //read the acceleration data from the ADXL345
  short x =0;
   x = (((short)_buff[1]) << 8) | _buff[0];
  short y = (((short)_buff[3]) << 8) | _buff[2];
  short z = (((short)_buff[5]) << 8) | _buff[4];
  //Serial.println(x * ADXL345_MG2G_MULTIPLIER * SENSORS_GRAVITY_STANDARD);
//  x = float(x*ADXL345_MG2G_MULTIPLIER * SENSORS_GRAVITY_STANDARD);
//  y = float(y*ADXL345_MG2G_MULTIPLIER * SENSORS_GRAVITY_STANDARD);
//  z = float(z*ADXL345_MG2G_MULTIPLIER * SENSORS_GRAVITY_STANDARD);
  //Serial.println(x);
  //out +="";
  out += x*ADXL345_MG2G_MULTIPLIER * SENSORS_GRAVITY_STANDARD;
  out+= ",";
  out+= y*ADXL345_MG2G_MULTIPLIER * SENSORS_GRAVITY_STANDARD;
  out+= ",";
  out += z*ADXL345_MG2G_MULTIPLIER * SENSORS_GRAVITY_STANDARD;
  return out;
  //return x * ADXL345_MG2G_MULTIPLIER * SENSORS_GRAVITY_STANDARD;
  //x = x + cal_x;

  
  //Serial.print("x: "); 
  //Serial.print( x*2./512 );
  //Serial.print(" y: ");
  //Serial.print( y*2./512 );
  //Serial.print(" z: ");
  //Serial.print( z*2./512 );
  //Serial.print("X: "); Serial.print( x);

  //Serial.println( sqrtf(x*x+y*y+z*z)*2./512 );

//getX() = read16(ADXL345_REG_DATAX0);
//x = getX() * ADXL345_MG2G_MULTIPLIER * SENSORS_GRAVITY_STANDARD;
  
}

void writeTo(byte address, byte val) 
{
  Wire.beginTransmission(DEVICE); // start transmission to device
  Wire.write(address); // send register address
  Wire.write(val); // send value to write
  Wire.endTransmission(); // end transmission
}

// Reads num bytes starting from address register on device in to _buff array
void readFrom(byte address, int num, byte _buff[]) {
  Wire.beginTransmission(DEVICE); // start transmission to device
  Wire.write(address); // sends address to read from
  Wire.endTransmission(); // end transmission
  Wire.beginTransmission(DEVICE); // start transmission to device
  Wire.requestFrom(DEVICE, num); // request 6 bytes from device

  int i = 0;
  while(Wire.available()) // device may send less than requested (abnormal)
  {
    _buff[i] = Wire.read(); // receive a byte
    i++;
  }
  Wire.endTransmission(); // end transmission
}
