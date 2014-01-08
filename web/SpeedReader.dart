library speedreader;

import 'dart:async';
import 'dart:html';

final WHITESPACES = new RegExp('\\s+');

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
    querySelector('#read').onClick.listen((e) { 
      setText((querySelector('#source') as TextAreaElement).value);
      reading = true;
      read();
    });
    window.onKeyPress.listen((e) {
      switch (e.keyCode) {
        case KeyCode.P:
          reading = !reading;
          read();  
          break;
        case KeyCode.R:
          restart();
          break;
        case KeyCode.K:
          setWordsPerMinute(wordsPerMinute + 10);
          break;
        case KeyCode.J:
          setWordsPerMinute(wordsPerMinute - 10);
          break;
        case KeyCode.H:
          rewind();
          break;
        case KeyCode.L:
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
    currentTimer = new Timer.periodic(new Duration(milliseconds: periodInMilliSeconds), (Timer t) {
      forward();
      if (!reading || currentPosition >= text.chunksLength()) {
        t.cancel();
        reading = false;
      }
    }); 
  }
  
  void displayChunk(int position) {
    querySelector('#text').setInnerHtml(text.chunkAt(position));
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