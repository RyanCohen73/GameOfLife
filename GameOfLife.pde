import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
private int NUM_ROWS = 20;
private int NUM_COLS = 20;
private Life[][] buttons; //2d array of Life buttons each representing one cell
private boolean[][] buffer; //2d array of booleans to store state of buttons array
private boolean running = true; //used to start and stop program
private int generationIndex = 0;
private int nextGenerationCounter = 0;

public void setup () {
  size(400, 400);
  frameRate(6);
  // make the manager
  Interactive.make( this );

  //your code to initialize buttons goes here
  this.buttons = new Life[NUM_ROWS][NUM_COLS];
  for (int iRow = 0; iRow < NUM_ROWS; iRow++) {
    for (int iCol = 0; iCol < NUM_COLS; iCol++) {
      this.buttons[iRow][iCol] = new Life(iRow, iCol);
    }
  }

  //your code to initialize buffer goes here
  this.buffer = new boolean[NUM_ROWS][NUM_COLS];
 
}

public void draw () {
  background(0);
  //System.out.println("initial test");
  if (this.nextGenerationCounter > 0) {
    gameFunctions();
  }
  if (this.running == false) //pause the program
    return;  
  gameFunctions();
  
}

private void gameFunctions() {
  copyFromButtonsToBuffer();
  runRules();  
  copyFromBufferToButtons();
  this.nextGenerationCounter = 0;
  this.generationIndex++;
}

private void runRules() {
  for (int iRow = 0; iRow < NUM_ROWS; iRow++) {
    for (int iCol = 0; iCol < NUM_COLS; iCol++) {
      if(countNeighbors(iRow, iCol) == 3) {
        this.buffer[iRow][iCol] = true;
      }
      else if(countNeighbors(iRow, iCol) == 2 && this.buttons[iRow][iCol].getIsAlive()  == true) {
        this.buffer[iRow][iCol] = true;

      }
      else {
        this.buffer[iRow][iCol] = false;
      }
      this.buttons[iRow][iCol].draw(); 
    }
  }
}

private void killAllCells() {
  for (int iRow = 0; iRow < NUM_ROWS; iRow++) {
    for (int iCol = 0; iCol < NUM_COLS; iCol++) {
      this.buttons[iRow][iCol].setAlive(false);
    }
  }
}
private void restartLife() {
  for (int iRow = 0; iRow < NUM_ROWS; iRow++) {
    for (int iCol = 0; iCol < NUM_COLS; iCol++) {
      this.buttons[iRow][iCol].setAlive(Math.random() < .5);
    }
  }
  this.generationIndex = 0;
}

public void copyFromBufferToButtons() {
  //your code here
  for (int iRow = 0; iRow < NUM_ROWS; iRow++) {
    for (int iCol = 0; iCol < NUM_COLS; iCol++) {
      this.buttons[iRow][iCol].setAlive(this.buffer[iRow][iCol]);
    }
  }
}

public void copyFromButtonsToBuffer() {
  //your code here
  for (int iRow = 0; iRow < NUM_ROWS; iRow++) {
    for (int iCol = 0; iCol < NUM_COLS; iCol++) {
      this.buffer[iRow][iCol] = this.buttons[iRow][iCol].getIsAlive();
    }
  }
}

public boolean isValid(int r, int c) {
  return 0<= r && r < NUM_ROWS && 0<= c && c < NUM_COLS;
}

public int countNeighbors(int row, int col) {
  int neighbors = 0;
  for (int i = -1; i <= 1; i++) {
    for (int j = -1; j <= 1; j++) {
      if (isValid(row+i, col+j) && this.buttons[row+i][col+j].getIsAlive()) {
        neighbors++;
      }
    }
  }
  if (this.buttons[row][col].getIsAlive()) {
    neighbors--;
  }
  return neighbors;
}

public class Life {
  private int row, col;
  private int rColor, gColor, bColor;
  private float x, y, width, height;
  private boolean alive;

  public Life (int row, int col) {
    this.width = 400/NUM_COLS;
    this.height = 400/NUM_ROWS;
    this.row = row;
    this.col = col; 
    this.x = this.col*this.width;
    this.y = this.row*this.height;
    this.alive = Math.random() < .5; // 50/50 chance cell will be alive
    //\this.alive = false;
    
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () {
    this.alive = !this.alive; //turn cell on and off with mouse press
  }

  public void selectColors() {
    //int[] aliveColor = new int[]{153, 255, 153}; //green
    int[] aliveColor = new int[]{153, 255, 255}; //blue
    //int[] deadColor = new int[]{255, 178, 102}; //orange
    //int[] deadColor = new int[]{76, 0, 153}; //purple
    int[] deadColor = new int[]{0, 0, 153}; //dark blue


    this.rColor = this.alive ? aliveColor[0] : deadColor[0];
    this.gColor = this.alive ? aliveColor[1] : deadColor[1];
    this.bColor = this.alive ? aliveColor[2] : deadColor[2];
  }
  public void draw () {
    selectColors();
    fill(this.rColor, this.gColor, this.bColor);
    //rect(this.x, this.y, this.width, this.height);
    float xPos = this.x + this.width/2;
    float yPos = this.y + this.width/2;
    circle(xPos, yPos, this.width);
  }
  public boolean getIsAlive() {
    //replace the code one line below with your code
    return this.alive;
  }
  public void setAlive(boolean living) {
    //your code here
    this.alive = living;
  }
}

public void keyPressed() {
  //your code here
  if (key == RETURN || key == ENTER) {
    this.nextGenerationCounter++;
  }
  if (keyCode == ' ') {
    this.running = !this.running;
  }
  if (keyCode == '1') {
    restartLife();
  }
  if (keyCode == '2') {
    killAllCells();
  }

}