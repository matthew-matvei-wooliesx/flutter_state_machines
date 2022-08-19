import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dateTimePickerProvider = Provider<DateTimePicker>(
  (_) => DialogDateTimePicker(
    datePicker: showDatePicker,
    timePicker: showTimePicker,
  ),
);

abstract class DateTimePicker {
  Future<DateTime?> pick(BuildContext context);
}

typedef PickTime = Future<TimeOfDay?> Function({
  required BuildContext context,
  required TimeOfDay initialTime,
});

typedef PickDate = Future<DateTime?> Function({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
});

class DialogDateTimePicker implements DateTimePicker {
  final PickDate _datePicker;
  final PickTime _timePicker;

  DialogDateTimePicker({
    required PickDate datePicker,
    required PickTime timePicker,
  })  : _datePicker = datePicker,
        _timePicker = timePicker;

  @override
  Future<DateTime?> pick(BuildContext context) async {
    final date = await _datePicker(
      context: context,
      firstDate: clock.daysAgo(7),
      initialDate: clock.now(),
      lastDate: clock.daysFromNow(7),
    );

    if (date == null) {
      return null;
    }

    final time = await _timePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(clock.now()),
    );

    if (time == null) {
      return null;
    }

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }
}
