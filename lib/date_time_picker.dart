import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dateTimePickerProvider = Provider<Future<DateTime?> Function()>(
  (_) => () => Future.value(
        clock.now(),
      ),
);
