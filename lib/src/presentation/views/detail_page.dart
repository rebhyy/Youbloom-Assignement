import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final String item;

  const DetailPage({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Page')),
      body: Center(
        child: Text('Detail of: $item'),
      ),
    );
  }
}
