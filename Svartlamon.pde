import controlP5.*;
import processing.svg.*;
import java.util.Collections;
import java.util.ArrayList;
import java.io.File;

ControlP5 cp5;
ColorWheel cpFill;
ColorWheel cpBg;

int numberOfShapes;  // Dynamically set based on loaded files
int numberOfFiles = 12;    // Number of files to be exported
int shapeSize = 350;      // Used for scaling shapes
float scaleFactor;        // Scale factor for drawing shapes
float largestDimension = 0;  // Initialize the largest dimension to zero

// Global color definitions
int bgColor = color(255, 136, 38, 255);    // Default background color - Orange with full opacity
int shapeFill = color(238, 202, 239, 255); // Default shape fill color - Light purple with full opacity

PShape[] svgs;            // Array to hold SVG shapes
PGraphics pg;
PGraphics preview;

void setup() {
  size(1024, 1024);
  preview = createGraphics(1024, 1024, JAVA2D);
  cp5 = new ControlP5(this);

  File dir = new File(sketchPath("assets"));
  File[] files = dir.listFiles((File file) -> file.getName().endsWith(".svg"));
  svgs = new PShape[files.length];
  numberOfShapes = files.length;

  for (int i = 0; i < files.length; i++) {
    svgs[i] = loadShape(files[i].getAbsolutePath());
    svgs[i].disableStyle();  // Disable the SVG's own style
    float w = svgs[i].width;
    float h = svgs[i].height;
    largestDimension = max(largestDimension, max(w, h));  // Find the maximum dimension
  }

  scaleFactor = shapeSize / largestDimension;  // Set the initial scale factor

  cp5.addSlider("numberOfShapes")
    .setRange(1, numberOfShapes)
    .setValue(numberOfShapes)
    .setPosition(10, 30)
    .setSize(200, 20)
    .addListener(new ControlListener() {
    public void controlEvent(ControlEvent event) {
      updatePreview();
    }
  }
  );

  cp5.addSlider("shapeSize")
    .setRange(50, 1000)
    .setValue(shapeSize)
    .setPosition(10, 60)
    .setSize(200, 20)
    .addListener(new ControlListener() {
    public void controlEvent(ControlEvent event) {
      shapeSize = (int) event.getController().getValue();
      scaleFactor = shapeSize / largestDimension;  // Recalculate the scale factor
      updatePreview();
    }
  }
  );

  cp5.addSlider("Files")
    .setRange(1, numberOfFiles)
    .setValue(numberOfFiles)
    .setDecimalPrecision(0)
    .setPosition(10, 90)
    .setSize(200, 20);

  cpFill = cp5.addColorWheel("fillPicker")
    .setPosition(10, 130)
    .setColorValue(shapeFill)
    .addListener(new ControlListener() {
    public void controlEvent(ControlEvent event) {
      shapeFill = cpFill.getRGB(); // Update global shape fill color variable
      updatePreview(); // Update the preview whenever the color changes
    }
  }
  );

  cpBg = cp5.addColorWheel("bgPicker")
    .setPosition(220, 130)
    .setColorValue(bgColor)
    .addListener(new ControlListener() {
    public void controlEvent(ControlEvent event) {
      bgColor = cpBg.getRGB(); // Update global background color variable
      updatePreview(); // Update the preview whenever the color changes
    }
  }
  );

  cp5.addButton("Export")
    .setPosition(10, 400)
    .setSize(80, 40)
    .addListener(new ControlListener() {
    public void controlEvent(ControlEvent event) {
      exportSVGs();
    }
  }
  );

  updatePreview();
}

void draw() {
  background(bgColor);
  image(preview, 0, 0, width, height);
}

void updatePreview() {
  preview.beginDraw();
  preview.background(bgColor);  // Use the color picked from the ColorWheel for background
  preview.fill(shapeFill);      // Use the color picked from the ColorWheel for shapes fill
  preview.noStroke();

  ArrayList<Integer> indices = new ArrayList<Integer>();
  for (int i = 0; i < svgs.length; i++) indices.add(i);
  Collections.shuffle(indices);

  for (int i = 0; i < numberOfShapes; i++) {
    int idx = indices.get(i);
    float w = svgs[idx].width;
    float h = svgs[idx].height;
    float x = random(w * scaleFactor / 2, preview.width - (w * scaleFactor / 2));
    float y = random(h * scaleFactor / 2, preview.height - (h * scaleFactor / 2));
    float angle = random(TWO_PI);  // Random angle for rotation in radians

    preview.pushMatrix();  // Save the current state of the matrix
    preview.translate(x, y);  // Translate to the drawing location
    preview.rotate(angle);  // Rotate by a random angle
    preview.scale(scaleFactor);  // Scale the shape to fit the drawing area
    preview.shape(svgs[idx], -w / 2, -h / 2);  // Draw the shape centered
    preview.popMatrix();  // Restore the matrix state
  }
  preview.endDraw();
}


void exportSVGs() {
  String username = System.getProperty("user.name");
  String baseFolderPath = "/Users/" + username + "/Downloads/Svartlamoen";
  String folderPath = baseFolderPath + "-01";
  File folderDir = new File(folderPath);
  int suffix = 2;

  while (folderDir.exists()) {
    folderPath = baseFolderPath + "-" + nf(suffix++, 2);
    folderDir = new File(folderPath);
  }
  folderDir.mkdirs();

  for (int fileNum = 1; fileNum <= numberOfFiles; fileNum++) {
    String filePath = folderPath + "/output-" + nf(fileNum, 2) + ".svg";
    pg = createGraphics(1024, 1024, SVG, filePath);
    pg.beginDraw();
    pg.background(bgColor);
    pg.noStroke();
    pg.fill(shapeFill);

    ArrayList<Integer> indices = new ArrayList<Integer>();
    for (int i = 0; i < svgs.length; i++) indices.add(i);
    Collections.shuffle(indices);

    for (int i = 0; i < numberOfShapes; i++) {
      int idx = indices.get(i);
      float w = svgs[idx].width;
      float h = svgs[idx].height;
      float x = random(w * scaleFactor / 2, pg.width - (w * scaleFactor / 2));
      float y = random(h * scaleFactor / 2, pg.height - (h * scaleFactor / 2));
      float angle = random(TWO_PI);  // Random angle for rotation in radians

      pg.pushMatrix();
      pg.translate(x, y);
      pg.rotate(angle);  // Apply random rotation
      pg.scale(scaleFactor);  // Apply uniform scaling
      pg.shape(svgs[idx], -w / 2, -h / 2);
      pg.popMatrix();
    }

    pg.endDraw();
    pg.dispose();
  }
}
