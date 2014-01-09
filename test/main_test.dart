library main_test;

import 'dart:async';

import 'package:unittest/unittest.dart';
import 'package:di/di.dart';
//import 'package:di/dynamic_injector.dart';
import 'package:angular/angular.dart';
import 'package:angular/mock/module.dart';

import '../lib/chunks.dart';
import '../web/main.dart';

main() {
  setUp(() {
    setUpInjector();
    module((Module m) => m.install(new MyAppModule()));
  });
  tearDown(tearDownInjector());
  
  group('Chunks', () {
    test('should chunk the input text on whitespaces by default', () {
      var chunks = new Chunks('foo bar');
      expect(chunks.length, equals(2));
      expect(chunks.chunkAt(0), equals('foo'));
      expect(chunks.chunkAt(1), equals('bar'));
    });
    
    test('should chunk the input text on the given separator', () {
      var chunks = new Chunks('foo bar', 'b');
      expect(chunks.length, equals(2));
      expect(chunks.chunkAt(0), equals('foo '));
      expect(chunks.chunkAt(1), equals('ar'));
    });
    
    test('lastIndex', () {
      var chunks = new Chunks('foo bar');
      expect(chunks.lastIndex, equals(1));
    });
  });
  
  group('SpeedReaderController', () {
    test('should have a default text', inject((SpeedReaderController speedReaderController) {
      expect(speedReaderController.text, isNotNull);
      expect(speedReaderController.text, equals('Hello World!'));
    }));
    
    test('should chunk test before playing', inject((SpeedReaderController speedReaderController) {
      expect(speedReaderController.currentChunk, equals(''));
      
      speedReaderController.playFromStart();
      expect(speedReaderController.currentChunk, equals('Hello'));
    }));
    
    test('should play the text', inject((SpeedReaderController speedReaderController) {
      speedReaderController.wordsPerMinute = 60; // 1 word per second
      speedReaderController.playFromStart();
      expect(speedReaderController.currentChunk, equals('Hello'));
      new Timer(
          new Duration(seconds: 1),
          expectAsync0(() {
            expect(speedReaderController.currentChunk, equals('World!'));
          }));
    }));
    
    test('should stop at the latest chunk', inject((SpeedReaderController speedReaderController) {
      speedReaderController.playFromStart();
      new Timer(
          new Duration(seconds: 1),
          expectAsync0(() {
            expect(speedReaderController.currentChunk, equals('World!'));
          }));
    }));
  });
}