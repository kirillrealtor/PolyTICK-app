import 'package:polytick_app/data/blog_posts/gottheimer_2026.dart';
import 'package:polytick_app/data/blog_posts/market_crash_2026.dart';
import 'package:polytick_app/data/blog_posts/micron_politicians.dart';
import 'package:polytick_app/data/blog_posts/pelosi_2026.dart';
import 'package:polytick_app/data/blog_posts/pelosi_3_years.dart';
import 'package:polytick_app/data/blog_posts/puts_vs_calls.dart';
import 'package:polytick_app/data/blog_posts/sell_to_open.dart';
import 'package:polytick_app/data/blog_posts/trump_2026.dart';
import 'package:polytick_app/data/blog_posts/tuberville_2026.dart';
import 'package:polytick_app/data/blog_posts/what_is_options_premium.dart';

class BlogPost {
  final int id;
  final String title;
  final String slug;
  final String excerpt;
  final String metaDescription;
  final String? content;
  final String category;
  final String author;
  final String? authorUrl;
  final String publishDate;
  final String? modifiedDate;
  final String readTime;
  final String image;
  final String? imageBg;
  final String? imageFit;
  final String? imagePosition;
  final List<BlogFaq>? faqs;

  const BlogPost({
    required this.id,
    required this.title,
    required this.slug,
    required this.excerpt,
    required this.metaDescription,
    this.content,
    required this.category,
    required this.author,
    this.authorUrl,
    required this.publishDate,
    this.modifiedDate,
    required this.readTime,
    required this.image,
    this.imageBg,
    this.imageFit,
    this.imagePosition,
    this.faqs,
  });
}

class BlogFaq {
  final String question;
  final String answer;

  const BlogFaq({
    required this.question,
    required this.answer,
  });
}

class BlogData {
  static const List<String> categories = [
    "All",
    "Politician Trades",
    "Market Analysis",
    "Education",
    "Regulation",
  ];

  static const List<BlogPost> posts = [
    marketCrash2026Post,
    trump2026Post,
    micronPoliticiansPost,
    whatIsOptionsPremiumPost,
    putsVsCallsPost,
    sellToOpenPost,
    pelosi3YearsPost,
    pelosi2026Post,
    gottheimer2026Post,
    tuberville2026Post,
  ];
}
