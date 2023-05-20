import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:clipboard/clipboard.dart';

class ResultScreen extends StatelessWidget {
  final String text;

  const ResultScreen({super.key, required this.text});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Kết quả'),
          backgroundColor: const Color.fromARGB(255, 1, 40, 71),
        ),
        body: Container(
          padding: const EdgeInsets.all(30.0),
          child: Text(text),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            FlutterClipboard.copy(text);
            Fluttertoast.showToast(
              msg: 'Text copied to clipboard',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.grey[600],
              textColor: Colors.white,
              );
          }, 
          tooltip: 'Increment',
        label: const Text("Copy to clipboard"),
      ),
  );
}