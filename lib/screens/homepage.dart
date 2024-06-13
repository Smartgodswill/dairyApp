import 'package:bookapp/auth/authflow.dart';
import 'package:bookapp/custom.dart/appname.dart';
import 'package:bookapp/custom.dart/note_card.dart';
import 'package:bookapp/themes/const.dart';
import 'package:bookapp/design/dimBackgroundimages.dart';
import 'package:bookapp/domain/notescreen.dart';
import 'package:bookapp/domain/weeklycalendar.dart';
import 'package:bookapp/domain/notereaderScreen.dart';
import 'package:bookapp/providers/usersprovider.dart';
import 'package:bookapp/subPages/aboutUsPage.dart';
import 'package:bookapp/subPages/mePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = '';
  String imageUrl = "";
  String currentDate = DateFormat('dd MMMM,yyyy').format(DateTime.now());
  final currentUser = FirebaseAuth.instance;

  void getUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection('collectionPath')
          .doc(user.uid)
          .get();
      if (snap.exists) {
        setState(() {
          userName = snap["userName"];
          imageUrl = snap["images"];
        });
        print(snap.data());
      }
    }
  }

  @override
  void initState() {
    getUserName();
    super.initState();
  }

  List<String> diaryTypes = [
    "Success\n diary",
    "Gratitude\n diary",
    "Emotional\n diary",
    "Story\n diary",
    "Note\n diary",
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authController = Provider.of<AuthRemote>(context);
    return Scaffold(
      backgroundColor: kblackcolor,
      appBar: AppBar(
        backgroundColor: kbackgroundColor,
        title: Text(
          currentDate,
          style: GoogleFonts.acme(
              fontSize: 20, fontWeight: FontWeight.bold, color: kwhitecolor),
        ),
        actions: [
          MaterialButton(
              onPressed: () {},
              child: Text(
                '😆Mood!',
                style: GoogleFonts.acme(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: kwhitecolor),
              )),
          Stack(
            children: [
              if (imageUrl.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                )
              else
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/images.png"),
                  ),
                ),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: kColoredcolor,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                          'assets/female.jpg',
                        ),
                        fit: BoxFit.cover)),
                margin: const EdgeInsets.only(top: 10),
                height: size.width / 1.5,
                width: size.width,
                child: DimImages(child: AppNameAnimation()),
              ),
              ListTile(
                leading: Text(
                  'Settings',
                  style: GoogleFonts.acme(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: kblackcolor),
                ),
                trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.settings,
                      size: 20,
                    )),
              ),
              ListTile(
                leading: Text(
                  'About us',
                  style: GoogleFonts.acme(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: kblackcolor),
                ),
                trailing: IconButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const AboutUsPage();
                      }));
                    },
                    icon: const Icon(
                      Icons.info_sharp,
                      size: 20,
                    )),
              ),
              ListTile(
                leading: Text(
                  'Me',
                  style: GoogleFonts.acme(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: kblackcolor),
                ),
                trailing: IconButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ChangeNotifierProvider<UserProvider>(
                            create: (_) => UserProvider(),
                            child:
                                MePage(UserName: userName, imageUrl: imageUrl));
                      }));
                    },
                    icon: const Icon(
                      Icons.person,
                      size: 20,
                    )),
              ),
              ListTile(
                leading: Text(
                  'SignOut',
                  style: GoogleFonts.acme(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: kblackcolor),
                ),
                trailing: IconButton(
                    onPressed: () async {
                      await authController.signout();
                    },
                    icon: const Icon(
                      Icons.arrow_forward,
                      size: 20,
                    )),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 25,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 205),
                    child: Text(
                      'Hi, $userName!',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.acme(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: kwhitecolor),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '  \u{1F44B}what are you thinking?',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.acme(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: kwhitecolor),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 145,
            child: DateScreen(),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: diaryTypes.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                      top: 20, left: 15, right: 15, bottom: 35),
                  child: Container(
                    height: 100,
                    width: 150,
                    decoration: BoxDecoration(
                      color: diaryTypes[index] == diaryTypes[1] ||
                              diaryTypes[index] == diaryTypes[3]
                          ? kbackgroundColor
                          : kwhitecolor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              diaryTypes[index],
                              style: TextStyle(
                                  fontSize: 23,
                                  color: kblackcolor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  height: 40,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: kblackcolor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    color: kwhitecolor,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) {
                                          return const NoteScreen();
                                        }),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.add,
                                      size: 25,
                                      color: kwhitecolor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Notes")
                  .where('uid', isEqualTo: currentUser.currentUser?.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: kblackcolor),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                      child: Text(
                    'No notes available',
                    style: TextStyle(
                        color: kwhitecolor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ));
                } else {
                  return RefreshIndicator(
                    backgroundColor: kcombinecolor,
                    color: kblackcolor,
                    onRefresh: () {
                      return Future.delayed(const Duration(seconds: 2));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index) {
                          var note = snapshot.data!.docs[index];
                          return SingleChildScrollView(
                            child: noteCard(
                              () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return NoteReaderScreen(doc: note);
                                  }),
                                );
                              },
                              note,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kcombinecolor,
        icon: Icon(
          Icons.add,
          size: 30,
          color: kwhitecolor,
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return NoteScreen();
          }));
        },
        label: Text(
          'What\'sUp',
          style: GoogleFonts.acme(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: kwhitecolor,
          ),
        ),
      ),
    );
  }
}
