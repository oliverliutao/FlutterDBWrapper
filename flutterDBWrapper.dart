
base on sqflite

-----------------


import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';


//dbName
//tbl_name
//{content: TEXT}

class SQFliteWrapper {

static final String dbName = "myappdatabase.db";
static final String keyString = "content";

static Future<String> initDb() async {

    var documentsDirectory = await getApplicationDocumentsDirectory();
    var path = join(documentsDirectory.path, dbName);

    // print(documentsDirectory);

    // make sure the folder exists
    if (!await new Directory(dirname(path)).exists()) {
     
      try {
        await new Directory(dirname(path)).create(recursive: true);
      } catch (e) {
        if (!await new Directory(dirname(path)).exists()) {
          print(e);
        }
      }
    }

    return path;
  }

static Future<bool> checkTable(String tableName) async {

    String path = await initDb();

    Database db = await openDatabase(path);

    List<Map<String, dynamic>> tables = await db.rawQuery("SELECT tbl_name FROM sqlite_master WHERE type = 'table'");
    // print("tables = $tables");

    db.close();

    for(int i = 0; i < tables.length; i++) {

      final item  = tables[i];

      if (item.containsValue(tableName)) {
  
        return true;
      }

    }

        return false;

}



  static createTable(String tableName) async {

    final exist = await SQFliteWrapper.checkTable(tableName);

    if (exist == true) {

      return;
    }

    String path = await initDb();

    Database db = await openDatabase(path);

    try {

        await db.execute("CREATE TABLE IF NOT EXISTS $tableName (id INTEGER PRIMARY KEY, $keyString TEXT)");

    } catch(e) {

        print("table already exist or something wrong");
    
    }finally {

      db.close();
    }

  }



//for store string value
  static cacheValue(String tableName, String value) async {

    final exist = await SQFliteWrapper.checkTable(tableName);

    if (exist == true) {

        String path = await initDb();

        Database db = await openDatabase(path);

        final count = await db.rawInsert('INSERT INTO $tableName ($keyString) VALUES(?)', [value]);

        print("count = $count");

        db.close();

      return;
    }

    String path = await initDb();

    Database db = await openDatabase(path);

    try {

        await db.execute("CREATE TABLE IF NOT EXISTS $tableName (id INTEGER PRIMARY KEY, $keyString TEXT)");

        final count = await db.rawInsert('INSERT INTO $tableName ($keyString) VALUES(?)', [value]);

        print("count = $count");

    } catch(e) {

        print("sqflite: cacheValue ---- table already exist or something wrong");
    
    }finally {

      db.close();
    }

  }




// static  insertValue(String tableName, String value) async {

//       String path = await initDb();

//       Database db = await openDatabase(path);

//       final count = await db.rawInsert('INSERT INTO $tableName ($keyString) VALUES(?)', [value]);

//       print("count = $count");

//       db.close();
//   }


//for retrieve value
static Future getValue(String tableName) async {

    String path = await initDb();

    Database db = await openDatabase(path);

    try {

      var dbResult =  await db.rawQuery("SELECT $keyString FROM $tableName");
      List list = dbResult;
      Map<String, dynamic> res = list.first;

      return res["content"];

    }catch(e) {

      print("sqflite: getValue --- something wrong");

    }finally {

        db.close();
    }
   
  }

  static updateValue(String tableName, dynamic value) async {

    String path = await initDb();

    Database db = await openDatabase(path);

    await db.rawUpdate(
          "UPDATE $tableName SET $keyString = ? ", [value]);

    db.close();

  }

  static deleteValue(String tableName) async {

    String path = await initDb();

    Database db = await openDatabase(path);

    final count = await db.rawDelete('DELETE FROM $tableName');

    print("count = $count");

    db.close();

  }
}

--------------

how to use?













shared_preference:

-------------------
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';


class SharedPreTool {

  
static SaveIntSP(String key, int value) async {

    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(key,value);

}

static Future<int> GetIntSP(String key) async {

    final prefs = await SharedPreferences.getInstance();

    final result = prefs.getInt(key);

    return result;

}

static SaveBoolSP(String key, bool value) async {

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key,value);

}

static Future<bool> GetBoolSP(String key) async {

    final prefs = await SharedPreferences.getInstance();

    final result = prefs.getBool(key);

    return result;

}

static SaveStringSP(String key, String value) async {

    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key,value);

}

static Future<String> GetStringSP(String key) async {

    final prefs = await SharedPreferences.getInstance();

    final result = prefs.getString(key);

    return result;

}

static SaveStringListSP(String key, List<String> value) async {

    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key,value);

}

static Future<List<String>> GetStringListSP(String key) async {

    final prefs = await SharedPreferences.getInstance();

    final result = prefs.getStringList(key);

    return result;

}

}
