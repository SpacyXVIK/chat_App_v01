import 'package:chat_app_v01/components/chat_bubble.dart';
import 'package:chat_app_v01/components/my_textfield.dart';
import 'package:chat_app_v01/services/auth/auth_service.dart';
import 'package:chat_app_v01/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {

  final String receiverEmail;
  final String receiverID;

  ChatPage({
  super.key,
  required this.receiverEmail,
  required this.receiverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // Text controller
  final TextEditingController _messageController = TextEditingController();

  // chat & auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  // for textfield focus
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // add listener to focus node
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        // cause a delay so that the keyboard has time to show up
        // then the amount of reamining space will be calculated
        // then scroll down
        Future.delayed(const Duration(milliseconds: 500),
        () => scrollDown(),
        );
      }
    });

    // wait a bit for listview to be built, then scroll to buttom
    Future.delayed(
    const Duration(milliseconds: 500),
    () => scrollDown(),
    );
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // scroll controller
  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent, 
      duration: const Duration(milliseconds: 500), 
      curve: Curves.fastOutSlowIn,
    );
  }

  // send message
  void sendMessage() async{
    // if there is something inside the textfield
    if (_messageController.text.isNotEmpty) {
      // send meassge
      await _chatService.sendMessage(widget.receiverID, _messageController.text);

      //  clear text controller
      _messageController.clear();
    }

    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail),
        foregroundColor: Colors.pinkAccent,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // display al messages
          Expanded(
            child: _buildMassageList(),
          ),

          // user input
          _buildUserInput(),

        ],
      ),
    );
  }

  // build meassge list
  Widget _buildMassageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverID, senderID), 
      builder: (context, snapshot){
        // errors
        if (snapshot.hasError) {
          return const Text("Error");
        }

        // lodaing 
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        // returnlist view
        return ListView(
          controller: _scrollController,
          children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      }
    );
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // is current user
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;

    // align message to the right if sender if sender is the current user, otherwise left
    var alignment = 
      isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;



    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: 
          isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(
          message: data["message"], 
          isCurrentUser: isCurrentUser,
          messageId: doc.id,
          userId: data["senderID"],
        ),
        ],
      ),
    );
  }

  // build meassge input
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Row(
        children: [
          // text field should take up most of the space
          Expanded(
            child: MyTextfield(
              hintText: "Type a message",
              obsecure: false,
              controller: _messageController,
              focusNode: myFocusNode,
            )
          ),
      
          // send Button
          Container(
            decoration: BoxDecoration(
              color: Colors.greenAccent,
              shape: BoxShape.circle,
            ),
            margin: EdgeInsets.only(right: 25),
            child: IconButton(
            onPressed: sendMessage,
            icon: Icon(Icons.arrow_upward),
            ),
          ),
        ],
      ),
    );
  }
}