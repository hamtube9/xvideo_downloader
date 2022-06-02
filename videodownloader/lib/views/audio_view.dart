import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioView extends StatefulWidget {
  final String? path;

  const AudioView({Key? key, this.path}) : super(key: key);

  @override
  State<AudioView> createState() => _AudioViewState();
}

class _AudioViewState extends State<AudioView>
    with SingleTickerProviderStateMixin {
  AudioPlayer? _audioPlayer;
  String currentTime = "", endTime = "";
  double minDuration = 0;
  double currentDuration = 0;
  double maxDuration = 0;
  AnimationController? _animationController;
  bool isPlaying = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setAudio();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(microseconds: 300));
  }

  void setAudio() async {
    _audioPlayer = AudioPlayer();
    await _audioPlayer!.setFilePath(widget.path!);
    currentDuration = minDuration;
    maxDuration = _audioPlayer!.duration!.inMilliseconds.toDouble();
    setState(() {
      currentTime = getDuration(currentDuration);
      endTime = getDuration(maxDuration);
    });

    changeStatusPlaying();
    _audioPlayer!.positionStream.listen((duration) {
      currentDuration = duration.inMilliseconds.toDouble();
      print(currentDuration);
      if(mounted){
        setState(() => currentTime = getDuration(currentDuration));

      }
    });
    _audioPlayer!.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
      if(mounted){
        setState(() {
          currentDuration = minDuration;
        });
      }
      }
    });
  }

  void changeStatusPlaying() {
    setState(() => isPlaying = !isPlaying);
    isPlaying ? _audioPlayer!.play() : _audioPlayer!.pause();
    currentDuration == maxDuration ? isPlaying : !isPlaying;
    !_animationController!.isCompleted
        ? _animationController!.forward()
        : _animationController!.reverse();
  }

  String getDuration(double value) {
    Duration duration = Duration(milliseconds: value.round());
    return [duration.inHours, duration.inMinutes, duration.inSeconds]
        .map((e) => e.remainder(60).toString().padLeft(2, "0"))
        .join(":");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController!.dispose();
    _audioPlayer!.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: Center(
          child: Image.asset('assets/images/audiofile_grey.png',fit: BoxFit.cover,),
        )),
        SizedBox(
          height: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text("$currentTime | $endTime",style: const TextStyle(color: Color(0xFF7E909E)),),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                height: 40,
                child: Row(
                  children: [
                    SizedBox(
                      child: GestureDetector(
                        onTap: () {

                          changeStatusPlaying();
                        },
                        child: AnimatedIcon(
                          icon: AnimatedIcons.play_pause,
                          progress: _animationController!,
                          color: const Color(0xFF7E909E),
                          size: 24,
                        ),
                      ),
                      width: 24,
                    ),
                    Expanded(
                        child: Container(
                      child: Slider(
                        value: currentDuration,
                        min: minDuration,
                        max: maxDuration,
                        activeColor: Colors.lightBlue,
                        inactiveColor: const Color(0xFF7E909E),
                        thumbColor: const Color(0xFF7E909E),
                        onChanged: (v) {
                          currentDuration = v;
                        },
                        onChangeEnd:(c){
                          print(c);
                          _audioPlayer!.seek(Duration(milliseconds: c.toInt()));
                        },
                        onChangeStart: (c){

                        },
                      ),
                      margin: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                    ))
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => reverseDuration(),
                      child: Container(
                        child: Image.asset(
                          'assets/images/reverse.png',
                          width: 24,
                          height: 24,
                        ),
                        alignment: Alignment.centerRight,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => forwardDuration(),
                      child: Container(
                        child: Image.asset(
                          'assets/images/forward.png',
                          width: 24,
                          height: 24,
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40,)
            ],
          ),
        ),
      ],
    );
  }

  reverseDuration() {
    var sec = 0.0;
    if(currentDuration <= 10000 ){
      sec = 0;
    }else{
      sec = (currentDuration - 10000);
    }
    _audioPlayer!.seek(Duration(milliseconds: sec.toInt()));

  }
  forwardDuration() {
    var sec = (currentDuration + 10000);
    if(sec > maxDuration){
      sec = maxDuration;
    }
    _audioPlayer!.seek(Duration(milliseconds: sec.toInt()));
  }
}
