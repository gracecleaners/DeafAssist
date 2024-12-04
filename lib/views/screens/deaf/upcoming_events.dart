import 'package:deafassist/const/app_colors.dart';
import 'package:flutter/material.dart';

class UpcomingEvents extends StatelessWidget {
  const UpcomingEvents({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
            title: const Text("Upcoming Events", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
      ),
      body: ListView.builder(  
        itemCount: 10,  
        itemBuilder: (context, index) {  
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListTile(  
              title: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(2)
                        ),
                        child: const Text("Hotel Africana", style: TextStyle(fontSize: 12,color: AppColors.primaryColor),)),
                      const SizedBox(width: 10,),
                      Text("08|12|2024", style: TextStyle(fontSize: 12,color: Colors.grey.withOpacity(0.5)),)
                    ],
                  ),
                  const Align(
                    alignment: Alignment.bottomLeft,
                    child: Text("Silent Dinner", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),)),
                ],
              ),  
              leading: Image.asset("assets/images/okumu.png"),
              trailing: Container(
                height: 5,
                width: 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.primaryColor
                ),
              ),  
              onTap: () {  
                // Action when an item is tapped  
                ScaffoldMessenger.of(context).showSnackBar(  
                  const SnackBar(content: Text('Tapped on Silent Dinner')),  
                );  
              },  
            ),
          );  
        },  
      ),  
    );
  }
}
