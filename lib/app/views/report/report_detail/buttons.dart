import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mep/app/core/constants/color_constant.dart';
import 'package:mep/app/core/enums/space.dart';
import 'package:share_plus/share_plus.dart';
import 'package:mep/app/data/models/report_model.dart';

import '../my_reports/my_reports_page.dart';



class Buttons extends StatelessWidget {
  const Buttons({super.key,required this.report});
  final Report report;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Button(
          onPressed: ()
          {
            final docUser = FirebaseFirestore
           .instance.collection('report').doc(report.id);
            docUser.delete();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyReportsPage(userId: UserId,)),
            );
          },
          iconData: Icons.delete,
        ),
        SpaceWidth.m.value,
        Button(
          onPressed: () {
            Share.share( "I've just reported an environmental issue via MEP app",);

          },
          iconData: Icons.share,
        ),
        SpaceWidth.m.value,
        Button(
          onPressed: ()
          {},
          iconData: Icons.edit,
        ),
        SpaceWidth.m.value,
        Button(
          onPressed: () {},
          iconData: Icons.location_on_outlined,
        ),
        SpaceWidth.m.value,
      ],
    );
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
