import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/src/widget/text_widget.dart';
import 'package:video_player/video_player.dart';

class StoriesSection extends StatelessWidget {
  const StoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: TextWidget(
            'Stories',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
          ),
        ),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: stories.length,
            itemBuilder: (context, index) {
              final story = stories[index];
              return story['type'] == 'video'
                  ? VideoStoryCard(
                      key: ValueKey(story['url']),
                      videoUrl: story['url'],
                      isLive: story['isLive'],
                    )
                  : ImageStoryCard(
                      imageUrl: story['url'],
                      isLive: story['isLive'],
                    );
            },
          ),
        ),
      ],
    );
  }
}

class ImageStoryCard extends StatelessWidget {
  final String imageUrl;
  final bool isLive;

  const ImageStoryCard({
    super.key,
    required this.imageUrl,
    this.isLive = false,
  });

  @override
  Widget build(BuildContext context) {
    return _StoryContainer(
      isLive: isLive,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey[200],
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
        errorWidget: (context, url, error) =>
            const Icon(Icons.error, color: Colors.grey),
      ),
    );
  }
}

class VideoStoryCard extends StatefulWidget {
  final String videoUrl;
  final bool isLive;

  const VideoStoryCard({
    super.key,
    required this.videoUrl,
    this.isLive = false,
  });

  @override
  State<VideoStoryCard> createState() => _VideoStoryCardState();
}

class _VideoStoryCardState extends State<VideoStoryCard> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isMuted = true;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    _controller = VideoPlayerController.asset(widget.videoUrl)
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() {
          _isInitialized = true;
        });
        _controller.setVolume(_isMuted ? 0 : 1);
        _controller.setLooping(true);
        _controller.play();
      });
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _controller.setVolume(_isMuted ? 0 : 1);
    });
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
      _isPlaying ? _controller.play() : _controller.pause();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePlay,
      child: _StoryContainer(
        isLive: widget.isLive,
        muteButton: GestureDetector(
          onTap: _toggleMute,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
        ),
        playOverlay: !_isPlaying
            ? const Center(
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 50,
                ),
              )
            : null,
        child: _isInitialized
            ? SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  clipBehavior: Clip.hardEdge,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                ),
              )
            : Container(
                color: Colors.black12,
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              ),
      ),
    );
  }
}

class _StoryContainer extends StatelessWidget {
  final Widget child;
  final bool isLive;
  final Widget? muteButton;
  final Widget? playOverlay;

  const _StoryContainer({
    required this.child,
    required this.isLive,
    this.muteButton,
    this.playOverlay,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.4)
                : Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            Positioned.fill(child: child),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.2),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.5),
                    ],
                  ),
                ),
              ),
            ),

            if (playOverlay != null) Positioned.fill(child: playOverlay!),

            if (isLive) Positioned(top: 12, left: 12, child: _LiveBadge()),

            if (muteButton != null)
              Positioned(top: 12, right: 12, child: muteButton!),
          ],
        ),
      ),
    );
  }
}

class _LiveBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFF0055),
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          TextWidget(
            'LIVE',
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        ],
      ),
    );
  }
}

final List<Map<String, dynamic>> stories = [
  {'type': 'video', 'url': 'assets/video/vd_story1.mp4', 'isLive': true},
  {'type': 'video', 'url': 'assets/video/vd_story_2.mp4', 'isLive': true},
  {'type': 'video', 'url': 'assets/video/vd_story3.mp4', 'isLive': true},
  {'type': 'video', 'url': 'assets/video/vd_story4.mp4', 'isLive': true},
];
