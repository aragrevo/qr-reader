// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/providers/scan_list_provider.dart';
import 'package:qr_reader/providers/ui_provider.dart';
import 'package:qr_reader/utils/utils.dart';

import 'custom_empty.dart';

class ScanTiles extends StatelessWidget {
  final IconData icon;
  const ScanTiles({required this.icon});

  @override
  Widget build(BuildContext context) {
    final scanListProvider = Provider.of<ScanListProvider>(context);
    final uiProvider = Provider.of<UiProvider>(context);
    final scans = scanListProvider.scans;

    if (scans.isEmpty) {
      final selected = uiProvider.selectedMenuOption == 0;
      return CustomEmpty(
        title: selected ? 'No maps yet' : 'No address yet',
        subtitle: 'You can scan QR codes from your phone',
      );
    }

    return ListView.builder(
        itemCount: scans.length,
        itemBuilder: (_, index) => Dismissible(
              key: UniqueKey(),
              background: Container(
                color: Colors.red,
              ),
              onDismissed: (direction) {
                final id = scans[index].id;

                Provider.of<ScanListProvider>(context, listen: false)
                    .removeScan(id!);
              },
              child: ListTile(
                  leading: Icon(icon, color: Theme.of(context).primaryColor),
                  title: Text(scans[index].value),
                  subtitle: Text(scans[index].id.toString()),
                  trailing: const Icon(Icons.keyboard_arrow_right,
                      color: Colors.grey),
                  onTap: () {
                    launchUrl(context, scans[index]);
                  }),
            ));
  }
}
