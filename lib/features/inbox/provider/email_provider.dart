import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/email_model.dart';


final emailProvider =
StateNotifierProvider<EmailNotifier, AsyncValue<List<Email>>>((ref) {
  return EmailNotifier();
});

class EmailNotifier extends StateNotifier<AsyncValue<List<Email>>> {
  EmailNotifier() : super(const AsyncLoading()) {
    loadEmails();
  }

  Future<void> loadEmails() async {
    await Future.delayed(const Duration(seconds: 2)); // simulate API

    state = AsyncData(List.generate(
      10,
          (index) => Email(
        id: '$index',
        sender: 'Sender $index',
        subject: 'Subject $index',
        body: 'This is the full email body for email $index',
        time: DateTime.now().subtract(Duration(minutes: index * 5)),
      ),
    ));
  }

  void markAsRead(String id) {
    state.whenData((emails) {
      state = AsyncData([
        for (final email in emails)
          if (email.id == id)
            Email(
              id: email.id,
              sender: email.sender,
              subject: email.subject,
              body: email.body,
              time: email.time,
              isRead: true,
            )
          else
            email
      ]);
    });
  }

  void addEmail(Email email) {
    state.whenData((emails) {
      state = AsyncData([email, ...emails]);
    });
  }
}