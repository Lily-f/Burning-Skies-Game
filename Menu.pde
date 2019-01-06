//menu class for when player is at menu screen
public class Menu{
  
  //fields
  PImage background;
  PImage player;
  
  //constructor. Set up background position
  public Menu(){
    
    //set the background to be the middle of the background image
    background = backgroundImage.get( (backgroundWidth-width)/2, (backgroundHeight-height)/2, 900, 900);
    player = loadImage("images/player.png");
    
    
    //clear score from previous game
    score = 0;
    
  }
  
  
  //display the menu screen
  void displayMenu(){
    background(background);
    //image(logo, (), ());
    image(player, width/2 , height/2);
    
    //title and user input prompts
    text("BURNING SKIES", width/2, textAscent() + 100);
    textFont(font, 50);
    text("Click your ship to start", width/2, height*2/6);
    text("Click for guns", width/2, height * 4/6);
    text("Spacebar for missiles", width/2, height * 9/12);
    image(powerupImage, width/2, height * 21/24);
    text("Powerup", width/2, height * 11/12);
    textFont(font, 100);
  }
  
  
  //check for user mouse click input
  void checkMouse(){
    
    if(!mousePressed){ return; }
    
    //check if user clicked on player ship to move into game state
    if(mouseX > width/2-player.width && mouseX < width/2+player.width && mouseY > height/2-player.height && mouseY < height/2+player.height){
      currentState = gameState;
    }
    
  }
  
}
