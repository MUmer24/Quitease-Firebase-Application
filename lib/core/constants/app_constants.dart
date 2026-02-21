import 'package:flutter/material.dart';

class AppConstants {
  // ------------------------------------- Onboarding Constants -------------------------------------
  // ---------------------- Authentication Screen Constants ----------------------
  // class AuthConstants extends GetxController {
  // --- Texts ---
  static const welcomeTxt = 'Welcome to Quitease';
  static const btn1Txt = 'Let\'s Go';
  static const btn2Txt = 'SignIn';

  // ---Images ---
  static const welcomeImg = 'assets/imgs/addictions.png';
  // }

  // ---------------------- Health Tracking Screen Constants ----------------------
  // class HealthTrackingScreenConstants extends GetxController {
  // --- Texts ---
  static const healthTrackingScreenAppbarTitle = 'Health Tracking';
  static const cigsPerDayLbl = 'Cigarettes per day';
  static const cigsPerPackLbl = 'Cigarettes per pack';
  static const pricePerPackLbl = 'Price per pack';
  static const nextBtn = 'Next';

  // --- Icons ---
  static const IconData calendarIcon = Icons.calendar_today;
  static const IconData fireIcon = Icons.local_fire_department;
  static const IconData moneyIcon = Icons.attach_money;
  // }

  // ---------------------- Quit Date Screen Constants ----------------------
  // class QuitDateScreenConstants extends GetxController {
  // --- Texts ---
  static const quest1 = 'When did you quit smoking?';
  static const questAltrnt =
      'If you haven\'t quit yet, select a date in the future.';
  static const dateFormat = 'MMMM d, yyyy \'at\' hh:mm a';
  static const dateTimeSelectionBtn = 'Select Date & Time';
  static const navigateToHealthTrackingBtn = 'Next';

  // --- Icons ---
  static const Icon backIcon = Icon(Icons.arrow_back);

  // --- Images ---
  static const quitImg = 'assets/imgs/date_time_selection.png';
  // }

  // ---------------------- Summary Screen Constants ----------------------
  // class SummaryScreenConstants extends GetxController {
  // --- Texts ---
  static const summaryScreenAppbarTitle = 'Your Smoke-Free Start';
  static const congratsTxt = 'Congratulations!';
  static const summaryScreenNextBtn = 'Finish & Start My Journey';
  static const label1 = 'Cigarettes';
  static const label2 = 'Saved';

  static String summaryTxt(int daysSinceQuit) {
    return ('You are on your way. In the first $daysSinceQuit days, you have avoided:');
  }
  // }
  // ---------------------------------------------------------------------------------------

  // ---------------------- Achievement Screen Constants ----------------------
  // class AchievementConstants extends GetxController {
  // --- Texts ---
  static const achievementScreenAppbarTitle = 'Achievements';

  // --- Colors ---
  static const Color eventColor = Colors.amberAccent;
  static const Color borderColor = Color.fromARGB(163, 162, 173, 182);
  // }

  // ---------------------- Dashboard Screen Constants ----------------------
  // class DashboardConstants extends GetxController {
  // --- Texts ---
  static const dashboardScreenAppbarTitle = 'QUITEASE';
  static const seeAllBtn = 'See all...';
  static const overallProgressSectionTitle = 'Overall Progress';
  static const achievementSectionTitle = 'Achievements';
  static const vitalitySectionTitle = 'Vitality Boost';
  static const vitalitySectionSubtitle =
      'Quitting smoking improves nearly every aspect of health\n — physical, mental, and emotional\n — while enhancing quality of life.';

  // --- Images ---
  static const timerSectionBgImg =
      'assets/imgs/dashboard_landscape_background.png';
  static const stopwatchImg = "assets/imgs/stopwatch.png";
  static const coinImg = 'assets/icons/coin.png';
  static const chronometerImg = "assets/icons/chronometer.png";
  static const vitalityBoostImg = 'assets/icons/boost.png';

  // --- Icons & Colors ---
  static const stopwatchIcon = Icons.local_fire_department;
  static const Color stopwatchIconColor = Colors.orange;
  static const cigsIcon = Icons.smoking_rooms;
  static const Color cigsIconColor = Colors.red;
  // }

  // ---------------------- Health Improvements Screen Constants ----------------------
  // --- Texts ---
  static const healthImprovementsScreenAppbarTitle = 'Health Improvements';
  static const bottomTxt = "Based on the World Health Organization data";

  // --- Images ---
  static const whoLogoImg = 'assets/imgs/who-logo.png';

  // ---------------------- Progress Screen Constants ----------------------
  // --- Texts ---
  static const progressScreenAppbarTitle = 'Progress';
  static const progressCardLabel1Txt = "Today's Progress";
  static const progressCardLabel2Txt = 'Weekly Progress';
  static const progressCardLabel3Txt = 'Monthly Progress';
  static const progressCardLabel4Txt = 'Yearly Progress';
  static const progressTypeCigarettesLabelTxt = 'cigarettes';
  static const progressTypeMoneyLabelTxt = 'saved';
  static const progressTypeTimeLabelTxt = 'time won back';

  // ---------------------- Settings Screen Constants ----------------------
  // --- Texts ---
  static const accountOverviewOptionTxt = 'Account Overview';
  static const profileOptionTxt = 'My Profile';
  static const resetDataOptionTxt = 'Reset Data';
  static const logoutOptionBtnTxt = 'Logout';

  // --- Icons ---
  static const profileIcon = Icons.person_outline;
  static const resetDataIcon = Icons.refresh_outlined;
  static const logoutIcon = Icons.logout;

  // --- Colors ---
  static const Color profileIconColor = Colors.lightBlueAccent;
  static const Color resetDataIconColor = Colors.deepPurpleAccent;
  static const Color logoutIconColor = Colors.red;

  // ---------------------- Profile Screen Constants ----------------------
  // --- Texts ---
  static const profileScreenAppbarTitle = 'My Profile';
  static const detailStatCardTitle = 'My Journey';
  static const profileScreenNextBtn = 'Next';
  static const statCardLabel1 = 'Cigarettes Avoided';
  static const statCardLabel2 = 'Money Saved';
  static const statCardLabel3 = 'Time Won Back';
  static const statCardLabel4 = 'Achievements Unlocked';

  // --- Icons ---
  static const statCardIcon1 = Icons.smoking_rooms;
  static const statCardIcon2 = Icons.attach_money;
  static const statCardIcon3 = Icons.timer;
  static const statCardIcon4 = Icons.emoji_events;

  // --- Colors ---
  static const Color statCardIconColor1 = Colors.red;
  static const Color statCardIconColor2 = Colors.green;
  static const Color statCardIconColor3 = Colors.blue;
  static const Color statCardIconColor4 = Colors.amber;

  // ---------------------- Sharing App String Constants ----------------------
  static const String githubRepoLink =
      "https://github.com/MUmer24/Quitease-Firebase-Application.git";
  static const String shareAppTitle = "QuitEase - Quit Smoking App";
  static const String shareAppDescription =
      "Check out QuitEase - Your companion for quitting smoking! 🚭\n\n"
      "Track your progress, earn achievements, and stay motivated on your journey to a smoke-free life.\n\n"
      "Download now: $githubRepoLink";
}
