import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeVideoPlayer extends StatefulWidget {
  final String youtubeUrl;

  const YoutubeVideoPlayer({super.key, required this.youtubeUrl});

  @override
  State<YoutubeVideoPlayer> createState() => _YoutubeVideoPlayerState();
}

class _YoutubeVideoPlayerState extends State<YoutubeVideoPlayer> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;

  @override
  void initState() {
    final videoId = YoutubePlayer.convertUrlToId(widget.youtubeUrl);
    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        disableDragSeek: false,
        enableCaption: false,
      ),
    )..addListener(() {
      if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
        setState(() {}); // update UI when play/pause changes
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.red,
        onReady: () {
          _isPlayerReady = true;
        },
      ),
      builder: (context, player) {
        return Stack(
          children: [
            AbsorbPointer(
              absorbing: !_controller.value.isPlaying,
              child: player,
            ),
            if (!_controller.value.isPlaying)
              Center(
                child: IconButton(
                  icon: const Icon(Icons.play_circle_fill, size: 64, color: Colors.white),
                  onPressed: () {
                    _controller.play();
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
