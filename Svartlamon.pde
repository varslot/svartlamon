 import processing.svg.*;
import java.util.Collections;
import java.util.ArrayList;

PShape[] svgs;   // Array to hold all 50 SVG shapes
int[] xPos;
int[] yPos;
PGraphics pg;

void setup() {
  size(800, 600); // Set the size of the canvas

  svgs = new PShape[50];  // Array to hold all 50 SVGs
  xPos = new int[8];     // Array to hold x positions for the 8 randomly selected SVGs
  yPos = new int[8];     // Array to hold y positions for the 8 randomly selected SVGs

  // Load all 50 SVG files from the 'assets' folder
  for (int i = 0; i < 50; i++) {
    svgs[i] = loadShape("assets/Asset " + (i + 1) + ".svg");
    svgs[i].disableStyle();  // Disables the SVG's own style
  }

  // Define the base folder path
  String username = System.getProperty("user.name"); // Automatically fetches the macOS username
  String baseFolderPath = "/Users/" + username + "/Downloads/Svartlamoen"; // Path to the new folder

  // Ensure the folder starts with Svartlamoen-01
  String folderPath = baseFolderPath + "-01";
  File dir = new File(folderPath);
  int suffix = 2;  // Start checking from Svartlamoen-02 if Svartlamoen-01 exists

  // Check if the folder exists and find a unique name
  while (dir.exists()) {
    folderPath = baseFolderPath + "-" + nf(suffix++, 2); // Increment suffix and format with leading zeros
    dir = new File(folderPath);
  }
  dir.mkdirs(); // Make the directory once a unique name is found

  // Generate and save SVG files
  for (int fileNum = 1; fileNum <= 24; fileNum++) {
    ArrayList<Integer> indices = new ArrayList<Integer>();
    for (int i = 0; i < 50; i++) indices.add(i);  // Create an index list from 0 to 49
    Collections.shuffle(indices);  // Shuffle the list to randomize

    // Setup SVG output for each file
    String filePath = folderPath + "/output-" + nf(fileNum, 2) + ".svg";
    pg = createGraphics(width, height, SVG, filePath);
    pg.beginDraw();
    pg.background(#16A57C); // Set the background color to hex #16A57C
    pg.fill(#EECAEF);       // Set the fill color to hex #EECAEF for all shapes
    pg.noStroke();          // Disable stroke for all shapes

    // Draw 8 random SVGs from the shuffled list
    for (int i = 0; i < 8; i++) {
      int idx = indices.get(i); // Get a random index
      xPos[i] = (int) random(width);  // Random x position within the canvas
      yPos[i] = (int) random(height); // Random y position within the canvas
      pg.shape(svgs[idx], xPos[i], yPos[i], 100, 100); // Draw shape at (xPos, yPos) with width and height of 400
    }

    pg.endDraw();  // Finish drawing
    pg.dispose();  // Save and close the SVG file
  }

  exit();  // Close the program after saving all files
}

void draw() {
  // Drawing on the main canvas is not needed for file generation
}
