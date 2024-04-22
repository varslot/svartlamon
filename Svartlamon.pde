import processing.svg.*;
import java.util.Collections;
import java.util.ArrayList;
import java.io.File;

// Live's Variables
int numberOfShapes = 24;  // Dynamic number of shapes to draw per SVG, easily adjustable
int numberOfFiles = 12; // Number of files to be exported
int bgColor = #16A57C; // Background Color
int shapeFill = #EECAEF; // Shape Color
int shapeSize = 50; // Size of Shapes

PShape[] svgs;   // Array to hold SVG shapes, size will be set dynamically
int[] xPos;
int[] yPos;
PGraphics pg;

void setup() {
  size(1024, 1024); // Set the size of the canvas

  // Dynamically load all SVG files from the 'assets' folder
  File dir = new File(sketchPath("assets"));
  File[] files = dir.listFiles((File file) -> file.getName().endsWith(".svg"));
  svgs = new PShape[files.length];  // Initialize the array now that we know the number of SVG files
  xPos = new int[numberOfShapes];   // Initialize x positions array for dynamic number of shapes
  yPos = new int[numberOfShapes];   // Initialize y positions array for dynamic number of shapes

  for (int i = 0; i < files.length; i++) {
    svgs[i] = loadShape(files[i].getAbsolutePath());
    svgs[i].disableStyle();  // Disables the SVG's own style
  }

  // Define the base folder path
  String username = System.getProperty("user.name"); // Automatically fetches the macOS username
  String baseFolderPath = "/Users/" + username + "/Downloads/Svartlamoen"; // Path to the new folder

  // Ensure the folder starts with Svartlamoen-01
  String folderPath = baseFolderPath + "-01";
  File folderDir = new File(folderPath);
  int suffix = 2;  // Start checking from Svartlamoen-02 if Svartlamoen-01 exists

  // Check if the folder exists and find a unique name
  while (folderDir.exists()) {
    folderPath = baseFolderPath + "-" + nf(suffix++, 2); // Increment suffix and format with leading zeros
    folderDir = new File(folderPath);
  }
  folderDir.mkdirs(); // Make the directory once a unique name is found

  // Generate and save SVG files
  for (int fileNum = 1; fileNum <= numberOfFiles; fileNum++) {
    ArrayList<Integer> indices = new ArrayList<Integer>();
    for (int i = 0; i < svgs.length; i++) indices.add(i);  // Create an index list from 0 to the number of loaded SVGs
    Collections.shuffle(indices);  // Shuffle the list to randomize

    // Setup SVG output for each file
    String filePath = folderPath + "/output-" + nf(fileNum, 2) + ".svg";
    pg = createGraphics(width, height, SVG, filePath);
    pg.beginDraw();
    pg.background(bgColor); // Set the background color to hex #16A57C
    pg.fill(shapeFill);       // Set the fill color to hex #EECAEF for all shapes
    pg.noStroke();          // Disable stroke for all shapes

    // Draw a dynamic number of random SVGs from the shuffled list
    for (int i = 0; i < numberOfShapes; i++) {
      int idx = indices.get(i); // Get a random index
      xPos[i] = (int) random(width);  // Random x position within the canvas
      yPos[i] = (int) random(height); // Random y position within the canvas
      pg.shape(svgs[idx], xPos[i], yPos[i], shapeSize, shapeSize); // Draw shape at (xPos, yPos) with width and height of 400
    }

    pg.endDraw();  // Finish drawing
    pg.dispose();  // Save and close the SVG file
  }

  exit();  // Close the program after saving all files
}

void draw() {
  // Drawing on the main canvas is not needed for file generation
}
