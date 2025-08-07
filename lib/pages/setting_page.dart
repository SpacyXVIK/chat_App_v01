import 'package:chat_app_v01/pages/blocked_users_page.dart';
import 'package:chat_app_v01/themes/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        foregroundColor: Colors.pinkAccent,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: 
      
      // dark mode
      Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: EdgeInsets.only(left: 25, top: 10, right: 25),
                padding: EdgeInsets.only(
                  left: 25, right: 25, top: 20, bottom: 20
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
              
                    // dark mode
                    const Text(
                      "Dark Node",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        //color: Theme.of(context).colorScheme.inversePrime,
                      ),
                      ),
                
                    // switch toggle
                    CupertinoSwitch(
                      value: 
                        Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
                      onChanged: (value) => 
                        Provider.of<ThemeProvider>(context, listen: false)
                        .toggleTheme(),
                    ),
                  ],
                ),
              ),

              // blocked users
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: EdgeInsets.only(left: 25, top: 10, right: 25),
                padding: EdgeInsets.only(
                  left: 25, right: 25, top: 20, bottom: 20
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
              
                    // title
                    const Text(
                      "Blocked Users",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        //color: Theme.of(context).colorScheme.inversePrime,
                      ),
                      ),
                
                    // button to go to blocked use page
                    IconButton
                    (onPressed: () => Navigator.push(context, 
                    MaterialPageRoute(builder: (context) => BlockedUsersPage(),
                    )),
                    icon: Icon(
                    Icons.arrow_forward_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    ),),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}