import 'package:chat_app_v01/components/my_drawer.dart';
import 'package:chat_app_v01/components/user_tile.dart';
import 'package:chat_app_v01/pages/chat_page.dart';
import 'package:chat_app_v01/services/auth/auth_service.dart';
import 'package:chat_app_v01/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // chat & auth service
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //leading: Icon(Icons.home),
        foregroundColor: Colors.pinkAccent,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("HOME"),
        centerTitle: true,
      ),
      drawer: MyDrawer(),
      body: _buildUserList(),
    );
  }

  // build a list of users except for the current logged in user
  Widget _buildUserList(){
    return StreamBuilder(
      stream: _chatService.getUsersStreamExcludingBlocked(),
       builder: (context, snapshot) {
        // error
        if (snapshot.hasError) {
          return const Text("Error");
        }

        // loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        print(snapshot.data);

        // return list view
        return ListView(
          children: snapshot.data!
            .where((userData) => userData["email"] != _authService.getCurrentUser()!.email)
            .map<Widget>((userData) => _buildUserListItem(userData, context))
            .toList(),
        );
       },
    );
  }

  // build individual list tile for user
  Widget _buildUserListItem(
    Map<String, dynamic> userData, BuildContext context) {
    // display all user except current user

      return UserTile(
      text: userData["email"],
      onTap: () {
        // tapped on a user -> go to chat page
        Navigator.push(
          context,
          MaterialPageRoute(
          builder: (context) => ChatPage(
            receiverEmail: userData["email"],
            receiverID: userData["uid"],
          )
          ),
          );
      },
    );
    
  }


}