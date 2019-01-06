//class for missiles fired by the player
public class PlayerMissile{
  
  //fields
  PImage image = playerMissileImage;
  PVector playerPosition = new PVector();
  PVector enemyPosition = new PVector();
  PVector position = new PVector();
  PVector velocity = new PVector();
  float hitBoxRadius = image.width/2.5;
  float acceleration = 0.2;  //rate that the missile accelerates (scalar value to increase magnitude)
  Enemy target;
  
  //constructor
  public PlayerMissile(PVector playerVelocity, PVector playerPos){
    playerPosition.set(playerPos);
    velocity.set(playerVelocity);
    position.set(playerPosition);
    
    findTarget();
    //if has target, set on collision vector
    if(target != null){
      velocity.set(enemyPosition.x - position.x, enemyPosition.y - position.y);
      velocity.setMag(playerVelocity.mag());
    }
  }
  
  
  //move the missile based on the target
  public void moveMissile(PVector playerPos){
    playerPosition.set(playerPos);
    
    position.add(velocity);  //move by velocity
    
    float currentSpeed = velocity.mag();
    
    //if has target, set on collision vector
    if(target != null){
      velocity.set(enemyPosition.x - position.x, enemyPosition.y - position.y);
    }
    //else find a target
    else{
      findTarget();
    }
    
    velocity.setMag(currentSpeed + acceleration);  //increace velocity with acceleration
  }
  
  
  //return boolean on if bullet inside frame
  public boolean inFrame(){
    if(position.x < 0 || position.x > backgroundWidth || position.y < 0 || position.y > backgroundHeight){
      return false;
    }
    return true;
  }
  
  
  //find the nearest enemy and set as target
  private void findTarget(){
    Map<String, HashSet<Enemy>> enemies = game.getEnemies();
    float smallestDistance = 999999999;
    
    //for all enemies, find the closest one and set as target
    for(HashSet<Enemy> enemyType : enemies.values()){
      for(Enemy enemy : enemyType){
        
        //store variables for distance calculation cus square roots & dist() are expensive
        float xDistanceBetween = enemy.getPosition().x - playerPosition.x;
        float yDistanceBetween = enemy.getPosition().y - playerPosition.y;
        
        float distanceToPlayer = xDistanceBetween * xDistanceBetween + yDistanceBetween * yDistanceBetween;
        if(distanceToPlayer < smallestDistance){
          smallestDistance = distanceToPlayer;
          target = enemy;
          enemyPosition = target.getPosition();
        }
      }
    }
  }
  
  
  //draws the missile
  public void drawMissile(){
    
    //only draw if is on the window (help stop lag)
    //if(width/2 + position.x - playerPosition.x < -image.width || width/2 + position.x - playerPosition.x > width + image.width || 
      //height/2 + position.y - playerPosition.y < -image.height || height/2 + position.y - playerPosition.y > height + image.height){return ;}
    
    pushMatrix();
    translate(width/2 + position.x - playerPosition.x, height/2 + position.y - playerPosition.y);
    rotate(velocity.heading() + HALF_PI); //half pi is due to heading not coming from north
    image(image, 0, 0);
    popMatrix();
  }
  
  
  //clear the current target
  public void clearTarget(){
    target = null;
  }
  
  
  public float getHitbox(){
    return hitBoxRadius;
  }
  
  public PVector getPosition(){
    return position;
  }
  
  
}
