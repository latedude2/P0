int bannerHeight = 300;    //The height of the banner
int selectionHeight = 50;  //The height of the selection 
int prevImage = 5;         //Image shown on the left side
int shownImage = 0;        //Image shown
int nextImage = 1;         //Image shown on the right side
float imgLoc = 0;          //X location of the main image
PImage banner;             //Banner image
PImage[] main;             //Main images
int mouseStart;            //X coordinate of the mouse when it was pressed
float followMultiplier = 0.8;   //Multiplier for the speed of the screen adjusment to a new target location 
int lastPress = 0;         //On which millisecond of the program's runtime was the screen interacted with last time
int waitTime = 60000;      //How long the poster waits until it resets to the introduction page (milliseconds)
void setup()
{
  mouseStart = 0;          //Setting mouseStart
  size(841,1189);          //Setting the size of the window
  frameRate(30);           //Setting the framerate to 30
  main = new PImage[6];    //Instantiating the images
  banner = loadImage("Banner.jpg");
  main[0] = loadImage("Main1.jpg");
  main[1] = loadImage("Main2.jpg");
  main[2] = loadImage("Main3.jpg");
  main[3] = loadImage("Main4.jpg");
  main[4] = loadImage("Main5.jpg");
  main[5] = loadImage("Main6.jpg");
  
}
void draw()
{
  background(255,0,0);  //Setting background color
  drawBanner(); 
  drawSelectionBar();
  drawMain();
  checkIfResetIsNeeded();
}
void mousePressed()
{
  if(mouseY > bannerHeight + selectionHeight)  //If mouse is below banner
    mouseStart = mouseX;      //Set new mouse start X coordinate
}
void mouseReleased()
{
  if(mouseX - mouseStart > width/2)    //if the mouse has moved enough to the right to change the shown image
  {
    
    shownImage--;           //change the shown images
    prevImage--;
    nextImage--;
    if(prevImage < 0)       //make sure the indexes do not leave the array
    {
      prevImage = main.length - 1;  
    }
    if(shownImage < 0)
    {
      shownImage = main.length - 1;
    }
    if(nextImage < 0)
    {
      nextImage = main.length - 1;
    }
    imgLoc = -width + (mouseX - mouseStart); //bug here //should set new image location
    mouseStart = mouseX;    //set new mouseStart 
}
  else if(mouseX - mouseStart < -width/2)    //if the mouse has moved enough to the right to change the shown image
  {
    
    shownImage++;         //change the shown images
    prevImage++;
    nextImage++;
    if(prevImage > main.length - 1)    //make sure the indexes do not leave the array
    {
    prevImage = 0;
    }
    if(shownImage > main.length - 1)
    {
      shownImage = 0;
    }
    if(nextImage > main.length - 1)
    {
      nextImage = 0;
    }
    imgLoc = width + (mouseX - mouseStart);  //bug here  //should set new image location
    mouseStart = mouseX;  //set new mouseStart  
}
  else imgLoc = mouseX - mouseStart;  //sets new image location, so it can move back to default location smoothly
  
}
void mouseClicked()
{
  lastPress = millis();
  if(mouseY > bannerHeight && mouseY < bannerHeight + selectionHeight)  //Mouse is on the selection bar
  for(int i = 0; i < main.length; i++)  //For each button in the selection bar
  {
    if(width/main.length * i < mouseX && width / main.length * (i + 1) > mouseX)  //checking if the mouse is within the specific button of the selection bar
    {
      shownImage = i;                //Set the shown image to the one which was pressed
      prevImage = shownImage - 1;    //Set next and previous images accordingly
      nextImage = shownImage + 1;
      imgLoc = 0;
      if(prevImage < 0)              //make sure the indexes do not leave the array
      {
        prevImage = main.length - 1;
      }
      if(nextImage > main.length - 1)
      {
        nextImage = 0;
      }
    }
  }
}
void checkIfResetIsNeeded()
{
 if(millis() - lastPress > waitTime)    //If the time since the mouse was clicked is more than the wait time
 {
  prevImage = 5;         //Reset the images
  shownImage = 0;        
  nextImage = 1;      
  lastPress = millis();  //Reset the last time pressed, so it doesn't reset every frame
 }
}
void drawBanner()
//Draws the banner
{
  image(banner ,0 ,0 , width, bannerHeight);
}
void drawMain()
//Draws the main part of the screen
{
  if(mousePressed && mouseY > bannerHeight + selectionHeight)    //If the mouse is pressed within the main section of the poster
  {
    image(main[prevImage], mouseX - mouseStart - width, selectionHeight + bannerHeight, width, height - selectionHeight - bannerHeight);    //show all the images accordingly
    image(main[shownImage], mouseX - mouseStart, selectionHeight + bannerHeight, width, height - selectionHeight - bannerHeight);
    image(main[nextImage], mouseX - mouseStart + width, selectionHeight + bannerHeight, width, height - selectionHeight - bannerHeight);
    
  }
  /* SIMPLE EDITION
  else image(main[shownImage], 0, selectionHeight + bannerHeight, width, height - selectionHeight - bannerHeight);
  */
  else { /*SMOOTH EDITION*/    //If the bottom part of the screen is not being interacted with, make sure it goes back to the default place smoothly
    imgLoc = followNumber(0, imgLoc);    //Set the new location of the screen
    image(main[prevImage], imgLoc - width, selectionHeight + bannerHeight, width, height - selectionHeight - bannerHeight);    //show all the images accordingly
    image(main[shownImage], imgLoc, selectionHeight + bannerHeight, width, height - selectionHeight - bannerHeight);
    image(main[nextImage], imgLoc + width, selectionHeight + bannerHeight, width, height - selectionHeight - bannerHeight);
    
  }
}
void drawSelectionBar()
//Draws the selection bar
{
  for(int i = 0; i < main.length; i++)    //For each page of the poster
  {
   image(main[i], width/main.length * i, bannerHeight, width / main.length * (i + 1),selectionHeight);     //Draw a button
  }
}
float followNumber(float target, float current)
//Returns a new number, which is closer to the target number
{
  return target - ((target - current) * followMultiplier);
}
