import 'package:chat_app_v01/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {

  final String message;
  final bool isCurrentUser;
  final String messageId;
  final String userId;

  const ChatBubble({
  super.key,
  required this.message,
  required this.isCurrentUser,
  required this.messageId,
  required this.userId,
  });

  // show options
  void _showOptions(BuildContext context, String messageId, String userId){
    showModalBottomSheet(
      context: context, 
      builder: (context) {
        return SafeArea(
        child: Wrap(
          children: [
            // report meassage button
            ListTile(
              leading: const Icon(Icons.flag),
              title: const Text("Report"),
              onTap: () {
                Navigator.pop(context);
                _reportMessage(context, messageId, userId);
              },
            ),
            // block user button
            ListTile(
              leading: const Icon(Icons.block),
              title: const Text("Block user"),
              onTap: () {
                Navigator.pop(context);
                _blockUser(context, userId);
              },
            ),

            // cancel button
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text("Cancel"),
              onTap: () => Navigator.pop(context),
            )
          ],
        )
      );
      }
    );
  }

  // repot message 
  _reportMessage(BuildContext context, String messageId, String userId){
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text("Report Message"),
        content: const Text("Are you sure you want to report this meassge?"),
        actions: [
          // cancel button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),

          // report button
          TextButton(
            onPressed: () {
              ChatService().reportuser(messageId, userId);
              // dismiss dialog
              Navigator.pop(context);
              ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(
                content: Text("Message Reported")
                ));
            }, 
            child: const Text("Report"),
          ),
        ],
      )
    );
  }

  // block user
  _blockUser(BuildContext context, String userId){
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text("Block User"),
        content: const Text("Are you sure you want to block this user?"),
        actions: [
          // cancel button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),

          // block button
          TextButton(
            onPressed: () {
              // perform block
              ChatService().blockUser(userId);
              // dismiss dialog
              Navigator.pop(context);
              // dismiss page
              Navigator.pop(context);
              // let user know of result
              ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(
                content: Text("User Blocked")
                ));
            }, 
            child: const Text("Block"),
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        if (!isCurrentUser) {
          // show options
          _showOptions(context, messageId, userId);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isCurrentUser ? Colors.greenAccent : Colors.grey.shade600,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        child: Text(
          message,
          style: TextStyle(color: isCurrentUser ? Colors.black : Colors.white),
          ),
      ),
    );
  }
}