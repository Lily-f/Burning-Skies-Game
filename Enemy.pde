//interface for all enemy types. 
public interface Enemy{
  
  public void move(PVector playerPos);
  public boolean touchingPlayer();
  public void redraw();
  public PVector getPosition();
  public PlayerProjectile touchingBullet();
  public PlayerMissile touchingMissile();
  public int getPoints();
  public void dropPowerup();
}
