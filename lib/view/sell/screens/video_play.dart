import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../../const/app_sizes.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String url;
  final String mediaUrl;
  const VideoPlayerScreen(this.url, this.mediaUrl, {super.key});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isVideoEnded = false;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(
      Uri.parse(VideoURL+widget.url),
    )..initialize().then((_) {
        setState(() {});
      });

    _controller.addListener(() {
      final bool isPlaying = _controller.value.isPlaying;
      final bool isEnded =
          _controller.value.position >= _controller.value.duration;

      if (!isPlaying && isEnded && !_isVideoEnded) {
        setState(() {
          _isVideoEnded = true;
          _isPlaying = false;
        });
      } else if (isPlaying && !_isPlaying) {
        setState(() {
          _isPlaying = true;
          _isVideoEnded = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_isVideoEnded) {
      _controller.seekTo(Duration.zero);
      _controller.play();
      setState(() {
        _isVideoEnded = false;
        _isPlaying = true;
      });
    } else if (_controller.value.isPlaying) {
      _controller.pause();
      setState(() {
        _isPlaying = false;
      });
    } else {
      _controller.play();
      setState(() {
        _isPlaying = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.isInitialized
            ? Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                  GestureDetector(
                    onTap: _togglePlayPause,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black26,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        (_controller.value.isPlaying && !_isVideoEnded)
                            ? Icons.pause
                            : Icons.play_arrow,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
