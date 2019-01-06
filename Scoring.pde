//scoring class for when player is at scoring screen
public class Scoring{
  
  //fields
  PImage background;
  PImage menuButton;
  
  //constructor
  public Scoring(){
    
    //set the background to be the middle of the background image
    background = backgroundImage.get( (backgroundWidth-width)/2, (backgroundHeight-height)/2, 900, 900);
    
    //set new cursor color
    mouse = loadImage("mouseWhite.png");
    cursor(mouse, mouse.width/2, mouse.height/2);
    
    //font size
    textFont(font, 100);
    
  }
  
  
  //display the scoring screen
  void displayScoring(){
    background(background);
    
    
    //messages to user on points earned, and a button for going back to menu
    text("YOU DIED", width/2, textAscent() + 100);
    
    //tell the user what their score was
    text("You scored: " + score, width/2, height/2);
    
    //load the image and put text on it
    menuButton = loadImage("menuButton.png");
    image(menuButton, width/2, height*7/8);
    text("Menu", width/2, height*7/8);
  }
  
  
  //check for user mouse click input
  void checkMouse(){
    
    if(!mousePressed){ return; }
    
    //check if user clicked menu button to move into menu state
    if(mouseX > (width-menuButton.width)/2 && mouseX < (width+menuButton.width)/2 && mouseY > height*7/8 - menuButton.height/2 && mouseY < height*7/8 + menuButton.height/2){
      currentState = menuState;
    }
    
    
  }
  
  
}
