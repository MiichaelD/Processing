float max_distance;

void setup() {
  //size(640, 360); 
  size(displayWidth, displayHeight);
  if (surface != null) {
    surface.setResizable(true);
  }
  noStroke();
  max_distance = dist(0, 0, width, height);
}

void draw() {
  background(0);

  for(int i = 0; i <= width; i += 20) {
    for(int j = 0; j <= height; j += 20) {
      float size = dist(mouseX, mouseY, i, j);
      size = size/max_distance * 80;
      ellipse(i, j, size, size);
    }
  }
}