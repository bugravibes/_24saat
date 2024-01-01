class Repair {
  DateTime dateReceive;
  DateTime dateDelivery;
  String nameCustomer;
  String nameReceiver;
  String watchBrand;
  String watchModel;
  String watchBand;
  String watchPhoto;
  String lastStatus;
  String operation;
  String code;
  String customerPhone;
//date_receive,date_delivery,name_customer,name_receiver,watch_brand,watch_model,watch_band,last_status,operation,code, customerPhone
  Repair(
      {required this.dateReceive,
      required this.dateDelivery,
      required this.nameCustomer,
      required this.nameReceiver,
      required this.watchBrand,
      required this.watchModel,
      required this.watchBand,
      required this.watchPhoto,
      required this.lastStatus,
      required this.operation,
      required this.code,
      required this.customerPhone});

  factory Repair.fromJson(Map<String, dynamic> json) {
    return Repair(
        dateReceive: DateTime.parse(json['date_receive']),
        dateDelivery:
            DateTime.parse(json['date_delivery'] ?? '1969-07-20 20:18:04Z'),
        nameCustomer: json['name_customer'],
        nameReceiver: json['name_receiver'],
        watchBrand: json['watch_brand'],
        watchModel: json['watch_model'] ?? 'model',
        watchBand: json['watch_band'] ?? 'band',
        //watchPhoto: json['watch_photo'],
        watchPhoto: json['watch_photo'] ?? '',
        lastStatus: json['last_status'] ?? 'null',
        operation: json['operation'],
        code: json['code'],
        customerPhone: json['customerPhone'] ?? 'girilmedi');
  }
}
