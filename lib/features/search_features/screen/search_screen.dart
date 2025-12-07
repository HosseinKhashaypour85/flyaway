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
  bool _hasError = false;
  String _errorMessage = '';
  List<SearchItem> _results = [];
  String _lastSearchQuery = '';

  Color get primaryBlue => const Color(0xFF0D6EFD);
  Color get lightBlue => const Color(0xFFF3F8FF);
  Color get whiteColor => Colors.white;
  Color get greyColor => Colors.grey;
  Color get errorRed => Colors.red;

  @override
  void initState() {
    super.initState();
    // Focus the search field when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  Future<void> _performSearch(String query) async {
    // Cancel previous timer
    _debounce?.cancel();

    if (query.trim().isEmpty) {
      setState(() {
        _isLoading = false;
        _hasError = false;
        _results = [];
        _lastSearchQuery = '';
      });
      return;
    }

    // Don't search same query again if already loaded
    if (query == _lastSearchQuery && _results.isNotEmpty) return;

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
        _hasError = false;
        _results = [];
        _lastSearchQuery = query;
      });

      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Simulate error for 'error' query
      if (query.toLowerCase() == 'error') {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = 'Network error occurred';
          _results = [];
        });
        return;
      }

      // Generate results
      final fakeResults = List.generate(5, (i) {
        return SearchItem(
          id: '$i',
          title: 'Result for "$query" #${i + 1}',
          subtitle: 'This is item ${i + 1} description with more details about the product',
          rating: 3.0 + (i % 2),
          price: 99.99 + (i * 10.0),
          category: i % 3 == 0 ? 'Popular' : 'Regular',
          reviewCount: (i + 1) * 10,
        );
      });

      setState(() {
        _isLoading = false;
        _results = query == 'empty' ? [] : fakeResults;
      });
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _results = [];
      _hasError = false;
      _lastSearchQuery = '';
    });
  }

  void _retrySearch() {
    if (_lastSearchQuery.isNotEmpty) {
      _performSearch(_lastSearchQuery);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBlue,
      appBar: AppAppBar().appBar(context),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              // Search Bar
              Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'search_box'.tr,
                      hintStyle: AppFontStyles().FirstFontStyleWidget(14.sp, greyColor),
                      prefixIcon: Icon(Icons.search, color: primaryBlue),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                        icon: Icon(Icons.clear, color: greyColor),
                        onPressed: _clearSearch,
                      )
                          : null,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 14.h,
                        horizontal: 16.w,
                      ),
                    ),
                    style: AppFontStyles().FirstFontStyleWidget(16.sp, Colors.black87),
                    onChanged: (value) {
                      setState(() {});
                      _performSearch(value);
                    },
                    onSubmitted: (value) {
                      _performSearch(value);
                    },
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Search Info
              if (_lastSearchQuery.isNotEmpty && !_isLoading && !_hasError && _results.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Row(
                    children: [
                      Text(
                        '${_results.length} results found for "$_lastSearchQuery"',
                        style: AppFontStyles().FirstFontStyleWidget(12.sp, primaryBlue),
                      ),
                    ],
                  ),
                ),

              // Results / Loading / Error / Empty
              Expanded(
                child: _buildContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_hasError) {
      return _buildErrorState();
    }

    if (_results.isEmpty && _lastSearchQuery.isNotEmpty) {
      return _buildEmptyState();
    }

    if (_results.isEmpty) {
      return _buildInitialState();
    }

    return _buildResultsList();
  }

  Widget _buildLoadingState() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemCount: 5,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) => ShimmerLoadingClass().shimmerCommentsCard(),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 140.w,
            height: 140.w,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(Icons.error_outline, size: 64.w, color: errorRed),
          ),
          SizedBox(height: 16.h),
          Text(
            'Search Error',
            style: AppFontStyles().FirstFontStyleWidget(16.sp, errorRed),
          ),
          SizedBox(height: 6.h),
          Text(
            _errorMessage,
            style: AppFontStyles().FirstFontStyleWidget(13.sp, errorRed.withOpacity(0.7)),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(12.r),
            child: InkWell(
              borderRadius: BorderRadius.circular(12.r),
              onTap: _retrySearch,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: primaryBlue,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  'Retry',
                  style: AppFontStyles().FirstFontStyleWidget(14.sp, whiteColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 140.w,
            height: 140.w,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(Icons.search_off, size: 64.w, color: primaryBlue),
          ),
          SizedBox(height: 16.h),
          Text(
            'No results found',
            style: AppFontStyles().FirstFontStyleWidget(16.sp, primaryBlue),
          ),
          SizedBox(height: 6.h),
          Text(
            'Try another keyword',
            style: AppFontStyles().FirstFontStyleWidget(13.sp, primaryBlue.withOpacity(0.7)),
          ),
          SizedBox(height: 20.h),
          Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(12.r),
            child: InkWell(
              borderRadius: BorderRadius.circular(12.r),
              onTap: _clearSearch,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  'Clear Search',
                  style: AppFontStyles().FirstFontStyleWidget(14.sp, primaryBlue),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 140.w,
            height: 140.w,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(Icons.search, size: 64.w, color: primaryBlue.withOpacity(0.5)),
          ),
          SizedBox(height: 16.h),
          Text(
            'Start Searching',
            style: AppFontStyles().FirstFontStyleWidget(16.sp, primaryBlue.withOpacity(0.7)),
          ),
          SizedBox(height: 6.h),
          Text(
            'Type something to find items',
            style: AppFontStyles().FirstFontStyleWidget(13.sp, primaryBlue.withOpacity(0.5)),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemCount: _results.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final item = _results[index];
        return _ResultCard(item: item);
      },
    );
  }
}

