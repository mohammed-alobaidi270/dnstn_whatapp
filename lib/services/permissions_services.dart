import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;

final permissionsServicesProvider =
    Provider<PermissionsServices>((ref) => PermissionsServices());

class PermissionsServices {
  Future<AsyncValue<bool>> checkPermission() async {
    if (Platform.isAndroid || Platform.isIOS) {
      // final serviceStatus = await Permission.locationWhenInUse.serviceStatus;
      // final isGpsOn = serviceStatus == ServiceStatus.enabled;

      // if (!isGpsOn) {
      //   print('Turn on location services before requesting permission.');
      // }

      // final status = await Permission.locationWhenInUse.request();
      // final statusCamera = await Permission.camera.request();
      // You can request multiple permissions at once.
      Map<Permission, PermissionStatus> statuses = await [
        Permission.contacts,
        Permission.phone,
      ].request();

      if (statuses[Permission.location] == PermissionStatus.granted &&
          statuses[Permission.camera] == PermissionStatus.granted) {
        if (kDebugMode) {
          print('Permission granted');
        }
        return const AsyncData(true);
      } else if (statuses[Permission.camera] == PermissionStatus.denied ||
          statuses[Permission.location] == PermissionStatus.denied) {
        if (kDebugMode) {
          print(
            'Permission denied. Show a dialog and again ask for the permission');
        }
        return const AsyncError(false);
      } else if (statuses[Permission.camera] ==
              PermissionStatus.permanentlyDenied ||
          statuses[Permission.location] == PermissionStatus.permanentlyDenied) {
        if (kDebugMode) {
          print('Take the user to the settings page.');
        }
        await openAppSettings();
        // return const AsyncError(false);
      }
      return const AsyncError(false);
    } else {
      return const AsyncData(true);
    }
  }
}
