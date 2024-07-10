part of craft_dynamic;

class DynamicPostCall {
  static final _moduleRepo = ModuleRepository();
  static final _profileRepo = ProfileRepository();

  static showReceipt({required context, required postDynamic, moduleName}) {
    _profileRepo.getAllAccountBalancesAndSaveInAppState();
    Future.delayed(const Duration(milliseconds: 500), () {
      CommonUtils.getxNavigate(
          widget: TransactionReceipt(
        postDynamic: postDynamic,
        moduleName: moduleName,
      ));
    });
  }

  static navigateToStatusRoute(PostDynamic postDynamic, {moduleItem}) {
    Future.delayed(const Duration(milliseconds: 500), () {
      CommonUtils.getxPop(
          widget: RequestStatusScreen(
        postDynamic: postDynamic,
        moduleItem: moduleItem,
      ));
    });
  }

  static showOTPForm(PostDynamic postDynamic, ModuleItem moduleItem,
      FormItem? formItem, context, PreCallData? preCallData) async {
    AppLogger.appLogD(tag: "OTP DIALOG", message: "Opening otp dialog....");
    var result = await OTPForm.confirmOTPTransaction(
        context, moduleItem, formItem, preCallData);
    Provider.of<PluginState>(context, listen: false).setRequestState(false);
  }

  static processDynamicResponse(
      DynamicData? dynamicData, BuildContext context, String? controlID,
      {moduleItem, formItem}) {
    try {
      Provider.of<PluginState>(context, listen: false)
          .setScanValidationLoading(false);
      Provider.of<PluginState>(context, listen: false).setRequestState(false);
    } catch (e) {
      AppLogger.appLogD(tag: "loader error", message: e);
    }

    var builder = DynamicFactory.getPostDynamicObject(
        dynamicData); //Get a builder based on action type

    var postDynamic = PostDynamic(builder, context, controlID ?? "");

    switch (postDynamic.status) {
      case success:
        {
          if (postDynamic.opensDynamicRoute) {
            AppLogger.appLogD(
                tag: "dynamic postcall",
                message: "will show a bottom dialog/open a new sceen");
            postDynamic.formID != null &&
                    postDynamic.formID == FormId.ALERTCONFIRMATIONFORM.name
                ? AlertUtil.showModalBottomDialog(
                    postDynamic.context, postDynamic.jsonDisplay)
                : context.navigate(DynamicWidget(
                    nextFormSequence: postDynamic.nextFormSequence,
                    isWizard: true,
                    jsonDisplay: postDynamic.jsonDisplay,
                    formFields: postDynamic.formFields,
                    moduleItem: moduleItem,
                  ));
            break;
          }

          if (!postDynamic.isList) {
            var receiptDetails = postDynamic.receiptDetails;
            if (receiptDetails != null && receiptDetails.isNotEmpty) {
              showReceipt(
                  context: postDynamic.context,
                  postDynamic: postDynamic,
                  moduleName: moduleItem.moduleName);
              break;
            } else {
              navigateToStatusRoute(
                postDynamic,
                moduleItem: moduleItem,
              );
              break;
            }
          } else if (postDynamic.tappedButton || postDynamic.isList) {
            AppLogger.appLogD(
                tag: "DYNAMIC POSTCALL",
                message: "now opening a list page--->");
            CommonUtils.navigateToRoute(
                context: postDynamic.context,
                widget: ListDataScreen(
                    title: moduleItem!.moduleName,
                    widget: ListWidget(
                      moduleItem: moduleItem,
                      dynamicList: postDynamic.list,
                      summary: postDynamic.summary,
                      scrollable: true,
                      controlID: postDynamic.controlID,
                    )));
            break;
          }
        }
        break;
      case forgotpin:
        {
          _moduleRepo.getModuleById(ModuleId.FORGOTPIN.name).then((module) {
            try {
              context.navigate(DynamicWidget(
                moduleItem: module,
              ));
            } catch (e) {
              AppLogger.appLogD(tag: "Unable to route...", message: e);
            }
          });
        }
        break;
      case failure:
        {
          AlertUtil.showAlertDialog(
              context, postDynamic.message ?? "Please Try Again Later!",
              title: "Info");
        }
        break;
      case lowFailure:
        {
          AlertUtil.showAlertDialog(
              context, postDynamic.message ?? "Please Try Again Later!",
              title: "Info", isInfoAlert: true);
        }
        break;
      case token:
        {
          navigateToStatusRoute(
            postDynamic,
            moduleItem: moduleItem,
          );
        }
        break;
      case changeBankType:
        {
          navigateToStatusRoute(postDynamic, moduleItem: moduleItem);
        }
        break;
      case otp:
        {
          showOTPForm(postDynamic, moduleItem, formItem, context,
              dynamicData?.preCallData);
        }
        break;
      case changeLanguage:
        {
          navigateToStatusRoute(postDynamic, moduleItem: moduleItem);
        }
        break;
      default:
        {
          CommonUtils.showToast(postDynamic.message ?? "Try Again Later!");
        }
    }
  }
}
