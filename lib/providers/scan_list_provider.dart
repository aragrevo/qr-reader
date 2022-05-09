import 'package:flutter/material.dart';
import 'package:qr_reader/providers/db_provider.dart';

class ScanListProvider extends ChangeNotifier {
  List<ScanModel> scans = [];
  String currentType = 'http';

  Future<ScanModel> addScan(String value) async {
    final scan = ScanModel(value: value);
    final id = await DBProvider.db.newScan(scan);
    scan.id = id;
    if (currentType == 'http') {
      scans.add(scan);
      notifyListeners();
    }
    return scan;
  }

  loadScans() async {
    final scans = await DBProvider.db.getScans();
    this.scans = [...scans];
    notifyListeners();
  }

  loadScansByType(String type) async {
    final scans = await DBProvider.db.getScansByType(type);
    this.scans = [...scans];
    currentType = type;
    notifyListeners();
  }

  removeScans() async {
    await DBProvider.db.deleteScans();
    scans = [];
    notifyListeners();
  }

  removeScan(int id) async {
    await DBProvider.db.deleteScan(id);
    loadScansByType(currentType);
  }
}
