import 'dart:math';

import 'package:flutter/material.dart';

import '../../styles/colors.dart';
import '../../styles/spacings.dart';
import '../../styles/texts.dart';

class InfoSlider extends StatelessWidget {
  const InfoSlider({super.key, required List<String> items}) : _items = items;

  final List<String> _items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/img/back1.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: kVerticalPadding),
        child: SizedBox(
          height: 105,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _items.length,
            itemBuilder: (context, i) {
              return Row(
                children: [
                  _buildLeadingSpacing(i),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kHorizontalPadding,
                      vertical: kVerticalPadding,
                    ),
                    decoration: BoxDecoration(
                      color: kBackgroundColor.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: _getContainerWidth(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_items[i], style: kTextSideBar),
                        Text('${Random().nextInt(1000)}€', style: kTitleHome),
                      ],
                    ),
                  ),
                  _buildTrailingSpacing(i),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLeadingSpacing(int index) {
    if (index == 0) {
      return const SizedBox(width: kHorizontalPadding);
    } else {
      return Container();
    }
  }

  Widget _buildTrailingSpacing(int index) {
    if (index < _items.length) {
      return const SizedBox(width: kHorizontalPadding);
    } else {
      return Container();
    }
  }

  double _getContainerWidth(BuildContext context) {
    if (MediaQuery.of(context).size.width > 390) {
      return 160;
    } else {
      return 200;
    }
  }
}
