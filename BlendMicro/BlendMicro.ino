#include <SPI.h>
#include <boards.h>
#include <EEPROM.h>
#include <RBL_nRF8001.h>


void setup() 
{
  Serial.begin(9600);
  char nameOfObject[15] = "";
  for(int i = 0; i < 15; i++)
  {
    nameOfObject[i] = (char) EEPROM.read(i);
  }
  ble_set_name(nameOfObject);
  ble_reset(4);
  ble_begin();
  pinMode(9,OUTPUT);
  pinMode(10,OUTPUT);
 
  

  
}
//BLE device makes a sound if recieving the chat message: "make sound".
void make_sound()
{
  digitalWrite(9,HIGH);
  digitalWrite(10,HIGH);
  delay(500);
  digitalWrite(9,LOW);
  digitalWrite(10,LOW);
  delay(500);
}

//BLE device changes, and saves its name if recieving the chat message: "setName" followed by the new name.
void change_name()
{

  ble_do_events();
  char nName[15] = "";
  int i = 0;
    
      
  while(ble_available() == 0)
  {
    ble_do_events();
  }
  while(ble_available())
  {
    nName[i] = (char) ble_read();
    i++;
  }
   for (int i = 0; i < 255; i++)
  {
    EEPROM.write(i, nName[i]);
  }
  
  Serial.println("New name: ");
  Serial.println(nName);
  setup();
  ble_do_events();
  
}


void loop() 
{
  ble_do_events();
  char setName[15] = "setName";
  char makeSound[15] = "makeSound";
  char rec[15] = "";
  int i = 0;
  int diff_A = 5;
  
  if(ble_available())
  {
    Serial.println("Bytes on BLE port!");
    while(ble_available()) 
    {
      rec[i] = (char) ble_read();
      i++;
    }
    Serial.println("Now printing string: ");
    Serial.println(rec);

    
    diff_A=strcmp(makeSound, rec);

    if(diff_A == 0)
    {
      make_sound();
    }
    diff_A = strcmp(setName, rec);
    if(diff_A == 0)
    {
    change_name();
    }
  }
}









