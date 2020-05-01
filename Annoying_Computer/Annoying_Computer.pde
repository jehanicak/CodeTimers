/*
  ReceiveData
  by Scott Kildall
  Expects a string of comma-delimted Serial data from Arduino:
  ** field is 0 or 1 as a string (switch)
  ** second fied is 0-4095 (potentiometer)
  ** third field is 0-4095 (LDR) —— NOT YET IMPLEMENTED
  
  
    Will change the background to red when the button gets pressed
    Will change speed of ball based on the potentiometer
    
 */
 

// Importing the serial library to communicate with the Arduino 
import processing.serial.*;    

// Initializing a vairable named 'myPort' for serial communication
Serial myPort;  



// Data coming in from the data fields
String [] data;
int switchValue = 0;    // index from data fields
int potValue = 1;

// Change to appropriate index in the serial list — YOURS MIGHT BE DIFFERENT
int serialIndex = 5;

// animated ball
int minPotValue = 0;
int maxPotValue = 4095;    // will be 1023 on other systems

//where I call the timer class
Timer badTimer;
Timer checkInTimer;
Timer noseyTimer;

Timer LDRTrack;

boolean bStarted = false;

//declaring a font
PFont displayFont;




void setup ( ) {
  size (800,  600);
  background(35, 35, 35);
  
  frameRate(5);
  
  textAlign(CENTER);
  displayFont = createFont("Helvetica", 65);
  
  // List all the available serial ports
  printArray(Serial.list());
  
  // Set the com port and the baud rate according to the Arduino IDE
  myPort  =  new Serial (this, Serial.list()[serialIndex],  115200); 
  
  //making all my timers
  badTimer = new Timer(1000);
  noseyTimer = new Timer(5000);
  checkInTimer = new Timer(10000);
  LDRTrack = new Timer(5000);
  
  //starting the timers 
  badTimer.start();
  checkInTimer.start();
  noseyTimer.start();
  
} 




// We call this to get the data 
void checkSerial() {
  while (myPort.available() > 0) {
    String inBuffer = myPort.readString();  
    
    print(inBuffer);
    
    // This removes the end-of-line from the string AND casts it to an integer
    inBuffer = (trim(inBuffer));
    
    data = split(inBuffer, ',');
 
    // do an error check here?
    switchValue = int(data[0]);
    potValue = int(data[1]);
  }
} 

//-- change background to red if we have a button
void draw ( ) {  
  
  background(0);
  // calling all my functions!
  checkSerial();
  
  basicTimersRunning();
  
  offAndOnTimers();
  
  LDRTimer();
  
} 

void basicTimersRunning(){
  // check to see if timer is expired, do something and then restart timer
  if( badTimer.expired() ) {
    //this flashes a sentence
    fill(0,255,0);
    textSize(65);
    text("Hey, Whatcha Doin?", width/2, height/2 ); 
    
    badTimer.start();
  }
  
    if( noseyTimer.expired() ) {
    //this flashes a sentence
    textSize(65);
    fill(0,0,255);
    text("Hello, you there?", width/2, height/2 - 100 ); 
    
    noseyTimer.start();
  }
  
  // check to see if other timer is expired, do something and then restart timer
  if( checkInTimer.expired() ) {
     //this flashes a sentence
    fill(255,0,0);
    textSize(65);
    text("ARE YOU STILL THERE?", width/2, height/2 + 100 ); 
    checkInTimer.start(); 
  }
  
}
//I was trying to control the timers with the button here but it didnt work
void offAndOnTimers(){
  if(switchValue == 1){
    background(35, 35, 35);
    textSize(50);
    text("This button does nothing...", width/2, height/2);
    noseyTimer.expired();
    checkInTimer.expired();
    badTimer.expired();
  }
  
}


//This function is not working 
void LDRTimer(){
    if(potValue > 10 && potValue < 1000){
     if( bStarted == false ) {
       LDRTrack.start();
       background(0, 0, 255);
       textSize(30);
       fill(255, 0, 0);
       text("Get off the LDR please...", width/2, height/2 );
     }
  }
     //LDRTrack.start();
     
     //if(LDRTrack.expired()){
     //  background(0, 0, 255);
     //  textSize(30);
     //  fill(255, 0, 0);
     //  text("Get off the potentiometer man...", width/2, height/2 ); 
       
     //  LDRTrack.start();
  }
      
