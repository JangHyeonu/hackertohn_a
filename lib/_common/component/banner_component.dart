import 'dart:async';

import 'package:flutter/material.dart';

class BannerComponent extends StatefulWidget {

  const BannerComponent({
    super.key
  });

  @override
  State<BannerComponent> createState() => _BannerComponentState();
}

class _BannerComponentState extends State<BannerComponent> {
  Timer? timer;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      int nextPage = _currentPage + 1;
      if(nextPage > 4) {
        nextPage = 0;
      }

      _pageController.animateToPage(nextPage, duration: const Duration(milliseconds: 400), curve: Curves.linear);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView(
          controller: _pageController,
          onPageChanged: (value) {
            setState(() {
              _currentPage = value;
            });
          },
          children: [
            buildBanner('assets/image/ban1.png'),
            buildBanner('assets/image/ban2.png'),
            buildBanner('assets/image/ban3.png'),
            buildBanner('assets/image/ban4.png'),
            buildBanner('assets/image/ban5.png'),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for(int i = 0; i < 5; i++)
                  Container(
                    margin: const EdgeInsets.all(4.0),
                    width: 12.0,
                    height: 12.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == i
                          ? Colors.grey
                          : Colors.grey.withOpacity(0.5),
                    ),
                  )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget buildBanner(String text) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0), // 원하는 둥근 정도를 설정합니다.
        color: Colors.black54,
      ),
      child: Image.asset(text, fit: BoxFit.fitWidth),
    );
  }
}
