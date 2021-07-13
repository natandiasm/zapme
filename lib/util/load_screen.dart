import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget loadProducts(){
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Shimmer.fromColors(
            baseColor: Colors.black12,
            highlightColor: Colors.black38.withOpacity(0.2),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              height: 55,
            )
        ),
      ),
      Expanded(
        child: ListView.builder(
          itemCount: 4,
            itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Shimmer.fromColors(
                baseColor: Colors.black12,
                highlightColor: Colors.black38.withOpacity(0.2),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: 70,
                )
            ),
          );
        }),
      ),
    ],
  );
}