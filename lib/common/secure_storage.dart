import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageKeys {
  static String id = "id";
}

class SecureStorage {
  static AndroidOptions getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
  static const iosOptions =
      IOSOptions(accessibility: KeychainAccessibility.first_unlock);

  static Future<dynamic> read(String key) async {
    try {
      const FlutterSecureStorage storage = FlutterSecureStorage();
      return storage.read(
          key: key, aOptions: getAndroidOptions(), iOptions: iosOptions);
    } catch (error) {
      return null;
    }
  }

  static Future<dynamic> write(String key, String value) async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    storage.write(
        key: key,
        value: value,
        aOptions: getAndroidOptions(),
        iOptions: iosOptions);
  }

  static Future<dynamic> delete(String key) async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    storage.delete(
        key: key, aOptions: getAndroidOptions(), iOptions: iosOptions);
  }

  static Future<dynamic> readAll() async {
    try {
      const FlutterSecureStorage storage = FlutterSecureStorage();
      return storage.readAll(
          aOptions: getAndroidOptions(), iOptions: iosOptions);
    } catch (error) {
      return null;
    }
  }

  static Future<dynamic> deleteAll(String key) async {
    try {
      const FlutterSecureStorage storage = FlutterSecureStorage();
      return storage.deleteAll(
          aOptions: getAndroidOptions(), iOptions: iosOptions);
    } catch (error) {
      return null;
    }
  }
}
