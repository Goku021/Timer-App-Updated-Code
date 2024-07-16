import 'package:untitled/timerModel.dart';

class CountDownTimer{


 late Duration _remainingTime;
 late Duration _fullTime;
 double radius = 1;
 int workTime = 30;
 bool isActive = true;

 CountDownTimer(){
   startWork();
 }
 void startWork(){
   radius = 1;
   _remainingTime = Duration(minutes: workTime, seconds: 0);
   _fullTime = _remainingTime;
   isActive = true;
 }

 String returnTime(Duration t){
   String minutes = (t.inMinutes < 10) ? "0${t.inMinutes}" : t.inMinutes.toString();
   int seconds = t.inSeconds - (t.inMinutes * 60);
   String numSeconds = (seconds < 10) ?"0$seconds" : seconds.toString();
   String formattedTime = "$minutes:$numSeconds";
   return formattedTime;
 }
 Stream<TimerModel> stream() async*{
   yield* Stream.periodic(const Duration(seconds: 1),(int a){
     String time;
     if(isActive){
       if(_remainingTime.inSeconds >=0){
         _remainingTime = _remainingTime - const Duration(seconds: 1);
       }else{
         isActive = false;
       }

       radius = _remainingTime.inSeconds / _fullTime.inSeconds;
     }
     time = returnTime(_remainingTime);
     return TimerModel(time, radius);
   });
 }

}