import 'package:deafassist/const/app_colors.dart';
import 'package:deafassist/modals/category.dart';
import 'package:deafassist/services/auth_service.dart';
import 'package:deafassist/views/screens/auth/loginpage.dart';
import 'package:deafassist/views/screens/deaf/chatDeaf.dart';
import 'package:deafassist/views/screens/deaf/resource_main.dart';
import 'package:deafassist/views/screens/deaf/view_interpreters.dart';
import 'package:deafassist/views/screens/trial.dart';
import 'package:deafassist/views/widgets/circleButton.dart';
import 'package:deafassist/views/widgets/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class HomeDeaf extends StatefulWidget {
  const HomeDeaf({Key? key}) : super(key: key);

  @override
  _HomeDeafState createState() => _HomeDeafState();
}

class _HomeDeafState extends State<HomeDeaf> {
   // Initialize your AuthService
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              AppBar(),
              Body(),
            ],
          ),
        ),
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<Category> categoryList = [
  Category(
    name: 'Interpreters',
    thumbnail: 'assets/images/logo.png',
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewInterpreters(),
        ),
      );
    },
  ),
  Category(
    name: 'Resources',
    thumbnail: 'assets/images/logo.png',
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Resources(),
        ),
      );
    },
  ),
  Category(
    name: 'Photography',
    thumbnail: 'assets/images/logo.png',
    onTap: () {
     Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewInterpreters(),
        ),
      );
    },
  ),
  Category(
    name: 'Product Design',
    thumbnail: 'assets/images/logo.png',
    onTap: () {
     Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewInterpreters(),
        ),
      );
    },
  ),
];


    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Deaf Assist", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
              const SizedBox(height: 8.0,),
              Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text."),
            ],
          )
        ),
        GridView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 8,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 20,
            mainAxisSpacing: 24,
          ),
          itemBuilder: (context, index) {
            return CategoryCard(
              category: categoryList[index],
            );
          },
          itemCount: categoryList.length,
        ),
      ],
    );
  }
}

class CategoryCard extends StatelessWidget {
  final Category category;
  const CategoryCard({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => category.onTap(), // Ensuring `onTap` executes
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.1),
              blurRadius: 4.0,
              spreadRadius: .05,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                category.thumbnail,
                height: 130,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(category.name)),
          ],
        ),
      ),
    );
  }
}


class AppBar extends StatelessWidget {
  final AuthService _authService = AuthService();
  AppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
      height: 250,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        color: Color(0xFFF8B11B)
        // gradient: LinearGradient(
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        //   stops: [0.1, 0.5],
        //   colors: [
        //     Color(0xff886ff2),
        //     Color(0xff6849ef),
        //   ],
        // ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello,\nGood Morning",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30
                )
              ),
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.backgroundColor
                ),
                icon: Icon(Icons.logout, color: AppColors.primaryColor,),
                onPressed: () async {
                  await _authService.signOut();
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                },
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const SearchTextField()
        ],
      ),
    );
  }
}