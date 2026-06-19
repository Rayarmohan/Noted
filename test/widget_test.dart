import 'package:flutter_test/flutter_test.dart';
import 'package:noted/main.dart';

void main() {
  testWidgets('App renders', (WidgetTester tester) async {
    await tester.pumpWidget(const NotedApp());
    expect(find.byType(NotedApp), findsOneWidget);
  });
}
