#include <IRremote.h>
#include <Servo.h>

#define IR_PIN 		    2
#define LED_PIN       3
#define INPUT1_PIN 	  4
#define INPUT2_PIN 	  6
#define DCMOTOR_PIN   8
#define SERVO_GK_PIN  13
#define SERVO_Y_PIN   12
#define SERVO_Z_PIN   11

#define DEFAULT   -1
#define POWER     3125149440
#define UP        4127850240
#define DOWN      4161273600
#define PLAYPAUSE 3208707840
#define LEVEL1    4077715200
#define LEVEL2    3877175040
#define LEVEL3    2707357440

Servo yServo;
Servo zServo;
Servo goalkeeperServo;

unsigned long command = DEFAULT;
bool powerState = false;
int playState = 0;
bool xRunning = false;
bool yRunning = false;
float yAngle = 0;
int yDirection = 1;
bool zRunning = false;
float zAngle = 0;
int zDirection = 1;
bool goalkeeperActivated = false;
float goalkeeperAngle = 70;
int goalkeeperDirection = 1;
bool commandReceived = false;
float goalkeeperSpeedLevel = 0.5;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  
  pinMode(INPUT1_PIN, OUTPUT);
  pinMode(INPUT2_PIN, OUTPUT);
  pinMode(DCMOTOR_PIN, OUTPUT);
  
  IrReceiver.begin(IR_PIN);

  yServo.attach(SERVO_Y_PIN);
  zServo.attach(SERVO_Z_PIN);
  goalkeeperServo.attach(SERVO_GK_PIN);

}

void loop() {
  
  // put your main code here, to run repeatedly:
  if (!commandReceived) {
    command = getCommand();
  }
  else {
    commandReceived = false;
  }

  if(command != DEFAULT) {
    //Serial.println(command);
  }
  
  if (goalkeeperActivated) {
    ExecuteGoalkeeper();
  }

  if (zRunning) {
  	ZRotation();
  }
  
  if (yRunning) {
    YRotation();
  }
  
  switch (command) {

    case POWER: 
      powerButtonPressed();
      break;
    
    case UP: 
      upButtonPressed();
      break;
    
    case DOWN:
      downButtonPressed();
      break;
    
    case PLAYPAUSE:
      playPauseButtonPressed();
      break;

    case LEVEL1:
      goalkeeperSpeedLevel = 0.5;
      break;
    
    case LEVEL2:
      goalkeeperSpeedLevel = 1;
      break;

    case LEVEL3:
      goalkeeperSpeedLevel = 2;
      break;
      
  }
}

unsigned long getCommand() {
  
  unsigned long rawData;
  
  if (IrReceiver.decode()) {
     
    rawData = IrReceiver.decodedIRData.decodedRawData;
    IrReceiver.resume();
    return rawData;

  }
  
  return DEFAULT;   
  
}

void powerButtonPressed() {
  
  if (powerState == true) {
  	analogWrite(DCMOTOR_PIN, 0);
    yServo.write(0);
    analogWrite(SERVO_Y_PIN, 0);
    zServo.write(65);
    analogWrite(SERVO_Z_PIN, 0);
    goalkeeperServo.write(70);
    analogWrite(SERVO_GK_PIN, 0);
    digitalWrite(LED_PIN, LOW);
    xRunning = false;
    yRunning = false;
    zRunning = false;
    goalkeeperActivated = false;
  }
  else {
    digitalWrite(LED_PIN, HIGH);
    zRunning = true;
    goalkeeperActivated = true;
  }
  powerState = !powerState; 
  
}

void upButtonPressed() {
  
  if (powerState == true) {
    playState = 3;
  	xRunning = true;
    analogWrite(DCMOTOR_PIN, 255);
    digitalWrite(INPUT1_PIN, HIGH);
    digitalWrite(INPUT2_PIN, LOW);
  }
    
}

void downButtonPressed() {
  
  if (powerState == true) {
    playState = 4;
  	xRunning = true;
    analogWrite(DCMOTOR_PIN, 255);
    digitalWrite(INPUT1_PIN, LOW);
    digitalWrite(INPUT2_PIN, HIGH);
  }
    
}

void playPauseButtonPressed() {
  
  if (powerState == true) {
    
    switch (playState) {
      
      case 1: {
        if(zRunning) {
          zRunning = false;
          yRunning = true;
          playState = 2;
        }
      }
      break;
      
      case 2: 
        if(yRunning) {
          yRunning = false;
          xRunning = true;
          playState = 3;
          command = UP;
          commandReceived = true;
        }
      break;
      
      case 3:
        if (xRunning) {
          analogWrite(DCMOTOR_PIN, 0);
          xRunning = false;
        }
        else {
          command = UP;
          commandReceived = true;
          xRunning = true;
        }
      break;
      
      case 4:
        if (xRunning) {
          analogWrite(DCMOTOR_PIN, 0);
          xRunning = false;
      	}
        else {
          command = DOWN;
          commandReceived = true;
          xRunning = true;
        }
      break;
    
        
    }  
    
  }
  
}

void YRotation() {
  
  unsigned long timeCount;
  static unsigned long previousTime = 0;
  static bool isInit = true;
  
  if (!yRunning) {
    isInit = true;
    return;
  }

  if (isInit) {
    previousTime = millis();
    isInit = false;
  }
  timeCount = millis() - previousTime;
  if(timeCount < 10) return;
  previousTime = millis();

  playState = 2;
  yServo.write(yAngle);

  if (yAngle > 20) {
    yDirection = 0;
  }
  if (yAngle < 0) {
    yDirection = 1;
  }
  
  if (yDirection == 1) {
    yAngle = yAngle + 0.5;
  }
  else {
    yAngle = yAngle - 0.5;
  }
    
}

void ZRotation() {
  
  unsigned long timeCount;
  static unsigned long previousTime = 0;
  static bool isInit = true;
  
  if (!zRunning) {
    isInit = true;
    return;
  }

  if (isInit) {
    previousTime = millis();
    isInit = false;
  }
  timeCount = millis() - previousTime;
  if(timeCount < 10) return;
  previousTime = millis();  
  
  playState = 1;
  zServo.write(zAngle);

  if (zAngle > 80) {
    zDirection = 0;
  }
  if (zAngle < 50) {
    zDirection = 1;
  }
  
  if (zDirection == 1) {
    zAngle = zAngle + 0.2;
  }
  else {
    zAngle = zAngle - 0.2;
  }

}

void ExecuteGoalkeeper() {
  
  unsigned long timeCount;
  static unsigned long previousTime = 0;
  static bool isInit = true;
  
  if (!goalkeeperActivated) {
    isInit = true;
    return;
  }

  if (isInit) {
    previousTime = millis();
    isInit = false;
  }
  timeCount = millis() - previousTime;
  if(timeCount < 10) return;
  previousTime = millis();  
  
  goalkeeperServo.write(goalkeeperAngle);

  if (goalkeeperAngle > 110) {
    goalkeeperDirection = 0;
  }
  if (goalkeeperAngle < 30) {
    goalkeeperDirection = 1;
  }
  
  if (goalkeeperDirection == 1) {
    goalkeeperAngle = goalkeeperAngle + goalkeeperSpeedLevel;
  }
  else {
    goalkeeperAngle = goalkeeperAngle - goalkeeperSpeedLevel;
  }

  Serial.println(goalkeeperAngle);

}










