import 'package:flutter/foundation.dart';

abstract class Urls {
  static String baseUrl =
      kIsWeb ? 'http://localhost:3000' : 'http://10.0.2.2:3000';
}
