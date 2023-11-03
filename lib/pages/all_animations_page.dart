import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AllAnimations extends StatefulWidget {
  AllAnimations({super.key, this.showNight = false});
  bool showNight;

  @override
  State<AllAnimations> createState() => _AllAnimationsState();
}

class _AllAnimationsState extends State<AllAnimations> {
  bool showNight = false;

  List weatherConditions = ["sunny", "rain", "clear", "cloud", "thunder", "fog", "mist", "rainthunder", "drizzle", "sleet", "snow"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showNight = widget.showNight;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: weatherConditions.length,
      child: Scaffold(
        backgroundColor: showNight ? Colors.black : Colors.white,
        appBar: AppBar(
          backgroundColor: showNight ? Colors.black : Colors.white,
          elevation: 0,
          title: Text(
            'All Animations',
            style: TextStyle(
              color: showNight? Colors.white : Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600
            ),
          ),
          leading: InkWell(
            onTap: ()=>Navigator.pop(context),
            child: Lottie.asset('assets/homeIcon.json')
          ),
          centerTitle: true,
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                TabBar(
                  indicatorColor: showNight ? Colors.white : Colors.black,
                  isScrollable: true,
                  tabs: List.generate(
                    weatherConditions.length,
                        (index) => Container(
                          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Text(
                            '${weatherConditions[index]}'.toUpperCase(),
                            style: TextStyle(color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                  ),
                ),
                SizedBox(height: 500, child: TabBarView(children: List.generate(weatherConditions.length, (index) =>  SizedBox(width: double.infinity, child: Lottie.asset('assets/${weatherConditions[index]}.json'))))),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20,),
                  decoration: BoxDecoration(
                    color: Colors.deepOrangeAccent,
                    borderRadius: BorderRadius.circular(50)
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Night mode',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16
                      ),
                      ),
                      Switch(
                        activeColor: Colors.black,
                        value: showNight,
                        onChanged: (value){
                          setState(() {
                            showNight = value;
                          });
                      },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
