/* --------------------------------------------------------------------------
 * SimpleOpenNI User Test
 * --------------------------------------------------------------------------
 * Processing Wrapper for the OpenNI/Kinect 2 library
 * http://code.google.com/p/simple-openni
 * --------------------------------------------------------------------------
 * prog:  Max Rheiner / Interaction Design / Zhdk / http://iad.zhdk.ch/
 * date:  12/12/2012 (m/d/y)
 * ----------------------------------------------------------------------------
 */
import promidi.*;
MidiIO midiIO;
MidiOut midiOut;

import SimpleOpenNI.*;
SimpleOpenNI  context;          
PVector leftHand = new PVector();
PVector rightHand = new PVector();
int boxHeight = 130;
int boxWidth = 210;
int last_nt = -1;
int nt;
int last_nt2 = -1;
int nt2;
int left1;
int left2;
int left3;
int left4;

int vfelt;
int[] tillag = new int[32];


void setup()
{
  frameRate(10);
  //get an instance of MidiIO
  midiIO = MidiIO.getInstance(this);

  //print a list of all available devices
  println("printPorts of midiIO");
  midiIO.printDevices();
  midiOut = midiIO.getMidiOut(0, 0); 
  size(640, 480);
  context = new SimpleOpenNI(this);
  if (context.isInit() == false)
  {
    println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
    exit();
    return;
  }
  context.setMirror(true);
  // enable depthMap generation 
  context.enableDepth();

  // enable skeleton generation for all joints
  context.enableUser();
  strokeWeight(3);
  smooth();
}

