import controlP5.*;
import processing.svg.*;
import java.util.Collections;
import java.util.ArrayList;
import java.io.File;

ControlP5 cp5;

// Variables
int numberOfShapes = 78;  // Dynamic number of shapes to draw per SVG, easily adjustable
int numberOfFiles = 12;    // Number of files to be exported
int bgColor = #16A57C;    // Background Color
int shapeFill = #EECAEF;  // Shape Color
int shapeSize = 200;      // Size of Shapes

PShape[] svgs;            // Array to hold SVG shapes, size will be set dynamically
int[] xPos;
int[] yPos;
PGraphics pg;
PGraphics preview;

void setup() {
  size(1024, 1024); // Set the size of the canvas
  surface.setResizable(true);

  // Setup ControlP5
  cp5 = new ControlP5(this);

  cp5.addSlider("numberOfShapes")
    .setRange(1, 78)
    .setValue(numberOfShapes)
    .setPosition(10, 30)
    .setSize(200, 20)
    .setId(1);

  cp5.addSlider("shapeSize")
    .setRange(50, 1000)
    .setValue(shapeSize)
    .setPosition(10, 60)
    .setSize(200, 20)
    .setId(3);

  cp5.addSlider("Files")
    .setRange(1, 100)
    .setValue(numberOfFiles)
    .setDecimalPrecision(0)
    .setPosition(10, 90)
    .setSize(200, 20)
    .setId(2);

  cp5.addButton("Export")
    .setPosition(10, 150)
    .setSize(80, 40)
    .setId(4);

  // Add listeners
  cp5.getController("numberOfShapes").addListener(new ControlListener() {
    public void controlEvent(ControlEvent event) {
      updatePreview();
    }
  }
  );

  cp5.getController("shapeSize").addListener(new ControlListener() {
    public void controlEvent(ControlEvent event) {
      updatePreview();
    }
  }
  );

  cp5.getController("Export").addListener(new ControlListener() {
    public void controlEvent(ControlEvent event) {
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

  preview = createGraphics(1024, 1024, JAVA2D);
  updatePreview();
}

void draw() {
  background(bgColor);
  image(preview, 0, 0, width, height);
}

void updatePreview() {
  preview.beginDraw();
  preview.background(bgColor);
  preview.noStroke();
  preview.fill(shapeFill);

  ArrayList<Integer> indices = new ArrayList<Integer>();
  for (int i = 0; i < svgs.length; i++) indices.add(i);
  Collections.shuffle(indices);

  for (int i = 0; i < numberOfShapes; i++) {
    int idx = indices.get(i);
    int x = (int) random(shapeSize/2.0, preview.width - shapeSize/2.0);  // Adjusted random call for float parameters
    int y = (int) random(shapeSize/2.0, preview.height - shapeSize/2.0); // Adjusted random call for float parameters
    preview.shape(svgs[idx], x, y, shapeSize, shapeSize);
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
      int x = (int) random(shapeSize/2.0, preview.width - shapeSize/2.0);  // Adjusted random call for float parameters
      int y = (int) random(shapeSize/2.0, preview.height - shapeSize/2.0); // Adjusted random call for float parameters
      pg.shape(svgs[idx], x, y, shapeSize, shapeSize);
    }

    pg.endDraw();
    pg.dispose();
  }
}
