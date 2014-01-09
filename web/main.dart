library speed_reader_controller;

import 'dart:async';

import 'package:angular/angular.dart';
import 'package:perf_api/perf_api.dart';

import '../lib/chunks.dart';

@NgController(
    selector: '[speed-reader]',
    publishAs: 'ctrl')
class SpeedReaderController { 
  
  String text = 'Hello World!';
  num wordsPerMinute = 300; // 5 words per second
  
  Chunks _chunks;
  Timer _currentTimer;
  int _currentPosition = 0;
  /* TODO
  int fontSize;
  String fontColor;
  String fontName;
  String backgroundColor;
  String alignment;
  */
  
  String get currentChunk => _chunks == null ? '' : _chunks.chunkAt(_currentPosition);
  
  void playFromStart() {
    _pause();
    _chunks = new Chunks(text);
    _currentPosition = 0;
    _play();
  }
  
  void _pause() {
    if (_currentTimer != null) _currentTimer.cancel();
  }

  void _play() {
    int periodInMilliSeconds = 1000 ~/ (wordsPerMinute ~/ 60);
    _currentTimer = new Timer.periodic(new Duration(milliseconds: periodInMilliSeconds), (Timer t) {
      ++_currentPosition;
      if (_currentPosition >= _chunks.lastIndex) {
        t.cancel();
      }
    }); 
  }
  
  //TODO: handle keyPress
}

class MyAppModule extends Module {
  MyAppModule() {
    type(SpeedReaderController);
    type(Profiler, implementedBy: Profiler); // comment out to enable profiling
  }
}

main() {
  ngBootstrap(module: new MyAppModule());
}