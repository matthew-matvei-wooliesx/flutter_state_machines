import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/diagnostics.dart';
import 'package:flutter_state_machines/date_time_picker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final testTimeSnapshot = DateTime.now();

  group("Given picking a date is cancelled", () {
    final dateTimePicker = DialogDateTimePicker(
      datePicker: _pickNoDate,
      timePicker: _pickTime(TimeOfDay.now()),
    );

    test("Then nothing is returned", () async {
      expect(await dateTimePicker.pick(_FakeBuildContext()), isNull);
    });
  });

  group("Given picking a time is cancelled", () {
    final dateTimePicker = DialogDateTimePicker(
      datePicker: _pickDate(clock.now()),
      timePicker: _pickNoTime,
    );

    test("Then nothing is returned", () async {
      expect(await dateTimePicker.pick(_FakeBuildContext()), isNull);
    });
  });

  group("Given both a date and a time has been chosen", () {
    late DateTime tomorrow;
    late TimeOfDay time;

    withClock(Clock.fixed(testTimeSnapshot), () {
      tomorrow = clock.daysFromNow(1);
      time = TimeOfDay.now();
    });

    final dateTimePicker = DialogDateTimePicker(
      datePicker: _pickDate(tomorrow),
      timePicker: _pickTime(time),
    );

    test("Then the date and time are returned", () {
      withClock(Clock.fixed(testTimeSnapshot), () async {
        final result = await dateTimePicker.pick(_FakeBuildContext());

        expect(result, isNotNull);
        expect(result!.day, tomorrow.day);
        expect(result.month, tomorrow.month);
        expect(result.day, tomorrow.day);
        expect(result.hour, time.hour);
        expect(result.minute, time.minute);
      });
    });
  });
}

PickDate _pickDate(DateTime dateTime) => ({
      required context,
      required initialDate,
      required firstDate,
      required lastDate,
    }) async =>
        dateTime;

Future<DateTime?> _pickNoDate({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) async =>
    null;

PickTime _pickTime(TimeOfDay timeOfDay) => ({
      required BuildContext context,
      required TimeOfDay initialTime,
    }) async =>
        timeOfDay;

Future<TimeOfDay?> _pickNoTime({
  required BuildContext context,
  required TimeOfDay initialTime,
}) async =>
    null;

class _FakeBuildContext extends BuildContext {
  @override
  bool get debugDoingBuild => throw UnimplementedError();

  @override
  InheritedWidget dependOnInheritedElement(InheritedElement ancestor,
      {Object? aspect}) {
    throw UnimplementedError();
  }

  @override
  T? dependOnInheritedWidgetOfExactType<T extends InheritedWidget>(
      {Object? aspect}) {
    throw UnimplementedError();
  }

  @override
  DiagnosticsNode describeElement(String name,
      {DiagnosticsTreeStyle style = DiagnosticsTreeStyle.errorProperty}) {
    throw UnimplementedError();
  }

  @override
  List<DiagnosticsNode> describeMissingAncestor(
      {required Type expectedAncestorType}) {
    throw UnimplementedError();
  }

  @override
  DiagnosticsNode describeOwnershipChain(String name) {
    throw UnimplementedError();
  }

  @override
  DiagnosticsNode describeWidget(String name,
      {DiagnosticsTreeStyle style = DiagnosticsTreeStyle.errorProperty}) {
    throw UnimplementedError();
  }

  @override
  T? findAncestorRenderObjectOfType<T extends RenderObject>() {
    throw UnimplementedError();
  }

  @override
  T? findAncestorStateOfType<T extends State<StatefulWidget>>() {
    throw UnimplementedError();
  }

  @override
  T? findAncestorWidgetOfExactType<T extends Widget>() {
    throw UnimplementedError();
  }

  @override
  RenderObject? findRenderObject() {
    throw UnimplementedError();
  }

  @override
  T? findRootAncestorStateOfType<T extends State<StatefulWidget>>() {
    throw UnimplementedError();
  }

  @override
  InheritedElement?
      getElementForInheritedWidgetOfExactType<T extends InheritedWidget>() {
    throw UnimplementedError();
  }

  @override
  BuildOwner? get owner => throw UnimplementedError();

  @override
  Size? get size => throw UnimplementedError();

  @override
  void visitAncestorElements(bool Function(Element element) visitor) {}

  @override
  void visitChildElements(ElementVisitor visitor) {}

  @override
  Widget get widget => throw UnimplementedError();
}
