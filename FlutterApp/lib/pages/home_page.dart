import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left:20),
      //Vertical divide the screen into 2 parts
      child: Column(
        children: [
          //Left part
          Expanded(
            flex: 69,
            child: Container(
              alignment: Alignment.topLeft,
              child: const Text(
                'SMARTPOLE DASHBOARD',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                )
              )
              ),
            ),
          //Right part
          Expanded(
            flex: 863,
            child: Container(
              //Horizontal divide the screen into 2 parts
              child: Row(
                children: [
                  //Left part
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.red,
                      ),
                    ),
                  //Right part
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.green,
                    ),
                  ),
                ],
              )
            ),
          ),
        ],
      ),
    );
  }
}
