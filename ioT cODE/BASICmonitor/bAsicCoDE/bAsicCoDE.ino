// #include <WiFi.h>
// #include <WebServer.h>
// #include <HTTPClient.h>
// #include "DHT.h"

// // -------- WIFI ----------
// const char* ssid="vivo";
// const char* pass="861tejas";

// // -------- BACKEND URL ----------
// String serverName="http:// 192.168.221.1:5000/sensor"; 

// // -------- PINS ----------
// #define DHTPIN 4
// #define DHTTYPE DHT22
// #define SOILPIN 34
// #define RELAY 26

// WebServer server(80);
// DHT dht(DHTPIN, DHTTYPE);

// // -------- SETTINGS ----------
// int soilThreshold=2500;
// bool autoMode=true;

// // ===========================
// // SEND DATA TO NODE SERVER
// // ===========================

// void sendToServer(float t,float h,int soil){

//   if(WiFi.status()==WL_CONNECTED){

//     HTTPClient http;

//     http.begin(serverName);
//     http.addHeader("Content-Type","application/json");

//     String json="{";
//     json+="\"temperature\":"+String(t)+",";
//     json+="\"moisture\":"+String(soil)+",";
//     json+="\"ph\":7";
//     json+="}";

//     int code=http.POST(json);

//     Serial.print("POST Code: ");
//     Serial.println(code);

//     http.end();
//   }
// }

// // ===========================
// // WEB PAGE CONTROL
// // ===========================

// void handleRoot(){

//  float t=dht.readTemperature();
//  float h=dht.readHumidity();
//  int soil=analogRead(SOILPIN);

//  if(isnan(t)||isnan(h)){ t=0; h=0; }

//  // AUTO WATER LOGIC
//  if(autoMode){
//    if(soil>soilThreshold) digitalWrite(RELAY,LOW);
//    else digitalWrite(RELAY,HIGH);
//  }

//  String page="<meta name='viewport' content='width=device-width'>";
//  page+="<h2>Smart Vermicompost System</h2>";

//  page+="Temp:"+String(t)+" C<br>";
//  page+="Humidity:"+String(h)+" %<br>";
//  page+="Soil:"+String(soil)+"<br><br>";

//  page+="<a href='/on'><button>PUMP ON</button></a><br><br>";
//  page+="<a href='/off'><button>PUMP OFF</button></a><br><br>";
//  page+="<a href='/auto'><button>AUTO</button></a><br><br>";
//  page+="<a href='/manual'><button>MANUAL</button></a>";

//  server.send(200,"text/html",page);
// }

// void pumpOn(){ autoMode=false; digitalWrite(RELAY,LOW); server.sendHeader("Location","/"); server.send(303); }
// void pumpOff(){ autoMode=false; digitalWrite(RELAY,HIGH); server.sendHeader("Location","/"); server.send(303); }
// void setAuto(){ autoMode=true; server.sendHeader("Location","/"); server.send(303); }
// void setManual(){ autoMode=false; server.sendHeader("Location","/"); server.send(303); }

// // ===========================
// // WIFI CONNECT WITH RETRY
// // ===========================

// void connectWiFi(){

//   WiFi.begin(ssid,pass);
//   Serial.print("Connecting");

//   int retry=0;

//   while(WiFi.status()!=WL_CONNECTED && retry<20){
//     delay(500);
//     Serial.print(".");
//     retry++;
//   }

//   if(WiFi.status()==WL_CONNECTED){
//     Serial.println("\nConnected!");
//     Serial.println(WiFi.localIP());
//   }
// }

// // ===========================
// // SETUP
// // ===========================

// void setup(){

//  Serial.begin(115200);

//  pinMode(RELAY,OUTPUT);
//  digitalWrite(RELAY,HIGH);

//  analogReadResolution(12);

//  dht.begin();

//  connectWiFi();

//  server.on("/",handleRoot);
//  server.on("/on",pumpOn);
//  server.on("/off",pumpOff);
//  server.on("/auto",setAuto);
//  server.on("/manual",setManual);

//  server.begin();
// }

// // ===========================
// // LOOP
// // ===========================

// void loop(){

//  server.handleClient();

//  // reconnect wifi if lost
//  if(WiFi.status()!=WL_CONNECTED){
//    connectWiFi();
//  }

//  // send data every 30 sec
//  static unsigned long last=0;

//  if(millis()-last>30000){

//    float t=dht.readTemperature();
//    float h=dht.readHumidity();
//    int soil=analogRead(SOILPIN);

//    if(!isnan(t)&&!isnan(h)){
//      sendToServer(t,h,soil);
//    }

