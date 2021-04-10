import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_trip_app/pages/schematization/models/SpotDetail.dart';
import 'package:easy_trip_app/utilities/screen_util.dart';
import 'package:easy_trip_app/utilities/user_state.dart';
import 'package:easy_trip_app/widgets/TextExpand.dart';
import 'package:flutter/material.dart';
import 'package:easy_trip_app/widgets/MarkdownStyleSheet.dart';
import 'package:easy_trip_app/widgets/MarkdownWidget.dart';

import '../presets.dart';

class SpotDetailPage extends StatefulWidget {
  SpotDetailPage({required this.poiId, this.spotName});

  //TODO: 加载景点

  String? spotName;
  int poiId;

  @override
  _SpotDetailPageState createState() => _SpotDetailPageState();
}

class _SpotDetailPageState extends State<SpotDetailPage> with ScreenUtil {
  bool isLoaded = false;

  void loadData() async {
    if (isLoaded) return;
    // await Future.delayed(Duration(seconds: 2));
    // if (mounted)
    //   setState(() {
    //     detail = SpotDetail(
    //       poiId: 114514,
    //       name: 'Some name',
    //       description: 'this is the slogen.',
    //       rating: 4.8,
    //       position: LatLng(0, 0),
    //     );
    //   });
    // todo: Uri 硬编码 更改为xml读取
    await User.request
        .get('https://api.ryuujo.com/poi/detail?poiID=${widget.poiId}')
        .then((value) {
      var json = value.data;
      print(json);
      var _detail = SpotDetail.fromJson(json);
      if (mounted)
        setState(() {
          detail = _detail;
        });
    }).whenComplete(() => isLoaded = true);
  }

  SpotDetail? detail;

  @override
  Widget build(BuildContext context) {
    loadData();
    return Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(detail?.name ?? widget.spotName ?? "..."),
                background: CachedNetworkImage(
                  imageUrl: detail?.coverUrl ??
                      'https://img1.mukewang.com/5c18cf540001ac8206000338.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: setHeight(20),
              ),
            ),

            // least todo: implement this
            // SliverOffstage(
            //   offstage: true,
            //   sliver: SliverGrid.count(
            //     crossAxisCount: 3,
            //     crossAxisSpacing: setWidth(20),
            //     children: [
            //       //Photos
            //       _Block(
            //         text: '1,470',
            //         tag: '实景图',
            //       ),
            //       //Likes
            //       _Block(
            //         text: '21,071',
            //         tag: '推荐',
            //       ),
            //       //Reviews
            //       _Block(
            //         text: '398',
            //         tag: '评价',
            //       ),
            //     ],
            //   ),
            // ),
            //评分
            SliverToBoxAdapter(
                child: Row(
                  children: [
                    Spacer(flex: 1),
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: Text(
                          '评分',
                          style: defaultTextStyle.copyWith(fontSize: 18),
                        ),
                      ),
                    ),
                    Spacer(),
                    Expanded(
                      flex: 7,
                      child: () {
                        return Text(
                          '${detail?.rating ?? '暂无'}',
                          style: defaultTextStyle.copyWith(
                            fontWeight: FontWeight.w900,
                            fontSize: 28,
                          ),
                        );
                      }.call(),
                    )
                  ],
                )),

            SliverList(
                delegate: SliverChildListDelegate(
              [
                Divider(),
                Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 30),
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                            child: Column(
                          children: [
                            Icon(Icons.av_timer_rounded),
                            Text('推荐游玩时间'),
                            Text(
                                '${(detail?.playTime.splitMapJoin(RegExp(r'(\d+)-(\d+)'), onMatch: (m) {
                                      return '${m[1] == m[2] ? m[1] : m[0]} (分钟)';
                                    })) ?? '--'}'),
                          ],
                        )),
                      ),
                      Expanded(
                        child: Center(
                            child: Column(
                          children: [
                            Icon(Icons.money),
                            Text('预计消费'),
                            Text('${detail?.prices.first ?? '--'}')
                            // fixme: adapt to different prices
                          ],
                        )),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.grey[50],
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextLimitDisplay(
                      minLines: 8,
                      text: detail?.description ?? '...',
                      style: defaultTextStyle.copyWith(height: 1.5),
                      shrinkIcon: Icon(
                        Icons.arrow_circle_up_outlined,
                        color: Colors.grey[500],
                      ),
                      expandIcon: Icon(
                        Icons.arrow_drop_down_circle_outlined,
                        color: Colors.grey[500],
                      ), //todo: adapt to night mode using non-outlined with deep color.
                    ),
                  ),
                ),
                detail == null ? SizedBox() : Divider(),
                detail == null
                    ? SizedBox()
                    : Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '开放时间',
                              style: defaultTextStyle.copyWith(fontSize: 20),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '${detail?.openTime ?? '全年开放'}',
                              //.splitMapJoin('\n', onMatch: (m) => '${m[0]}　'),
                              style: defaultTextStyle,
                            )
                          ],
                        ),
                      ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: MarkdownBody(
                    //todo: solve the '\n' in markdown table cell.
                    data: detail?.preferMd ?? '',
//                         '''# 优惠政策
// |适用人群|描述|优惠|
// |---|---|---|
// |儿童| **1、** 6周岁（含6周岁）以下或身高1.2米（含1.2米）以下（有监护人陪同）儿童免费；**2、**“六一”儿童节，14周岁以下儿童（含14周岁）免费（随同家长一人享受半价优惠 ）；|免费|
// |老人|年龄：60周岁（含）以上|优惠|
// |学生|1、大、中、小学学生（含港、澳、台学生；不含成人教育、研究生）凭学生证或学校介绍信可购买学生/儿童票； 2、6周岁（不含6周岁）至18周岁（含18周岁）未成年人，可凭身份证、户口本或护照购买学生/儿童票|优惠|
// |残疾人|凭残疾人证件|免费|
// |军人|“八一”建军节，现役军人凭有效证件|免费|
// |离休干部|凭离休证|免费|
// |低保人员|持有本市城乡居民最低生活保障金领取证的人员凭有效证件|半价|
// |女性|三八”妇女节，女性观众享受|半价|
// ''',
                    // bulletBuilder: (a, b) => SizedBox(),
                    styleSheet: MarkdownStyleSheet(
                        h1: defaultTextStyle.copyWith(fontSize: 20),
                        h3: defaultTextStyle,
                        strong: TextStyle(fontWeight: FontWeight.bold),
                        tableColumnWidthBuilder: (index) => (const [
                              FixedColumnWidth(60),
                              FlexColumnWidth(1.0),
                              FixedColumnWidth(60)
                            ])[index]),
                  ),
                ),
              ],
            ))
          ],
        ));
  }
}

class _Block extends StatelessWidget {
  _Block({
    required this.text,
    required this.tag,
  });

  final String text;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.green[100],
          borderRadius: BorderRadius.circular(3),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // todo: replace the two with RichText.
            //Bigger Sized Text
            Text(
              text,
              style: defaultTextStyle.copyWith(
                  fontSize: 24,
                  color: Colors.green[700],
                  fontWeight: FontWeight.w700),
            ),
            //Smaller Sized Tag
            Text(
              tag,
              style: defaultTextStyle.copyWith(
                  fontSize: 14, color: Colors.green[500]),
            )
          ],
        ));
  }
}
