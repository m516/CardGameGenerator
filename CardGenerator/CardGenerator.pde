/** //<>//
 * Many Pages. 
 * 
 * Saves a new page into a PDF file each loop through draw().
 * Pressing the mouse finishes writing the file and exits the program.
 */



float DPI = 300;
float PAGE_WIDTH_INCHES = 8.5;
float PAGE_HEIGHT_INCHES = 11.0;

int CARD_WIDTH_PIXELS = int(DPI*2.5);
int CARD_HEIGHT_PIXELS = int(DPI*3.5);

int NUM_ROWS = 0;
int NUM_COLS = 0;

int BORDER_PIXELS = int(DPI/5);

int TITLE_SIZE=24;
int BODY_SIZE=12;
int FOOTER_SIZE=12;

boolean isPreview = true;

import processing.pdf.*;

PGraphicsPDF pdf;

void settings(){
  NUM_ROWS = int(PAGE_HEIGHT_INCHES/(CARD_HEIGHT_PIXELS/DPI));
  NUM_COLS = int(PAGE_WIDTH_INCHES/(CARD_WIDTH_PIXELS/DPI));
  
  int w = NUM_COLS*CARD_WIDTH_PIXELS;
  int h = NUM_ROWS*CARD_HEIGHT_PIXELS;
  size(w,h,PDF,"cards.pdf");
}

void setup() {
  loadCards("cards.txt");
}

void draw() {
  
  PGraphicsPDF pdf = (PGraphicsPDF) g;  // Get the renderer
  
  int x = 0, y = 0;
  for(Card card: cards){
    for(int i = 0; i < (isPreview?1:card.count); i++){
      drawCard(card, x*CARD_WIDTH_PIXELS, y*CARD_HEIGHT_PIXELS);
      x=(x+1)%NUM_COLS;
      if(x==0){
        y=(y+1)%NUM_ROWS;
        if(y==0){
          pdf.nextPage();
        }
      }
    }
  }
  exit();
}
