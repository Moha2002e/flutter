import 'package:flutter/material.dart';
import 'package:projectexamen/l10n/app_localizations.dart';
import 'package:projectexamen/styles/colors.dart';
import 'package:projectexamen/styles/sizes.dart';
import 'package:projectexamen/styles/spacings.dart';
import 'package:projectexamen/styles/texts.dart';

class Carousel extends StatefulWidget {
  const Carousel({super.key});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  final PageController controller = PageController();

  int _currentIndex = 0;

  List<String> _getItems(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    if (localizations == null) {
      return ['', '', '', ''];
    }
    return [
      localizations.carousel1,
      localizations.carousel2,
      localizations.carousel3,
      localizations.carousel4,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final _items = _getItems(context);
    return Column(
      children: [
        SizedBox(
          height: kCarouselHeight,
          child: PageView.builder(
            scrollDirection: Axis.horizontal,
            controller: controller,
            itemCount: _items.length,
            itemBuilder: (context, i) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: kPaddingHorizontalL,
                ),
                child: Text(_items[i], style: kCarouselText, textAlign: TextAlign.center,),
              );
            },
            onPageChanged: (i) {
              setState(() {
                _currentIndex = i;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPaddingHorizontalL),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int i = 0; i < _items.length; i++)
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    controller.animateToPage(
                      i,
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    color: _currentIndex == i
                        ? kCarouselActiveLine
                        : kCarouselInactiveLine,
                    height: 3,
                    width:
                    (MediaQuery.of(context).size.width / _items.length) -
                        (kPaddingHorizontal * 2),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}