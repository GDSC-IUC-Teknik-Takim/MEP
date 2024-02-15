import 'package:flutter/material.dart';

class ReportSuccesful extends StatelessWidget {
  const ReportSuccesful({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Container(
            width: 291.06,
            height: 444.26,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  color: Colors.white,
                  child: Image.asset(
                    'assets/images/basarili.png',
                    fit: BoxFit.contain,
                  ),
                ),
                Container(
                  width: 200,
                  height: 50,
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      "Report Successfully Completed. ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF325A3E),
                        fontWeight: FontWeight.bold, // Metni kalın yapar
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 200,
                  height: 100,
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      "Your report arrived authorities successfully. Just wait ... Muniplicity  arrive the scene asap.",
                      textAlign: TextAlign.center, // Metni ortala
                    ),
                  ),
                ),
                Container(
                  width: 300,
                  height: 100,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(30.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF325A3E), // Butonun arka plan rengi
                        onPrimary: Colors.white, // Buton metni rengi
                        padding: EdgeInsets.all(5.0), // Buton içi boşluk
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              38.0), // Butonun kenar yuvarlaklığı
                        ),
                      ),
                      onPressed: () {
                        // Butona basıldığında yapılacak işlemler buraya gelecek.
                      },
                      child: Text('Continue'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
