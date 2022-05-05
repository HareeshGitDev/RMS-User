import 'dart:developer';

import 'package:RentMyStay_user/property_details_module/model/property_details_model.dart';
import 'package:RentMyStay_user/theme/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PropertyGalleryViewPage extends StatefulWidget {
  final List<Pic> imageList;
  final String? videoLink;

  const PropertyGalleryViewPage(
      {Key? key, required this.imageList, required this.videoLink})
      : super(key: key);

  @override
  _PropertyGalleryViewPageState createState() =>
      _PropertyGalleryViewPageState();
}

class _PropertyGalleryViewPageState extends State<PropertyGalleryViewPage> {
  late YoutubePlayerController youTubeController;
  var _mainHeight;
  var _mainWidth;
  bool showVideo = false;

  @override
  void initState() {
    super.initState();
    youTubeController = YoutubePlayerController(
      initialVideoId:widget.videoLink ??'',
      flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: true,
          controlsVisibleAtStart: false,
          useHybridComposition: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text('Property Gallery'),
        actions: [
          GestureDetector(
            onTap: () => setState(() => showVideo = !showVideo),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: CustomTheme.white),
              padding: EdgeInsets.only(left: 10, right: 10),
              margin: EdgeInsets.only(right: 10, top: 8, bottom: 8),
              child: Row(
                children: [
                  Text(
                    showVideo ? 'Photo Mode' : 'Video Mode',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: CustomTheme.appTheme),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(showVideo ? Icons.photo : Icons.play_circle_fill,
                      color: CustomTheme.appTheme),
                ],
              ),
            ),
          )
        ],
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: Visibility(
              visible: showVideo,
              replacement: CarouselSlider(
                items: widget.imageList
                    .map((e) => CachedNetworkImage(
                          imageUrl: e.picWp.toString(),
                          imageBuilder: (context, imageProvider) =>
                              InteractiveViewer(
                            minScale: 0.5,
                            maxScale: 4.0,
                            scaleEnabled: true,
                            constrained: true,
                            panEnabled: true,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Shimmer.fromColors(
                              child: Container(
                                height: _mainHeight * 0.3,
                                color: Colors.grey,
                              ),
                              baseColor: Colors.grey[200] as Color,
                              highlightColor: Colors.grey[350] as Color),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ))
                    .toList(),
                options: CarouselOptions(
                    height: _mainHeight * 0.3,
                    enlargeCenterPage: false,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlay: true,
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.decelerate,
                    enableInfiniteScroll: true,
                    viewportFraction: 1),
              ),
              child: YoutubePlayerBuilder(
                onEnterFullScreen: () {
                  log('FullScreen');
                },
                player: YoutubePlayer(
                  aspectRatio: 1.2,
                  controller: youTubeController,
                  showVideoProgressIndicator: false,
                  topActions: [
                    Text(
                      'Powered by RMS',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                        onPressed: () {
                          if (youTubeController.flags.mute) {
                            youTubeController.unMute();
                          }
                        },
                        icon: Icon(
                          Icons.volume_mute,
                          color: Colors.white,
                        ))
                  ],
                ),
                builder: (BuildContext context, Widget player) => player,
              )),
        ),
      ),
    );
  }
}
