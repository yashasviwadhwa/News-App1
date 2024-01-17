import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:news1/Components/BottomNav.dart';
import 'package:news1/Components/Custom_tag.dart';
import 'package:news1/Model/NewsModel.dart';
import 'package:news1/Module/ArticleScreen.dart';
import 'package:news1/Provider/NewsProvider.dart';
import 'package:provider/provider.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({Key? key}) : super(key: key);
  static const double separatorWidth = 20.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(
          Icons.menu,
          color: Colors.white,
        ),
      ),
      body: FutureBuilder<List<Articles>>(
        future: Provider.of<NewsProvider>(context).fetchNews("business"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No news available.'));
          } else {
            final articles = snapshot.data!;

            return ListView(
              padding: EdgeInsets.zero,
              children: [
                FirstSection(articles[0], context),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Breaking News",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "View All",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: 30,
                  height: 220,
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: articles.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) =>
                        NewsCard(context, articles[index]),
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(width: separatorWidth),
                  ),
                ),
              ],
            );
          }
        },
      ),
      bottomNavigationBar: BottomNav(),
    );
  }

  Widget NewsCard(BuildContext context, Articles article) {
    return InkWell(
      onTap: () {
        Provider.of<NewsProvider>(context, listen: false)
            .setSelectedArticle(article);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ArticleScreen(),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(left: 20),
        width: MediaQuery.of(context).size.width * 0.6,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: article.urlToImage ?? "",
              fit: BoxFit.fill,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            Expanded(
              child: Text(
                article.title ?? '',
                maxLines: 2,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  height: 2.0,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Container FirstSection(Articles article, BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: CachedNetworkImageProvider(
            article.urlToImage ??
              'https://images.unsplash.com/photo-1525286376485-60c84ee403d1?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDM3fGlVSXNuVnRqQjBZfHxlbnwwfHx8fHw%3D'),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTag(
            backgroundColor: Colors.grey.withAlpha(150),
            children: const [
              Text(
                "News Of The Day",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            article.title ?? "",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Row(
            children: [
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Learn More",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.arrow_right_alt,
                color: Colors.white,
                size: 25,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
