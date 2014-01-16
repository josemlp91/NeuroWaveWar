// rob@faludi.com
// A full example for using Sockets in Processing to communicate with a Lantronix XPort.
// This program could also be used to communicate primitive variables (bytes) with any other TCP/IP enabled device.
//
// We open a Socket, check to see if data is available, get a byte of data
// from the remote device, and then send a byte of data to the remote device.
// At the end of the program, we close the streams of data and close the Socket.
// (Once you are done debugging your code, you should remove all the println statements for better speed.)


import java.io.*;  // this is the input/output library needed for data streams
import java.net.*; // this is the network library needed for sockets

String host; 
int port;
Socket mySocket;                    // declare Socket
DataInputStream myInputStream;      // declare data input stream. This will run within a socket, bringing data into Java
DataOutputStream myOutputStream;    // declare data output stream. This will run within a socket, sending data out from Java
byte myDataIn, myDataOut;           // declare some variables to store the data we're sending and receiving

void setup(){
  size(400,255);
  background(0);
  framerate(30);
  host = "xport3.faludi.com";  // define a host to communicate with. This can be a name or IP address
  port = 10001;                // define a port to contact on that host. Must be a number, typically 10001 for an XPort
}


void draw(){
  checkConnection(host, port);        // subroutine to create a connection, via a socket, to the XPort
  if (dataIsWaiting() == true) {      //  check to see if there's new data waiting to come in
    myDataIn = getSomeData();         //  ... and if there's new data, get it
  }
  myDataOut = 65;                     // create some placeholder data, in this case ASCII letter A
  sendSomeData(myDataOut);            // send the data out
}


////////CHECK CONNECTION\\\\\\\\
void checkConnection(String host, int port) {
  if(mySocket == null || mySocket.isConnected() == false) {                 
    println("trying to connect to: " + host + " at port: " + port);
    try{                                      // make an attempt to run the following code
      mySocket = new Socket(host,port);       // initialize socket, connecting it to a host computer's port
      println("connected!");
    }
    catch(Exception e) {                         // if the "try" attempt gave an error, run the following code
      e.printStackTrace();                       // print the error to the log
      println("unable to connect to: " + host + " at port: " + port);
    }
  }
}


////////CHECK TO SEE IF DATA IS WAITING TO COME IN\\\\\\\\\\\
boolean dataIsWaiting() {
  boolean bytesAvailable = false;
  if ( myInputStream == null) {  // if there's no active input stream
    try {
      myInputStream = new DataInputStream(mySocket.getInputStream()); // create an new input stream from a particular socket
      println("opening input stream");
    }
    catch (Exception e) {
      e.printStackTrace();
      println("error while opening input stream");
    }
  }
  try {
    if (myInputStream.available()>0) {      // check to see if any bytes are available
      bytesAvailable = true;                // ...and if they are set the variable to true
      println(myInputStream.available() + " bytes available...");
    }
  }
  catch(Exception e) {
    e.printStackTrace();
    println("error while checking for bytes available");
  }
  return bytesAvailable;
}


////////GET SOME DATA \\\\\\\\\\
byte getSomeData() {
  byte inData = 0;               // declare and initialize the data variable
  try {
    if (myInputStream.available()>0) {  //   only read the byte if there's a byte to read [this is a redundant check]
      inData = myInputStream.readByte();  // read a byte from the input stream
      println("data received: " + inData);
    }
  }
  catch(Exception e){
    e.printStackTrace();
    println("no data");
  }
  return inData;
}


////////SEND SOME DATA\\\\\\\\\\
void sendSomeData(byte outData){
  if (myOutputStream == null) { // if there's no active output stream
    try {
      myOutputStream = new DataOutputStream(mySocket.getOutputStream()); // create an new output stream from a particular socket
        }
    catch (Exception e) {
      e.printStackTrace();
      println("no output stream");
    }
  }
  try{
    myOutputStream.writeByte(outData); // write a byte to the output stream
    println("data sent: " + outData);
  }
  catch(Exception e){
    e.printStackTrace();
    println("event send failed");
  } 
}


public void stop() { // when the program quits
  try {
    myInputStream.close();  // close the input stream
    myOutputStream.close(); // close the output stream
    mySocket.close(); // close the socket
  }
  catch (Exception e) {
    e.printStackTrace();
    println("couldn't close connection");
  }
}
