import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VideoDemo(),
    );
  }
}
class VideoDemo extends StatefulWidget {
  @override
  _VideoDemoState createState() => _VideoDemoState();
}

class _VideoDemoState extends State<VideoDemo> {

 Key _key = GlobalKey<ScaffoldState>();

 String url ="https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4";
 VlcPlayerController vlcPlayerController;
 bool isPlaying = true;
 bool isBuffering = true;
 String position = '';
 String duration = '';
 double sliderValue = 0.0;
 double startValue = 0.0;
 double volume = 80;


 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    vlcPlayerController = new VlcPlayerController(onInit: (){
      vlcPlayerController.play();
    });
    vlcPlayerController.addListener(() {
      if(!this.mounted){
        return;
      }
      if(vlcPlayerController.initialized){
        var Position = vlcPlayerController.position;
        var Duration = vlcPlayerController.duration;
        if(Duration.inHours == 0) {
          var startPosition = Position.toString().split('.')[0];
          var startDuration = Duration.toString().split('.')[0];
          position =
          '${startPosition.split(':')[1]}:${startPosition.split(':')[2]}';
          duration =
          '${startDuration.split(':')[1]};${startDuration.split(':')[2]}';
        }else{
          position = Position.toString().split('.')[0];
          duration = Duration.toString().split('.')[0];
        }
        sliderValue = vlcPlayerController.position.inSeconds.toDouble();


        switch(vlcPlayerController.playingState){

          case PlayingState.PLAYING:
            setState(() {
              isBuffering = false;
            });
            break;
          case PlayingState.BUFFERING:
            setState(() {
              isBuffering = true;
            });
            break;

          case PlayingState.STOPPED:
            setState(() {
              isBuffering = false;
              isPlaying = false;
            });
            break;

          case PlayingState.PAUSED:
            setState(() {
              isPlaying = false;
              isBuffering = false;
            });
            break;

          case PlayingState.ERROR:
            setState(() {
            });
            print('Error cant play');
            break;

          default:
            setState((){});
            break;
        }
      }
    });
  }

 @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    vlcPlayerController.dispose();
  }

  void playAndPause(){
   String state = vlcPlayerController.playingState.toString();

   if(state == 'PlayingState.PLAYING'){
     vlcPlayerController.pause();
     setState(() {
       isPlaying = false;
     });
   }
   else{
     vlcPlayerController.play();
     setState(() {
       isPlaying = true;
     });
   }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text('Demo'),
      ),
      body: Builder(builder:(context){
        return Container(
          padding: EdgeInsets.all(10.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              SizedBox(
                height: 250,
                child: new VlcPlayer(
                    controller: vlcPlayerController,
                    aspectRatio: 16 / 9,
                    url: url,
                  isLocalMedia: false,
                  placeholder: Container(
                    height: 250.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                      flex: 1,
                      child: FlatButton(
                          onPressed: (){playAndPause();},
                          child: isPlaying ? Icon(Icons.pause_circle_outline) :
                              Icon(Icons.play_circle_outline),
                      ),),
                  Flexible(
                    flex: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(position),
                        Expanded(
                            child: Slider(
                                value: sliderValue,
                                activeColor: Colors.red,
                                min: 0.0,
                                max: vlcPlayerController.duration == null ? 1.0
                                    : vlcPlayerController.duration.inSeconds.toDouble(),
                                onChanged: (progress){
                                  setState(() {
                                    sliderValue = progress.floor().toDouble();
                                  });
                                  vlcPlayerController.setTime(sliderValue.toInt()* 1000);
                                }
                            ),
                        ),
                        Text(duration),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(height: 1,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Volume Level'),
                  Slider(
                    min: 0,
                    max: 100,
                    value: volume,
                    onChanged: (value){
                      setState(() {
                        volume = value;
                      });

                      vlcPlayerController.setVolume(volume.toInt());
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}


















