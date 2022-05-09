import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:qr_reader/models/scan_model.dart';
export 'package:qr_reader/models/scan_model.dart';

class DBProvider {
  static dynamic _database;
  static final DBProvider db = DBProvider._();
  static const String _table = 'Scans';
  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, 'ScansDB.db');
    print(path);

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Scans (id INTEGER PRIMARY KEY, type TEXT, value TEXT)');
    });
  }

  Future<int> newScan(ScanModel scan) async {
    final db = await database;
    final res = await db.insert(_table, scan.toJson());
    return res;
  }

  Future<List<ScanModel>> getScans() async {
    final db = await database;
    final response = await db.query(_table);

    return response.isNotEmpty
        ? response.map((e) => ScanModel.fromJson(e)).toList()
        : [];
  }

  Future<ScanModel?> getScan(int id) async {
    final db = await database;
    final response = await db.query(_table, where: 'id = ?', whereArgs: [id]);

    return response.isNotEmpty ? ScanModel.fromJson(response.first) : null;
  }

  Future<List<ScanModel>> getScansByType(String type) async {
    final db = await database;
    final response =
        await db.query(_table, where: 'type = ?', whereArgs: [type]);

    return response.isNotEmpty
        ? response.map((e) => ScanModel.fromJson(e)).toList()
        : [];
  }

  Future<int> updateScan(ScanModel scan) async {
    final db = await database;
    final res = await db
        .update(_table, scan.toJson(), where: 'id = ?', whereArgs: [scan.id]);
    return res;
  }

  Future<int> deleteScan(int id) async {
    final db = await database;
    final response = await db.delete(_table, where: 'id = ?', whereArgs: [id]);

    return response;
  }

  Future<int> deleteScans() async {
    final db = await database;
    final response = await db.delete(_table);

    return response;
  }
}
