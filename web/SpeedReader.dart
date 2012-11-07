library speedreader;

import 'dart:coreimpl';
import 'dart:isolate';
import 'dart:html';

final WHITESPACES = new JSSyntaxRegExp('\\s+');
final P_KEY = 'p'.charCodeAt(0);
final R_KEY = 'r'.charCodeAt(0);
final K_KEY = 'k'.charCodeAt(0);
final J_KEY = 'j'.charCodeAt(0);
final H_KEY = 'h'.charCodeAt(0);
final L_KEY = 'l'.charCodeAt(0);

class SpeedReader { 
  Timer currentTimer;
  bool reading = false;
  Text text;
  int currentPosition = 0;
  int wordsPerMinute = 300;
  /* TODO
  int fontSize;
  String fontColor;
  String fontName;
  String backgroundColor;
  String alignment;
  */

  SpeedReader(String text) {
    setText(text);
  }

  setText(String text) {
    this.text = new Text(text);
    restart();
  }

  void run() {
    document.query('#read').on.click.add((Event e) { 
      setText(document.query('#source').value);
      reading = true;
      read();
    });
    window.on.keyPress.add((Event e)
    {
      switch (e.charCode) {
        case P_KEY:
          reading = !reading;
          read();  
          break;
        case R_KEY:
          restart();
          break;
        case K_KEY:
          setWordsPerMinute(wordsPerMinute + 10);
          break;
        case J_KEY:
          setWordsPerMinute(wordsPerMinute - 10);
          break;
        case H_KEY:
          rewind();
          break;
        case L_KEY:
          forward();
          break;
      }
      //print('${e.keyCode},${e.keyIdentifier},${e.charCode}');
    });
  }

  void forward() {
    if (currentPosition >= text.chunksLength()) {
      return;
    }
    displayChunk(currentPosition++);
  }

  void rewind() {
    reading = false;
    if (currentPosition <= 0) {
      return;
    }
    displayChunk(currentPosition--);
  }

  void setWordsPerMinute(int wordsPerMinute) {
    this.wordsPerMinute = wordsPerMinute;
    print('wordsPerMinute: $wordsPerMinute');
    if (currentTimer != null) {
      currentTimer.cancel();
    }
    read();
  }

  void read() {
    if (!reading || currentPosition >= text.chunksLength()) {
      return;
    }
    int periodInMilliSeconds = 1000 ~/ (wordsPerMinute ~/ 60);
 	  currentTimer = new Timer.repeating(periodInMilliSeconds, (Timer t) {
      forward();
      if (!reading || currentPosition >= text.chunksLength()) {
      	t.cancel();
        reading = false;
  	  }
  	}); 
  }
  
  void displayChunk(int position) {
    document.query('#text').innerHTML = text.chunkAt(position);
  }

  void restart() {
    displayChunk(currentPosition = 0);
  }
}

class Text {
  String text;
  List<String> chunks;
  //int chunkSize;
  
  Text(String text) {
    this.text = text;
    chunkText();
  }

  void chunkText() {
    this.chunks = text.split(WHITESPACES); //TODO: also use chunkSize
  }

  String chunkAt(int position) {
    return chunks[position];
  }

  int chunksLength() {
    return chunks.length;
  }
}

main() {
  new SpeedReader("Hello World!").run();
}