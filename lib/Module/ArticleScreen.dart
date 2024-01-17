import 'package:flutter/material.dart';
import 'package:news1/Components/Custom_tag.dart';
import 'package:news1/Model/NewsModel.dart';
import 'package:news1/Provider/NewsProvider.dart';
import 'package:provider/provider.dart';

class ArticleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Articles? selectedArticle =
        Provider.of<NewsProvider>(context, listen: false).selectedArticle;

    return Scaffold(
      
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: selectedArticle?.urlToImage != null
              ? DecorationImage(
                  image: NetworkImage(selectedArticle?.urlToImage ?? ""),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: SafeArea(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 150,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: CustomTag(
                        backgroundColor: Colors.black.withAlpha(150),
                        children: [
                          Text(
                            selectedArticle?.source?.name ?? "",
                            maxLines: 1,
                            style: const TextStyle(
                              color: Colors.white,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          selectedArticle?.title ?? "",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              _NewsBody(article: selectedArticle), // Removed Flexible
            ],
          ),
        ),
      ),
    );
  }
}

class _NewsBody extends StatelessWidget {
  const _NewsBody({
    Key? key,
    required this.article,
  }) : super(key: key);

  final Articles? article;

  @override
  Widget build(BuildContext context) {
    if (article == null) {
      // Handle the case where the article is null
      return const SizedBox.shrink();
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      width: double.infinity,
      padding: const EdgeInsets.all(30.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, // Set to stretch
        children: [
          Row(
            children: [
              CustomTag(
                backgroundColor: Colors.grey,
                children: [
                  if (article?.urlToImage != null)
                    CircleAvatar(
                      radius: 10,
                      backgroundImage: NetworkImage(
                        article?.urlToImage ?? '',
                      ),
                    ),
                  const SizedBox(width: 10),
                  Text(
                    article?.author ?? "",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              CustomTag(
                backgroundColor: Colors.grey.shade200,
                children: [
                  const Icon(
                    Icons.timer,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${DateTime.now().difference(DateTime.parse(article?.publishedAt ?? "")).inHours}h',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            article?.title ?? "",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            article?.description ?? "",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
