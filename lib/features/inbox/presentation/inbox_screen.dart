import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../compose/presentation/compose_screen.dart';
import '../../email_detail/email_detail_screen.dart';
import '../provider/email_provider.dart';

class InboxScreen extends ConsumerWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emails = ref.watch(emailProvider);
    final emailState = ref.watch(emailProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Center(child: const Text("Inbox")),
        backgroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ComposeScreen()),
          );
        },
        icon: const Icon(Icons.edit, color: Colors.white,),
        label: const Text("Compose", style: TextStyle(color: Colors.white,),),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // This forces Riverpod to reload your emails
          ref.invalidate(emailProvider);
        },
        child: emailState.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Center(
                child: SizedBox(
                  width: 35.0,
                  height: 35.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 6,
                    // Thickness of the ring
                    backgroundColor: Colors.blueAccent,
                    // Grey ring behind
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white), // Moving part (white)
                  ),
                ),
              ),
            ),
          ),
        
          error: (e, _) => const Center(child: Text("Something went wrong")),
        
          data: (emails) {
            return ListView.separated(
              itemCount: emails.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final email = emails[index];
        
                return InkWell(
                  onTap: () {
                    ref.read(emailProvider.notifier).markAsRead(email.id);
        
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EmailDetailScreen(emailId: email.id),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
        
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.blueAccent,
                          child: Text(email.sender[0], style: TextStyle(color: Colors.white),),
                        ),
        
                        const SizedBox(width: 12),
        
        
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      email.sender,
                                      style: TextStyle(
                                        fontWeight: email.isRead
                                            ? FontWeight.normal
                                            : FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('hh:mm a').format(email.time),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: email.isRead
                                          ? FontWeight.normal
                                          : FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
        
                              const SizedBox(height: 4),
        
                              Text(
                                email.subject,
                                style: TextStyle(
                                  fontWeight: email.isRead
                                      ? FontWeight.normal
                                      : FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
        
                              const SizedBox(height: 2),
        
                              Text(
                                email.body,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}


