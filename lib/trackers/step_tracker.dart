import 'package:fooducate/calculator_brain.dart';
import 'package:fooducate/screens/food_search_screen.dart';
import 'package:fooducate/screens/gender_screen.dart';
import 'package:fooducate/screens/home_screen.dart';
import 'package:fooducate/app_user.dart';
import 'package:fooducate/trackers/h2o_tracker.dart';
//import '../app_user.dart';
import '../calculate_button.dart';
import '../tracker.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'dart:async';
import 'package:fooducate/constants.dart';

class StepTracker extends StatefulWidget {
  static String id = 'StepTracker';
  AppUser cAppUser;
  StepTracker({Key key,@required this.cAppUser}) : super(key: key);
  @override
  _StepTrackerState createState() => _StepTrackerState();
}

class _StepTrackerState extends State<StepTracker> with Tracker {
  Stream<StepCount> _stepCountStream;
  Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '0';
  AppUser cAppUser;
  CalculatorBrain cBrain;
  int currentTabIndex = 1;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void onStepCount(StepCount event) {
    print(event);
    setState(() {
      cAppUser.setStepsCount(event.steps);
      _steps = event.steps.toString();
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    print(_status);
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      cAppUser.setStepsCount(0);
      _steps = 'Step Count not available';
    });
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) {
      //if string data
      print(arguments['CurrentAppUserData']);
      //if you passed object
      //final cAppUser = arguments['CurrentAppUserData'];
      cAppUser = arguments['CurrentAppUserData'];
      print('in step tracker ${cAppUser.getEmail()},${cAppUser.getStepsCount()}');
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: null,
        title: Text('STEP TRACKER'),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: <Widget>[
          Center(
            child: Container(
              height: 300,
              width: 400,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(1.0, 1.0),
                      blurRadius: 2.0,
                    )
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                        top: 10.0,
                      ),
                      child: Text(
                        'Steps taken:'.toUpperCase(),
                        style: kLabelTextStyle.copyWith(color: Colors.purple),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: Text(
                      _steps,
                      style: kLabelTextStyle.copyWith(fontSize: 30.0),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    child: Text(
                      'Pedestrian status:',
                      style: kLabelTextStyle.copyWith(color: Colors.purple),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: Icon(
                      _status == 'walking'
                          ? Icons.directions_walk
                          : _status == 'stopped'
                              ? Icons.accessibility_new
                              : Icons.error,
                      color: Colors.purple,
                      size: 70,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        _status,
                        style: _status == 'walking' || _status == 'stopped'
                            ? TextStyle(fontSize: 30)
                            : TextStyle(fontSize: 20, color: Colors.purple),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 33,
          ),
          CalculateButton(
            onTap: () {

              cBrain = CalculatorBrain(
                  gender: cAppUser.getGender(),
                  cUser: cAppUser);
              cBrain.calculateStepsCountProgress();
              print('drink ${cBrain.calculateDailyH2O()} L');
              setState(() {
                //updateUserHealth(); //TODO:onTap update ui
              });
              //Navigator.of(context).pop();
              Navigator.pushNamed(context, HomeScreen.id,arguments: {'CurrentAppUserData': cAppUser});
            },
            buttonTitle: "CONTINUE",
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.purple.shade100,
        elevation: 15,
        currentIndex: currentTabIndex,
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
            //currentPage = pages[index];
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
            icon: IconButton(
              icon: Icon(Icons.home_outlined), //Icon(Icons.account_circle_rounded)
              onPressed: () {
                setState(() {
                  //updateUserHealth();
                });
              },
            ),
          ),
          BottomNavigationBarItem(
            label: 'Steps',
            icon: IconButton(
              icon: Icon(Icons.directions_walk_rounded), //Icon(Icons.account_circle_rounded)
              onPressed: () {
                Navigator.pushNamed(context, StepTracker.id, arguments: {
                  'CurrentAppUserData': cAppUser,
                  'CurrentAppUserCB': cBrain
                });
              },
            ),
          ),
          BottomNavigationBarItem(
            label: 'Food',
            icon: IconButton(
              icon: Icon(Icons.restaurant_menu), //Icon(Icons.account_circle_rounded)
              onPressed: () {
                Navigator.pushNamed(context, FoodScreen.id, arguments: {
                  'CurrentAppUserData': cAppUser,
                  'CurrentAppUserCB': cBrain
                });
              },
            ),
          ),
          BottomNavigationBarItem(
            label: 'Water Tracker',
            icon: IconButton(
              icon: Icon(Icons.wine_bar_sharp), //Icon(Icons.account_circle_rounded)
              onPressed: () {
                Navigator.pushNamed(context, H2OTracker.id, arguments: {
                  'CurrentAppUserData': cAppUser,
                  'CurrentAppUserCB': cBrain
                });
              },
            ),
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.account_circle_rounded),
            label: 'Me',
            icon: IconButton(
              icon: Icon(Icons.account_circle_outlined),
              onPressed: () {
                Navigator.pushNamed(context, GenderSelect.id, arguments: {
                  'CurrentAppUserData': cAppUser,
                  'CurrentAppUserCB': cBrain
                }); //arguments: {'CurrentAppUserData': cAppUser}
                setState(() {
                  //updateUserHealth();
                });
                //Navigator.pushNamed(context, routeName)
              },
            ),
          ),
        ],
      ),
    );
  }
}
/*
class StepTracker extends StatefulWidget {
  static String id = 'StepTracker';
  @override
  _StepTrackerState createState() => _StepTrackerState();
}

class _StepTrackerState extends State<StepTracker> with Tracker {
  Pedometer _pedometer;
  StreamSubscription<int> _subscription;
  String _stepCountValue = '?';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    startListening();
  }

  void onData(int stepCountValue) {
    print(stepCountValue);
  }

  void startListening() {
    _pedometer = new Pedometer();
    _subscription = _pedometer.pedometerStream.listen(_onData,
        onError: _onError, onDone: _onDone, cancelOnError: true);
  }

  void stopListening() {
    _subscription.cancel();
  }

  void _onData(int newValue) async {
    print('New step count value: $newValue');
    setState(() => _stepCountValue = "$newValue");
  }

  void _onDone() => print("Finished pedometer tracking");

  void _onError(error) => print("Flutter Pedometer Error: $error");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: null,
            title: const Text('STEP TRACKER'),
            backgroundColor: Colors.purple,
          ),
          body: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Icon(
                Icons.directions_walk,
                size: 90,
                color: Colors.purple,
              ),
              new Text(
                'Steps taken:',
                style: TextStyle(fontSize: 30),
              ),
              new Text(
                '$_stepCountValue',
                style: TextStyle(fontSize: 100, color: Colors.purple),
              )
            ],
          ))
    );
  }
}
*/
