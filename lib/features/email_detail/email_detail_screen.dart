import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../inbox/data/email_model.dart';
import '../inbox/provider/email_provider.dart';

class EmailDetailScreen extends ConsumerWidget {
  final String emailId;

  const EmailDetailScreen({super.key, required this.emailId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailState = ref.watch(emailProvider);

    return emailState.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),

      error: (e, _) => const Scaffold(
        body: Center(child: Text("Failed to load email")),
      ),

      data: (emails) {
        final email = emails.firstWhere(
              (e) => e.id == emailId,
        );

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(email.subject),
          ),

          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// Sender
                Text(
                  email.sender,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 8),

                /// Time
                Text(
                  DateFormat('dd MMM, hh:mm a').format(email.time),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 20),

                /// Body
                Text(
                  email.body,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}