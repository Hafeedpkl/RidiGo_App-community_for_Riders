import 'package:flutter/material.dart';
import 'package:ridigo/ui/community_chat/views/single_group.dart';

class ChatGroups extends StatelessWidget {
  const ChatGroups({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Community Chat'),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/profile-image.png'),
              radius: 25,
            ),
            title: Text('Group ${index + 1}'),
            subtitle: const Text(
              'admin : hello',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(title: 'Group ${index + 1}'),
                )),
          );
        },
        // separatorBuilder: (context, index) => Divider(),
      ),
    );
  }
}
