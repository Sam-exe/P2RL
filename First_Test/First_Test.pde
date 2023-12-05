import controlP5.*;

int cols = 32;
int rows = 32;
float[][] terrain;
PImage[] images; // Array to store multiple images
int currentImageIndex = 0; // Index to track the current image
int scl = 25;
ControlP5 cp5;
int v1,v2,v3,v4,v5;
boolean v6;
boolean actionEnabled = true; // Flag to toggle mouse-controlled rotation on/off
float initialRotateX = 0, initialRotateY = 0; // To store initial rotation values

void setup() {
  size(800, 800, P3D);
  
  // Load multiple images into an array
  String[] imageNames = {
    "test3.png", "test.png", "test2.png","test4.png" // Add your image filenames here
  };
  images = new PImage[imageNames.length];
  for (int i = 0; i < imageNames.length; i++) {
    images[i] = loadImage(imageNames[i]);
    images[i].resize(cols, rows);
  }
  
  cp5 = new ControlP5(this);
  cp5.addSlider("v1")
     .setPosition(40, 60)
     .setSize(200,50)
     .setRange(100, 300)
     .setValue(250)
     .setColorCaptionLabel(color(20, 20, 20));
   cp5.addSlider("v2")
     .setPosition(40, 100)
     .setSize(200, 50)
     .setRange(100, 1000)
     .setValue(255)
     .setColorCaptionLabel(color(20, 20, 20));     
   cp5.addSlider("v3")
     .setPosition(40, 140)
     .setSize(200, 50)
     .setRange(-1, 2)
     .setValue(0)
     .setColorCaptionLabel(color(20, 20, 20));
   cp5.addSlider("v4")
     .setPosition(40, 180)
     .setSize(200, 50)
     .setRange(-1, 2)
     .setValue(0)
     .setColorCaptionLabel(color(20, 20, 20));
    cp5.addSlider("v5")
     .setPosition(40, 220)
     .setSize(200, 50)
     .setRange(-10, 10)
     .setValue(1)
     .setColorCaptionLabel(color(20, 20, 20));
    cp5.addButton("v6")
     .setPosition(40, 250)
     .setSize(200, 50)
     .setColorCaptionLabel(color(20, 20, 20));
  stroke(0, 0, 0);
  textureMode(NORMAL);
}

void draw() {
  background(0);
  terrain = new float[cols][rows];
  images[currentImageIndex].loadPixels();
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      int loc = x + y * cols;
      float b = brightness(int(images[currentImageIndex].pixels[loc]*v4));
      terrain[x][y] = map(b, v3, v2, -200, v1); // Adjusted height range for colors
    }
  }
  
  // Draw GUI elements (slider)
  cp5.draw();
  
  // Apply transformations for the terrain
  push();
  translate(width / 2, height / 2);
  if (actionEnabled) {
    float rotX = map(mouseY, 0, height, -HALF_PI, HALF_PI);
    float rotY = map(mouseX, 0, width, -PI, PI);
    
    rotateX(rotX);
    rotateY(rotY);
  } else {
    rotateX(initialRotateX); // Reset to initial X rotation
    rotateY(initialRotateY); // Reset to initial Y rotation
  }
  
  scale(1);
  translate(-cols * scl / 2, -rows * scl / 2); 
  // Drawing the terrain
  for (int y = 0; y < rows - 1; y++) {
    beginShape(TRIANGLE_STRIP);
    texture(images[currentImageIndex]);
    for (int x = 0; x < cols; x++) {
      float u = map(x, 0, cols - 1, 0, 1);
      float v1 = map(y, 0, rows - 1, 0, 1);
      float v2 = map(y + 1, 0, rows - 1, 0, 1);

      float h1 = terrain[x][y];
      float h2 = terrain[x][y + 1];

      vertex(x * scl, y * scl, h1, u, v1);
      vertex(x * scl, (y + 1) * scl, h2, u, v2);
    }
    endShape();
  }

  // Draw vertices as points
  stroke(255);
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      float h = terrain[x][y];
      point(x * scl, y * scl, h);
    }
  }
  pop();
}

void keyPressed() {
  if (key == TAB) {
    // Toggle action on/off
    actionEnabled = !actionEnabled;
    if (!actionEnabled) {
      initialRotateX = map(mouseY, 0, height, -HALF_PI, HALF_PI); // Store current X rotation
      initialRotateY = map(mouseX, 0, width, -PI, PI); // Store current Y rotation
    }
  } else if (key == ' '||v6) { // Press spacebar to switch to the next image
    currentImageIndex = (currentImageIndex + 1) % images.length;
  }
}
