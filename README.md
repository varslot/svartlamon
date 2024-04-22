# SVG Shape Viewer and Exporter

This Processing application allows users to dynamically load SVG files from a specified folder, display them with adjustable parameters, and export the results as SVG files. The application uses the ControlP5 library to provide a graphical user interface for real-time interaction and customization.

## Features

- **Dynamic SVG Loading**: Automatically loads all SVG files from the "assets" folder.
- **Interactive Controls**: Utilize sliders and color pickers to adjust the display parameters of the SVGs, such as the number of shapes, shape size, and colors.
- **Real-time Preview**: Updates the display in real-time as you adjust the controls.
- **SVG Export**: Exports one or more SVGs based on the current settings to a specified directory.

## Installation

### Prerequisites

- Processing 3.x
- ControlP5 library for Processing (can be installed via the Contribution Manager in Processing)

### Setup

1. **Download Processing**

   - Go to [Processing.org](https://processing.org/download/) and download the latest version for your operating system.

2. **Install ControlP5 Library**

   - Open Processing and navigate to `Sketch > Import Library... > Add Library...`
   - Search for "ControlP5" and install it.

3. **Download Project**

   - Download this project as a zip file and extract it.
   - Alternatively, clone the repo:

```
git clone https://github.com/varslot/svarlamon.git
```

4. **Open Project**
   - Open the Processing IDE and then open the downloaded project (`.pde` file).

## Usage

1. **Load SVGs**

   - Place your SVG files in the "assets" folder located within the sketch directory.

2. **Run the Application**

   - Run the sketch to see the SVGs displayed. Use the GUI controls to adjust the number of shapes, their sizes, and colors.

3. **Adjust Parameters**

   - Move the sliders to change the size and the number of shapes displayed.
   - Use the color picker to change the color properties of the shapes.

4. **Export SVGs**
   - Click the "Export" button to save the displayed SVGs to the "Downloads" directory on your machine.
