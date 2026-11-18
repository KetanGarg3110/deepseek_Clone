import 'package:deepseek/models/onboardingContentModel.dart';
import 'package:deepseek/provider/onBoardingProvider.dart';
import 'package:deepseek/screens/login_page.dart';
import 'package:deepseek/utiles/util_helper.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../utiles/pref_helper.dart';

class OnBoardScreen extends StatelessWidget {
  const OnBoardScreen({super.key});

  //   const OnBoardScreen({super.key});
  //
  //   @override
  //   State<OnBoardScreen> createState() => _OnBoardScreenState();
  // }
  //
  // class _OnBoardScreenState extends State<OnBoardScreen> {
  //   var currentIndex = 0;
  //   late PageController _pageController;

  // @override
  // void initState() {
  //   _pageController = PageController(initialPage: 0);
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   _pageController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OnBoardingProvider>(context);

    // initState for StatelessWidget
    // WidgetsBinding.instance.addPostFrameCallback((_){
    //   _pageController =PageController(initialPage: 0);
    // });

    return Scaffold(
      body: PageView.builder(
        controller: provider.pageController,
        itemCount: contents.length,
        onPageChanged: (index) {
          // setState(() {
          //   currentIndex = index;
          // });
          provider.changePage(index);
        },
        itemBuilder: (context, index) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(11.0),
                child: Lottie.asset(
                  contents[index].image,
                  width: 400,
                  height: 400,
                ),
              ),
              Text(
                contents[index].title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
              ),
              Spacer(),
              Text(
                contents[index].discription,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
              Spacer(flex: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  contents.length,
                  (index) => buildDot(index, provider.currentIndex),
                ),
              ),
              Spacer(flex: 2),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 100),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (provider.currentIndex == contents.length - 1) {
                    // Save onboarding status with help of Hive not a sharedPref.
                    Pref.showOnBoarding = false;

                    // Continue ke baad kya hoga
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DeepSeekLogin(),
                      ),
                    );
                  } else {
                    // next vala option hai
                    // _pageController.nextPage(
                    //   duration: Duration(milliseconds: 100),
                    //   curve: Curves.bounceIn,
                    // );
                    provider.nextPage();
                  }
                },
                child: Text(
                  provider.currentIndex == contents.length - 1
                      ? "Continue"
                      : "Next",
                  style: mTextStyle16(
                    mColor: Colors.white,
                    mFontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Spacer(flex: 2),
              //   Lottie.asset('assets/lottie_files/on_boardAnimation2.json'),
            ],
          );
        },
      ),
    );
  }

  Widget buildDot(int index, int currentIndex) {
    return Container(
      height: 10,
      width: currentIndex == index ? 20 : 10,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.blue,
      ),
    );
  }
}