void draw()
{
  background(0);
  // update the cam
  context.update();
  // draw depthImageMap
  //image(context.depthImage(),0,0);
  //image(context.userImage(),0,0);
  int[] userList = context.getUsers();
  for (int i=0;i<userList.length;i++)
  {
    if (context.isTrackingSkeleton(userList[0]))
    {
      context.getJointPositionSkeleton(userList[0], SimpleOpenNI.SKEL_LEFT_HAND, leftHand);
      context.getJointPositionSkeleton(userList[0], SimpleOpenNI.SKEL_RIGHT_HAND, rightHand);
      stroke(255);
      drawSkeleton(userList[0]);
    }
  }
  //Lefthand  
  context.convertRealWorldToProjective(leftHand, leftHand);
  fill(255, 0, 0);
  ellipse(leftHand.x, leftHand.y, 50, 50);  
  noFill();
  //Righthand
  context.convertRealWorldToProjective(rightHand, rightHand);
  fill(0, 0, 255);
  ellipse(rightHand.x, rightHand.y, 50, 50);  
  noFill();

  //Her tegnes firkanter:
  rect(50, 0, 180, 100);
  rect(0, 0, 50, 100);
  rect(50, 100, 130, 100);
  rect(0, 100, 50, 100);
  rect(50, 200, 130, 110);
  rect(0, 200, 50, 110);
  rect(50, 310, 170, 100);
  rect(0, 310, 50, 100);


  fill(0, 255, 0);
  // venstre top;
  if (leftHand.x < 210 && leftHand.x > 50 && leftHand.y < 110) {
    nt=24;
    rect(50, 0, 180, 100);
  }

  else if (leftHand.x < 50 && leftHand.x > 0 && leftHand.y < 110) {
    nt=25;
    rect(0, 0, 50, 100);
  }
  // venstre midt
  else if (leftHand.x < 180 && leftHand.x > 50 && leftHand.y > 110 && leftHand.y < 260) {
    nt=26;
    rect(50, 100, 130, 100);
  }
  else if (leftHand.x < 50 && leftHand.x > 0 && leftHand.y > 130 && leftHand.y <220) {
    nt=27;
    rect(0, 100, 50, 100);
  }
  // venstre bund
  else if (leftHand.x < 210 && leftHand.x > 50 && leftHand.y > 200 && leftHand.y < 310) {
    nt=28;
    rect(50, 200, 130, 110);
  }
  else if (leftHand.x < 50 && leftHand.x > 0 && leftHand.y > 200 && leftHand.y < 310) {
    nt=29;
    rect(0, 200, 50, 110);
  }
  // venstre bund 2
  else if (leftHand.x < 210 && leftHand.x > 50 && leftHand.y > 310 && leftHand.y < 390) {
    nt=30;
    rect(50, 310, 170, 100);
  }
  else if (leftHand.x < 50 && leftHand.x > 0 && leftHand.y > 310 && leftHand.y < 390) {
    nt=31;
    rect(0, 310, 50, 100);
  }
  else {
    nt = -1;
    last_nt = -1;
  }
  
  if (nt != last_nt){
    int nnt=nt;
    if (nt==24 || nt==26 || nt==28 || nt==30){
      nnt=nt+tillag[nt]*20;
      print(" "+tillag[nt]+" ");
      tillag[nt]=(tillag[nt]+1)%3;
    }      
    println(nnt+" "+last_nt);
    Note note = new Note(nnt, 60, 500);
    midiOut.sendNote(note);
    last_nt=nt;
  }
  
  






//  if (leftHand.x < 210 && leftHand.x > 50 && leftHand.y < 110) 
//  {
//    fill(0, 255, 0);
//    nt = 24 + left1*20;
//    if (last_nt != nt && last_nt != nt+20 && last_nt != nt+40) {
//      left1=(left1+1)%3;
//      println(nt+" "+last_nt);
//      Note note = new Note(nt, 60, 500);
//      midiOut.sendNote(note);
//      last_nt=nt;
//    }
//  }
//  rect(50, 0, 180, 100);
//  noFill();
//
//  if (leftHand.x < 50 && leftHand.x > 0 && leftHand.y < 110)
//  {
//    fill(255, 0, 0);
//    nt = 25;
//    if (last_nt != nt) {
//      println(nt+" "+last_nt);
//      Note note = new Note(nt, 60, 500);
//      midiOut.sendNote(note);
//      last_nt=nt;
//    }
//  }
//  rect(0, 0, 50, 100);
//  noFill();
//  // venstre midt
//  if (leftHand.x < 180 && leftHand.x > 50 && leftHand.y > 110 && leftHand.y < 260)
//  {
//    fill(0, 255, 0);
//    nt = 26 + left2*20;
//    if (last_nt != nt && last_nt != nt+20 && last_nt != nt+40) {
//      left1=(left2+1)%3;
//      println(nt+" "+last_nt);
//      Note note = new Note(nt, 60, 500);
//      midiOut.sendNote(note);
//      last_nt=nt;
//    }
//  }
//
//  rect(50, 100, 130, 100);
//  noFill();
//  if (leftHand.x < 50 && leftHand.x > 0 && leftHand.y > 130 && leftHand.y <220)
//  {
//    fill(255, 0, 0);
//    nt = 27;
//    if (last_nt != nt) {
//      println(nt+" "+last_nt);
//      Note note = new Note(nt, 60, 500);
//      midiOut.sendNote(note);
//      last_nt=nt;
//    }
//  }
//  rect(0, 100, 50, 100);
//  noFill();
//
//  // venstre bund
//  if (leftHand.x < 210 && leftHand.x > 50 && leftHand.y > 200 && leftHand.y < 310)
//  {
//    fill(0, 255, 0);
//    nt = 28 + left3*20;
//    if (last_nt != nt && last_nt != nt+20 && last_nt != nt+40) {
//      left1=(left3+1)%3;
//      println(nt+" "+last_nt);
//      Note note = new Note(nt, 60, 500);
//      midiOut.sendNote(note);
//      last_nt=nt;
//    }
//  }
//  rect(50, 200, 130, 110);
//  noFill();
//  if (leftHand.x < 50 && leftHand.x > 0 && leftHand.y > 200 && leftHand.y < 310)
//  {
//    fill(255, 0, 0);
//    nt = 29;
//    if (last_nt != nt) {
//      println(nt+" "+last_nt);
//      Note note = new Note(nt, 60, 500);
//      midiOut.sendNote(note);
//      last_nt=nt;
//    }
//  }
//  rect(0, 200, 50, 110);
//  noFill();
//
//  // venstre bund 2
//  if (leftHand.x < 210 && leftHand.x > 50 && leftHand.y > 310 && leftHand.y < 390)
//  {
//    fill(0, 255, 0);
//    nt = 30 + left4*20;
//    if (last_nt != nt && last_nt != nt+20 && last_nt != nt+40) {
//      left1=(left4+1)%3;
//      println(nt+" "+last_nt);
//      Note note = new Note(nt, 60, 500);
//      midiOut.sendNote(note);
//      last_nt=nt;
//    }
//  } 
//
//  rect(50, 310, 170, 100);
//  noFill();
//  if (leftHand.x < 50 && leftHand.x > 0 && leftHand.y > 310 && leftHand.y < 390)
//  {
//    fill(255, 0, 0);
//    nt = 31;
//    if (last_nt != nt) {
//      println(nt+" "+last_nt);
//      Note note = new Note(nt, 60, 500);
//      midiOut.sendNote(note);
//      last_nt=nt;
//    }
//  }
//  rect(0, 310, 50, 100);


  noFill();
  // højre top
  if (rightHand.x > 430 && rightHand.y > 0 && rightHand.y < 130)
  {
    fill(0, 255, 0);
    nt2 = 32;
  }
  rect(430, 0, boxWidth, boxHeight);
  noFill();
  // højre midt
  if (rightHand.x > 430 + 30 && rightHand.y > 130 && rightHand.y < 260)
  {
    fill(0, 255, 0);
    nt2 = 33;
  }
  rect(460, 130, boxWidth - 30, boxHeight);
  noFill();
  // højre bund
  if (rightHand.x > 430 && rightHand.y > 260 && rightHand.y < 390)
  {
    fill(0, 255, 0);
    nt2 = 34;
  }
  rect(430, 260, boxWidth, boxHeight);



  //Her laves der notes

  // println(nt+" "+last_nt+" "+last_nt);



  //  if (nt  !=  last_nt) {


  // venstre top;
  //    if (leftHand.x < 210 && leftHand.x > 50 && leftHand.y < 110)
  //    {
  //
  //      println(nt+" "+last_nt);
  //      Note note = new Note(nt, 60, 500);
  //      midiOut.sendNote(note);
  //      last_nt=nt;
  //    }


  //    if (leftHand.x < 50 && leftHand.x > 0 && leftHand.y < 110)
  //    {
  //
  //      println(nt+" "+last_nt);
  //      Note note = new Note(nt, 60, 500);
  //      midiOut.sendNote(note);
  //      last_nt=nt;
  //    }
  //
  //    // venstre midt
  //    if (leftHand.x < 180 && leftHand.x > 50 && leftHand.y > 110 && leftHand.y < 260)
  //    {
  //
  //      println(nt+" "+last_nt);
  //      Note note = new Note(nt, 60, 500);
  //      midiOut.sendNote(note);
  //      last_nt=nt;
  //    }
  //
  //
  //    if (leftHand.x < 50 && leftHand.x > 0 && leftHand.y > 130 && leftHand.y <220)
  //    {
  //
  //      println(nt+" "+last_nt);
  //      Note note = new Note(nt, 60, 500);
  //      midiOut.sendNote(note);
  //      last_nt=nt;
  //    }
  //
  //
  //    // venstre bund
  //    if (leftHand.x < 210 && leftHand.x > 50 && leftHand.y > 200 && leftHand.y < 310)
  //    {
  //
  //      println(nt+" "+last_nt);
  //      Note note = new Note(nt, 60, 500);
  //      midiOut.sendNote(note);
  //      last_nt=nt;
  //    }
  //
  //    if (leftHand.x < 50 && leftHand.x > 0 && leftHand.y > 200 && leftHand.y < 310)
  //    {
  //
  //      println(nt+" "+last_nt);
  //      Note note = new Note(nt, 60, 500);
  //      midiOut.sendNote(note);
  //      last_nt=nt;
  //    }
  //
  //
  //    // venstre bund 2
  //    if (leftHand.x < 210 && leftHand.x > 50 && leftHand.y > 310 && leftHand.y < 390)
  //    {
  //
  //      println(nt+" "+last_nt);
  //      Note note = new Note(nt, 60, 500);
  //      midiOut.sendNote(note);
  //      last_nt=nt;
  //    }
  //
  //    if (leftHand.x < 50 && leftHand.x > 0 && leftHand.y > 310 && leftHand.y < 390)
  //    {
  //
  //      println(nt+" "+last_nt);
  //      Note note = new Note(nt, 60, 500);
  //      midiOut.sendNote(note);
  //      last_nt=nt;
  //    }
  //  }


  if (nt2  !=  last_nt2) {
    // højre top
    if (rightHand.x > 430 && rightHand.y > 0 && rightHand.y < 130)

    {
      println(nt2+" "+last_nt2);
      Note note = new Note(nt2, 60, 500);
      midiOut.sendNote(note);
      last_nt2=nt2;
    }


    // højre midt
    if (rightHand.x > 430 + 30 && rightHand.y > 130 && rightHand.y < 260)
    {
      println(nt2+" "+last_nt2);
      Note note = new Note(nt2, 60, 500);
      midiOut.sendNote(note);
      last_nt2=nt2;
    }

    // højre bund
    if (rightHand.x > 430 && rightHand.y > 260 && rightHand.y < 390)

    {
      println(nt2+" "+last_nt2);
      Note note = new Note(nt2, 60, 500);
      midiOut.sendNote(note);
      last_nt2=nt2;
    }
  }
}

