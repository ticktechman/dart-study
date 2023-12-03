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

  Future<int> fill() async {
    int size = fillsize;
    while (!isStop && size > 0) {
      print(size);
      if (size >= GB) {
        await RandomFile.generate(FileNameGenerator.next(path + "/dc"), size: GB);
        size -= GB;
      } else {
        await RandomFile.generate(FileNameGenerator.next(path + "/dc"), size: size);
        size -= size;
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
  var df = DiskFiller(path: 'data', fillsize: GB + MB);
  await df.fill();
}
