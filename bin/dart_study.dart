import 'dart:io';
import 'dart:math';

const int KB = 1024;
const int MB = 1024 * KB;
const int GB = 1024 * MB;

class RandomBlob {
  RandomBlob({this.size = 1024 * 1024 * 1}) {
    _blob = List<int>.generate(size, (index) => rand.nextInt(255));
  }

  List<int> get blob {
    for (var i = 0; i < size; i++) {
      _blob[i] = rand.nextInt(255);
    }
    return _blob;
  }

  List<int> _blob = [];
  final Random rand = Random();
  int size;
}

class RandomFile {
  static Future<int> generate(String name, {int size = 512 * MB}) async {
    var file = File(name);
    var sink = file.openWrite(mode: FileMode.writeOnly);
    int blocksize = 1 * MB;
    var blob = RandomBlob(size: blocksize);
    int count = (size / blocksize).floor();
    print(count);
    for (int i = 0; i < count; i++) {
      sink.add(blob.blob);
      await sink.flush();
    }

    var reminder = size % blocksize;
    if (reminder != 0) {
      sink.add(blob.blob.sublist(0, reminder));
    }
    await sink.close();
    return 0;
  }
}

class FileNameGenerator {
  static String next(String prefix) {
    return '${prefix}_${DateTime.now().toIso8601String()}.dat';
  }
}

class DiskFiller {
  DiskFiller({required this.path, required this.fillsize});

  int fill() {
    int size = fillsize;
    while (!isStop && size >= 0) {
      if (size >= GB) {
        RandomFile.generate(FileNameGenerator.next("dc"), size: GB);
        size -= GB;
      } else {
        RandomFile.generate(FileNameGenerator.next("dc"), size: size);
      }
    }
    return 0;
  }

  void stop() {
    isStop = true;
  }

  final String path;
  final int fillsize;
  bool isStop = false;
}

void main() async {
  RandomFile.generate(FileNameGenerator.next("dc"), size: MB);
}