// Data Model
class SearchItem {
  final String id;
  final String title;
  final String subtitle;
  final double rating;
  final double price;
  final String category;
  final int reviewCount;

  SearchItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.rating,
    required this.price,
    required this.category,
    required this.reviewCount,
  });
}

// Result Card (Updated with your existing styles)
class _ResultCard extends StatelessWidget {
  final SearchItem item;

  const _ResultCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: () {
          // Handle item tap
        },
        child: Padding(
          padding: EdgeInsets.all(14.r),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image/Icon Container
              Container(
                width: 72.r,
                height: 72.r,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF4FF),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(Icons.local_movies, size: 36.r, color: const Color(0xFF0D6EFD)),
              ),
              SizedBox(width: 12.w),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Category
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (item.category == 'Popular')
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0D6EFD).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              'Popular',
                              style: AppFontStyles().FirstFontStyleWidget(
                                10.sp,
                                const Color(0xFF0D6EFD),
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 4.h),

                    // Subtitle
                    Text(
                      item.subtitle,
                      style: const TextStyle(fontSize: 13, color: Colors.black54),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),

                    // Rating and Price Row
                    Row(
                      children: [
                        // Rating
                        RatingBar.builder(
                          initialRating: item.rating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 16.r,
                          ignoreGestures: true,
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (_) {},
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          item.rating.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '(${item.reviewCount})',
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                        const Spacer(),

                        // Price
                        Text(
                          '\$${item.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0D6EFD),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Shimmer Loading Class (same as your existing)
class ShimmerLoadingClass {
  Widget shimmerCommentsCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Material(
        color: Colors.white,
        elevation: 1,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(14.r),
          child: Row(
            children: [
              Container(
                width: 72.r,
                height: 72.r,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 14.h, width: double.infinity, color: Colors.grey[300]),
                    SizedBox(height: 8.h),
                    Container(height: 12.h, width: 150.w, color: Colors.grey[300]),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Container(height: 12.h, width: 80.w, color: Colors.grey[300]),
                        SizedBox(width: 8.w),
                        Container(height: 12.h, width: 24.w, color: Colors.grey[300]),
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