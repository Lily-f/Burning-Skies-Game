//class for basic shooting enemy
public class Trapper implements Enemy{
  
  //fields
  PImage image = trapperImage;
  PVector playerPosition = new PVector();
  PVector position = new PVector();
  PVector velocity = new PVector();
  float speed = 2.2;
  float hitBoxRadius = image.width/2.5;
  int points = 3;  //number of points the shooter is worth
  float dropPowerupChance = 0.2;
  PVector acceleration = new PVector();
  float desiredSeperation = image.width*1.2;
  float maxAcceleration = 0.8;
  
  //fields for laying mines
  int gunCooldown = 120; //fire every x frames
  int gunCurrentCooldown = 0;  //number of frames gun has cooled for
  
  //constructor. Pick spawn location and calculate speed and position vectors
  public Trapper(PVector playerPos, PVector spawnPosition){
    
    position.set(spawnPosition.x, spawnPosition.y);
    playerPosition.set(playerPos);
    
    //set the angle and magnitude of the trapper so it points at player and moves 'speed' pixels per frame
    velocity.set(playerPosition.x - position.x, playerPosition.y - position.y);
    velocity.setMag(speed);
    
  }
  
  
  //move the trapper based on where the player is
  public void move(PVector playerPos){
    
    //implementation of the BOIDS repulsion algorythim. stops the rammers getting too close to one another
    acceleration.set(0,0);
    float count = 0;
    //go through all enemy and if there are to close, find a repulsion force
    for(HashSet<Enemy> enemyType : game.getEnemies().values()){
      for(Enemy enemy : new HashSet<Enemy>(enemyType)){
        float distance = PVector.dist(position, enemy.getPosition());
        if(distance > 0 && distance < desiredSeperation){
          count ++;
          PVector difference = PVector.sub(position, enemy.getPosition());
          difference.normalize();
          difference.div(distance);
          acceleration.add(difference);
        }
      }
    }
    //get the average of the forces
    if(count > 0){
      acceleration.div(count);
    }
    //if there is a force, then force = desired - velocity
    if(acceleration.mag() > 0){
      acceleration.setMag(speed);
      acceleration.sub(velocity);
      acceleration.limit(maxAcceleration);
    }
    
    //update position of the player, point the ship towards the player and set speed
    playerPosition.set(playerPos);
    velocity.set(playerPosition.x - position.x, playerPosition.y - position.y);
    velocity.setMag(speed);
    
    //set new velocity
    velocity.add(acceleration);
    velocity.limit(speed);
    //set new position
    position.add(velocity);
    
    
    //drop a mine
    dropMine();
  }
  
  
  //fires the main gun at the player
  private void dropMine(){
    //cool the guns down
    gunCurrentCooldown ++;
    
    //if mine launcher is cooled down, fire and reset cooldown
    if(gunCurrentCooldown >= gunCooldown){
      game.enemyMines.add(new EnemyMine(playerPosition, position));
      gunCurrentCooldown = 0;
    }
  }
  
  //return true/false depending on if touching the player.
  public boolean touchingPlayer(){
    //store variables for collision detection cus square roots are expensive
    float xDistanceBetween = position.x - playerPosition.x;
    float yDistanceBetween = position.y - playerPosition.y;
    float totalHitboxDistance = hitBoxRadius + game.player.getHitbox(); 
    
    return ((xDistanceBetween * xDistanceBetween) + (yDistanceBetween * yDistanceBetween) < totalHitboxDistance * totalHitboxDistance);
  }
  
  
  //return bullet if colliding with a bullet from player, else null
  public PlayerProjectile touchingBullet(){
    HashSet<PlayerProjectile> bullets = game.player.getBullets();
    for(PlayerProjectile bullet : bullets){
      float bulletHitboxRadius = bullet.getHitbox();
      PVector bulletPosition = bullet.getPosition();
      
      //store variables for collision detection cus square roots are expensive
      float xDistanceBetween = position.x - bulletPosition.x;
      float yDistanceBetween = position.y - bulletPosition.y;
      float totalHitboxDistance = hitBoxRadius + bulletHitboxRadius;
      
      if((xDistanceBetween * xDistanceBetween) + (yDistanceBetween * yDistanceBetween) < totalHitboxDistance * totalHitboxDistance){
        return bullet;
      }
    }
    return null;
  }
  
  
  //return a missile that is touching or null if none
  public PlayerMissile touchingMissile(){
    HashSet<PlayerMissile> missiles = game.player.getMissiles();
    for(PlayerMissile missile : missiles){
      float missileHitboxRadius = missile.getHitbox();
      PVector missilePosition = missile.getPosition();
      
      //store variables for collision detection cus square roots are expensive
      float xDistanceBetween = position.x - missilePosition.x;
      float yDistanceBetween = position.y - missilePosition.y;
      float totalHitboxDistance = hitBoxRadius + missileHitboxRadius;
      
      if((xDistanceBetween * xDistanceBetween) + (yDistanceBetween * yDistanceBetween) < totalHitboxDistance * totalHitboxDistance){
        return missile;
      }
    }
    
    return null;
  }
  
  
  //chance to create a random powerup at this position
  public void dropPowerup(){
    if(random(0,1) < dropPowerupChance){
      game.powerups.add(new Powerup(playerPosition, position));
    }
  }
  
  
  //draw the shooter based on where the player & trapper are on the background. also draw mines
  public void redraw(){
    
    pushMatrix();
    translate(width/2 + position.x - playerPosition.x, height/2 + position.y - playerPosition.y);
    rotate(PVector.sub(position, playerPosition).heading() - HALF_PI);
    image(image, 0, 0);
    
    popMatrix();
  }
  
  public PVector getPosition(){return position;}
  
  public int getPoints(){return points;}
  
}
