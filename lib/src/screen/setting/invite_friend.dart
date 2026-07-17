import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/src/widget/text_widget.dart';


class Friend {
  final String name;
  final String phone;
  final String image;
  bool isInvited;

  Friend({
    required this.name,
    required this.phone,
    required this.image,
    this.isInvited = false,
  });
}

class InviteFriendsScreen extends StatefulWidget {
  const InviteFriendsScreen({super.key});

  @override
  State<InviteFriendsScreen> createState() => _InviteFriendsScreenState();
}

class _InviteFriendsScreenState extends State<InviteFriendsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: TextWidget(
          "Invite Friends".tr,
          color: isDark ? Colors.white : Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: friends.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          indent: 80,
          color: isDark ? Colors.white10 : Colors.grey.withValues(alpha: 0.1),
        ),
        itemBuilder: (context, index) {
          final friend = friends[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
            leading: CachedNetworkImage(
              imageUrl: friend.image,
              imageBuilder: (context, imageProvider) =>
                  CircleAvatar(radius: 30, backgroundImage: imageProvider),
              placeholder: (context, url) =>
                  CircleAvatar(
                      radius: 30,
                      backgroundColor: isDark ? Colors.white10 : Colors.grey[200]
                  ),
              errorWidget: (context, url, error) =>
                  CircleAvatar(
                      radius: 30,
                      backgroundColor: isDark ? Colors.white10 : Colors.grey[200],
                      child: Icon(Icons.person, color: isDark ? Colors.white54 : Colors.grey)
                  ),
            ),
            title: Text(
              friend.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            subtitle: Text(
              friend.phone,
              style: TextStyle(
                  color: isDark ? Colors.white54 : Colors.grey[600],
                  fontSize: 14
              ),
            ),
            trailing: _buildInviteButton(context, friend, () {
              setState(() {
                friend.isInvited = true;
              });
            }),
          );
        },
      ),
    );
  }

  Widget _buildInviteButton(BuildContext context, Friend friend, VoidCallback onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (friend.isInvited) {
      return OutlinedButton(
        onPressed: null,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
              color: isDark ? Colors.white24 : Colors.black12,
              width: 1
          ),
          shape: const StadiumBorder(),
          minimumSize: const Size(85, 36),
        ),
        child: TextWidget(
          "Invited".tr,
          color: isDark ? Colors.white38 : Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      );
    } else {
      return ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? Colors.white : Colors.black,
          foregroundColor: isDark ? Colors.black : Colors.white,
          elevation: 0,
          shape: const StadiumBorder(),
          minimumSize: const Size(85, 36),
        ),
        child: TextWidget(
          "Invite".tr,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      );
    }
  }
}
final List<Friend> friends = [

  Friend(
    name: "Tynisha Obey",
    phone: "+1-300-555-0135",
    image:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQq26kqWRjAAt1rLrxKBrWySNFaD6kUBGAByw&s",
  ),
  Friend(
    name: "Florencio Dorrance",
    phone: "+1-202-555-0136",
    image:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTHDRlp-KGr_M94k_oor4Odjn2UzbAS7n1YoA&s",
  ),
  Friend(
    name: "Chantal Shelburne",
    phone: "+1-300-555-0119",
    image:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQMkHji1MZ5nLrr_meHzKlmbr-qLtA_4G7S0w&s",
  ),
  Friend(
    name: "Maryland Winkles",
    phone: "+1-300-555-0161",
    image:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTAFEK6Nuc7lRA6mtKrXFgQX7TubFtK2pfiSw&s",
  ),
  Friend(
    name: "Rodolfo Goode",
    phone: "+1-300-555-0136",
    image:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRoqrPhgLfy8mj7ZjJmOXf1nZKvTgErfHSZfA&s",
  ),

  // 20 New Users
  Friend(
    name: "Benny Spanbauer",
    phone: "+1-202-555-0167",
    image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSyfB7PfEflBu-yk4ZQAb2kwhk87Li0KAoxhg&s",
  ),
  Friend(
    name: "Tyra Dhillon",
    phone: "+1-202-555-0119",
    image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTqZRH6g_ItZa02zbIjOQrmKmeFnLg8ZrLbnA&s",
  ),
  Friend(
    name: "Jamel Eusebio",
    phone: "+1-300-555-0171",
    image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTpKNXV1K4aBDUulpa35tGH6FtpxxpdZhR2CQ&s",
  ),
  Friend(
    name: "Pedro Huard",
    phone: "+1-202-555-0171",
    image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZY-xqB5QoO4zACtC1625x1ZdwOq6GTNOsUg&s",
  ),
  Friend(
    name: "Clinton Mcclure",
    phone: "+1-300-555-0135",
    image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR3ECIzvlEk8HIw_puDGggHWxSSgU5BJPKtWA&s",
  ),
  Friend(
    name: "Araceli Hanser",
    phone: "+1-202-555-0144",
    image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTjYT-tzw0aZb_nOJ7UTyMVXTlHzEnwlJJOfw&s",
  ),
  Friend(
    name: "Krystal Gonsalves",
    phone: "+1-300-555-0188",
    image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTg1wqBfdgfJcBXCjTJjCAAEKg76BPFn70ycw&s",
  ),
  Friend(
    name: "Demetrius Varga",
    phone: "+1-202-555-0199",
    image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSAm5FtDee8wW9EX4NXPUuVshmiUle7VDzGYw&s",
  ),
  Friend(
    name: "Liana Shull",
    phone: "+1-300-555-0122",
    image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTXNCcmomowr083Fjj46ulBqPJXVLnUAIHtlQ&s",
  ),
  Friend(
    name: "Marvin Pappas",
    phone: "+1-202-555-0155",
    image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRKq694cHIvq4lS60iBFG4MLiTmXhBilpNdAQ&s",
  ),
  Friend(
    name: "Aaliyah Morrow",
    phone: "+1-300-555-0147",
    image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSZHEqLoMXN9DbRDvUqFRZLzhpOqjxTBOTzNw&s",
  ),
  Friend(
    name: "Stefan Whitfield",
    phone: "+1-202-555-0128",
    image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTyNLv3ljOwODIX7g-VJ_c3MS59dDOmtZHPHA&s",
  ),
  Friend(
    name: "Elowen Thorne",
    phone: "+1-300-555-0166",
    image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTS1IPQiLoK0ycsRlIQe926lp3oIiQUiA_3ug&s",
  ),
  Friend(
    name: "Beckett Vance",
    phone: "+1-202-555-0133",
    image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcReeazMa3mc2Hq8fl65QzwV6rQ7qw70mSKq1g&s",
  ),
  Friend(
    name: "Seraphina Moon",
    phone: "+1-300-555-0144",
    image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRzpzFLsgQQvFbisFM5w55FMmf5w5dsQ6eQxw&s",
  ),
  Friend(
    name: "Jasper Thorne",
    phone: "+1-202-555-0111",
    image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTDSyHlfs7bgo41bylfffhGeQE5cFApuiOtfw&s",
  ),
  Friend(
    name: "Imogen Hayes",
    phone: "+1-300-555-0100",
    image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTLOEEY3jajroDKDyNt929iHEMKu5Xi-Na2xg&s",
  ),
  Friend(
    name: "Killian Draven",
    phone: "+1-202-555-0192",
    image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRR1ielZ5f892ogh2W9wjHS71Lo9tW66VU9Rw&s",
  ),
  Friend(
    name: "Nova Sterling",
    phone: "+1-300-555-0158",
    image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRjiqetoxDPNkopLWPsC8bu4-3eUhv3nmc1JQ&s",
  ),
  Friend(
    name: "Silas Vane",
    phone: "+1-202-555-0129",
    image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjSmgAPpLz4ePkYkAqNvMMOvtpp9cYKIGkZQ&s",
  ),
];
