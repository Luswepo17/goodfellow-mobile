import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:goodfellow/utils/constants/image_strings.dart';

class PromoBanners extends StatelessWidget {
  const PromoBanners({super.key});

  @override
  Widget build(BuildContext context) {
    const List<String> urlImages = [
      APPImages.promoBanner1,
      APPImages.promoBanner2,
      APPImages.promoBanner3,
    ];

    return Center(
      child: CarouselSlider.builder(
        options: CarouselOptions(
          height: 110,
          autoPlay: true,
          // reverse: true,
          viewportFraction: 1,
          //enlargeCenterPage: false,
          pageSnapping: false,
          enableInfiniteScroll: true,
          //enlargeStrategy: CenterPageEnlargeStrategy.height,
          autoPlayInterval: const Duration(seconds: 5),
        ),
        itemCount: urlImages.length,
        itemBuilder: (context, index, realIndex) {
          final urlImage = urlImages[index];

          return buildImage(urlImage, index);
        },
      ),
    );
  }

  Widget buildImage(String urlImage, int index) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(
            (0.2 * 255).toInt(),
          ), // Shadow color with opacity
          spreadRadius: .5, // How much the shadow spreads
          blurRadius: 8, // How soft the shadow appears
          offset: const Offset(0, 4), // Offset of the shadow (x: 0, y: 4)
        ),
      ],
      borderRadius: BorderRadius.circular(12), // Optional: rounded corners
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(2), // Same radius as the container
      child: Image.asset(
        urlImage,
        fit: BoxFit.fitWidth,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.error, color: Colors.red),
      ),
    ),
  );
}
