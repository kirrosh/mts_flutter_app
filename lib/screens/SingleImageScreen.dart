import 'package:flutter/material.dart';

import '../ImageCompressor.dart';

class SingleImageScreen extends StatelessWidget {
  final String fileName;

  const SingleImageScreen({Key key, this.fileName}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ImageCompressor(
          fileName: this.fileName,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
