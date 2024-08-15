import 'package:flutter/material.dart';

class TCircularLoader extends StatelessWidget {
  const TCircularLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
            ),
          ],
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
            ),
            SizedBox(height: 20),
            Text(
              'Loading...',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
