import 'dart:developer';

import 'package:flutter/foundation.dart';

void debugLog(String message) {
  if (kDebugMode) {
    log(message);
  }
}
