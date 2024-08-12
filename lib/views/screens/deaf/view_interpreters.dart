import 'package:deafassist/const/app_colors.dart';
import 'package:deafassist/views/screens/auth/registerpage.dart';
import 'package:deafassist/views/widgets/search.dart';
import 'package:deafassist/views/widgets/text_widget.dart';
import 'package:flutter/material.dart';
class ViewInterpreters extends StatelessWidget {
  const ViewInterpreters({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text('Book Interpreter',style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: ('Quicksand'),
                fontSize: 30,
                color: Colors.white
              ),),
            ),
            SizedBox(height: 5,),
            
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SearchTextField(labelText: "Search for interpreter by name",suffixIcon: Icon(Icons.send, color: AppColors.primaryColor,),),
            ),
            SizedBox(height: 30,),
            Expanded(
              child: Container(
                // height: MediaQuery.of(context).size.height,
                // width: double.infinity,
                decoration: const BoxDecoration(
                    color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  )
                ),
                child: ListView(
                    children: [
                     GestureDetector(
                      onTap: (){
            //             Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => RegisterPage()),
            // );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 35, 
                              backgroundImage: AssetImage("assets/images/okumu.png"),
                            ),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(text: "Hello", fontSize: 20,fontWeight: FontWeight.bold),
                                MyText(text: "oscar@gmail.com", color: Colors.black.withOpacity(0.6),)
                              ],
                            ),
                            Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: MyText(text: "Unavailable", color: AppColors.backgroundColor,),
                              ))
                          ],
                        ),
                      ),
                     ),
                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 10),
                       child: Divider(),
                     ),
                     GestureDetector(
                      onTap: (){
            //             Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => RegisterPage()),
            // );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 35, 
                              backgroundImage: AssetImage("assets/images/okumu.png"),
                            ),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(text: "Hello", fontSize: 20,fontWeight: FontWeight.bold),
                                MyText(text: "oscar@gmail.com", color: Colors.black.withOpacity(0.6),)
                              ],
                            ),
                            Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: MyText(text: "Unavailable", color: AppColors.backgroundColor,),
                              ))
                          ],
                        ),
                      ),
                     ),
                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 10),
                       child: Divider(),
                     ),
                     GestureDetector(
                      onTap: (){
            //             Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => RegisterPage()),
            // );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 35, 
                              backgroundImage: AssetImage("assets/images/okumu.png"),
                            ),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(text: "Hello", fontSize: 20,fontWeight: FontWeight.bold),
                                MyText(text: "oscar@gmail.com", color: Colors.black.withOpacity(0.6),)
                              ],
                            ),
                            Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: MyText(text: "Unavailable", color: AppColors.backgroundColor,),
                              ))
                          ],
                        ),
                      ),
                     ),
                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 10),
                       child: Divider(),
                     ),
                     GestureDetector(
                      onTap: (){
            //             Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => RegisterPage()),
            // );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 35, 
                              backgroundImage: AssetImage("assets/images/okumu.png"),
                            ),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(text: "Hello", fontSize: 20,fontWeight: FontWeight.bold),
                                MyText(text: "oscar@gmail.com", color: Colors.black.withOpacity(0.6),)
                              ],
                            ),
                            Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: MyText(text: "Unavailable", color: AppColors.backgroundColor,),
                              ))
                          ],
                        ),
                      ),
                     ),
                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 10),
                       child: Divider(),
                     ),
                     GestureDetector(
                      onTap: (){
            //             Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => RegisterPage()),
            // );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 35, 
                              backgroundImage: AssetImage("assets/images/okumu.png"),
                            ),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(text: "Hello", fontSize: 20,fontWeight: FontWeight.bold),
                                MyText(text: "oscar@gmail.com", color: Colors.black.withOpacity(0.6),)
                              ],
                            ),
                            Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: MyText(text: "Unavailable", color: AppColors.backgroundColor,),
                              ))
                          ],
                        ),
                      ),
                     ),
                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 10),
                       child: Divider(),
                     ),
                     GestureDetector(
                      onTap: (){
            //             Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => RegisterPage()),
            // );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 35, 
                              backgroundImage: AssetImage("assets/images/okumu.png"),
                            ),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(text: "Hello", fontSize: 20,fontWeight: FontWeight.bold),
                                MyText(text: "oscar@gmail.com", color: Colors.black.withOpacity(0.6),)
                              ],
                            ),
                            Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: MyText(text: "Unavailable", color: AppColors.backgroundColor,),
                              ))
                          ],
                        ),
                      ),
                     ),
                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 10),
                       child: Divider(),
                     ),
                     GestureDetector(
                      onTap: (){
            //             Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => RegisterPage()),
            // );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 35, 
                              backgroundImage: AssetImage("assets/images/okumu.png"),
                            ),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(text: "Hello", fontSize: 20,fontWeight: FontWeight.bold),
                                MyText(text: "oscar@gmail.com", color: Colors.black.withOpacity(0.6),)
                              ],
                            ),
                            Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: MyText(text: "Unavailable", color: AppColors.backgroundColor,),
                              ))
                          ],
                        ),
                      ),
                     ),
                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 10),
                       child: Divider(),
                     ),
                     GestureDetector(
                      onTap: (){
            //             Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => RegisterPage()),
            // );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 35, 
                              backgroundImage: AssetImage("assets/images/okumu.png"),
                            ),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(text: "Hello", fontSize: 20,fontWeight: FontWeight.bold),
                                MyText(text: "oscar@gmail.com", color: Colors.black.withOpacity(0.6),)
                              ],
                            ),
                            Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: MyText(text: "Unavailable", color: AppColors.backgroundColor,),
                              ))
                          ],
                        ),
                      ),
                     ),
                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 10),
                       child: Divider(),
                     ),
                     GestureDetector(
                      onTap: (){
            //             Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => RegisterPage()),
            // );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 35, 
                              backgroundImage: AssetImage("assets/images/okumu.png"),
                            ),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(text: "Hello", fontSize: 20,fontWeight: FontWeight.bold),
                                MyText(text: "oscar@gmail.com", color: Colors.black.withOpacity(0.6),)
                              ],
                            ),
                            Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: MyText(text: "Unavailable", color: AppColors.backgroundColor,),
                              ))
                          ],
                        ),
                      ),
                     ),
                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 10),
                       child: Divider(),
                     ),
                     GestureDetector(
                      onTap: (){
            //             Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => RegisterPage()),
            // );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 35, 
                              backgroundImage: AssetImage("assets/images/okumu.png"),
                            ),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(text: "Hello", fontSize: 20,fontWeight: FontWeight.bold),
                                MyText(text: "oscar@gmail.com", color: Colors.black.withOpacity(0.6),)
                              ],
                            ),
                            Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: MyText(text: "Unavailable", color: AppColors.backgroundColor,),
                              ))
                          ],
                        ),
                      ),
                     ),
                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 10),
                       child: Divider(),
                     ),
                     GestureDetector(
                      onTap: (){
            //             Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => RegisterPage()),
            // );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 35, 
                              backgroundImage: AssetImage("assets/images/okumu.png"),
                            ),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(text: "Hello", fontSize: 20,fontWeight: FontWeight.bold),
                                MyText(text: "oscar@gmail.com", color: Colors.black.withOpacity(0.6),)
                              ],
                            ),
                            Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: MyText(text: "Unavailable", color: AppColors.backgroundColor,),
                              ))
                          ],
                        ),
                      ),
                     ),
                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 10),
                       child: Divider(),
                     ),
                    ],
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}