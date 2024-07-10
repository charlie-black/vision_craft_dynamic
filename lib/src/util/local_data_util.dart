import '../../craft_dynamic.dart';

class LocalDataUtil {
  static refreshBeneficiaries(List<dynamic> beneficiaries) {
    AppLogger.appLogD(
        tag: "refreshing beneficiaries...", message: beneficiaries);
    final beneficiaryRepository = BeneficiaryRepository();
    List<Beneficiary> list = [];

    for (var beneficiary in beneficiaries) {
      list.add(Beneficiary.fromJson(beneficiary));
    }
    beneficiaryRepository.insertBeneficiaries(list);
  }
}
