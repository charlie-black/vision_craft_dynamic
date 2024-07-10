import 'package:geolocator/geolocator.dart';

class LocationUtil {
  static getLatLong() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (serviceEnabled) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return {
        "lat": position.latitude.toString(),
        "long": position.longitude.toString()
      };
    }

    return {"lat": "0.0000", "long": "0.0000"};
  }
}
