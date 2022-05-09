import 'package:flutter/cupertino.dart';
import 'package:qr_reader/models/scan_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

void launchUrl(BuildContext context, ScanModel scan) async {
  if (scan.type == ScanType.http.name) {
    final url = scan.value;
    if (!await canLaunchUrlString(url)) throw 'Could not launch $url';
    await launchUrlString(url);
  }
  if (scan.type == ScanType.geo.name) {
    Navigator.pushNamed(context, 'maps', arguments: scan);
  }
}
