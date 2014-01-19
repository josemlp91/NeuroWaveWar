import processing.net.*; 
Client myClient1; 
Client myClient2;

int dataIn1;
int dataIn2;

  int tope=480;
  int acumula1=0;
  int acumula2=0;
 
void setup() { 
  size(500, 200); 
  // Connect to the local machine at port 5204.
  // This example will not run if you haven't
  // previously started a server on this port.
  myClient1 = new Client(this, "127.0.0.1", 5210); 
  myClient2 = new Client(this, "25.85.166.140", 5220); 

} 
 
void draw() { 
  
  if (myClient1.available() > 0) { 
    dataIn1 = myClient1.read(); 
  }
 
 if (myClient2.available() > 0) { 
    dataIn2 = myClient2.read(); 
  } 
  
  background(255);
  fill(0);
  textSize(20);
 
 if (acumula1==tope) text("Jugador 1 has ganado", 5, 130);
 else if (acumula2==tope) text("Jugador 2 has ganado", 5, 130);
  
  else {
  text("Aten acumulada Jugador 1: " + acumula1, 5, 60);

  acumula1=acumula1 + (dataIn1/50 );   
  
  text("Aten acumulada Jugador 2: " + acumula2, 5, 130);
  acumula2=acumula2 + (dataIn2 / 50);

  color c=color(255, 0, 0);
 fill(c);
 rect ( 0 , 70 , acumula1 , 30 );
  c=color(0, 255, 0);
 fill(c);
 rect ( 0 , 140 , acumula2 , 30 );
 
 
  }

// println(dataIn); 
  //smooth();
} 
