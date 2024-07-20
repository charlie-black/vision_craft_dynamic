// ignore_for_file: depend_on_referenced_packages

library craft_dynamic;

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:archive/archive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:collection/collection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:craft_dynamic/antochanges/loan_products.dart';
import 'package:craft_dynamic/src/builder/request_builder.dart';
import 'package:craft_dynamic/src/ui/dynamic_static/pdf_screen.dart';
import 'package:craft_dynamic/src/ui/dynamic_static/receipt_qr_code.dart';
import 'package:craft_dynamic/src/ui/dynamic_static/term_deposit_status.dart';
import 'package:craft_dynamic/src/ui/dynamic_static/viewpdf_screen.dart';
import 'package:craft_dynamic/src/ui/platform_components/platform_button.dart';
import 'package:craft_dynamic/src/util/config_util.dart';
import 'package:craft_dynamic/src/util/location_util.dart';
import 'package:craft_dynamic/src/util/notifications_util.dart';
import 'package:craft_dynamic/src/util/root_checker.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:encrypt/encrypt.dart' as encryptcrpto hide SecureRandom;
import 'package:encrypt/encrypt.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' hide Key;
import 'package:flutter/material.dart' hide Key;
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart'
    hide PhoneNumber;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' hide Response;
import "package:hex/hex.dart";
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';
import 'package:local_session_timeout/local_session_timeout.dart'
    hide SessionTimeoutState, SessionTimeoutManager;
// import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:logger/logger.dart';
import 'package:logging/logging.dart' as weblogger;
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path_provider/path_provider.dart';
import 'package:pem/pem.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pinput/pinput.dart';
import 'package:pointycastle/block/aes_fast.dart';
import 'package:pointycastle/block/modes/gcm.dart';
import 'package:pointycastle/pointycastle.dart' hide Padding;
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:unique_identifier/unique_identifier.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:vibration/vibration.dart';
import 'package:yaml/yaml.dart';

import '/src/providers/group_button_provider.dart';
import '/src/ui/dynamic_static/grouped_button.dart';
import '/src/ui/dynamic_static/list_screen.dart';
import 'antochanges/loan_list_screen.dart';
import 'src/builder/factory_builder.dart';
import 'src/native_binder/native_bind.dart';
import 'src/network/api_util.dart';
import 'src/network/connectivity_plus.dart';
import 'src/network/dynamic_request.dart';
import 'src/network/network_repository.dart';
import 'src/network/rsa_util.dart';
import 'src/session_manager/session_manager.dart';
import 'src/ui/dynamic_static/biometric_login.dart';
import 'src/ui/dynamic_static/request_status.dart';
import 'src/ui/dynamic_static/transactions_list.dart';
import 'src/ui/dynamic_static/view_beneficiary.dart';
import 'src/ui/dynamic_static/view_standing_order.dart';
import 'src/ui/forms/forms_list.dart';
import 'src/ui/modules/module_util.dart';
import 'src/ui/modules/modules_list.dart';
import 'src/ui/platform_components/platform_textfield.dart';
import 'src/util/clipper_util.dart';
import 'src/util/enum_formatter_util.dart';
import 'src/util/widget_util.dart';

part 'src/adapter/dropdown_adapter.dart';
part 'src/app_data/constants.dart';
part 'src/app_data/entity.dart';
part 'src/app_data/enums.dart';
part 'src/app_data/model.dart';
part 'src/app_data/model.g.dart';
part 'src/app_data/shared_pref.dart';
part 'src/hive/hive_repository.dart';
part 'src/hive/hive_util.dart';
part 'src/network/api_service.dart';
part 'src/network/dynamic_postcall.dart';
part 'src/repository/auth_repository.dart';
part 'src/repository/home_repository.dart';
part 'src/repository/init_repository.dart';
part 'src/repository/profile_repository.dart';
part 'src/session_manager/session_helper.dart';
part 'src/state/plugin_state.dart';
part 'src/ui/dynamic_components.dart';
part 'src/ui/dynamic_craft_wrapper.dart';
part 'src/ui/dynamic_screen.dart';
part 'src/ui/dynamic_static/blurr_load_screen.dart';
part 'src/ui/dynamic_static/list_data.dart';
part 'src/ui/dynamic_static/qr_scanner.dart';
part 'src/ui/dynamic_static/search_module_screen.dart';
part 'src/ui/dynamic_static/transaction_receipt.dart';
part 'src/ui/dynamic_widget_factory.dart';
part 'src/ui/forms/confirmation_form.dart';
part 'src/ui/forms/dynamic_form.dart';
part 'src/ui/forms/otp_form.dart';
part 'src/ui/modules/module_assets.dart';
part 'src/ui/modules/module_item.dart';
part 'src/util/alert_dialog_util.dart';
part 'src/util/biometric_util.dart';
part 'src/util/common_lib_util.dart';
part 'src/util/common_widgets_util.dart';
part 'src/util/crypt_util.dart';
part 'src/util/device_info_util.dart';
part 'src/util/extensions_util.dart';
part 'src/util/logger_util.dart';
part 'src/util/pdf_util.dart';
part 'src/util/permissions_util.dart';
part 'src/util/string_util.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  RemoteNotification? remoteNotification = message.notification;
  String? bigImage = message.data['image'];

  AppLogger.appLogD(tag: "main:backgroundnotification", message: message.data);
  // AppNotification appNotification = AppNotification(
  //   title: remoteNotification?.title,
  //   body: remoteNotification?.body,
  //   imageUrl: bigImage,
  // );
  // if (remoteNotification != null) {
  //   _firebaseUtil.saveNotificationToLocalDB(appNotification);
  // }
}
