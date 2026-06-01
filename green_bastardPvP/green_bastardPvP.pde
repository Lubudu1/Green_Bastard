// Trailer Park Boys: The Green Bastard vs Ricky (PvP Fight)
// PLAYER 1 (Ricky): W/A/S/D | F to Attack
// PLAYER 2 (Green Bastard): ARROWS | P to Attack

import processing.sound.*;

SoundFile themeMusic;

class Fighter {
  float x, y;
  float vx, vy;
  float w = 90, h = 140;
  int hp = 100;
  boolean isJumping = false;
  boolean isCrouching = false;
  boolean isAttacking = false;
  int attackTimer = 0;
  int direction = 1; // 1 = right, -1 = left
  String name;
  
  Fighter(float startX, float startY, String n) {
    x = startX;
    y = startY;
    name = n;
  }
  
  void update() {
    x += vx;
    y += vy;
    
    // Gravity physics
    if (y < 400) {
      vy += 0.6;
      isJumping = true;
    } else {
      y = 400;
      vy = 0;
      isJumping = false;
    }
    
    x = constrain(x, 0, width - w);
    
    if (isAttacking) {
      attackTimer--;
      if (attackTimer <= 0) isAttacking = false;
    }
  }
  
  void display() {
    pushMatrix();
    translate(x + w/2, y + h/2);
    scale(direction, 1);
    
    float currentH = isCrouching ? h * 0.6 : h;
    float offsetCrouch = isCrouching ? h * 0.2 : 0;
    
    strokeWeight(4);
    
    if (name.equals("Ricky")) {
      // Ricky Model
      fill(20); noStroke();
      rect(-25, offsetCrouch - 75, 45, 25, 10); // Hair
      stroke(0); fill(255, 224, 189);
      ellipse(0, offsetCrouch - 50, 40, 40); // Head
      fill(50); noStroke();
      rect(-20, offsetCrouch - 55, 6, 15); // Sideburns
      rect(-10, offsetCrouch - 40, 20, 5);  // Mustache
      stroke(0); fill(240);
      rect(-15, offsetCrouch - 30, 30, 50, 5); // Shirt
      stroke(40); strokeWeight(2);
      line(-15, offsetCrouch - 10, 15, offsetCrouch - 10);
      line(-15, offsetCrouch + 10, 15, offsetCrouch + 10);
      stroke(0); strokeWeight(4); fill(30);
      rect(-15, offsetCrouch + 20, 12, currentH - 70); // Pants
      rect(3, offsetCrouch + 20, 12, currentH - 70);
      stroke(255); strokeWeight(3);
      line(10, offsetCrouch - 42, 22, offsetCrouch - 42); // Cigarette
      stroke(255, 100, 0); point(23, offsetCrouch - 42);
      stroke(0); strokeWeight(4);
      if (isAttacking) line(10, offsetCrouch - 10, 45, offsetCrouch - 10);
      else {
        line(-15, offsetCrouch - 10, -25, offsetCrouch + 10);
        line(15, offsetCrouch - 10, 25, offsetCrouch + 10);
      }
    } else {
      // Green Bastard Model
      stroke(0); fill(46, 139, 87);
      ellipse(0, offsetCrouch - 50, 44, 46); // Mask
      fill(255, 255, 255, 180); stroke(139, 69, 19); strokeWeight(3);
      ellipse(-10, offsetCrouch - 52, 18, 18); // Glasses
      ellipse(10, offsetCrouch - 52, 18, 18);
      line(-2, offsetCrouch - 52, 2, offsetCrouch - 52);
      fill(0); noStroke();
      ellipse(-10, offsetCrouch - 52, 4, 4); ellipse(10, offsetCrouch - 52, 4, 4);
      stroke(0); strokeWeight(4); fill(34, 139, 34);
      rect(-16, offsetCrouch - 27, 32, 48, 4); // Suit
      fill(148, 0, 211); rect(-16, offsetCrouch + 10, 32, 12); // Trunks
      fill(255, 224, 189);
      rect(-13, offsetCrouch + 22, 10, currentH - 72); // Legs
      rect(3, offsetCrouch + 22, 10, currentH - 72);
      stroke(0);
      if (isAttacking) line(10, offsetCrouch - 5, 48, offsetCrouch - 5);
      else {
        line(-16, offsetCrouch - 5, -28, offsetCrouch + 15);
        line(16, offsetCrouch - 5, 28, offsetCrouch + 15);
      }
    }
    
    if (isAttacking) {
      fill(255, 0, 0, 100); noStroke(); rectMode(CORNER);
      rect(w/2 - 10, offsetCrouch - 20, 40, 20); // Range
    }
    popMatrix();
  }
  
