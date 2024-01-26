import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nexus/screens.dart/InsertCodeScreen.dart';
import 'package:nexus/screens.dart/ProfileScreen.dart';
import 'package:nexus/widgets/ChatListTile.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key, required this.title});

  final String title;

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              letterSpacing: 15,
            ),
          ),
        ),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(EvaIcons.search)),
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                  constraints: BoxConstraints.loose(
                    Size(MediaQuery.of(context).size.width,
                        MediaQuery.of(context).size.height * 0.85),
                  ),
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => const ProfileScreen());
            },
            icon: const Icon(EvaIcons.person),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        margin: const EdgeInsets.only(top: 0),
        child: ListView(
          padding: EdgeInsets.zero,
          dragStartBehavior: DragStartBehavior.down,
          children: const [
            ChatListTile(
              title: "Edis Davis",
              lastMessage: "Did you do your homework?",
            ),
            ChatListTile(
              title: "Kirli Cekim",
              lastMessage: "Don't forget my food!!",
            ),
            ChatListTile(
              title: "Edis Davis",
              lastMessage: "Did you do your homework?",
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context, builder: (_) => const InsertCodeScreen());
        },
        backgroundColor: Colors.white,
        elevation: 20,
        child: const Icon(EvaIcons.codeDownload),
      ),
    );
  }
}
