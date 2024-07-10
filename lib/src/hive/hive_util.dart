part of craft_dynamic;

class HiveBox<T> {
  static final Map<Type, HiveBox<dynamic>> _instances = {};

  factory HiveBox(Type type) {
    if (_instances.containsKey(type)) {
      return _instances[type] as HiveBox<T>;
    } else {
      final instance = HiveBox<T>._internal();
      _instances[type] = instance;
      return instance;
    }
  }

  HiveBox._internal();

  Box<T>? _box;

  Future<Box<T>?> getBox(String name) async {
    _box ??= await Hive.openBox<T>(name);
    return _box;
  }
}

class HiveUtil {
  static clearBoxCache(String boxName) async {
    final appDocumentDir =
        await path_provider.getApplicationDocumentsDirectory();
    final boxCacheDir = '${appDocumentDir.path}/.hive/$boxName';

    await Hive.box(boxName).close();
    await Hive.box(boxName).deleteFromDisk();
    await Hive.box(boxName).compact();

    // Delete the cache directory
    final cacheDir = Directory(boxCacheDir);
    if (await cacheDir.exists()) {
      await cacheDir.delete(recursive: true);
    }
  }

  static initializeHive() async {
    try {
      if (!Hive.isAdapterRegistered(19)) {
        await Hive.close();
        await Hive.initFlutter();
        Hive.registerAdapter(FaqAdapter());
        Hive.registerAdapter(MenuBorderAdapter());
        Hive.registerAdapter(MenuPropertiesAdapter());
        Hive.registerAdapter(BlockSpacingAdapter());
        Hive.registerAdapter(ModuleItemAdapter());
        Hive.registerAdapter(FormItemAdapter());
        Hive.registerAdapter(ActionItemAdapter());
        Hive.registerAdapter(UserCodeAdapter());
        Hive.registerAdapter(BankBranchAdapter());
        Hive.registerAdapter(AtmLocationAdapter());
        Hive.registerAdapter(ImageDataAdapter());
        Hive.registerAdapter(BranchLocationAdapter());
        Hive.registerAdapter(FrequentAccessedModuleAdapter());
        Hive.registerAdapter(BankAccountAdapter());
        Hive.registerAdapter(BeneficiaryAdapter());
        Hive.registerAdapter(ModuleToHideAdapter());
        Hive.registerAdapter(ModuleToDisableAdapter());
        Hive.registerAdapter(PendingTrxDisplayAdapter());
        Hive.registerAdapter(OnlineAccountProductAdapter());
        // Hive.registerAdapter(NotificationAdapter());
      }
    } catch (e) {
      AppLogger.appLogD(tag: "hive_util", message: e);
    }
  }
}
