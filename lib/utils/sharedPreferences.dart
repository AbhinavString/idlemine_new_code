import '../main.dart';

class SharedPreferencesFunctions {
  saveLoginUserId(String userId) {
    sharedPreferences!.setString("userID", userId);
  }

  String? getLoginUserId() {
    return sharedPreferences!.getString("userID");
  }
  saveLoginStatuscode(String Statuscode) {
    sharedPreferences!.setString("Statuscode", Statuscode);
  }

  String? getLoginStatuscode() {
    return sharedPreferences!.getString("Statuscode");
  }

  saveIsloginstatus(String Isloginstatus) {
    sharedPreferences!.setString("Isloginstatus", Isloginstatus);
  }

  String? getIsloginstatus() {
    return sharedPreferences!.getString("Isloginstatus");
  }


  saveRegisterBy(String RegisterBy) {
    sharedPreferences!.setString("RegisterBy", RegisterBy);
  }

  String? getRegisterBy() {
    return sharedPreferences!.getString("RegisterBy");
  }

  saveLoginStatus(String status) {
    sharedPreferences!.setString("status", status);
  }

  String? getLoginStatus() {
    return sharedPreferences!.getString("status");
  }

  saveConfirmOtpStatus(String ConfirmOtpstatus) {
    sharedPreferences!.setString("ConfirmOtpstatus", ConfirmOtpstatus);
  }

  String? getConfirmOtpStatus() {
    return sharedPreferences!.getString("ConfirmOtpstatus");
  }

  saveForgotConfirmOtpStatus(String forgotConfirmOtp) {
    sharedPreferences!.setString("forgotConfirmOtp", forgotConfirmOtp);
  }

  String? getForgotConfirmOtpStatus() {
    return sharedPreferences!.getString("forgotConfirmOtp");
  }

  setResetStatus(String ResetStatus) {
    sharedPreferences!.setString("ResetStatus", ResetStatus);
  }

  String? getResetStatus() {
    return sharedPreferences!.getString("ResetStatus");
  }

  setOtpStatus(String OtpStatus) {
    sharedPreferences!.setString("OtpStatus", OtpStatus);
  }

  String? getOtpStatus() {
    return sharedPreferences!.getString("OtpStatus");
  }



  saveLoginToken(String Token) {
    sharedPreferences!.setString("Token", Token);
  }

  String? getLoginToken() {
    return sharedPreferences!.getString("Token");
  }


  saveLoginEmail(String emailAddress) {
    sharedPreferences!.setString("EMAIL", emailAddress);
  }

  String? getLoginEmail() {
    return sharedPreferences!.getString("EMAIL");
  }


  saveNotification(bool Notification) {
    sharedPreferences!.setBool("Notification",Notification );
  }

  bool? getNotification() {
    return sharedPreferences!.getBool("Notification");
  }

  saveSound(bool Sound) {
    sharedPreferences!.setBool("Sound",Sound );
  }

  bool? getSound() {
    return sharedPreferences!.getBool("Sound");
  }

  saveOfferNotification(bool isOfferNotificationActive) {
    sharedPreferences!.setBool("isOfferNotificationActive",isOfferNotificationActive );
  }

  bool? getOfferNotification() {
    return sharedPreferences!.getBool("isOfferNotificationActive");
  }

  logout(){
    sharedPreferences!.clear();
  }
}