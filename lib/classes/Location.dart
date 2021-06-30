import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:geolocator/geolocator.dart';
import 'package:optica/widgets/MyAlertDialog.dart';

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> determinePosition(context) async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    MyDialog(
      context: context,
      alertTitle: 'Ubicación GPS apagada',
      alertContent: 'Por favor, encienda la\nubicación GPS',
      buttonText: 'Ok',
      buttonAction: () => Phoenix.rebirth(context)
    ).createDialog();
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale 
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      MyDialog(
        context: context,
        alertTitle: 'Acceso GPS denegado',
        alertContent: 'Si no se concede acceso\na la ubicación GPS,\nla aplicación no puede funcionar',
        buttonText: 'Ok',
        buttonAction: () => Phoenix.rebirth(context)
      ).createDialog();

      return Future.error('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately. 
    MyDialog(
      context: context,
      alertTitle: 'Acceso GPS denegado\npermanentemente',
      alertContent: 'Se le ha denegado permanentemente\nla ubicación GPS a la aplicación.\nPor favor, conceda los permisos necesarios en los ajustes de su dispositivo',
      buttonText: 'Ok',
      buttonAction: () async {
        SystemNavigator.pop();
        await Geolocator.openAppSettings();
      }
    ).createDialog();
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}