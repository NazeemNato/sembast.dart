@TestOn('browser')
library sembast_web.test.idb_io_simple_test;

import 'package:sembast/sembast.dart';
import 'package:sembast_web/sembast_web.dart' hide databaseFactoryWeb;
import 'package:sembast_web/src/browser.dart';
import 'package:test/test.dart';

var testPath = '.dart_tool/sembast_web/databases';

Future main() async {
  var factory = databaseFactoryWeb;

  group('web', () {
    test('notification', () async {
      var revisionFuture = storageRevisionStream.first;
      var store = StoreRef<String, String>.main();
      var record = store.record('key');
      await factory.deleteDatabase('test');
      var db = await factory.openDatabase('test');
      expect(await record.get(db), isNull);
      await record.put(db, 'value');
      expect(await record.get(db), 'value');

      var storageRevision = await revisionFuture;
      expect(storageRevision.name, 'test');
      expect(storageRevision.revision, greaterThanOrEqualTo(1));
      await db.close();
    });
  });
}