import controlP5.*;
import processing.svg.*;
import java.util.Collections;
import java.util.ArrayList;
import java.io.File;

ControlP5 cp5;
ColorWheel cpFill;
ColorWheel cpBg;

int numberOfShapes;
int numberOfFiles = 24;
int shapeSize = 400;
float scaleFactor;
float largestDimension = 0;

int bgColor = color(255, 136, 38, 255);
int shapeFill = color(238, 202, 239, 255);

PShape[] svgs;
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
    svgs[i].disableStyle();
    float w = svgs[i].width;
    float h = svgs[i].height;
    largestDimension = max(largestDimension, max(w, h));
  }
  
  scaleFactor = shapeSize / largestDimension;
  
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
      scaleFactor = shapeSize / largestDimension;
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
      shapeFill = cpFill.getRGB();
      updatePreview();
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
  preview.background(bgColor);
  preview.fill(shapeFill);
  preview.noStroke();
  
  ArrayList<Integer> indices = new ArrayList<Integer>();
  for (int i = 0; i < svgs.length; i++) indices.add(i);
  Collections.shuffle(indices);
  
  for (int i = 0; i < numberOfShapes; i++) {
    int idx = indices.get(i);
    float w = svgs[idx].width;
    float h = svgs[idx].height;
    float x = random(0, preview.width);
    float y = random(0, preview.height);
    float angle = random(TWO_PI);
    
    preview.pushMatrix();
    preview.translate(x, y);
    preview.rotate(angle);
    preview.scale(scaleFactor);
    preview.shape(svgs[idx], -w / 2, -h / 2);
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
  
  while(folderDir.exists()) {
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
      float x = random(0, pg.width);
      float y = random(0, pg.height);
      float angle = random(TWO_PI);
      
      pg.pushMatrix();
      pg.translate(x, y);
      pg.rotate(angle);
      pg.scale(scaleFactor);
      pg.shape(svgs[idx], -w / 2, -h / 2);
      pg.popMatrix();
    }
    
    pg.endDraw();
    pg.dispose();
  }
}
