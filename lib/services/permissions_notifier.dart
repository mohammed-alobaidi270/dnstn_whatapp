import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dnstn_whatapp/services/permissions_services.dart';


final permissionNotifier =
    StateNotifierProvider<PermissionsNotifier, AsyncValue<bool>>((ref) {
  final PermissionsServices _permissionsServices =
      ref.read(permissionsServicesProvider);
  return PermissionsNotifier(null, false, _permissionsServices, ref);
});

class PermissionsNotifier extends StateNotifier<AsyncValue<bool>> {
  PermissionsNotifier(AsyncValue<bool>? state, this.permissionStatus,
      this._permissionsServices, this.ref)
      : super(const AsyncLoading()) {
    checkPermissions();
  }

  final bool? permissionStatus;
  final PermissionsServices _permissionsServices;
  final Ref ref;
  checkPermissions() async {
    state = await _permissionsServices.checkPermission();
  }
}
