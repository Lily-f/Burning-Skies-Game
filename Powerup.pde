//class for the powerups that the player can unlock
public class Powerup{
  
  //fields
  PImage image = powerupImage;
  PVector position = new PVector();
  PVector playerPosition = new PVector();
  float hitBoxRadius = image.width/2.5;
  int type = (int)random(0, 2);  // types of powerup, increased bullets, brief invincibility, faster movespeed?
  
  //constructor
  public Powerup(PVector playerPos, PVector spawnPosition){
    position.set(spawnPosition);
    playerPosition.set(playerPos);
  }
  
  
  //return true/false depending on if touching the player.
  public boolean touchingPlayer(){
    //re-get the position of the player for drawing
    playerPosition = game.player.getPosition();
    
    //store variables for collision detection cus square roots are expensive
    float xDistanceBetween = position.x - playerPosition.x;
    float yDistanceBetween = position.y - playerPosition.y;
    float totalHitboxDistance = hitBoxRadius + game.player.getHitbox(); 
    
    return ((xDistanceBetween * xDistanceBetween) + (yDistanceBetween * yDistanceBetween) < totalHitboxDistance * totalHitboxDistance);
  }
  
  
  //activate the powerUp
  public void activatePowerup(){
    if(type == 0 || (game.atMaxLives() && type == 1) ){
      game.player.increaseInvincibility(300);
    }
    else if (type == 1){
      game.addLife();
    }
  }
  
  
  //redraw the powerUp (based on power and players location)
  public void redraw(){
    pushMatrix();
    translate(width/2 + position.x - playerPosition.x, height/2 + position.y - playerPosition.y);
    image(image, 0, 0);
    popMatrix();
  }
  
}
