import 'package:flutter/material.dart';

class BannerComponent extends StatefulWidget {

  const BannerComponent({
    super.key
  });

  @override
  State<BannerComponent> createState() => _BannerComponentState();
}

class _BannerComponentState extends State<BannerComponent> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

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
            buildBanner('1번 배너'),
            buildBanner('2번 배너'),
            buildBanner('3번 배너'),
            buildBanner('4번 배너'),
            buildBanner('5번 배너'),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for(int i = 0; i < 5; i++)
                  Container(
                    margin: EdgeInsets.all(4.0),
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
        color: Colors.blueGrey,
      ),
      child: Center(child: Text(text)),
    );
  }
}
