import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {

  final String text;
  final void Function()? onTap;

  const UserTile({
    super.key,
    required this.text,
    required this.onTap,
    });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.greenAccent,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            // icon
            Icon(Icons.person),

            SizedBox(width: 20),

            // user name
            Text(
              text, 
              style: TextStyle(
                color: Colors.black,
                 fontSize: 20,
                 fontWeight: FontWeight.bold
                )
              ),
          ],
        ),
      ),
    );
  }
}