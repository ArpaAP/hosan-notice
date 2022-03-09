import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;

import '../modules/refresh_token.dart';

class AssignmentPage extends StatefulWidget {
  final String assignmentId;

  AssignmentPage({Key? key, required this.assignmentId}) : super(key: key);

  @override
  _AssignmentPageState createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> {
  final user = FirebaseAuth.instance.currentUser!;
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  final remoteConfig = RemoteConfig.instance;
  final storage = new LocalStorage('auth.json');

  bool? assignmentLoadDone;

  late Future<Map<dynamic, dynamic>> _assignment;

  Future<Map<dynamic, dynamic>> fetchAssignment() async {
    var rawData = remoteConfig.getAll()['BACKEND_HOST'];
    var cfgs = jsonDecode(rawData!.asString());

    final response = await http.get(
        Uri.parse(
            '${kReleaseMode ? cfgs['release'] : cfgs['debug']}/assignments/${widget.assignmentId}'),
        headers: {
          'ID-Token': await user.getIdToken(true),
          'Authorization': 'Bearer ${storage.getItem('AUTH_TOKEN')}',
        });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401 &&
        jsonDecode(response.body)['code'] == 40100) {
      await refreshToken();
      return await fetchAssignment();
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  void initState() {
    _assignment = fetchAssignment();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _assignment,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
              appBar: AppBar(
                title: Text('과제 불러오는 중...'),
              ),
              body: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    CircularProgressIndicator(color: Colors.deepPurple),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text('불러오는 중', textAlign: TextAlign.center),
                    )
                  ])));
        }

        print('asdf');

        final data = snapshot.data;

        Duration? timeDiff;
        String? timeDiffStr;
        if (data['createdAt'] != null) {
          timeDiff =
              DateTime.parse(data['createdAt']).difference(DateTime.now());
          if (timeDiff.inSeconds <= 0) {
            final timeDiffNegative =
                DateTime.now().difference(DateTime.parse(data['createdAt']));
            if (timeDiffNegative.inDays > 0)
              timeDiffStr = '${timeDiffNegative.inDays}일 전 등록함';
            else if (timeDiffNegative.inHours > 0)
              timeDiffStr = '${timeDiffNegative.inHours}시간 전 등록함';
            else if (timeDiffNegative.inMinutes > 0)
              timeDiffStr = '${timeDiffNegative.inMinutes}분 전 등록함';
            else
              timeDiffStr = '${timeDiffNegative.inSeconds}초 전 등록함';
          } else {
            if (timeDiff.inDays > 0)
              timeDiffStr = '${timeDiff.inDays}일 남음';
            else if (timeDiff.inHours > 0)
              timeDiffStr = '${timeDiff.inHours}시간 남음';
            else if (timeDiff.inMinutes > 0)
              timeDiffStr = '${timeDiff.inMinutes}분 남음';
            else
              timeDiffStr = '${timeDiff.inSeconds}초 남음';
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['title']),
                Text(
                    data['deadline'] != null
                        ? '기한: ${DateTime.parse(data['deadline']).toLocal().toString().split('.')[0]} 까지'
                        : '기한 없음',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .apply(color: Colors.white))
              ],
            ),
            toolbarHeight: 70,
            backgroundColor: (data['deadline'] == null ||
                    DateTime.parse(data['deadline'])
                            .difference(DateTime.now())
                            .inSeconds >=
                        0)
                ? Colors.deepPurple
                : Colors.pink,
          ),
          body: RefreshIndicator(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: double.infinity,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Card(
                              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: ListTile(
                                horizontalTitleGap: 2,
                                leading: Icon(Icons.subject, size: 28),
                                title: Text(
                                  data['subject']['name'],
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 16),
                                ),
                                onTap: () {},
                              )),
                        ),
                        (data['teacher'] != null
                            ? Expanded(
                                flex: 3,
                                child: Card(
                                    margin: EdgeInsets.fromLTRB(6, 10, 0, 0),
                                    child: ListTile(
                                      horizontalTitleGap: 2,
                                      leading: Icon(Icons.person, size: 28),
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data['teacher'],
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            '선생님',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      onTap: () {},
                                    )),
                              )
                            : SizedBox(width: 0))
                      ],
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 0,
                        margin: EdgeInsets.only(top: 10, bottom: 5),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 10),
                          child: SelectableText(
                              (data['description'] as String).isNotEmpty
                                  ? data['description'].replaceAll(r'\n', '\n')
                                  : '(내용 없음)',
                              style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(width: 5),
                        Text.rich(
                          TextSpan(
                            style: Theme.of(context).textTheme.caption,
                            children: [
                              TextSpan(
                                text: data['author']['name'],
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              TextSpan(
                                text: '님이 ${timeDiffStr}',
                              ),
                            ],
                          ),
                        ),
                        Expanded(child: Container()),
                        TextButton.icon(
                          onPressed: () {},
                          icon: Icon(
                            Icons.edit,
                            size: 22,
                          ),
                          label: Text('수정'),
                          style: TextButton.styleFrom(
                            textStyle: TextStyle(fontSize: 14),
                          ),
                        ),
                        SizedBox(width: 5),
                        TextButton.icon(
                          onPressed: () {},
                          icon: Icon(
                            Icons.delete,
                            size: 22,
                          ),
                          label: Text('삭제'),
                          style: TextButton.styleFrom(
                            primary: Colors.red[800],
                            textStyle: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        SizedBox(width: 5),
                        Text(
                          '이 과제/수행평가의 댓글',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .apply(color: Colors.grey[700], fontSizeDelta: -1),
                        ),
                        SizedBox(width: 10),
                        Expanded(child: Divider(thickness: 1)),
                      ],
                    )
                  ],
                ),
              ),
            ),
            onRefresh: () async {
              final fetchFuture = fetchAssignment();
              setState(() {
                _assignment = fetchFuture;
              });
              await Future.wait([fetchFuture]);
            },
          ),
        );
      },
    );
  }
}
