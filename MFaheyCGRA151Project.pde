// -----imports-----
import java.util.*;

// -----fields-----

//stage objects like menu and game
Menu menu;
Game game;
Scoring scoring;

// init fields to be filled with main and viewable port of background image
PImage backgroundImage;

//fonts && cursor
PFont font;
PImage mouse;

//score from ships killed
int score = 0;

//information about the background image size
int backgroundWidth;
int backgroundHeight;

//fields for state game is in
int menuState = 0;
int gameState = 1;
int scoringState = 2;
int currentState = menuState;


//store the various sprites so i don't keep loading them
PImage enemyMineImage;
PImage enemyProjectileImage;
PImage rammerImage;
PImage shooterImage;
PImage trapperImage;
PImage playerProjectileImage;
PImage playerMissileImage;
PImage powerupImage;
PImage bossImage;

// -----setup before game starts-----
void setup(){
  
  
  //load in the different sprites in a futile attempt to reduce lag
  enemyMineImage = loadImage("images/enemyMine.png");
  enemyProjectileImage = loadImage("images/enemyBullet.png");
  rammerImage = loadImage("images/rammer.png");
  shooterImage = loadImage("images/shooter.png");
  trapperImage = loadImage("images/trapper.png");
  playerProjectileImage = loadImage("images/bullet.png");
  playerMissileImage = loadImage("images/missile.png");
  powerupImage = loadImage("images/powerup.png");
  bossImage = loadImage("images/boss.png");
  
  
  frameRate(60);
  
  //load the font style
  font = loadFont("AgencyFB-Reg-48.vlw");
  textFont(font, 150);
  textAlign(CENTER, CENTER);
  
  
  // set canvas size
  size(900,900);  
  
  
  // load in the BIG image for the background
  backgroundImage = loadImage("backgroundBorder.png");  
  
  //Set information about backgroundImage size
  backgroundWidth = backgroundImage.width;
  backgroundHeight = backgroundImage.height;
  
  //set mode of drawing Pimages
  imageMode(CENTER);
  
  //set new cursor picture, and make mouse hotspot in middle of new cursor
  mouse = loadImage("mouseWhite.png");
  cursor(mouse, mouse.width/2, mouse.height/2);  //numbers found through trial and error.   mouse.width didn't help ???
  
}



// -----all actions and events that happen each frame-----
void draw(){
  
  ////Controller for game to seperate different stages
  
  //If in menu State
  if(currentState == menuState){
    
    //If menu object doesn't exist, create it and clear the scoring object
    if(menu == null){
      menu = new Menu();
      scoring = null;
    }
    menu.displayMenu();
    menu.checkMouse();
    
  }
  
  //If in game State
  else if(currentState == gameState){
    
    //If game object doesn't exist, make it and clear menu object
    if(game == null){
      game = new Game();
      menu = null;
    }
    game.spawnEnemy();
    game.displayGame();
    game.checkInput();
  }
  
  //If in scoring state
  else if(currentState == scoringState){
    
    //if scoring object doesn't exist, make it and clear the game object
    if(scoring == null){
      scoring = new Scoring();
      game = null;
    }
    scoring.displayScoring();
    scoring.checkMouse();
    
  }
  
  //This only triggers if the state stuff has gone wrong. Yay bug testing
  else{
    println("Current state is unknown?!?");
  }
}
