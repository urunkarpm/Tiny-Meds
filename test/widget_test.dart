import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiny_meds/main.dart';
import 'package:tiny_meds/presentation/providers/inventory_provider.dart';

void main() {
  testWidgets('TinyMedsApp renders inventory screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          filteredMedicinesProvider.overrideWith((ref) => Stream.value([])),
        ],
        child: const TinyMedsApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('My Medicines'), findsOneWidget);
  });
}
