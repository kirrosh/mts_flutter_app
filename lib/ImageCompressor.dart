import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class ImageCompressor extends StatefulWidget {
  final String fileName;

  const ImageCompressor({Key key, this.fileName}) : super(key: key);
  @override
  _ImageCompressorState createState() => _ImageCompressorState();
}

class _ImageCompressorState extends State<ImageCompressor> {
  ImageProvider provider;
  Size size = Size(0, 0);
  double yPosition = 0;
  bool isProgressBarShown = true;

  void _testCompressFile() async {
    setState(() {
      this.isProgressBarShown = true;
    });
    final img = AssetImage("img/${widget.fileName}");
    Size size = await calculateImageSize(img);
    print(size);
    final config = new ImageConfiguration();

    AssetBundleImageKey key = await img.obtainKey(config);
    final ByteData data = await key.bundle.load(key.name);
    final dir = await path_provider.getTemporaryDirectory();

    File file = File("${dir.absolute.path}/test.png");
    file.writeAsBytesSync(data.buffer.asUint8List());
    Size calculatedSize = calculateSize(size);
    List<int> list = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: calculatedSize.width.toInt(),
      minHeight: calculatedSize.height.toInt(),
    );
    ImageProvider provider = MemoryImage(Uint8List.fromList(list));

    Size compressedSize = await calculateImageSize(provider);
    print(compressedSize);
    setState(() {
      this.size = compressedSize;
      this.provider = provider;
      this.yPosition = 260;
      this.isProgressBarShown = false;
    });
  }

  void setDefaultSize(ImageProvider image) async {
    Size size = await calculateImageSize(image);
    setState(() {
      this.size = size;
      this.isProgressBarShown = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider img = AssetImage("img/${widget.fileName}");
    if (provider == null) {
      this.setDefaultSize(img);
    }
    return Column(
      children: <Widget>[
        this.isProgressBarShown
            ? LinearProgressIndicator()
            : Container(
                height: 6,
              ),
        FlatButton(
          child: Text('Compress file'),
          color: Colors.green,
          onPressed: _testCompressFile,
        ),
        Text('${this.size.width.toString()} X ${this.size.height.toString()}'),
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height - 300,
          child: Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Image(
                  image: provider ?? img,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
              new Align(
                alignment: Alignment.center,
                child: Container(
                  width: 200,
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white),
                    ),
                  ),
                ),
              ),
              new Align(
                alignment: Alignment.center,
                child: AnimatedContainer(
                  transform: Matrix4.translationValues(0, yPosition, 0),
                  duration: new Duration(seconds: 1),
                  child: ClipPath(
                    clipper: new MyClipper(),
                    child: Image(
                      image: provider ?? img,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Future<Size> calculateImageSize(ImageProvider image) {
  Completer<Size> completer = Completer();
  image.resolve(new ImageConfiguration()).addListener(
    ImageStreamListener(
      (ImageInfo image, bool synchronousCall) {
        var myImage = image.image;
        Size size = Size(myImage.width.toDouble(), myImage.height.toDouble());
        completer.complete(size);
      },
    ),
  );
  return completer.future;
}

Size calculateSize(Size size) {
  const maxSize = 1200;
  double scale = 1;
  if (size.width > size.height) {
    scale = maxSize / size.width;
  } else {
    scale = maxSize / size.height;
  }
  return Size(size.width * scale, size.height * scale);
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.moveTo(size.width / 2 - 100, size.height / 2 - 56.5);
    path.lineTo(size.width / 2 + 100, size.height / 2 - 56.5);
    path.lineTo(size.width / 2 + 100, size.height / 2 + 56.5);
    path.lineTo(size.width / 2 - 100, size.height / 2 + 56.5);
    path.lineTo(size.width / 2 - 100, size.height / 2 - 56.5);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
