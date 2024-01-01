import 'package:_24saat/Objects/Repair.dart';

void createRepairObject(
    {required DateTime dateReceive,
    required DateTime dateDelivery,
    required String nameCustomer,
    required String nameReceiver,
    required String watchBrand,
    required String watchModel,
    required String watchBand,
    required String watchPhoto,
    required String lastStatus,
    required String operation,
    required String code,
    required String customerPhone}) {
  // Create a Repair object using the provided parameters and store it in the database
  Repair newRepair = Repair(
      dateReceive: dateReceive,
      dateDelivery: dateDelivery,
      nameCustomer: nameCustomer,
      nameReceiver: nameReceiver,
      watchBrand: watchBrand,
      watchModel: watchModel,
      watchBand: watchBand,
      watchPhoto: watchPhoto,
      lastStatus: lastStatus,
      operation: operation,
      code: code,
      customerPhone: customerPhone);
  // Save the newRepair object to your database using your database logic
}
