import 'package:fmanager/services/api/dio_api.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../services/storage_service.dart';
import 'common.dart';
import 'config.dart';

class Queue {
  static Box getQueueContainer() {
    return Get.put(StorageService()).getHiveBox('queue');
  }

  static putAt(int index, dynamic value) {
    List l = getQueueItems();
    l.remove(index);
    l.insert(index, value);
    getQueueContainer().put(
      Config().primaryCacheKey,
      l,
    );
  }

  static add(dynamic value) {
    List l = getQueueItems();

    l.add(value);

    getQueueContainer().put(
      Config().primaryCacheKey,
      l,
    );
  }

  static List getQueueItems() {
    return getQueueContainer().get(
      Config().primaryCacheKey,
      defaultValue: [],
    );
  }

  static getAt(int index) {
    List l = getQueueItems();
    return l[index];
  }

  static Future deleteAt(int index) async {
    List l = getQueueItems();
    l.removeAt(index);
    await getQueueContainer().put(
      Config().primaryCacheKey,
      l,
    );
  }

  static Future processQueue() async {
    var qc = getQueueItems();
    var queueLength = qc.length;
    var l = List.generate(queueLength, (index) => 0);

    for (var i in l) {
      var q = await getAt(i);
      await processQueueItem(q, i);
    }
  }

  static Future processQueueItem(var q, int index) async {
    try {
      var response = await DioApi().saveDocs(
        q["doctype"],
        q["data"][0],
      );

      if (response.statusCode == 200) {
        await deleteAt(index);
      } else {
        await putAt(
          index,
          {
            ...q,
            "error": response.statusMessage,
          },
        );
      }
    } catch (e) {
      print(e);
      putAt(
        index,
        {
          ...q,
          "error": (e as ErrorResponse).statusMessage,
        },
      );
    }
  }
}
