

import 'package:flutter/services.dart';
import 'package:groupstudy/services/logger.dart';

enum FlavorType {
  dev(type: 'dev'),
  prod(type: 'prod');

  final String type;

  const FlavorType({
    required this.type,
  });

  factory FlavorType.getByType(String? type) {
    switch (type) {
      case 'dev':
        return FlavorType.dev;

      case 'prod':
        return FlavorType.prod;

      default:
        throw Exception("Unknown Flavor Exception: $type");
    }
  }
}

class Flavor {
  Flavor._();

  static Future<void> init(Function(FlavorType) onInit) async {
    Logger logger = Logger('Flavor');

    // flavor = 'dev' | 'product'
    await const MethodChannel('flavor')
        .invokeMethod<String>('getFlavor').then((type) {
          logger.infoLog('start with flavor: $type');
          FlavorType flavor = FlavorType.getByType(type);
          onInit(flavor);
        });
  }
}