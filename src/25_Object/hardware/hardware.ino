#define PIN_MOTOR_PWM 2
#define PIN_MOTOR_DIR_1 4
#define PIN_MOTOR_DIR_2 5
#define PIN_SENSOR 3
#define PIN_MOTOR_RECHAZO 6
#define DEFAULT_PROGRAM_DELAY 50

String serial_info;
bool state = false;
bool motorState = false;
bool sensorState = false;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(PIN_MOTOR_PWM, OUTPUT);
  pinMode(PIN_SENSOR, INPUT); // Led motor
  pinMode(PIN_MOTOR_DIR_1, OUTPUT);
  pinMode(PIN_MOTOR_DIR_2, OUTPUT);
  pinMode(PIN_MOTOR_RECHAZO, OUTPUT);
  digitalWrite(PIN_MOTOR_DIR_1, LOW);
  digitalWrite(PIN_MOTOR_DIR_2, HIGH);
}

void loop() {
  if(Serial.available()){
    serial_info = Serial.readString();
    if(serial_info.equals("start")){
      state = true;
    }
    if(serial_info.equals("stop")){
      state = false;
    }
    if(serial_info.equals("accept")){
      analogWrite(PIN_MOTOR_RECHAZO, 120);
    }
    if(serial_info.equals("reject")){
      analogWrite(PIN_MOTOR_RECHAZO, 210);
    }
  }

  if (state)
  {
    motorState = digitalRead(PIN_SENSOR);
    sensorState = digitalRead(PIN_SENSOR);

    // if (motorState) analogWrite(PIN_MOTOR_PWM, 250);
    // else analogWrite(PIN_MOTOR_PWM, 0);
    if (motorState) analogWrite(PIN_MOTOR_PWM, 250);
    else digitalWrite(PIN_MOTOR_PWM, LOW);

    // Stop program
    if(serial_info.equals("continue")){
        motorState = true;
        analogWrite(PIN_MOTOR_PWM, 250);
        if (sensorState)
        {
          serial_info = "";
        }
        
      }
    printData();
  } else {
    // Turn off execution
    motorState = false;
    analogWrite(PIN_MOTOR_PWM, 0);
  }
  delay(DEFAULT_PROGRAM_DELAY);
}


void printData() {
  Serial.print("{");
  Serial.print("\"state\":");
  if (state) Serial.print("true");
  else Serial.print("false");
  Serial.print(",");
  Serial.print("\"motor\":");
  if (motorState) Serial.print("true");
  else Serial.print("false");
  Serial.print(",");
  Serial.print("\"sensor\":");
  if (sensorState) Serial.print("true");
  else Serial.print("false");
  Serial.print(",");
  Serial.print("\"serial\":");
  Serial.print("\"");
  Serial.print(serial_info);
  Serial.print("\"");
  Serial.println("}");
}