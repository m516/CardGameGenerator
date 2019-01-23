import java.util.LinkedList;

class Card {
  PImage contentImage, borderImage;
  String title, footer;
  String[] body;
  int count = 1;
}

LinkedList<Card> cards;
int totalCards = 0;

void loadCards(String filename) {
  //Create new list of cards
  cards = new LinkedList<Card>();
  //Load the file
  String[] lines = loadStrings(filename);
  LinkedList<String> bodyText = new LinkedList<String>(); //Cumulative list of body text
  Card currentCard = new Card(); //the current card edited
  int state=0; //The state of the program, used to determine 
  //0-title
  //1-body
  //2-footer
  //Parse each line
  for (int i = 0; i < lines.length; i++) {
    //Get the string
    String line = lines[i];
    //Print it out (debug)
    println(line);
    //Check if it's a parameter
    try {
      if (line.length()==0) { //If empty
        if (state==1) {
          state++; //Change to footer
          continue;
        }
      } else if (line.charAt(0)=='-') {
        if (line.length()<2) continue;
        //Check all parameters
        if (line.charAt(1)=='b') {
          currentCard.borderImage=loadImage(line.substring(line.lastIndexOf('\t')+1));
        } else if (line.charAt(1)=='i') {
          currentCard.contentImage=loadImage(line.substring(line.lastIndexOf('\t')+1));
        } else if (Character.isDigit(line.charAt(1))) {
          currentCard.count = Integer.parseInt(line.substring(1));
        }
      } else if (line.charAt(0)=='*' && line.length()==1) {
        currentCard.body = new String[bodyText.size()];
        bodyText.toArray(currentCard.body);
        bodyText.clear();
        cards.add(currentCard);
        totalCards += currentCard.count;
        currentCard = new Card();
        state = 0;
      }
      //If not a parameter
      else {
        switch(state) {
        case 0: //title
          currentCard.title = line;
          state++;
          println("Title finished");
          break;
        case 1: //body
          //Add text to body list
          bodyText.add(line);
          break;
        case 2://footer
          currentCard.footer=line;
          state++;
          println("Footer finished");
          break;
        default:
          throw new IllegalStateException("Found text that doesn't belong in header, body, or footer");
        }
      }
    }
    catch(Exception e) {
      print("Error parsing line ");
      print(i);
      print(":");
      println(e.getMessage());
      e.printStackTrace();
    }
  }
}


void drawCard(Card card, float x, float y) {
  pushMatrix();
  translate(x, y);
  //Draw the images
  PImage border = card.borderImage;
  PImage content = card.contentImage;

  boolean isDark = false;

  if (content==null) {
    if (border==null) {
      fill(200);
      noStroke();
      rect(0, 0, CARD_WIDTH_PIXELS, CARD_HEIGHT_PIXELS);
    } else {
      border = border.copy();
      border.resize(CARD_WIDTH_PIXELS, CARD_HEIGHT_PIXELS);
      image(border, 0, 0);
    }
    fill(255);
    noStroke();
    rect(BORDER_PIXELS, BORDER_PIXELS, CARD_WIDTH_PIXELS-2*BORDER_PIXELS, CARD_HEIGHT_PIXELS-2*BORDER_PIXELS);
  } else {
    content = content.copy();
    if (border==null) {
      content.resize(CARD_WIDTH_PIXELS, CARD_HEIGHT_PIXELS);
      image(content, 0, 0);
    } else {
      border = border.copy();
      border.resize(CARD_WIDTH_PIXELS, CARD_HEIGHT_PIXELS);
      content.resize(CARD_WIDTH_PIXELS, CARD_HEIGHT_PIXELS);
      image(border, 0, 0);
      content = content.get(BORDER_PIXELS, BORDER_PIXELS, CARD_WIDTH_PIXELS-2*BORDER_PIXELS, CARD_HEIGHT_PIXELS-2*BORDER_PIXELS);
      image(content, BORDER_PIXELS, BORDER_PIXELS);
    }


    isDark = brightness(content.get(CARD_WIDTH_PIXELS/2, CARD_HEIGHT_PIXELS/2))<128;
  }


  //Draw the text
  fill(isDark?255:0);
  noStroke();

  //Title text
  float textSize = DPI/5.0;
  textSize(textSize);
  while (textWidth(card.title)>CARD_WIDTH_PIXELS*.75) textSize(--textSize);
  textAlign(CENTER, BOTTOM);
  strokeWeight(2);
  text(card.title, CARD_WIDTH_PIXELS/2, CARD_HEIGHT_PIXELS/8);

  //Body
  textSize = DPI/8.0;
  textSize(textSize);
  while (textSize*card.body.length>CARD_HEIGHT_PIXELS*0.6) textSize(--textSize);
  textAlign(CENTER, CENTER);
  float yText = CARD_HEIGHT_PIXELS*0.3;
  for (String s : card.body) {
    float lineTextSize = textSize;
    textSize(lineTextSize);
    while (textWidth(s)>CARD_WIDTH_PIXELS*.75) textSize(--lineTextSize);
    if (s.charAt(0)=='*') {
      textAlign(LEFT, CENTER);
      text(s, CARD_WIDTH_PIXELS/8, yText);
    } else {
      textAlign(CENTER, CENTER);
      text(s, CARD_WIDTH_PIXELS/2, yText);
    }
    yText+=textSize*1.2;
  }

  //Footer text
  if (card.footer!=null) {
    textSize = DPI/8.0;
    textSize(textSize);
    while (textWidth(card.title)>CARD_WIDTH_PIXELS*.75) textSize(--textSize);
    textAlign(CENTER, TOP);
    strokeWeight(2);
    text(card.footer, CARD_WIDTH_PIXELS/2, CARD_HEIGHT_PIXELS*9/10);
  }

  //Card count
  textAlign(CENTER, BOTTOM);
  textSize=DPI/8.0;
  textSize(textSize);
  while (textWidth(card.title)>CARD_WIDTH_PIXELS*.5) textSize(--textSize);
  StringBuilder text = new StringBuilder(32);
  text.append(card.count);
  text.append('/');
  text.append(totalCards);
  text(text.toString(), CARD_WIDTH_PIXELS/2, CARD_HEIGHT_PIXELS-4);

  //Border
  noFill();
  stroke(isDark?255:0);
  strokeWeight(DPI/50);
  rect(0, 0, CARD_WIDTH_PIXELS, CARD_HEIGHT_PIXELS, BORDER_PIXELS*2);

  popMatrix();
}
