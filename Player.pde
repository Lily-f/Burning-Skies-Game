//class for the players ship. Only used in game state
public class Player{
  
  //Movement fields
  PVector playerPosition = new PVector(); //on the big image, not window
  PVector playerVelocity = new PVector();
  PVector mousePos = new PVector();
  PImage playerSprite = loadImage("images/player.png");
  float maxTurn = PI/20; //PI/20
  float angleDifference;
  
  //weapon/health fields
  int gunCooldown = 7; //fire every x frames 
  int missileCooldown = 60; //fire every 120 frames (every 2 seconds)
  int gunCurrentCooldown = 0;  //number of frames cooled for (when >= to cooldown, its ready)
  int missileCurrentCooldown = 0; //starts off not ready to fire
  float hitBoxRadius = playerSprite.width/2.5;
  int damageInterval = 80;  //number of frames between points player can take damage. Basically to stop instant death
  int currentDamageInterval = 0;  //number of frames till more damage can be taken. when hit resets to damageInterval
  int invincibility = 0;  //number of frames of invincibility remaining (achieved with powerups)
  
  HashSet<PlayerProjectile> projectiles = new HashSet<PlayerProjectile>();  //set of all projectiles fired
  HashSet<PlayerMissile> missiles = new HashSet<PlayerMissile>();  //set of all missiles fired
  
  
  //constructor. Set variables
  public Player(){
    
    //set the vectors
    playerPosition.set(backgroundWidth/2, backgroundHeight/2);
    playerVelocity.set(0,-1);  //for angle calculations in first frame, requires a velocity
    mousePos.set(mouseX - width/2, mouseY - height/2);
    
  }
  
  
  //move player
  public void move(){
    
    //find angle between vectors ship velocity and mouse position from ship. can't be greater than maxTurn
    findAngle();
    
    //Find velocity based on mouse position from ship. Magnitude is preportional to distance
    
    playerVelocity.setMag( dist(mouseX, mouseY, width/2, height/2) );  //set magnitude
    playerVelocity.div(sqrt(width + height));
    playerVelocity.rotate(angleDifference);  //rotate to point towards mouse (but never rotate too much per frame)
    playerPosition.add(playerVelocity);
    
    //check boundaries
    checkBoundaries();
  }
  
  
  //find angle between ship heading and mouse position to ship
  private void findAngle(){
    
    //vind ablge between the two vectors
    mousePos.set(mouseX - width/2, mouseY - height/2);
    angleDifference = PVector.angleBetween(mousePos, playerVelocity);
    
    //if going anti-clockwise then want negative rotation
    if(mousePos.heading() < playerVelocity.heading()){
      angleDifference *= -1;
    }
    
    //counter the headings going from -ve to +ve on the x axis line from -PI to PI
    if(( (playerVelocity.heading() < 0 && mousePos.heading() > 0) || (playerVelocity.heading() > 0 && mousePos.heading() < 0) ) && mouseX < width/2){
      angleDifference *= -1;
    }
    
    
    //player can only turn maxTurn per frame    
    if(angleDifference > maxTurn){
      angleDifference = maxTurn;
    }
    else if(angleDifference < -maxTurn){
      angleDifference = -maxTurn;
    }
  }
  
  
  //check if player is out of bounds
  private void checkBoundaries(){
    //check left
    if(playerPosition.x < width/2){
      playerPosition.x = width/2;
    }
    //check right
    else if(playerPosition.x > backgroundWidth - width/2){
      playerPosition.x = backgroundWidth - width/2;
    }
    
    //check up
    if(playerPosition.y < height/2){
      playerPosition.y = height/2;
    }
    //check down
    else if(playerPosition.y > backgroundHeight - height/2){
      playerPosition.y = backgroundHeight - height/2;
    }
  }
  
  
  //drawPlayer. If player is currently invincible, tint image red
  public void drawPlayer(){
    
    //if player is damaged, draw tinted, flashing every frame
    if(currentDamageInterval > 0 && currentDamageInterval % 20 >= 10){
      tint(0,0,0,50);
    }
    //if player has invincibility then tint the ship a different color. also text prompt
    if(invincibility > 0){
      textAlign(LEFT, CENTER);
      text("Shield: " + invincibility, width - textWidth("Shield: xxxxxx"), height - textAscent());
      textAlign(CENTER, CENTER);
      tint(0,200,200);
    }
    
    //rotate around the center and draw player
    pushMatrix();
    translate(width/2, height/2);
    rotate(playerVelocity.heading() + HALF_PI);
    image( playerSprite, 0, 0);
    noTint();
    popMatrix();
    
  }
  
  
  //fires guns but only if not on cooldown
  public void fireGuns(){
    
    //if guns are cooledDown, fire and reset cooldown
    if(gunCurrentCooldown >= gunCooldown){
      projectiles.add(new PlayerProjectile(playerVelocity, playerPosition));
      gunCurrentCooldown = 0;
    }
    
  }
  
  
  //fires missiles but only if not on cooldown
  public void fireMissile(){
    if(missileCurrentCooldown >= missileCooldown){
      missiles.add(new PlayerMissile(playerVelocity, playerPosition));
      missileCurrentCooldown = 0;
      
    }
  }
  
  
  //cool all weapons down by 1 frame. also reduces number of frames till damage can be taken next || reduce invincibility
  public void coolWeapons(){
    gunCurrentCooldown ++;
    missileCurrentCooldown ++;
    if(currentDamageInterval > 0){
      currentDamageInterval --;
    }
    if(invincibility > 0){
      invincibility --;
    }
  }
  
  
  //move player's bullets and missiles
  public void moveWeapons(){
    
    //move all of the bullets
    for(PlayerProjectile bullet : new HashSet<PlayerProjectile>(projectiles)){
      
      //only move bullets in the frame
      if(bullet.inFrame()){
        bullet.moveBullet(playerPosition);
        bullet.drawBullet();
      }
      //remove bullets that go off the map
      else{
        projectiles.remove(bullet);
      }
    }
    
    
    //move all player missiles
    for(PlayerMissile missile : new HashSet<PlayerMissile>(missiles)){
      if(missile.inFrame()){
        missile.moveMissile(playerPosition);
        missile.drawMissile();
      }
      else{
        missiles.remove(missile);
      }
    }
    
  }
  
  
  //when the player is hit, and currentDamageInterval is 0, take damage
  public void takeDamage(){
    
    //only take damage if CurrentDamageInterval is 0
    if(currentDamageInterval == 0 && invincibility == 0){
      currentDamageInterval = damageInterval;
      if(game.lives.size() != 0){ game.lives.remove(0); }
      if(game.lives.size() == 0){
        currentState = scoringState;
      }
    }    
    
  }
  
  
  //increase the invincibility of the player for a given number of frames
  public void increaseInvincibility(int frames){
    invincibility = frames;  //this means that the invincibility doesn't stack (use += for stacking)
  }
  
  
  //removes a specified bullet from the set
  public void removeBullet(PlayerProjectile bullet){
    projectiles.remove(bullet);
  }
  
  
  //removes a given missile
  public void removeMissile(PlayerMissile missile){
    missiles.remove(missile);
  }
  
  //return the position vector of the player
  public PVector getPosition(){
    return playerPosition;
  }
  
  public float getHitbox(){
    return hitBoxRadius;
  }
  
  public HashSet<PlayerProjectile> getBullets(){
    return projectiles;
  }
  
  public HashSet<PlayerMissile> getMissiles(){
    return missiles;
  }
  
}
