import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'post.dart';

class Post {
  final int id;
  final String author;
  final String date;
  final String title;
  late int views;
  final int upvotes;
  final int downvotes;
  final String? category;
  final String description;

  void set increment_views(int v) {
    this.views = v;
  }

  Post(
      {required this.id,
      required this.author,
      required this.date,
      required this.title,
      required this.views,
      required this.upvotes,
      required this.downvotes,
      this.category,
      required this.description});
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  List<Widget> _posts = [];

  @override
  void initState() {
    super.initState();
    _posts.add(
      FutureBuilder(
        future: get_posts(_posts.length, _posts.length + 5),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            List<Post> posts = snapshot.data!.cast<Post>();
            return PostBuilder(post_list: posts);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<List<Post>> get_posts(int start, int end) async {
    var r = await http.get(Uri.parse(
        "https://fluttermenele.kacperek0.repl.co/posts?start=$start&stop=$end"));
    var json = jsonDecode("[${const Utf8Decoder().convert(r.bodyBytes)}]");
    List<Post> posts = [];
    for (var post in json) {
      for (var i = 0; i < json[0].length; i++) {
        posts.add(
          Post(
            id: post['$i']["id"],
            author: post['$i']["user"],
            date: post['$i']["date"].substring(0, 16),
            title: post['$i']["title"],
            views: post['$i']["views"],
            upvotes: post['$i']["upvotes"],
            downvotes: post['$i']["downvotes"],
            category: post['$i']["category"],
            description: post['$i']["description"],
          ),
        );
      }
    }
    return posts;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Template(
      context: context,
      body: NotificationListener<ScrollEndNotification>(
        onNotification: (scrollEnd) {
          final metrics = scrollEnd.metrics;
          if (metrics.atEdge) {
            bool isTop = metrics.pixels <= 50;
            if (isTop) {
              print('At the top');
            } else {
              setState(() {
                _posts.add(
                  FutureBuilder(
                    future: get_posts(_posts.length, _posts.length + 5),
                    builder:
                        (BuildContext context, AsyncSnapshot<List> snapshot) {
                      if (snapshot.hasData) {
                        List<Post> posts = snapshot.data!.cast<Post>();
                        return PostBuilder(post_list: posts);
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                );
              });
              print("bottom");
            }
          }
          return true;
        },
        child: ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return _posts[_posts.length - 1];
          },
        ),
      ),
    );
  }
}

class PostBuilder extends StatefulWidget {
  List<Post> post_list;
  PostBuilder({Key? key, required this.post_list}) : super(key: key);

  @override
  State<PostBuilder> createState() => _PostBuilderState();
}

class _PostBuilderState extends State<PostBuilder> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      cacheExtent: 5,
      addRepaintBoundaries: false,
      addAutomaticKeepAlives: true,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.post_list.length,
      itemBuilder: (context, i) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5.0,
                  spreadRadius: 5.0,
                  offset: Offset(
                    5.0,
                    5.0,
                  ),
                ),
              ],
            ),
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text(widget.post_list[i].title),
                  subtitle: Text(widget.post_list[i].author),
                  trailing: Text(widget.post_list[i].date),
                ),
                InkWell(
                  onTap: () {
                    // setState(() {
                    //   widget.post_list[i].views++;
                    // });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return PostLookup(
                            post: widget.post_list[i],
                          );
                        },
                      ),
                    );
                  },
                  child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Image.network(
                          "https://obraski.kacperek0.repl.co/static/img/posts/" +
                              (widget.post_list[i].id - 1).toString() +
                              "_large.webp")),
                ),
                Divider(),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                          child: Center(
                              child: Text("+" +
                                  widget.post_list[i].upvotes.toString())),
                          flex: 1),
                      VerticalDivider(),
                      Expanded(
                          child: Center(
                              child: Text("-" +
                                  widget.post_list[i].downvotes.toString())),
                          flex: 1),
                      VerticalDivider(),
                      Expanded(
                          child: Center(
                              child: Text(widget.post_list[i].views.toString() +
                                  " Wyświetleń")),
                          flex: 2),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
    ;
  }
}
