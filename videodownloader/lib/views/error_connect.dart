import 'package:flutter/material.dart';

class ErrorConnectionView extends StatefulWidget {
  Function? onclick;
  ErrorConnectionView({Key? key, this.onclick}) : super(key: key);

  @override
  _ErrorConnectionViewState createState() => _ErrorConnectionViewState();
}

class _ErrorConnectionViewState extends State<ErrorConnectionView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/image_connection.png'),
          Container(
            margin: const EdgeInsets.fromLTRB(24, 8, 24, 8),
            child: const Center(
              child: Text(
                "Error Connection" ,
                textAlign: TextAlign.center,
              ),
            ),
          ),

        ],
      ),
    );
  }


}