// import 'package:flutter/material.dart';
// import 'package:youtube_player_iframe/youtube_player_iframe.dart';

// class YoutubeLiveStreamWidget extends StatefulWidget {
//   final String videoId;

//   const YoutubeLiveStreamWidget({Key? key, required this.videoId})
//       : super(key: key);

//   @override
//   _YoutubeLiveStreamWidgetState createState() =>
//       _YoutubeLiveStreamWidgetState();
// }

// class _YoutubeLiveStreamWidgetState extends State<YoutubeLiveStreamWidget> {
//   late YoutubePlayerController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = YoutubePlayerController(
//       params: YoutubePlayerParams(
//         showControls: true,
//         showFullscreenButton: true,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return YoutubePlayerIFrame(
//       controller: _controller,
//       aspectRatio: 16 / 9,
//     );
//   }

//   @override
//   void dispose() {
//     _controller.close();
//     super.dispose();
//   }
// }
