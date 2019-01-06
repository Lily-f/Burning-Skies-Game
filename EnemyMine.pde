//class for mines launched by enemy. They don't move
public class EnemyMine{
  
  //fields
  PVector playerPosition = new PVector();
  PVector position = new PVector();
  PImage image = enemyMineImage;
  float hitBoxRadius = image.width/2.5;
  int life = 450;  //number of frames mine stays on screen for
  
  //constructor
  public EnemyMine(PVector playerPosition, PVector enemyPosition){
    
    //set initial position to be where the enemy that fired is
    position.set(enemyPosition);
    
    //save where the player is for drawing
    playerPosition.set(playerPosition);
    
  }
  
  
  //return boolean on if bullet inside frame
  public boolean inFrame(){
    if(position.x < 0 || position.x > backgroundWidth || position.y < 0 || position.y > backgroundHeight){
      return false;
    }
    return true;
  }
  
  
  //check the number of lives bomb has (each represents 1 frame). return if 0
  public boolean checkLife(){
    life --;
    return (life == 0);
  }
  
  
  //draw the bullet onscreen
  public void drawMine(PVector playerPos){
    
    playerPosition.set(playerPos);
        
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
