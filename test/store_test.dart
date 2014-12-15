library tekartik_iodb.store_test;

// basically same as the io runner but with extra output
import 'package:tekartik_test/test_config_io.dart';
import 'package:sembast/database.dart';
import 'package:sembast/database_memory.dart';
import 'database_test.dart';

void main() {
  useVMConfiguration();
  defineTests(memoryDatabaseFactory);
}

void defineTests(DatabaseFactory factory) {

  group('store', () {

    Database db;

    setUp(() {
      return setupForTest(factory).then((Database database) {
        db = database;
      });
    });


    tearDown(() {
      db.close();
    });

    test('clear', () {
      Store store = db.getStore("test");
      return store.put("hi", 1).then((int key) {
        return store.clear();
      }).then((_) {
        return store.get(1).then((value) {
          expect(value, null);
        });
      });

    });

    test('delete', () {
      Store store = db.getStore("test");
      return db.deleteStore("test").then((_) {
        expect(db.findStore("test"), isNull);
      });

    });

    test('delete_main', () {
      Store store = db.getStore(null);
      return db.deleteStore(null).then((_) {
        expect(db.findStore(null), db.mainStore);
        expect(db.stores, [db.mainStore]);
        return db.deleteStore(db.mainStore.name).then((_) {
          expect(db.findStore(null), db.mainStore);
          expect(db.stores, [db.mainStore]);
        });
      });

    });

    test('put/get', () {
      Store store1 = db.getStore("test1");
      Store store2 = db.getStore("test2");
      return store1.put("hi", 1).then((int key) {
        expect(key, 1);
      }).then((_) {
        return store2.put("ho", 1).then((int key) {
          expect(key, 1);
        });
      }).then((_) {
        return store1.get(1).then((String value) {
          expect(value, "hi");
        });
      }).then((_) {
        return store2.get(1).then((String value) {
          expect(value, "ho");
        });
      }).then((_) {
        return db.reOpen().then((_) {
          return store1.get(1).then((String value) {
            expect(value, "hi");
          });
        }).then((_) {
          return store2.get(1).then((String value) {
            expect(value, "ho");
          });

        });
      });
    });
  });
}