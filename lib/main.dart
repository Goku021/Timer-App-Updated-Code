import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:untitled/countDownTimer.dart';
import 'package:untitled/timerModel.dart';

void main(){
  runApp( const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});
  @override
  Widget build(BuildContext context){
    return const MaterialApp(
      title: "Timer App",
      home: MyHomePage(),
    );
  }
}
class MyHomePage extends StatefulWidget{
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage>{



  String time = "30:00";
  CountDownTimer timer = CountDownTimer();
  late Stream<TimerModel> timerStream;
  double percent = 1.0;
  int workTime = 30;
  int shortBreakTime = 5;
  int longBreakTime = 15;

  @override
  void initState(){
    super.initState();
    timerStream = timer.stream();
    timer.startWork();
    workTime = 30;
  }
  void stopTimer(){
    timer.isActive = false;
  }
  void restartTimer(){
    timerStream = timer.stream();
    timer.startWork();
  }
  void startTimer(int minutes){
    timer.workTime = minutes;
    timerStream = timer.stream();
    timer.startWork();
  }
  void updateTimes(int work, int short, int long){
    workTime = work;
    shortBreakTime = short;
    longBreakTime = long;
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Timer App", style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
        actions: [
          IconButton(onPressed:() async {
           final result = await Navigator.push(context, MaterialPageRoute(builder: (context){
              return  SettingPage(workTime: workTime,shortBreakTime: shortBreakTime, longBreakTime: longBreakTime,);
            }));
           if(result != null){
             updateTimes(result['work'], result['short'], result['long']);
           }
          }, icon:const Icon(Icons.settings))
        ],
      ),
      body: LayoutBuilder(builder :(BuildContext context, BoxConstraints constraints){
        final double availableWidth = constraints.maxWidth;
        return Column(

          children: [
            Row(
              children: [
               Expanded(child:Padding(padding:const EdgeInsets.all(10.0),
                   child: ProductiveButton(color: Colors.red, text: "Work", width: 5.0, onPressed: ()=>startTimer(workTime) ),
               ),
               ),
                Expanded(child:Padding(padding:const EdgeInsets.all(10.0),
                  child: ProductiveButton(color: Colors.red, text: "Short Break", width: 5.0, onPressed: ()=>startTimer(shortBreakTime) ),
                ),
                ),
                Expanded(child:Padding(padding:const EdgeInsets.all(10.0),
                  child: ProductiveButton(color: Colors.red, text: "Long Break", width: 5.0, onPressed: ()=>startTimer(longBreakTime) ),
                ),
                )
              ],
            ),
            StreamBuilder(stream: timerStream, builder: (context, snapShot){
              if(snapShot.connectionState == ConnectionState.active){
                time = snapShot.data?.time ?? "30:00";
                percent = snapShot.data?.radius ?? 1;
              }
              return CircularPercentIndicator(radius: availableWidth / 4,
              percent: percent,
              lineWidth: 10.0, progressColor: Colors.deepPurpleAccent,
                center: Text(time, style:const TextStyle(fontWeight: FontWeight.bold, fontSize: 45.0),),);
            }),
            Row( children: [
            Expanded(child:Padding(padding:const EdgeInsets.all(10.0),
              child: ProductiveButton(color: Colors.red, text: "Stop", width: 5.0, onPressed: stopTimer ),
            ),
            ),
            Expanded(child:Padding(padding:const EdgeInsets.all(10.0),
              child: ProductiveButton(color: Colors.red, text: "Restart", width: 5.0, onPressed: restartTimer, ),
            ),
            )
      ]
            )
          ],
        );
      }),
    );
  }
}

class ProductiveButton extends StatelessWidget{
  final Color color;
  final String text;
  final double width;
  final VoidCallback onPressed;
  const ProductiveButton({super.key,required this.color, required this.text, required this.width, required this.onPressed});
  @override
  Widget build(BuildContext context){
    return MaterialButton(onPressed: onPressed,color: color,minWidth: width,child:Text(text),);
  }
}

class SettingPage extends StatefulWidget{
  final int workTime;
  final int shortBreakTime;
  final int longBreakTime;
  const SettingPage({super.key, required this.workTime, required this.longBreakTime, required this.shortBreakTime});

  @override
  _SettingsPageState createState()=> _SettingsPageState();
}
class _SettingsPageState extends State<SettingPage>{
  late int workTime;
  late int shortBreakTime;
  late int longBreakTime;

  @override
  void initState(){
    super.initState();
    workTime = widget.workTime;
    shortBreakTime = widget.shortBreakTime;
    longBreakTime = widget.longBreakTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(title:const Text("Settings", style: TextStyle(color: Colors.black),),
       centerTitle: true,
       backgroundColor: Colors.teal,
     ),
      body: Center(
        child: Column(
          children: [
            Padding(padding: const EdgeInsets.fromLTRB(0, 20, 0, 20), child:Container(
              width: 600.0,
              decoration: BoxDecoration(shape: BoxShape.rectangle,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(20.0)),
                  child:   TextField(
                decoration: const InputDecoration(border: InputBorder.none,
                  hintText: "Work time (in minutes)",
                  contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
                ),
                    onChanged: (value){
                  setState(() {
                    workTime = int.tryParse(value) ?? widget.workTime;
                  });
                    },
                  ),
            ),
                ),
            Padding(padding: const EdgeInsets.fromLTRB(0, 20, 0, 20), child:Container(
              width: 600.0,
              decoration: BoxDecoration(shape: BoxShape.rectangle,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(20.0)),
              child:   TextField(
                decoration: const InputDecoration(border: InputBorder.none,
                  hintText: "Short break time (in minutes)",
                  contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
                ),
                onChanged: (value){
                  setState(() {
                    shortBreakTime = int.tryParse(value) ?? widget.shortBreakTime;
                  });
                },
              ),
            ),
            ),
            Padding(padding: const EdgeInsets.fromLTRB(0, 20, 0, 20), child:Container(
              width: 600.0,
              decoration: BoxDecoration(shape: BoxShape.rectangle,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(20.0)),
              child:   TextField(
                decoration: const InputDecoration(border: InputBorder.none,
                  hintText: "Long Break time (in minutes)",
                  contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
                ),
                onChanged: (value){
                  setState(() {
                    longBreakTime = int.tryParse(value) ?? widget.longBreakTime;
                  });
                },
              ),
            ),
            ),
            ElevatedButton(onPressed: (){
              Navigator.pop(context,{
                'work':workTime,
                'short': shortBreakTime,
                'long': longBreakTime,
              });
            }, child:const Text("Save"))
          ],
        ),
      ),
    );
  }
}