import 'package:flutter/material.dart';

import '../../../../core/shared/domain/entities/magazine.dart';

class AllEditionsListView extends StatelessWidget {
  const AllEditionsListView({
    required this.magazines,
    super.key,
  });

  final List<Magazine> magazines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'ALL EDITIONS',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: magazines.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final magazine = magazines[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset(
                    magazine.assetImage,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
