part of craft_dynamic;

class PermissionUtil {
  static checkRequiredPermissions() async {
    await _checkReadPhoneStatePermission();
    await _checkContactsPermission();
    await _checkCameraPermission();
    await _checkLocationPermission();
    await _checkStoragePermissions();
  }

  static _checkReadPhoneStatePermission() async {
    if (await Permission.phone.status.isDenied) {
      await Permission.phone.request();
    }
  }

  static _checkContactsPermission() async {
    if (await Permission.contacts.status.isDenied) {
      await Permission.contacts.request();
    }
  }

  static _checkCameraPermission() async {
    if (await Permission.camera.status.isDenied) {
      await Permission.camera.request();
    }
  }

  static _checkLocationPermission() async {
    if (await Permission.location.status.isDenied) {
      await Permission.location.request();
    }
  }

  static _checkStoragePermissions() async {
    if (await Permission.storage.status.isDenied) {
      await Permission.storage.request();
    }
  }
}
