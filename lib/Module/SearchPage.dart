import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news1/Components/BottomNav.dart';
import 'package:news1/Provider/NewsProvider.dart';
import 'package:news1/Model/NewsModel.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> tabs = [
      "Business",
      "Entertainment",
      'General',
      "health",
      'Science',
      "Sports",
      "Technology"
    ];

    return DefaultTabController(
      initialIndex: 0,
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.menu),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Discover",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "News From All Over The World",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Search',
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: const RotatedBox(
                      quarterTurns: 1,
                      child: Icon(Icons.tune),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
            _CategoryNews(tabs: tabs),
          ],
        ),
        bottomNavigationBar: BottomNav(),
      ),
    );
  }
}

class _CategoryNews extends StatelessWidget {
  const _CategoryNews({
    Key? key,
    required this.tabs,
  }) : super(key: key);

  final List<String> tabs;

  Widget _buildNewsList(String tab, List<Articles>? articles) {
    if (articles == null) {
      return const Center(child: CircularProgressIndicator());
    } else if (articles.isEmpty) {
      return const Center(child: Text('No news available for this category'));
    } else {
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Material(
                elevation: 3.0,
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 5.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: article.urlToImage ?? "",
                            placeholder: (context, url) => Image.network(
                                'https://th.bing.com/th/id/OIG.oPJm5FMm2UKL6IFVVVGK?w=270&h=270&c=6&r=0&o=5&dpr=1.3&pid=ImgGn'),
                            errorWidget: (context, url, error) => Image.network(
                                'https://th.bing.com/th/id/OIG.oPJm5FMm2UKL6IFVVVGK?w=270&h=270&c=6&r=0&o=5&dpr=1.3&pid=ImgGn'),
                            fit: BoxFit.fill,
                            height: 120,
                            width: 120,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: Text(
                                article.title ?? '',
                                maxLines: 1,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17.0,
                                ),
                              ),
                            ),
                            const SizedBox(height: 7.0),
                            Container(
                              width: MediaQuery.of(context).size.width / 1.7,
                              child: Text(
                                article.description ?? '',
                                maxLines: 3,
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(height: 15),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          padding: const EdgeInsets.only(bottom: 5),
          isScrollable: true,
          indicatorColor: const Color.fromARGB(255, 11, 199, 139),
          tabs: tabs
              .map(
                (tab) => Tab(
                  icon: Text(
                    tab,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: TabBarView(
            children: tabs
                .map(
                  (tab) => FutureBuilder<List<Articles>>(
                    future: Provider.of<NewsProvider>(context).fetchNews(tab),
                    builder: (context, snapshot) =>
                        _buildNewsList(tab, snapshot.data),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
