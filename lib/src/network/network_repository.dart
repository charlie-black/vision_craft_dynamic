import '../../craft_dynamic.dart';

final _sharedPref = CommonSharedPref();
final _bankAccountRepository = BankAccountRepository();
final _beneficiaryRepository = BeneficiaryRepository();
final _frequentAccessedModulesRepository = FrequentAccessedModuleRepository();
final _moduleToDisableRepository = ModuleToDisableRepository();
final _pendingTransactionsRepository = PendingTrxDisplayRepository();
final _moduleToHideRepository = ModuleToHideRepository();
final _userCodeRepository = UserCodeRepository();
final _onlineAccountProductRepository = OnlineAccountProductRepository();
final _bankBranchRepository = BankBranchRepository();
final _imageDataRepository = ImageDataRepository();
final _atmLocationRepository = AtmLocationRepository();
final _branchLocationRepository = BranchLocationRepository();
final _moduleRepository = ModuleRepository();
final _formRepository = FormsRepository();
final _actionControlRepository = ActionControlRepository();
final _faqRepository = FaqRepository();

class UIDataRepository {
  addUIDataToDB({required UIResponse? uiResponse}) async {
    if (uiResponse?.formControl != null) {
      List<FormItem> forms = [];
      uiResponse?.formControl?.forEach((formItem) {
        try {
          forms.add(FormItem.fromJson(formItem));
        } catch (e) {
          AppLogger.appLogE(
              tag: "formitem insertion error at $formItem",
              message: e.toString());
        }
      });
      _formRepository.insertFormItems(forms);
    }
    if (uiResponse?.actionControl != null) {
      List<ActionItem> actions = [];

      uiResponse?.actionControl?.forEach((actionItem) {
        actions.add(ActionItem.fromJson(actionItem));
      });
      _actionControlRepository.insertActionControls(actions);
    }
    if (uiResponse?.module != null) {
      List<ModuleItem> modules = [];
      await _moduleRepository.closeBox();
      uiResponse?.module?.forEach((item) {
        try {
          modules.add(ModuleItem.fromJson(item));
        } catch (e) {
          AppLogger.appLogE(
              tag: "module insertion error at $item", message: e.toString());
        }
      });
      _moduleRepository.insertModuleItems(modules);
    }
  }
}

class UserAccountRepository {
  addUserAccountData(ActivationResponse activationResponse) async {
    List<BankAccount> userAccounts = [];
    List<Beneficiary> beneficiaries = [];
    List<ModuleToHide> modulesToHide = [];
    List<ModuleToDisable> modulesToDisable = [];
    List<PendingTrxDisplay> pendingTransactions = [];
    List<FrequentAccessedModule> frequentModules = [];

    _sharedPref.addUserAccountInfo(
        key: UserAccountData.FirstName.name,
        value: activationResponse.firstName);
    _sharedPref.addUserAccountInfo(
        key: UserAccountData.LastName.name, value: activationResponse.lastName);
    _sharedPref.addUserAccountInfo(
        key: UserAccountData.IDNumber.name, value: activationResponse.idNumber);
    _sharedPref.addUserAccountInfo(
        key: UserAccountData.EmailID.name, value: activationResponse.emailID);
    _sharedPref.addUserAccountInfo(
        key: UserAccountData.ImageUrl.name, value: activationResponse.imageUrl);
    _sharedPref.addUserAccountInfo(
        key: UserAccountData.LastLoginDateTime.name,
        value: activationResponse.lastLoginDate);
    _sharedPref.addUserAccountInfo(
        key: UserAccountData.Phone.name, value: activationResponse.phone);

    activationResponse.accounts?.forEach((item) {
      userAccounts.add(BankAccount.fromJson(item));
    });
    await _bankAccountRepository.insertBankAccounts(userAccounts);

    activationResponse.frequentAccessedModules?.forEach((item) {
      frequentModules.add(FrequentAccessedModule.fromJson(item));
    });
    await _frequentAccessedModulesRepository
        .insertFrequentModules(frequentModules);

    activationResponse.beneficiary?.forEach((item) {
      beneficiaries.add(Beneficiary.fromJson(item));
    });
    await _beneficiaryRepository.insertBeneficiaries(beneficiaries);

    activationResponse.modulesToHide?.forEach((item) {
      modulesToHide.add(ModuleToHide.fromJson(item));
    });
    await _moduleToHideRepository.insertModulesToHide(modulesToHide);

    activationResponse.modulesToDisable?.forEach((item) {
      modulesToDisable.add(ModuleToDisable.fromJson(item));
    });
    await _moduleToDisableRepository.insertModulesToDisable(modulesToDisable);

    activationResponse.pendingTransactions?.forEach((item) {
      pendingTransactions.add(PendingTrxDisplay.fromJson(item));
    });
    await _pendingTransactionsRepository
        .insertPendingTransactions(pendingTransactions);
  }
}

class StaticDataRepository {
  addStaticData(StaticResponse? staticResponse) async {
    await _sharedPref.addAppIdleTimeout(staticResponse?.appIdleTimeout);
    List<UserCode> userCodes = [];
    List<BranchLocation> branchLocations = [];
    List<BankBranch> bankBranches = [];
    List<AtmLocation> atms = [];
    List<OnlineAccountProduct> products = [];
    List<ImageData> images = [];
    List<Faq> faqs = [];

    staticResponse?.usercode?.forEach((item) {
      userCodes.add(UserCode.fromJson(item));
    });
    _userCodeRepository.insertUserCodes(userCodes);

    staticResponse?.onlineAccountProduct?.forEach((item) {
      products.add(OnlineAccountProduct.fromJson(item));
    });
    _onlineAccountProductRepository.insertOnlineAccountProducts(products);

    staticResponse?.bankBranch?.forEach((item) {
      bankBranches.add(BankBranch.fromJson(item));
    });
    _bankBranchRepository.insertBankBranches(bankBranches);

    staticResponse?.image?.forEach((item) {
      images.add(ImageData.fromJson(item));
    });
    _imageDataRepository.insertImages(images);

    staticResponse?.atmLocation?.forEach((item) {
      atms.add(AtmLocation.fromJson(item));
    });
    _atmLocationRepository.insertAtmLocations(atms);

    staticResponse?.branchLocation?.forEach((item) {
      branchLocations.add(BranchLocation.fromJson(item));
    });
    _branchLocationRepository.insertBranchLocations(branchLocations);

    staticResponse?.faqs?.forEach((item) {
      faqs.add(Faq.fromJson(item));
    });
    _faqRepository.insertFaqs(faqs);
  }
}
