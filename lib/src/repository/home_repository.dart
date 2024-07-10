part of craft_dynamic;

final _moduleRepository = ModuleRepository();
final _hiddenModulesRepository = ModuleToHideRepository();
final _frequentAccessedModuleRepository = FrequentAccessedModuleRepository();

class HomeRepository {
  // Call this method to get main modules
  Future<List<ModuleItem>> getMainModules() async {
    List<ModuleItem> modules =
        await _moduleRepository.getModulesById("MAIN") ?? [];
    List<ModuleToHide>? hiddenModules =
        await _hiddenModulesRepository.getAllModulesToHide();
    hiddenModules?.forEach((hiddenModule) {
      try {
        modules.removeWhere(
            (element) => element.moduleId == hiddenModule.moduleId);
      } catch (e) {
        AppLogger.appLogE(tag: "modules get error", message: e.toString());
      }
    });
    return modules;
  }

  // Call this method to get tab modules
  Future<List<ModuleItem>?> getTabModules() async {
    List<ModuleItem>? modules = await _moduleRepository.getTabModules();
    List<ModuleToHide>? hiddenModules =
        await _hiddenModulesRepository.getAllModulesToHide();
    hiddenModules?.forEach((hiddenModule) {
      try {
        modules?.removeWhere(
            (element) => element.moduleId == hiddenModule.moduleId);
      } catch (e) {
        AppLogger.appLogE(tag: "tab modules error", message: e.toString());
      }
    });
    return modules;
  }

  Future<List<FrequentAccessedModule>> getFrequentlyAccessedModules() async {
    return _frequentAccessedModuleRepository.getAllFrequentModules();
  }
}
