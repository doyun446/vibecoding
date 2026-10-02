// 네 발로 서 있는 고릴라 (Processing 4, Java 모드)
// 옆모습, 오른쪽을 바라보는 너클 보행 자세

color FUR      = color(45, 45, 50);    // 몸통 털
color FUR_FAR  = color(28, 28, 32);    // 뒤쪽(먼 쪽) 팔다리
color SILVER   = color(150, 150, 155); // 등의 은빛 털
color SKIN     = color(75, 72, 72);    // 얼굴, 손발

void setup() {
  size(600, 400);
  noLoop();   // 정지 그림이므로 한 번만 그림
}

void draw() {
  drawBackground();
  drawGorilla();
}

void drawBackground() {
  background(190, 225, 200);          // 하늘/정글 안개
  noStroke();
  fill(120, 175, 120);                // 먼 숲
  ellipse(120, 300, 360, 220);
  ellipse(480, 310, 420, 200);
  fill(85, 140, 80);                  // 땅
  rect(0, 315, width, 85);
  fill(0, 40);                        // 고릴라 그림자
  ellipse(310, 322, 330, 24);
}

void drawGorilla() {
  // 1) 먼 쪽 팔다리 (몸통 뒤에 가려지도록 먼저 그림)
  drawLimb(235, 245, 245, 285, 240, 312, 34, FUR_FAR);   // 먼 쪽 뒷다리
  drawLimb(410, 195, 425, 265, 420, 312, 36, FUR_FAR);   // 먼 쪽 앞팔
  noStroke();
  fill(FUR_FAR);
  ellipse(250, 315, 60, 18);
  ellipse(425, 315, 44, 18);

  // 2) 몸통: 어깨가 엉덩이보다 높도록 살짝 기울임
  noStroke();
  fill(FUR);
  pushMatrix();
  translate(300, 215);
  rotate(radians(-12));
  ellipse(0, 0, 270, 150);
  fill(SILVER);                        // 실버백
  ellipse(-25, -38, 150, 45);
  popMatrix();

  fill(FUR);
  ellipse(375, 180, 130, 130);         // 어깨 근육
  ellipse(215, 250, 95, 110);          // 엉덩이/허벅지

  // 3) 가까운 쪽 팔다리
  drawLimb(210, 265, 200, 295, 205, 312, 38, FUR);       // 뒷다리
  drawLimb(385, 200, 398, 268, 388, 312, 42, FUR);       // 앞팔
  noStroke();
  fill(SKIN);
  ellipse(215, 316, 70, 20);           // 뒷발
  ellipse(392, 316, 50, 20);           // 주먹(너클)

  // 4) 머리
  fill(FUR);
  ellipse(450, 122, 60, 55);           // 정수리 볏
  ellipse(455, 165, 95, 105);          // 머리
  fill(SKIN);
  ellipse(420, 168, 18, 24);           // 귀
  ellipse(476, 178, 62, 72);           // 얼굴
  fill(FUR_FAR);
  rect(452, 150, 52, 13, 6);           // 눈썹뼈

  fill(255);                           // 눈
  ellipse(468, 168, 9, 9);
  ellipse(490, 168, 9, 9);
  fill(0);
  ellipse(469, 168, 4, 4);
  ellipse(491, 168, 4, 4);

  fill(25);                            // 콧구멍
  ellipse(476, 187, 7, 5);
  ellipse(489, 187, 7, 5);

  stroke(25);                          // 입
  strokeWeight(2);
  line(466, 201, 496, 201);
}

// 어깨/엉덩이 -> 팔꿈치/무릎 -> 손/발 을 잇는 두 마디 팔다리
void drawLimb(float x1, float y1, float x2, float y2,
              float x3, float y3, float w, color c) {
  stroke(c);
  strokeWeight(w);
  strokeCap(ROUND);
  line(x1, y1, x2, y2);
  line(x2, y2, x3, y3);
}