  void attack(Fighter opponent) {
    if (!isAttacking) {
      isAttacking = true;
      attackTimer = 12;
      float attackRangeX = (direction == 1) ? (x + w) : (x - 40);
      float attackWidth = 40;
      boolean hitX = (attackRangeX + attackWidth > opponent.x) && (attackRangeX < opponent.x + opponent.w);
      boolean hitY = (y + h > opponent.y) && (y < opponent.y + opponent.h);
      if (hitX && hitY && !opponent.isCrouching) {
        opponent.hp -= 10;
        if (opponent.hp < 0) opponent.hp = 0;
      }
    }
  }
}

Fighter ricky; Fighter greenBastard;
boolean gameOver = false; String winnerName = "";

boolean keyA = false, keyD = false, keyW = false, keyS = false, keyF = false;
boolean keyLeft = false, keyRight = false, keyUp = false, keyDown = false, keyP = false;

void setup() {
  size(800, 600);
  initGame();
  try {
    themeMusic = new SoundFile(this, "C:\\Users\\Student\\Downloads\\Trailer Park Boys theme.mp3");
    themeMusic.loop();
  } catch (Exception e) {
    println("Warning: Audio file missing or unreadable. Running without sound.");
  }
}

void initGame() {
  ricky = new Fighter(150, 400, "Ricky");
  greenBastard = new Fighter(550, 400, "Zielony Skurwiel");
  gameOver = false;
}

void draw() {
  background(120, 145, 120); 
  fill(70); noStroke(); rect(0, 540, width, 60);
  
  if (!gameOver) {
    handleInputs();
    ricky.update();
    greenBastard.update();
    ricky.direction = (ricky.x < greenBastard.x) ? 1 : -1;
    greenBastard.direction = (greenBastard.x < ricky.x) ? 1 : -1;
    if (ricky.hp <= 0) { gameOver = true; winnerName = greenBastard.name; }
    else if (greenBastard.hp <= 0) { gameOver = true; winnerName = ricky.name; }
  }
  ricky.display(); greenBastard.display();
  drawUI();
}

void handleInputs() {
  if (keyA && !ricky.isCrouching) ricky.vx = -4;
  else if (keyD && !ricky.isCrouching) ricky.vx = 4;
  else ricky.vx = 0;
  if (keyW && !ricky.isJumping && !ricky.isCrouching) ricky.vy = -13;
  ricky.isCrouching = (keyS && !ricky.isJumping);
  if (keyF) ricky.attack(greenBastard);

  if (keyLeft && !greenBastard.isCrouching) greenBastard.vx = -4;
  else if (keyRight && !greenBastard.isCrouching) greenBastard.vx = 4;
  else greenBastard.vx = 0;
  if (keyUp && !greenBastard.isJumping && !greenBastard.isCrouching) greenBastard.vy = -13;
  greenBastard.isCrouching = (keyDown && !greenBastard.isJumping);
  if (keyP) greenBastard.attack(ricky);
}

void drawUI() {
  fill(50); rect(40, 30, 250, 25, 5); fill(46, 204, 113);
  rect(40, 30, map(ricky.hp, 0, 100, 0, 250), 25, 5);
  fill(255); textSize(16); textAlign(LEFT, CENTER); text(ricky.name + " (P1: WASD + F)", 45, 15);
  
  fill(50); rect(width - 290, 30, 250, 25, 5); fill(231, 76, 60);
  rect(width - 290, 30, map(greenBastard.hp, 0, 100, 0, 250), 25, 5);
  fill(255); textAlign(RIGHT, CENTER); text(greenBastard.name + " (P2: Arrows + P)", width - 45, 15);
  
  if (gameOver) {
    fill(0, 0, 0, 190); rect(0, 0, width, height);
    fill(255, 204, 0); textAlign(CENTER, CENTER); textSize(45); text("ZWYCIEZCA: " + winnerName, width / 2, height / 2 - 40);
    textSize(20); fill(255); text("Nacisnij ENTER, aby zagrac ponownie", width / 2, height / 2 + 30);
  }
}

void keyPressed() {
  if (gameOver && keyCode == ENTER) { initGame(); return; }
  if (key == 'a' || key == 'A') keyA = true; if (key == 'd' || key == 'D') keyD = true;
  if (key == 'w' || key == 'W') keyW = true; if (key == 's' || key == 'S') keyS = true;
  if (key == 'f' || key == 'F') keyF = true;
  if (keyCode == LEFT) keyLeft = true; if (keyCode == RIGHT) keyRight = true;
  if (keyCode == UP) keyUp = true; if (keyCode == DOWN) keyDown = true;
  if (key == 'p' || key == 'P') keyP = true;
}

void keyReleased() {
  if (key == 'a' || key == 'A') keyA = false; if (key == 'd' || key == 'D') keyD = false;
  if (key == 'w' || key == 'W') keyW = false; if (key == 's' || key == 'S') keyS = false;
  if (key == 'f' || key == 'F') keyF = false;
  if (keyCode == LEFT) keyLeft = false; if (keyCode == RIGHT) keyRight = false;
  if (keyCode == UP) keyUp = false; if (keyCode == DOWN) keyDown = false;
  if (key == 'p' || key == 'P') keyP = false;
}
