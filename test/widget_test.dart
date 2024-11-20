import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/app/modules/home/views/home_view.dart';

void main() {
  testWidgets('HomeView displays video and photo sections correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: HomeView(),
      ),
    );

    // Verify that the video and photo sections are displayed correctly.
    expect(find.text('Video Kuis'), findsOneWidget);
    expect(find.text('Foto Kuis'), findsOneWidget);

    // Verify that the 'Ambil Foto' button is present.
    expect(find.text('Ambil Foto'), findsOneWidget);

    // Simulate a tap on the 'Ambil Foto' button and trigger a frame.
    await tester.tap(find.text('Ambil Foto'));
    await tester.pump();

    // Verify that the photo section updates after tap.
    expect(find.text('Belum ada foto diambil.'), findsNothing);

    // Add additional tests to simulate interactions with video or photo sections.
    // For example, testing video tap interaction:
    expect(find.byType(Card), findsWidgets); // Verify if there are cards (for video and photo items).
  });

  testWidgets('Test video URL validation', (WidgetTester tester) async {
    // Simulate video URL being empty or invalid

    await tester.pumpWidget(
      MaterialApp(
        home: HomeView(),
      ),
    );

    // Assuming the controller will show a message for invalid URL
    // Add your assertions based on your behavior, such as snackbar for error.
    await tester.tap(find.byIcon(Icons.add)); // Simulating an action (e.g., triggering video tap)
    await tester.pump();

    // Check if the snackbar shows an error message about invalid URL
    expect(find.text('URL video tidak valid'), findsOneWidget);
  });
}
