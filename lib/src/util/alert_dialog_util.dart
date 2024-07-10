part of craft_dynamic;

class AlertUtil {
  static showAlertDialog(BuildContext context, String message,
      {isConfirm = false,
      isInfoAlert = false,
      showTitleIcon = true,
      formFields,
      title,
      confirmButtonText = "Ok",
      cancelButtonText = "Cancel"}) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      // user must tap button!
      pageBuilder: (BuildContext context, anim1, anim2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
            scale: curve,
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: AlertDialog(
                actionsPadding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
                insetPadding: const EdgeInsets.symmetric(horizontal: 44),
                titlePadding: const EdgeInsets.symmetric(vertical: 0),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                title: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 44),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8))),
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        title == null
                            ? const SizedBox()
                            : Text(
                                title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                        const SizedBox(
                          width: 8,
                        ),
                        showTitleIcon
                            ? isInfoAlert
                                ? Icon(
                                    Icons.info_outline,
                                    color: APIService.appPrimaryColor
                                        .withOpacity(.4),
                                    size: 28,
                                  )
                                : const Icon(
                                    Icons.error_outline,
                                    color: Colors.redAccent,
                                    size: 28,
                                  )
                            : const SizedBox()
                      ],
                    ))),
                content: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                        child: ListBody(
                      children: <Widget>[
                        Divider(
                          height: 0,
                          color: APIService.appPrimaryColor.withOpacity(.4),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Center(
                            child: Text(
                          message,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.normal),
                          textAlign: TextAlign.center,
                        )),
                        const SizedBox(
                          height: 24,
                        ),
                      ],
                    ))),
                actions: <Widget>[
                  Row(
                    mainAxisAlignment: isConfirm
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.center,
                    children: [
                      isConfirm
                          ? Row(
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                    child: Text(
                                      cancelButtonText,
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: APIService.appSecondaryColor),
                                    ).tr()),
                                const SizedBox(
                                  width: 12,
                                ),
                              ],
                            )
                          : const SizedBox(),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: Text(
                            confirmButtonText,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ).tr()),
                    ],
                  )
                ],
              ),
            ));
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static showModalBottomDialog(context, message) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
            padding:
                const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 4),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12))),
            child: ListView(
              shrinkWrap: true,
              children: [
                DynamicTextViewWidget(jsonText: message).render(),
                WidgetFactory.buildButton(context, () {
                  Navigator.of(context).pop();
                }, "Done")
              ],
            ));
      },
    );
  }
}