//    last=millis();
//  }
// }


// #include <WiFi.h>
// #include <WebServer.h>
// #include "DHT.h"

// #define DHTPIN 4
// #define DHTTYPE DHT22
// #define SOILPIN 34
// #define RELAY 26

// const char* ssid="vivo";
// const char* pass="861tejas";

// WebServer server(80);
// DHT dht(DHTPIN, DHTTYPE);

// // ===== SETTINGS =====
// int soilThreshold = 2500;   // adjust after testing
// bool autoMode = true;       // automatic watering ON

// // ====================

// void handleRoot(){

//  float t=dht.readTemperature();
//  float h=dht.readHumidity();
//  int soil=analogRead(SOILPIN);

//  // fix DHT NAN issue
//  if(isnan(t)||isnan(h)){
//    t=0; h=0;
//  }

//  // AUTO WATER LOGIC
//  if(autoMode){
//    if(soil > soilThreshold){      // soil dry
//      digitalWrite(RELAY,LOW);     // pump ON (LOW trigger relay)
//    }else{
//      digitalWrite(RELAY,HIGH);    // pump OFF
//    }
//  }

//  String page="<meta name='viewport' content='width=device-width, initial-scale=1'>";
//  page+="<h2>ESP32 Smart Plant System</h2>";

//  page+="Temperature: "+String(t)+" C<br>";
//  page+="Humidity: "+String(h)+" %<br>";
//  page+="Soil value: "+String(soil)+"<br><br>";

//  page+="<a href='/on'><button style='font-size:20px'>PUMP ON</button></a><br><br>";
//  page+="<a href='/off'><button style='font-size:20px'>PUMP OFF</button></a><br><br>";

//  page+="<a href='/auto'><button style='font-size:18px'>AUTO MODE</button></a><br><br>";
//  page+="<a href='/manual'><button style='font-size:18px'>MANUAL MODE</button></a>";

//  server.send(200,"text/html",page);
// }

// void pumpOn(){
//  autoMode=false;
//  digitalWrite(RELAY,LOW);
//  server.sendHeader("Location","/");
//  server.send(303);
// }

// void pumpOff(){
//  autoMode=false;
//  digitalWrite(RELAY,HIGH);
//  server.sendHeader("Location","/");
//  server.send(303);
// }

// void setAuto(){
//  autoMode=true;
//  server.sendHeader("Location","/");
//  server.send(303);
// }

// void setManual(){
//  autoMode=false;
//  server.sendHeader("Location","/");
//  server.send(303);
// }

// void setup(){

//  Serial.begin(115200);
//  delay(1000);

//  Serial.println("Booting...");

//  pinMode(RELAY,OUTPUT);
//  digitalWrite(RELAY,HIGH);

//  analogReadResolution(12);

//  dht.begin();

//  WiFi.begin(ssid,pass);

//  Serial.print("Connecting");

//  while(WiFi.status()!=WL_CONNECTED){
//    delay(500);
//    Serial.print(".");
//  }

//  Serial.println("");
//  Serial.println("WiFi connected!");
//  Serial.print("IP: ");
//  Serial.println(WiFi.localIP());

//  server.on("/",handleRoot);
//  server.on("/on",pumpOn);
//  server.on("/off",pumpOff);
//  server.on("/auto",setAuto);
//  server.on("/manual",setManual);

//  server.begin();
// }

// void loop(){
//  server.handleClient();
// }

// #define RELAY 23

// void setup() {
//   pinMode(RELAY, OUTPUT);
//   digitalWrite(RELAY, HIGH);   // start OFF
// }

// void loop() {

//   // Pump ON
//   digitalWrite(RELAY, LOW);
//   delay(5000);

//   // Pump OFF
//   digitalWrite(RELAY, HIGH);
//   delay(5000);

// }


//MG995 servo Motor

#define IN1 18
#define IN2 19
#define ENA 5

void setup() {
  pinMode(IN1, OUTPUT);
  pinMode(IN2, OUTPUT);
  pinMode(ENA, OUTPUT);

  digitalWrite(ENA, HIGH);   // enable motor driver
}

void loop() {

  // Clockwise
  digitalWrite(IN1, HIGH);
  digitalWrite(IN2, LOW);
  delay(5000);

  // Stop
  digitalWrite(IN1, LOW);
  digitalWrite(IN2, LOW);
  delay(2000);

  // Anticlockwise
  digitalWrite(IN1, LOW);
  digitalWrite(IN2, HIGH);
  delay(5000);

  // Stop
  digitalWrite(IN1, LOW);
  digitalWrite(IN2, LOW);
  delay(2000);
}