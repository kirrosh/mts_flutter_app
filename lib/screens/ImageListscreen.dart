import 'package:flutter/material.dart';

import 'SingleImageScreen.dart';

class ImageListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ListView(
          children: <Widget>[
            ListItem(
              fileName: '2736x3420.jpg',
              dimensionsTitle: '2736 X 3420',
            ),
            ListItem(
              fileName: '3567x5350.jpg',
              dimensionsTitle: '3567 X 5350',
            ),
            ListItem(
              fileName: '4000x2327.jpg',
              dimensionsTitle: '4000 X 2327',
            ),
            ListItem(
              fileName: '5472x3648.jpg',
              dimensionsTitle: '5472 X 3648',
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class ListItem extends StatelessWidget {
  final String fileName;
  final String dimensionsTitle;

  const ListItem({Key key, this.fileName, this.dimensionsTitle})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SingleImageScreen(
              fileName: this.fileName,
              dimensionsTitle: this.dimensionsTitle,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black87,
          border: Border.all(width: 1),
        ),
        height: 100,
        width: double.infinity,
        child: Center(
          child: Text(
            this.dimensionsTitle,
            style: TextStyle(
              fontSize: 25,
              color: Colors.blueGrey,
            ),
          ),
        ),
      ),
    );
  }
}
