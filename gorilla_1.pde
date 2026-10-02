// 고릴라: 마우스를 누르면 두 발로 일어나 가슴을 두드림 (Processing 4, Java 모드)
// 평소에는 네 발로 서 있고, 클릭하면 일어서기 -> 가슴 두드리기 -> 다시 내려오기

color FUR      = color(45, 45, 50);    // 몸통 털
color FUR_NEAR = color(62, 62, 68);    // 가까운 쪽 팔다리 (몸통 위에서도 보이도록 조금 밝게)
color FUR_FAR  = color(28, 28, 32);    // 먼 쪽 팔다리
color SILVER   = color(150, 150, 155); // 등의 은빛 털
color SKIN     = color(75, 72, 72);    // 얼굴, 손발

// 상태: 0 = 네 발, 1 = 일어서는 중, 2 = 가슴 두드리는 중, 3 = 내려오는 중
int state = 0;
float t = 0;            // 0 = 네 발 자세, 1 = 두 발 자세
float e = 0;            // t를 부드럽게 만든 값 (모든 좌표 보간에 사용)
int beatStart = 0;      // 두드리기 시작한 프레임

final float RISE_SPEED  = 0.04;  // 일어서는 속도
final int   BEAT_FRAMES = 150;   // 두드리는 시간 (60프레임 = 1초)
final float BEAT_SPEED  = 0.45;  // 두드리는 빠르기

void setup() {
  size(600, 400);
  frameRate(60);
}

void mousePressed() {
  if (state == 0) state = 1;     // 네 발로 서 있을 때만 시작
}

void draw() {
  updateState();
  e = t * t * (3 - 2 * t);       // 부드러운 가속/감속
  drawBackground();
  drawGorilla();
}

void updateState() {
  if (state == 1) {
    t += RISE_SPEED;
    if (t >= 1) { t = 1; state = 2; beatStart = frameCount; }
  } else if (state == 2) {
    if (frameCount - beatStart > BEAT_FRAMES) state = 3;
  } else if (state == 3) {
    t -= RISE_SPEED;
    if (t <= 0) { t = 0; state = 0; }
  }
}

// 네 발 자세 값 a 와 두 발 자세 값 b 사이를 보간
float mix(float a, float b) {
  return lerp(a, b, e);
}

void drawBackground() {
  background(190, 225, 200);
  noStroke();
  fill(120, 175, 120);
  ellipse(120, 300, 360, 220);
  ellipse(480, 310, 420, 200);
  fill(85, 140, 80);
  rect(0, 315, width, 85);
  fill(0, 40);                                   // 그림자
  ellipse(mix(310, 245), 322, mix(330, 190), 24);
}

void drawGorilla() {
  // 주요 관절 위치 (네 발 자세 -> 두 발 자세)
  float hipX = mix(215, 230), hipY = mix(250, 235);
  float shX  = mix(375, 255), shY  = mix(185, 105);
  float hdX  = mix(455, 290), hdY  = mix(165, 65);

  // 가슴 두드리기: 양팔이 번갈아 가슴을 침 (0 = 가슴에 닿음, 1 = 가장 멀리)
  float phase = (frameCount - beatStart) * BEAT_SPEED;
  float beatNear = max(0, sin(phase));
  float beatFar  = max(0, -sin(phase));

  // 1) 먼 쪽 팔다리 (몸통 뒤)
  drawLimb(mix(235, 250), mix(245, 240), mix(245, 262), mix(285, 280),
           mix(240, 250), 312, 34, FUR_FAR);
  float fhx = mix(420, lerp(328, 378, beatFar));
  float fhy = mix(312, lerp(150, 125, beatFar));
  drawLimb(mix(410, 280), mix(195, 120), mix(425, 345), mix(265, 175),
           fhx, fhy, 36, FUR_FAR);
  noStroke();
  fill(FUR_FAR);
  ellipse(mix(250, 262), 315, 60, 18);           // 먼 쪽 뒷발
  fill(SKIN);
  ellipse(fhx + mix(5, 0), fhy + mix(3, 0), mix(44, 30), mix(18, 30));  // 먼 쪽 주먹

  // 2) 몸통: 엉덩이와 어깨를 잇는 타원
  float ang = atan2(shY - hipY, shX - hipX);
  float len = dist(hipX, hipY, shX, shY) + 100;
  noStroke();
  fill(FUR);
  pushMatrix();
  translate((hipX + shX) / 2, (hipY + shY) / 2);
  rotate(ang);
  ellipse(0, 0, len, 150);
  fill(SILVER);                                  // 실버백 (등 쪽)
  ellipse(-20, -48, len * 0.5, 40);
  popMatrix();

  fill(FUR);
  ellipse(shX, shY, 130, 130);                   // 어깨 근육
  ellipse(hipX, hipY, 95, 110);                  // 엉덩이

  // 3) 머리
  drawHead(hdX, hdY);

  // 4) 가까운 쪽 다리
  drawLimb(mix(210, 230), mix(265, 245), mix(200, 238), mix(295, 282),
           mix(205, 218), 312, 38, FUR_NEAR);
  noStroke();
  fill(SKIN);
  ellipse(mix(215, 228), 316, 70, 20);           // 뒷발

  // 5) 가까운 쪽 팔 (가장 앞)
  float nhx = mix(388, lerp(300, 350, beatNear));
  float nhy = mix(312, lerp(150, 135, beatNear));
  drawLimb(mix(385, 265), mix(200, 125), mix(398, 305), mix(268, 185),
           nhx, nhy, 42, FUR_NEAR);
  noStroke();
  fill(SKIN);
  ellipse(nhx + mix(4, 0), nhy + mix(4, 0), mix(50, 32), mix(20, 32));  // 주먹
}

void drawHead(float x, float y) {
  noStroke();
  fill(FUR);
  ellipse(x - 5, y - 43, 60, 55);                // 정수리 볏
  ellipse(x, y, 95, 105);                        // 머리
  fill(SKIN);
  ellipse(x - 35, y + 3, 18, 24);                // 귀
  ellipse(x + 21, y + 13, 62, 72);               // 얼굴
  fill(FUR_FAR);
  rect(x - 3, y - 15, 52, 13, 6);                // 눈썹뼈

  fill(255);                                     // 눈
  ellipse(x + 13, y + 3, 9, 9);
  ellipse(x + 35, y + 3, 9, 9);
  fill(0);
  ellipse(x + 14, y + 3, 4, 4);
  ellipse(x + 36, y + 3, 4, 4);

  fill(25);                                      // 콧구멍
  ellipse(x + 21, y + 22, 7, 5);
  ellipse(x + 34, y + 22, 7, 5);

  if (state == 2) {                              // 두드릴 때는 입을 벌림
    fill(120, 30, 30);
    ellipse(x + 26, y + 37, 26, 14);
  } else {
    stroke(25);
    strokeWeight(2);
    line(x + 11, y + 36, x + 41, y + 36);
  }
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
