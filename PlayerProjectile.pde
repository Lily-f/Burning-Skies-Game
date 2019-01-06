//class for bullets fired by the player
public class PlayerProjectile{
  
  //fields
  PVector playerPosition = new PVector();
  PVector position = new PVector();
  PVector velocity = new PVector();
  PImage image = playerProjectileImage;
  float muzzleSpeed = 10;
  float hitBoxRadius = image.width/2.5;
  
  
  //constructor. Sets up initial movement vectors
  public PlayerProjectile(PVector playerVelocity, PVector playerPosition){
    
    //set the velocity of the bullet to be the velocity of the player and increase magnitude by muzzleSpeed
    velocity.set(playerVelocity);
    velocity.setMag(velocity.mag() + muzzleSpeed);
    
    //set initial position to be where the player is
    position.set(playerPosition);
  }
  
  
  //move the bullet by its velocity
  public void moveBullet(PVector playerPos){
    position.add(velocity);
    
    //update the player position
    playerPosition.set(playerPos);
    
  }
  
  
  //return boolean on if bullet inside frame
  public boolean inFrame(){
    if(position.x < 0 || position.x > backgroundWidth || position.y < 0 || position.y > backgroundHeight){
      return false;
    }
    return true;
  }
  
  
  //draw the bullet onscreen
  public void drawBullet(){
    
    pushMatrix();
    translate(width/2, height/2);
    image(image, position.x - playerPosition.x, position.y - playerPosition.y);
    popMatrix();
  }
  
  
  public PVector getPosition(){
    return position;
  }
  
  public float getHitbox(){
    return hitBoxRadius;
  }
  
}
