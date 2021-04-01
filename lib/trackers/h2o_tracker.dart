import '../tracker.dart';
import 'package:fooducate/user_data_input.dart';
import 'package:fooducate/app_user.dart';
class H2OTracker with Tracker {
  int userDrankH2O; //user drank H2O
  AppUser cAppUser;
  H2OTracker({this.cAppUser});

  void setUserDrankH2O(int h2oDrank){
    userDrankH2O = h2oDrank;
  }
  int getUserDrankH2O() {
    return userDrankH2O;
  }

}
