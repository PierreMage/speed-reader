library chunks;

const WHITESPACES = '\\s+';

class Chunks {
  List<String> _chunks;
  //int chunkSize;
  
  Chunks(String text, [String separator = WHITESPACES])
      : _chunks = text.split(new RegExp(separator)); //TODO: also use chunkSize

  int get length => _chunks.length;
  int get lastIndex => length - 1;
  String chunkAt(int position) => _chunks[position];
}