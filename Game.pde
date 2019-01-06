//game class for when player is inside the game
public class Game{
  
  //fields
  PImage background;
  Player player;
  int maxRammers = 4;
  int maxShooters = 2;
  int maxTrappers = 1;
  int maxLives = 5;
  boolean bossSpawned = false;
  int bossEggs = 3;  //number of enemy that spawn on boss when he dies
  
  //arraylist of lives
  List <PImage> lives = new ArrayList<PImage>(  Arrays.asList(loadImage("player.png"), loadImage("player.png"), loadImage("player.png")) );
  
  //map of all enemy types and a sets of individual enemys
  Map <String, HashSet<Enemy>> enemies = new HashMap<String, HashSet<Enemy> >();
  Set<EnemyProjectile> enemyBullets = new HashSet<EnemyProjectile>();
  Set<EnemyMine> enemyMines = new HashSet<EnemyMine>();
  
  //set of powerups in the game
  Set<Powerup> powerups = new HashSet<Powerup>();
  
  
  //constructor
  public Game(){
    //fill the map with sets of enemy types
    enemies.put("rammer", new HashSet<Enemy>() );
    enemies.put("shooter", new HashSet<Enemy>() );
    enemies.put("trapper", new HashSet<Enemy>());
    enemies.put("boss", new HashSet<Enemy>());
    
    //set the background to be the middle of the background image
    background = backgroundImage.get( (backgroundWidth-width)/2, (backgroundHeight-height)/2, 900, 900);
    
    //make player object
    player = new Player();
    
    //set new cursor color
    mouse = loadImage("mouse.png");
    cursor(mouse, mouse.width/2, mouse.height/2);
    
  }
  
  
  //spawn in new enemy on the sides. Note only 1 of each time can be spawned per frame
  private void spawnEnemy(){
    
    //increase the number of enemies that spawn if score gets high
    if(score > 15){
      maxRammers = 6;
    }
    if(score > 25){
      maxTrappers = 3;
    }
    if(score > 35){
      maxShooters = 3;
    }
    
    //check if any list has less than an arburtrary number of enemies to see if more need to be added
    if(enemies.get("rammer").size() < maxRammers){
      //get random coordinates along one of the sides
      PVector randomCoordinates = randomCoordinateSide();
      Rammer rammer = new Rammer( player.getPosition(), randomCoordinates);
      //if the players score is higher, increase the speed of the rammer
      if(score > 15){
        rammer.speed *= 1.2;
        rammer.maxAcceleration *= 1.2;
      }
      enemies.get("rammer").add( rammer );
    }
    //check if any list has less than an arburtrary number of enemies to see if more need to be added
    if(enemies.get("shooter").size() < maxShooters){
      //get random coordinates along one of the sides
      PVector randomCoordinates = randomCoordinateSide();
      Shooter shooter = new Shooter( player.getPosition(), randomCoordinates);
      if(score > 50){
        shooter.gunCooldown /= 1.2;
      }
      if(score > 25){
        shooter.speed *= 1.2;
        shooter.maxAcceleration *= 1.2;
      }
      enemies.get("shooter").add( shooter );
    }
    //check if any list has less than an arburtrary number of enemies to see if more need to be added
    if(enemies.get("trapper").size() < maxTrappers){
      PVector randomCoordinates = randomCoordinateSide();
      Trapper trapper = new Trapper( player.getPosition(), randomCoordinates);
      if(score > 40){
        trapper.gunCooldown /= 1.2;
      }
      if(score > 20){
        trapper.speed *= 1.2;
        trapper.maxAcceleration *= 1.2;
      }
      enemies.get("trapper").add(trapper);
    }
    //check if score is high enough and a boss hasn't already been spawned
    if(score > 25 && !bossSpawned){
      PVector randomCoordinates = randomCoordinateSide();
      Boss boss = new Boss(player.getPosition(), randomCoordinates);
      enemies.get("boss").add(boss);
      bossSpawned = true;
    }
  }
  
  
  //get random coords along 1 of the 4 sides
  private PVector randomCoordinateSide(){
    float xCoord;
    float yCoord;
    float margin = 150;  //a bit on the sides to make the enemy not visible when it spawns in
    
    //randomly pick one of the 4 sides to spawn on
    int side = java.util.concurrent.ThreadLocalRandom.current().nextInt(0, 5);  //gives between 0 and 4 inclusive
    
    //randomly find value between 0(inclusive) and 1(exclusive) to multiply with width/height to find random coord on an axis
    float randomFloat = java.util.concurrent.ThreadLocalRandom.current().nextFloat();
    
    //left side
    if(side == 0){ 
      xCoord = -margin;
      yCoord = randomFloat * backgroundHeight;
    }
    //top side
    else if(side == 1){
      xCoord = randomFloat * backgroundWidth;
      yCoord = -margin;
    }
    //right side
    else if(side == 2){
      xCoord = backgroundWidth + margin;
      yCoord = randomFloat * backgroundHeight;
    }
    //bottom side
    else{  // if(side == 3  or random is bad  ){
      xCoord = randomFloat * backgroundWidth;
      yCoord = backgroundHeight + margin;
    }
    
    PVector randomPosition = new PVector(xCoord, yCoord);
    return randomPosition;
  }
  
  
  //calculate all movement, collisions, and display new positions
  private void displayGame(){
    
    //move all objects
    player.move();
    background = backgroundImage.get((int)player.playerPosition.x - width/2, (int)player.playerPosition.y - height/2, 900, 900);
    background(background); 
    
    //cool weapons and move the projectiles (also draws them)
    player.coolWeapons();
    player.moveWeapons();
    
    //check collisions with player, playerProjectiles, enemy, and enemy projectiles. also draws enemy
    checkCollisions();
    
    //move enemy weapons and draw
    moveEnemyWeapons();
    drawPowerups();
    player.drawPlayer();
    drawPlayerLives();
  }
  
  
  //check player collisions with enemys and their projectiles
  private void checkCollisions(){
    
    //check collisions with powerups. if touching then activate the powerup
    for(Powerup powerup : new HashSet<Powerup>(powerups)){
      if(powerup.touchingPlayer()){
        powerup.activatePowerup();
        powerups.remove(powerup);
      }
    }
        
    //check collisions with enemy objects
    
    //check player collisions with all enemy bullets
    for(EnemyProjectile enemyBullet : new HashSet<EnemyProjectile>(enemyBullets)){
      
      //store variables for collision detection cus square roots are expensive
      float xDistanceBetween = enemyBullet.getPosition().x - player.getPosition().x;
      float yDistanceBetween = enemyBullet.getPosition().y - player.getPosition().y;
      float totalHitboxDistance = enemyBullet.getHitbox() + player.getHitbox();
      
      if( (xDistanceBetween * xDistanceBetween) + (yDistanceBetween * yDistanceBetween) < totalHitboxDistance*totalHitboxDistance ){
        enemyBullets.remove(enemyBullet);
        player.takeDamage();
      }
    }
    
    
    //check player collisions with all enemy mines
    for(EnemyMine enemyMine : new HashSet<EnemyMine>(enemyMines)){
      
      //store variables for collision detection cus square roots are expensive
      float xDistanceBetween = enemyMine.getPosition().x - player.getPosition().x;
      float yDistanceBetween = enemyMine.getPosition().y - player.getPosition().y;
      float totalHitboxDistance = enemyMine.getHitbox() + player.getHitbox();
      
      if((xDistanceBetween * xDistanceBetween) + (yDistanceBetween * yDistanceBetween) < totalHitboxDistance*totalHitboxDistance){
        enemyMines.remove(enemyMine);
        player.takeDamage();
      }
    }
    

    //move enemies, check player collisions with enemies. check enemy collisions with player weapons
    for(HashSet<Enemy> enemyType : enemies.values()){
      for(Enemy enemy : new HashSet<Enemy>(enemyType)){
        
        //move and draw enemy
        enemy.move(player.getPosition());
        enemy.redraw();
        
        //if enemy is destroyed then all missiles need to be checked to find new target
        boolean checkMissileTarget = false;
        
        //if enemy is touching player, delete the enemy, make lives decrease, and check if game over
        if(enemy.touchingPlayer()){
          //remove enemy if its not the boss
          if(!(enemy instanceof Boss)){
            enemyType.remove(enemy);
          }
          checkMissileTarget = true;
          player.takeDamage();
        }
        
        //check if enemy touching bullet
        PlayerProjectile bullet = enemy.touchingBullet();
        if (bullet != null){
          
          //if enemy is rammer then reduce its health and only remove if has no health
          if(enemy instanceof Rammer ){
            if( ((Rammer)enemy).takeHit() ){
              enemyType.remove(enemy);
              enemy.dropPowerup();
              score += enemy.getPoints();   //increment the player's score by point worth of enemy
            }
          }
          //else if boss then reduce its health and only remove if has no health
          else if(enemy instanceof Boss){
            if( ((Boss)enemy).takeHit()){
              enemyType.remove(enemy);
              enemy.dropPowerup();
              score += enemy.getPoints();   //increment the player's score by point worth of enemy
              
              //spawn in some other enemies when he dies from his position
              for(int i = 0; i < bossEggs; i ++){
                Rammer rammer = new Rammer(player.getPosition(), enemy.getPosition());
                rammer.speed *= 1.2;
                rammer.maxAcceleration *= 1.2;
                enemies.get("rammer").add(rammer);
              }
            }
          }
          //otherwise not rammer so instantly remove
          else{
            enemyType.remove(enemy);
            enemy.dropPowerup();
            score += enemy.getPoints();   //increment the player's score by point worth of enemy
          }
          checkMissileTarget = true;
          player.removeBullet(bullet);
        }
        
        //check enemy touching missile
        PlayerMissile missile = enemy.touchingMissile();
        if(missile != null){
          //if enemy is rammer then reduce its health and only remove if has no health
          if(enemy instanceof Rammer ){
            if( ((Rammer)enemy).takeHit() ){
              enemyType.remove(enemy);
              enemy.dropPowerup();
              score += enemy.getPoints();   //increment the player's score by point worth of enemy
            }
          }
          //else if boss then reduce its health and only remove if has no health
          else if(enemy instanceof Boss){
            if( ((Boss)enemy).takeHit()){
              enemyType.remove(enemy);
              enemy.dropPowerup();
              score += enemy.getPoints();   //increment the player's score by point worth of enemy
              
              //spawn in some rammers when he dies from his position
              for(int i = 0; i < bossEggs; i ++){
                Rammer rammer = new Rammer(player.getPosition(), enemy.getPosition());
                rammer.speed *= 1.2;
                rammer.maxAcceleration *= 1.2;
                enemies.get("rammer").add(rammer);
              }
            }
          }
          //otherwise not rammer so instantly remove
          else{
            enemyType.remove(enemy);
            enemy.dropPowerup();
            score += enemy.getPoints();   //increment the player's score by point worth of enemy
          }
          checkMissileTarget = true;
          player.removeMissile(missile);
        }
        
        //if enemy was destroyed, make sure any missiles that were targeting it don't anymore
        if(checkMissileTarget){ checkMissileTargets(enemy); }
        
        
      }  //-end enemys objs in enemytype set
    }  //-end enemy type set
  }  //-end method
  
  
  //check all missiles that are targeting a given enemy to target something else
  public void checkMissileTargets(Enemy enemy){
    for(PlayerMissile missile : player.getMissiles()){
      if(missile.target == enemy){
        missile.clearTarget();
      }
    }
  }
  
  
  //move and draw all enemy weapons
  private void moveEnemyWeapons(){
    
    //move and draw bullets
    for(EnemyProjectile bullet : enemyBullets){
      
      bullet.moveBullet(player.getPosition());
      bullet.drawBullet();
    }
    
    //draw mines
    for(EnemyMine mine : new HashSet<EnemyMine>(enemyMines)){
      //if the mine has been onscreen for its whole life, remove it
      if(mine.checkLife()){enemyMines.remove(mine);}
      else{
        mine.drawMine(player.getPosition());
      }
    }
    
  }
  
  
  //draws powerups
  private void drawPowerups(){
    for(Powerup powerup : powerups){
      powerup.redraw();
    }
  }
  
  
  //draws the players lives at the bottom left of screen
  private void drawPlayerLives(){
    pushMatrix();
    scale(0.5, 0.5);
    for(int i = 0; i < lives.size(); i ++){
      PImage icon = lives.get(i);
      image(icon, (icon.width + 10) * i + icon.width, height*2 - 10 - icon.height);
    }
    popMatrix();
    
    textFont(font, 60);
    text("Lives", 60, height - 120);
    
    textAlign(LEFT, CENTER);
    text("Score: " + score , 10, height - 240);
    textAlign(CENTER, CENTER);
  }
  
  
  //boolean if at max lives or not
  public boolean atMaxLives(){
    return (lives.size() == maxLives);
  }
  
  //adds an extra life (from powerups). max l
  public void addLife(){
    lives.add(loadImage("player.png"));
  }
  
  
  //check if the player has made input
  public void checkInput(){
    
    //if mouse pressed then shoot guns
    if(mousePressed){
      player.fireGuns();
    }
    
    //check for keyboard input
    if(keyPressed){
      
      //if spacebar pressed then shoot missile
      if(key == ' '){
        player.fireMissile();
      }
    }
  }
  
  
  //return the map of all enemies
  public Map<String, HashSet<Enemy>> getEnemies(){
    return enemies;
  }
}
