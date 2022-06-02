import 'dart:convert';
import 'package:flutter/material.dart';
import 'home.dart';
import 'package:http/http.dart' as http;

class Comment {
  final String author;
  final String date;
  final String content;

  Comment({required this.author, required this.date, required this.content});
}

class PostLookup extends StatefulWidget {
  final Post post;
  const PostLookup({required this.post});

  @override
  State<PostLookup> createState() => _PostLookupState();
}

class _PostLookupState extends State<PostLookup> {
  Future<List<Comment>> get_comments(int post_id) async {
    var r = await http.get(
        Uri.parse("https://fluttermenele.kacperek0.repl.co/comments/$post_id"));
    var json = jsonDecode("[${const Utf8Decoder().convert(r.bodyBytes)}]");
    List<Comment> comments = [];
    for (var post in json) {
      for (var i = 0; i < json[0].length; i++) {
        comments.add(
          Comment(
            date: post['$i']["date"],
            author: post['$i']["user"],
            content: post['$i']["content"],
          ),
        );
      }
    }
    return comments;
  }

  @override
  Widget build(BuildContext context) {
    Post post = widget.post;
    return Scaffold(
      appBar: AppBar(
        title: Text("Podgląd posta"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text(post.title),
              leading: Icon(Icons.account_circle, size: 64.0),
              subtitle: Text(post.author),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [Text(post.date), Icon(Icons.more_vert)],
              ),
            ),
            Container(
              child: Text(
                post.description,
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.left,
              ),
              width: double.infinity,
              padding: EdgeInsets.all(16),
            ),
            Container(
              child: Image.network(
                "https://obraski.kacperek0.repl.co/static/img/posts/" +
                    (post.id - 1).toString() +
                    "_large.webp",
                fit: BoxFit.fitWidth,
              ),
              width: double.infinity,
              constraints: BoxConstraints(maxHeight: double.infinity),
              padding: EdgeInsets.all(16.0),
            ),
            Divider(),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "+" + post.upvotes.toString(),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "-" + post.downvotes.toString(),
                    textAlign: TextAlign.center,
                  ),
                ),
                const VerticalDivider(),
                Expanded(
                  flex: 1,
                  child: Text(
                    post.views.toString() + " wyświetleń",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 3,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Komentarz",
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: ElevatedButton(
                      child: Text("Dodaj"),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            FutureBuilder(
              future: get_comments(post.id),
              builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: (snapshot.data! as List).length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, i) {
                      return Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.account_circle),
                            title: Text(snapshot.data![i].author),
                            trailing: Text(snapshot.data![i].date),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 4),
                            child: SizedBox(
                              width: double.infinity,
                              child: Text(
                                snapshot.data![i].content,
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          Divider(),
                        ],
                      );
                    },
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
