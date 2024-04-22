import controlP5.*;
import processing.svg.*;
import java.util.Collections;
import java.util.ArrayList;
import java.io.File;

ControlP5 cp5;
ColorWheel cpFill;
ColorWheel cpBg;

// Initialize default colors
int bgColor = color(255, 136, 38, 255);    // Default background color - Orange with some transparency
int shapeFill = color(238, 202, 239, 255);  // Default shape fill color - Same as background

// Variables
int numberOfShapes = 78;  // Dynamic number of shapes to draw per SVG, easily adjustable
int numberOfFiles = 12;    // Number of files to be exported
int shapeSize = 100;      // Size of Shapes

PShape[] svgs;            // Array to hold SVG shapes, size will be set dynamically
int[] xPos;
int[] yPos;
PGraphics pg;
PGraphics preview;

void setup() {
  size(1024, 1024); // Set the size of the canvas
  surface.setResizable(true);

  preview = createGraphics(1024, 1024, JAVA2D);

  // Setup ControlP5
  cp5 = new ControlP5(this);

  cp5.addSlider("numberOfShapes")
    .setRange(1, 78)
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
      updatePreview();
    }
  }
  );

  cp5.addSlider("Files")
    .setRange(1, 100)
    .setValue(numberOfFiles)
    .setDecimalPrecision(0)
    .setPosition(10, 90)
    .setSize(200, 20);

  cpFill = cp5.addColorWheel("fillPicker")
    .setPosition(10, 130)
    .setColorValue(color(255, 128, 0, 128)) // Initial RGBA color
    .addListener(new ControlListener() {
    public void controlEvent(ControlEvent event) {
      shapeFill = cpFill.getRGB(); // Update global shape fill color variable
      updatePreview(); // Update the preview whenever the color changes
    }
  }
  );

  cpBg = cp5.addColorWheel("bgPicker")
    .setPosition(220, 130)
    .setColorValue(color(255, 128, 0, 128)) // Initial RGBA color
    .addListener(new ControlListener() {
    public void controlEvent(ControlEvent event) {
      bgColor = cpBg.getRGB(); // Update global shape fill color variable
      updatePreview(); // Update the preview whenever the color changes
    }
  }
  );

  cp5.addButton("Export")
    .setPosition(10, 400)
    .setSize(80, 40)
    .setId(4)
    .onRelease(new CallbackListener() {
    public void controlEvent(CallbackEvent event) {
      exportSVGs();
    }
  }
  );

  // Load SVGs
  File dir = new File(sketchPath("assets"));
  File[] files = dir.listFiles((File file) -> file.getName().endsWith(".svg"));
  svgs = new PShape[files.length];
  for (int i = 0; i < files.length; i++) {
    svgs[i] = loadShape(files[i].getAbsolutePath());
    svgs[i].disableStyle();  // Disables the SVG's own style
  }

  updatePreview();
}

void draw() {
  background(bgColor);
  image(preview, 0, 0, width, height);
}

void updatePreview() {
  preview.beginDraw();
  preview.background(bgColor); // Uses the color picked from the ColorPicker for background
  preview.fill(shapeFill);       // Uses the color picked from the ColorPicker for shapes fill
  preview.noStroke();

  ArrayList<Integer> indices = new ArrayList<Integer>();
  for (int i = 0; i < svgs.length; i++) indices.add(i);
  Collections.shuffle(indices);

  for (int i = 0; i < numberOfShapes; i++) {
    int idx = indices.get(i);
    float w = svgs[idx].width;
    float h = svgs[idx].height;
    float x = random(w/2, preview.width - w/2);
    float y = random(h/2, preview.height - h/2);
    preview.pushMatrix();
    preview.translate(x, y);
    preview.shape(svgs[idx], -w/2, -h/2, shapeSize, shapeSize);
    preview.popMatrix();
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
      float x = random(w/2, pg.width - w/2);
      float y = random(h/2, pg.height - h/2);
      pg.pushMatrix();
      pg.translate(x, y);
      pg.shape(svgs[idx], -w/2, -h/2, shapeSize, shapeSize);
      pg.popMatrix();
    }

    pg.endDraw();
    pg.dispose();
  }
}
