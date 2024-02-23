import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mep/app/core/constants/color_constant.dart';
import 'package:mep/app/core/enums/space.dart';
import 'package:share_plus/share_plus.dart';
import 'package:mep/app/data/models/report_model.dart';
import 'package:mep/app/views/auth/register/register_service.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../my_reports/my_reports_page.dart';



class Buttons extends StatefulWidget {
  const Buttons({super.key,required this.report});
  final Report report;

  @override
  State<Buttons> createState() => _ButtonsState();
}

class _ButtonsState extends State<Buttons> {

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Button(
          onPressed: ()
          {
            final docUser = FirebaseFirestore
           .instance.collection('report').doc(widget.report.id);
            docUser.delete();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyReportsPage()),
            );
          },
          iconData: Icons.delete,
        ),
        SpaceWidth.m.value,
        Button(
          onPressed: () {
            Share.share( "I've just reported an environmental issue via MEP app here is the probleme scene: https://www.google.com/maps/search/?api=1&query=${widget.report.latitude.toString()},${widget.report.longitude.toString()}",);


          },
          iconData: Icons.share,
        ),
        SpaceWidth.m.value,
        Button(
          onPressed: ()
          {
            print("button is pressed");
          },
          iconData: Icons.edit,
        ),
        SpaceWidth.m.value,
        Button(
          onPressed: ()
          {
            _openmap(
                widget.report.latitude.toString()
                ,widget.report.longitude.toString());
          },
          iconData: Icons.location_on_outlined,
        ),
        SpaceWidth.m.value,
      ],
    );
  }

  Future <void> _openmap(String Latitude,String Longtitude)
  async {
     String googleURL=
         'https://www.google.com/maps/search/?api=1&query=$Latitude,$Longtitude';
     await canLaunchUrlString(googleURL)
      ? await launchUrlString(googleURL)
      : throw 'Could not reach the location';

  }
}

class Button extends StatelessWidget {
  final Function()? onPressed;
  final IconData iconData;
  const Button({
    super.key,
    required this.onPressed,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstant.backgroundColor),
      onPressed: onPressed,
      child: Center(
          child: Icon(
        color: Colors.black,
        iconData,
      )),
    );
  }
}
