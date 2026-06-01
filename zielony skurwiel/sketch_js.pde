// Trailer Park Boys: The Green Bastard vs Ricky (p5.js Web Edition)

let themeMusic;
let ricky, greenBastard;
let gameOver = false;
let winnerName = "";

// Key buffering arrays
let keyA = false, keyD = false, keyW = false, keyS = false, keyF = false;
let keyLeft = false, keyRight = false, keyUp = false, keyDown = false, keyP = false;

function preload() {
  // Przeglądarka załaduje plik z tego samego folderu
  try {
    soundFormats('mp3');
    themeMusic = loadSound('theme.mp3');
  } catch(e) {
    console.log("Audio load failed or blocked by browser policy.");
  }
}

class Fighter {
  constructor(startX, startY, n) {
    this.x = startX;
    this.y = startY;
    this.vx = 0;
    this.vy = 0;
    this.w = 90;
    this.h = 140;
    this.hp = 100;
    this.isJumping = false;
    this.isCrouching = false;
    this.isAttacking = false;
    this.attackTimer = 0;
    this.direction = 1;
    this.name = n;
  }
  
  update() {
    this.x += this.vx;
    this.y += this.vy;
    
    if (this.y < 400) {
      this.vy += 0.6;
      this.isJumping = true;
    } else {
      this.y = 400;
      this.vy = 0;
      this.isJumping = false;
    }
    
    this.x = constrain(this.x, 0, width - this.w);
    
    if (this.isAttacking) {
      this.attackTimer--;
      if (this.attackTimer <= 0) this.isAttacking = false;
    }
  }
  
  display() {
    push();
    translate(this.x + this.w/2, this.y + this.h/2);
    scale(this.direction, 1);
    
    let currentH = this.isCrouching ? this.h * 0.6 : this.h;
    let offsetCrouch = this.isCrouching ? this.h * 0.2 : 0;
    
    strokeWeight(4);
    
    if (this.name === "Ricky") {
      // Ricky
      fill(20); noStroke();
      rect(-25, offsetCrouch - 75, 45, 25, 10);
      stroke(0); fill(255, 224, 189);
      ellipse(0, offsetCrouch - 50, 40, 40);
      fill(50); noStroke();
      rect(-20, offsetCrouch - 55, 6, 15);
      rect(-10, offsetCrouch - 40, 20, 5);
      stroke(0); fill(240);
      rect(-15, offsetCrouch - 30, 30, 50, 5);
      stroke(40); strokeWeight(2);
      line(-15, offsetCrouch - 10, 15, offsetCrouch - 10);
      line(-15, offsetCrouch + 10, 15, offsetCrouch + 10);
      stroke(0); strokeWeight(4); fill(30);
      rect(-15, offsetCrouch + 20, 12, currentH - 70);
      rect(3, offsetCrouch + 20, 12, currentH - 70);
      stroke(255); strokeWeight(3);
      line(10, offsetCrouch - 42, 22, offsetCrouch - 42);
      stroke(255, 100, 0); point(23, offsetCrouch - 42);
      stroke(0); strokeWeight(4);
      if (this.isAttacking) line(10, offsetCrouch - 10, 45, offsetCrouch - 10);
      else {
        line(-15, offsetCrouch - 10, -25, offsetCrouch + 10);
        line(15, offsetCrouch - 10, 25, offsetCrouch + 10);
      }
    } else {
      // Green Bastard
      stroke(0); fill(46, 139, 87);
      ellipse(0, offsetCrouch - 50, 44, 46);
      fill(255, 255, 255, 180); stroke(139, 69, 19); strokeWeight(3);
      ellipse(-10, offsetCrouch - 52, 18, 18);
      ellipse(10, offsetCrouch - 52, 18, 18);
      line(-2, offsetCrouch - 52, 2, offsetCrouch - 52);
      fill(0); noStroke();
      ellipse(-10, offsetCrouch - 52, 4, 4); ellipse(10, offsetCrouch - 52, 4, 4);
      stroke(0); strokeWeight(4); fill(34, 139, 34);
      rect(-16, offsetCrouch - 27, 32, 48, 4);
      fill(148, 0, 211); rect(-16, offsetCrouch + 10, 32, 12);
      fill(255, 224, 189);
      rect(-13, offsetCrouch + 22, 10, currentH - 72);
      rect(3, offsetCrouch + 22, 10, currentH - 72);
      stroke(0);
      if (this.isAttacking) line(10, offsetCrouch - 5, 48, offsetCrouch - 5);
      else {
        line(-16, offsetCrouch - 5, -28, offsetCrouch + 15);
        line(16, offsetCrouch - 5, 28, offsetCrouch + 15);
      }
    }
    
    if (this.isAttacking) {
      fill(255, 0, 0, 100); noStroke(); rectMode(CORNER);
      rect(this.w/2 - 10, offsetCrouch - 20, 40, 20);
    }
    pop();
  }
  
  attack(opponent) {
    if (!this.isAttacking) {
      this.isAttacking = true;
      this.attackTimer = 12;
      let attackRangeX = (this.direction === 1) ? (this.x + this.w) : (this.x - 40);
      let attackWidth = 40;
      let hitX = (attackRangeX + attackWidth > opponent.x) && (attackRangeX < opponent.x + opponent.w);
      let hitY = (this.y + this.h > opponent.y) && (this.y < opponent.y + opponent.h);
      if (hitX && hitY && !opponent.isCrouching) {
        opponent.hp -= 10;
        if (opponent.hp < 0) opponent.hp = 0;
      }
    }
  }
}

function setup() {
  let canvas = createCanvas(800, 600);
  // Odpalenie audio po kliknięciu (wymóg przeglądarek)
  canvas.mousePressed(startAudio);
  initGame();
}

function initGame() {
  ricky = new Fighter(150, 400, "Ricky");
  greenBastard = new Fighter(550, 400, "Zielony Skurwiel");
  gameOver = false;
}

function startAudio() {
  if (themeMusic && !themeMusic.isPlaying()) {
    themeMusic.loop();
  }
}

function draw() {
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

function handleInputs() {
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

function drawUI() {
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

function keyPressed() {
  if (gameOver && keyCode === ENTER) { initGame(); return; }
  if (key === 'a' || key === 'A') keyA = true; if (key === 'd' || key === 'D') keyD = true;
  if (key === 'w' || key === 'W') keyW = true; if (key === 's' || key === 'S') keyS = true;
  if (key === 'f' || key === 'F') keyF = true;
  if (keyCode === LEFT_ARROW) keyLeft = true; if (keyCode === RIGHT_ARROW) keyRight = true;
  if (keyCode === UP_ARROW) keyUp = true; if (keyCode === DOWN_ARROW) keyDown = true;
  if (key === 'p' || key === 'P') keyP = true;
}

function keyReleased() {
  if (key === 'a' || key === 'A') keyA = false; if (key === 'd' || key === 'D') keyD = false;
  if (key === 'w' || key === 'W') keyW = false; if (key === 's' || key === 'S') keyS = false;
  if (key === 'f' || key === 'F') keyF = false;
  if (keyCode === LEFT_ARROW) keyLeft = false; if (keyCode === RIGHT_ARROW) keyRight = false;
  if (keyCode === UP_ARROW) keyUp = false; if (keyCode === DOWN_ARROW) keyDown = false;
  if (key === 'p' || key === 'P') keyP = false;
}
