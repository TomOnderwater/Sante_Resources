#include <Wire.h>

#define DEBUG true
#define Serial if(DEBUG)Serial

#define DEVICE (0x53) // Device address as specified in data sheet
float last_value = 0;
float prelast_value = 0;

int show_count = 0; 
int trigger_count = 0;
float trigger_value = -5; //DEFAULT VALUE ???
float current_value = 0;

#define ADXL345_MG2G_MULTIPLIER (0.004)
#define SENSORS_GRAVITY_STANDARD          (SENSORS_GRAVITY_EARTH)
#define SENSORS_GRAVITY_EARTH             (9.80665F)              /**< Earth's gravity in m/s^2 */

byte _buff[6];
char POWER_CTL = 0x2D;    //Power Control Register
char DATA_FORMAT = 0x31;
char DATAX0 = 0x32;    //X-Axis Data 0
char DATAX1 = 0x33;    //X-Axis Data 1
char DATAY0 = 0x34;    //Y-Axis Data 0
char DATAY1 = 0x35;    //Y-Axis Data 1
char DATAZ0 = 0x36;    //Z-Axis Data 0
char DATAZ1 = 0x37;    //Z-Axis Data 1

float max_x=0;
float min_x=0;
float cal_x, cal_y, cal_z =0;
float x = 0;


String readAccel() {
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
  out +="X";
  out += x*ADXL345_MG2G_MULTIPLIER * SENSORS_GRAVITY_STANDARD;
  out+= "Y";
  out+= y*ADXL345_MG2G_MULTIPLIER * SENSORS_GRAVITY_STANDARD;
  out+= "Z";
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
void readFrom(byte address, int num, byte _buff[]) 
{
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

void setup() {
  delay(1000);

  Serial.begin(115200);


//ADXL345
  // i2c bus SDA = GPIO0; SCL = GPIO2
  Wire.begin(D2,D1);      
  
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

void loop() {
  //current_value = readAccel();  // read ONLY x, for the y and x modify the readAccel function
Serial.println(readAccel());

//  Serial.print("x: ");Serial.print(current_value);  Serial.print(" x(corrected): ");Serial.print(current_value - cal_x);    
//  Serial.print(" Min:" );Serial.print(min_x); Serial.print(" Max:" ); Serial.println(max_x);    
//  Serial.print("Trigger value:"); Serial.print(trigger_value); Serial.print(" Count:"); Serial.println(trigger_count);
  delay(100);   // only read every 100ms

}

