import 'package:flutter/material.dart';

import '../ImageCompressor.dart';

class SingleImageScreen extends StatelessWidget {
  final String fileName;
  final String dimensionsTitle;

  const SingleImageScreen({Key key, this.fileName, this.dimensionsTitle})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.dimensionsTitle),
      ),
      body: Center(
        child: ImageCompressor(
          fileName: this.fileName,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
