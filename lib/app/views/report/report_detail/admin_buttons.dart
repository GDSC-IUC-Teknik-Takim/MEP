import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mep/app/core/constants/color_constant.dart';
import 'package:mep/app/core/enums/space.dart';
import 'package:share_plus/share_plus.dart';
import 'package:mep/app/data/models/report_model.dart';
import 'package:mep/app/views/auth/register/register_service.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../my_reports/my_reports_page.dart';



class AdminButtons extends StatefulWidget {
  const AdminButtons({Key? key, required this.report}) : super(key: key);

  final Report report;

  @override
  _AdminButtonsState createState() => _AdminButtonsState();
}

class _AdminButtonsState extends State<AdminButtons> {
  @override
  Widget build(BuildContext context) {
    print('AdminButtons rebuild');

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Button(
          onPressed: () async {
            final docUser = FirebaseFirestore.instance.collection('report').doc(widget.report.id);
            await docUser.delete();
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
            Share.share("I've just reported an environmental issue via MEP app here is the problem scene: https://www.google.com/maps/search/?api=1&query=${widget.report.latitude.toString()},${widget.report.longitude.toString()}");
          },
          iconData: Icons.share,
        ),
        SpaceWidth.m.value,
        Button(
          onPressed: () {
            setState(() {
              if (widget.report.status == 'We have received') {
                widget.report.status = 'We are addressing';
              } else if (widget.report.status == 'We are addressing') {
                widget.report.status = 'We are unable to resolve due to technical difficulties.';
              } else if (widget.report.status == 'We are unable to resolve due to technical difficulties.') {
                widget.report.status = 'Resolved';
              } else if (widget.report.status == 'Resolved') {
                widget.report.status = 'We have received';
              }
            });

            final docUser = FirebaseFirestore.instance.collection('report').doc(widget.report.id);
            docUser.update({'status': widget.report.status});
          },
          iconData: Icons.edit,
        ),
        SpaceWidth.m.value,
        Button(
          onPressed: () {
            _openmap(widget.report.latitude.toString(), widget.report.longitude.toString());
          },
          iconData: Icons.location_on_outlined,
        ),
        SpaceWidth.m.value,
      ],
    );
  }

  Future<void> _openmap(String latitude, String longitude) async {
    final googleURL = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    await canLaunchUrlString(googleURL) ? await launchUrlString(googleURL) : throw 'Could not reach the location';
  }
}

class Button extends StatelessWidget {
  final Function()? onPressed;
  final IconData iconData;

  const Button({Key? key, required this.onPressed, required this.iconData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorConstant.backgroundColor,
      ),
      onPressed: onPressed,
      child: Center(
        child: Icon(
          color: Colors.black,
          iconData,
        ),
      ),
    );
  }
}
