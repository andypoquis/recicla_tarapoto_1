// lib/app/data/models/redeemed_incentive_with_user.dart

import 'redeemed_incentive_model.dart';

/// Combina la info del incentivo canjeado con la info del usuario (name, address).
class RedeemedIncentiveWithUser {
  final RedeemedIncentiveModel incentive; // Los campos del canje
  final String userName; // Nombre del usuario
  final String userAddress; // Dirección (u otros campos que necesites)

  RedeemedIncentiveWithUser({
    required this.incentive,
    required this.userName,
    required this.userAddress,
  });
}
