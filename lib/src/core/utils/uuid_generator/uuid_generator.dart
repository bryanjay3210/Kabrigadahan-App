import 'package:kabrigadan_mobile/src/core/utils/shared_preferences/get_preferences.dart';
import 'package:uuid/uuid.dart';

class UuidGenerator{
  var uuid = const Uuid();
  var nowYear = DateTime.now().year;

  Future<String> generateUuid() async {
    String uid = uuid.v4();
    String tempId = uid.substring(uid.length - 8);
    Map<String, dynamic> brigadahanFundsSettings = await GetPreferences().getBrigadahanFoundationFundsSettings();
    String brigadahanFundsCode = brigadahanFundsSettings["brigadahanFoundationFundsCode"].toString();

    String generatedUuid = "$brigadahanFundsCode${nowYear.toString()}$tempId";

    return generatedUuid;
  }
}