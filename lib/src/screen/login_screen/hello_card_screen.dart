import 'package:flutter/material.dart';
import 'package:shopping_app/src/widget/text_widget.dart';
import 'package:video_player/video_player.dart';
import '../main_screen/main_holder.dart';
import 'card_dashboard.dart';

class HelloCardScreen extends StatefulWidget {
  const HelloCardScreen({super.key});

  @override
  State<HelloCardScreen> createState() => _HelloCardScreenState();
}

class _HelloCardScreenState extends State<HelloCardScreen> {
  final PageController pageController = PageController(viewportFraction: 0.88);
  int indexScroll = 0;
  final List<OnboardingItem> _items = [
    OnboardingItem(
      url: 'assets/video/model_2.mp4',
      title: 'Premium Collection',
      description:
          'Explore our curated selection of high-end fashion pieces tailored just for you.',
      isVideo: true,
    ),
    OnboardingItem(
      url:
          'assets/video/model_1.mp4',
      title: 'Modern Lifestyle',
      description:
          'Upgrade your daily routine with our modern and minimalist product designs.',
      isVideo: true,
    ),
    OnboardingItem(
      url:
          'https://img.i-scmp.com/cdn-cgi/image/fit=contain,width=1024,format=auto/sites/default/files/d8/images/canvas/2023/07/21/6e75fba0-9480-4c97-8e7c-2ae472788604_d2e0237f.jpg',
      title: 'Ready to Shop?',
      description:
          'Join thousands of users and start your luxury shopping journey today.',
      isShowButton: true,
      isVideo: false,
    ),
  ];

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -80,
            left: -60,
            child: Opacity(
              opacity: 0.5,
              child: Image.asset(
                'assets/image/login1.png',
                width: 360,
                errorBuilder: (c, e, s) => const SizedBox(),
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            right: -80,
            child: Opacity(
              opacity: 0.5,
              child: Image.asset(
                'assets/image/bubble5.png',
                width: 360,
                errorBuilder: (c, e, s) => const SizedBox(),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 60),
                Expanded(
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: _items.length,
                    onPageChanged: (value) =>
                        setState(() => indexScroll = value),
                    itemBuilder: (context, index) {
                      double scale = indexScroll == index ? 1.0 : 0.9;
                      return AnimatedScale(
                        scale: scale,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutQuart,
                        child: CardDashboard(
                          imageWidget: _items[index].isVideo
                              ? VideoPlayerWidget(
                                  url: _items[index].url,
                                  play: indexScroll == index,
                                )
                              : Image.network(
                                  _items[index].url,
                                  fit: BoxFit.cover,
                                ),
                          title: _items[index].title,
                          description: _items[index].description,
                          isShowButton: _items[index].isShowButton,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _items.length,
                    (index) => _buildDot(index),
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: indexScroll == _items.length - 1 ? 1.0 : 0.0,
                    child: IgnorePointer(
                      ignoring: indexScroll != _items.length - 1,
                      child: SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MainHolder(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0055FF),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child:TextWidget(
                            'Get Started',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    bool isSelected = indexScroll == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 6),
      height: 8,
      width: isSelected ? 24 : 8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: isSelected
            ? const Color(0xFF0055FF)
            : Colors.grey.withValues(alpha: 0.3),
      ),
    );
  }
}

class OnboardingItem {
  final String url;
  final String title;
  final String description;
  final bool isShowButton;
  final bool isVideo;

  OnboardingItem({
    required this.url,
    required this.title,
    required this.description,
    this.isShowButton = false,
    this.isVideo = false,
  });
}
class VideoPlayerWidget extends StatefulWidget {
  final String url;
  final bool play;

  const VideoPlayerWidget({super.key, required this.url, required this.play});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.url)
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(true);
        _controller.setVolume(0);
        if (widget.play) _controller.play();
      });
  }

  @override
  void didUpdateWidget(VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_controller.value.isInitialized) {
      widget.play ? _controller.play() : _controller.pause();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            ),
          )
        : const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Color(0xFF0055FF),
            ),
          );
  }
}
