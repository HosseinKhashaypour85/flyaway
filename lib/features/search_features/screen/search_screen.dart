import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flyaway/config/app_config/app_app_bar/app_app_bar.dart';
import 'package:flyaway/config/app_config/app_font_styles/app_font_styles.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  bool _isLoading = false;
  List<SearchItem> _results = [];

  Future<void> _performSearch(String query) async {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () async {
      if (query.trim().isEmpty) {
        setState(() {
          _isLoading = false;
          _results = [];
        });
        return;
      }

      setState(() {
        _isLoading = true;
        _results = [];
      });

      await Future.delayed(const Duration(seconds: 1));

      final fakeResults = List.generate(5, (i) {
        return SearchItem(
          id: '$i',
          title: 'Result for "$query" #${i + 1}',
          subtitle: 'This is item ${i + 1} description',
          rating: 3.0 + (i % 2),
        );
      });

      setState(() {
        _isLoading = false;
        _results = query == 'empty' ? [] : fakeResults;
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Color get primaryBlue => const Color(0xFF0D6EFD);
  Color get lightBlue => const Color(0xFFF3F8FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBlue,
      appBar: AppAppBar().appBar(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 🔹 Search Bar (moved from AppBar)
              Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(color: Color(0xFFE3F2FD)),
                  child: TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: 'search_box'.tr,
                      hintStyle: AppFontStyles().FirstFontStyleWidget(14.sp, Colors.grey),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _performSearch('');
                          setState(() {});
                        },
                      )
                          : null,
                      border: InputBorder.none,
                      contentPadding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                    ),
                    onChanged: (value) {
                      setState(() {});
                      _performSearch(value);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 🔹 Results / Loading / Empty
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return ListView.separated(
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) => ShimmerLoadingClass().shimmerCommentsCard(),
      );
    }

    if (_results.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(Icons.search_off, size: 64, color: primaryBlue),
            ),
            const SizedBox(height: 16),
            Text(
              'No results found',
              style: TextStyle(
                fontSize: 16,
                color: primaryBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Try another keyword',
              style: TextStyle(fontSize: 13, color: primaryBlue.withOpacity(0.7)),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: _results.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = _results[index];
        return _ResultCard(item: item);
      },
    );
  }
}

// ---------------------------------------
// 🔹 Data Model
// ---------------------------------------
class SearchItem {
  final String id;
  final String title;
  final String subtitle;
  final double rating;

  SearchItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.rating,
  });
}

// ---------------------------------------
// 🔹 Result Card
// ---------------------------------------
class _ResultCard extends StatelessWidget {
  final SearchItem item;

  const _ResultCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF4FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.local_movies, size: 36, color: Color(0xFF0D6EFD)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.subtitle,
                      style: const TextStyle(fontSize: 13, color: Colors.black54),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        RatingBar.builder(
                          initialRating: item.rating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 16,
                          ignoreGestures: true,
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (_) {},
                        ),
                        const SizedBox(width: 8),
                        Text(
                          item.rating.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------
// 🔹 Shimmer Skeleton
// ---------------------------------------
class ShimmerLoadingClass {
  Widget shimmerCommentsCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Material(
        color: Colors.white,
        elevation: 1,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 14, width: double.infinity, color: Colors.grey[300]),
                    const SizedBox(height: 8),
                    Container(height: 12, width: 150, color: Colors.grey[300]),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(height: 12, width: 80, color: Colors.grey[300]),
                        const SizedBox(width: 8),
                        Container(height: 12, width: 24, color: Colors.grey[300]),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
