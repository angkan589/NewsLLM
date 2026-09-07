import 'package:flutter/material.dart' as material;
import 'package:newsllm/core/session/app_session.dart';

/// Returns the Bangla version of fixed interface copy when Bangla is selected.
/// News and quiz content from Firestore is already localized by the repository.
String localizedUi(String text) {
  if (!AppSession.instance.isBangla) {
    return text;
  }

  final exact = _banglaUi[text];
  if (exact != null) {
    return exact;
  }

  final briefings = RegExp(r'^(\d+) briefings$').firstMatch(text);
  if (briefings != null) {
    return '${_banglaDigits(briefings.group(1)!)}টি সংবাদ সংক্ষেপ';
  }

  final questions = RegExp(r'^(\d+) questions$').firstMatch(text);
  if (questions != null) {
    return '${_banglaDigits(questions.group(1)!)}টি প্রশ্ন';
  }

  final minutes = RegExp(r'^(\d+) min read$').firstMatch(text);
  if (minutes != null) {
    return '${_banglaDigits(minutes.group(1)!)} মিনিটে পড়ুন';
  }

  final questionProgress = RegExp(
    r'^Question (\d+) of (\d+)$',
  ).firstMatch(text);
  if (questionProgress != null) {
    return 'প্রশ্ন ${_banglaDigits(questionProgress.group(1)!)} / '
        '${_banglaDigits(questionProgress.group(2)!)}';
  }

  final attempts = RegExp(r'^Attempt (\d+)$').firstMatch(text);
  if (attempts != null) {
    return 'চেষ্টা ${_banglaDigits(attempts.group(1)!)}';
  }

  final searchResults = RegExp(r'^(\d+) search results?$').firstMatch(text);
  if (searchResults != null) {
    return '${_banglaDigits(searchResults.group(1)!)}টি ফল পাওয়া গেছে';
  }

  final correct = RegExp(r'^(\d+)/(\d+) correct$').firstMatch(text);
  if (correct != null) {
    return '${_banglaDigits(correct.group(1)!)} / '
        '${_banglaDigits(correct.group(2)!)} সঠিক';
  }

  return text;
}

String localizedToday() {
  final date = DateTime.now();
  const englishWeekdays = <String>[
    'MONDAY',
    'TUESDAY',
    'WEDNESDAY',
    'THURSDAY',
    'FRIDAY',
    'SATURDAY',
    'SUNDAY',
  ];
  const englishMonths = <String>[
    'JANUARY',
    'FEBRUARY',
    'MARCH',
    'APRIL',
    'MAY',
    'JUNE',
    'JULY',
    'AUGUST',
    'SEPTEMBER',
    'OCTOBER',
    'NOVEMBER',
    'DECEMBER',
  ];

  if (!AppSession.instance.isBangla) {
    return '${englishWeekdays[date.weekday - 1]}, ${date.day} '
        '${englishMonths[date.month - 1]} ${date.year}';
  }

  const banglaWeekdays = <String>[
    'সোমবার',
    'মঙ্গলবার',
    'বুধবার',
    'বৃহস্পতিবার',
    'শুক্রবার',
    'শনিবার',
    'রবিবার',
  ];
  const banglaMonths = <String>[
    'জানুয়ারি',
    'ফেব্রুয়ারি',
    'মার্চ',
    'এপ্রিল',
    'মে',
    'জুন',
    'জুলাই',
    'আগস্ট',
    'সেপ্টেম্বর',
    'অক্টোবর',
    'নভেম্বর',
    'ডিসেম্বর',
  ];
  return '${banglaWeekdays[date.weekday - 1]}, '
      '${_banglaDigits('${date.day}')} ${banglaMonths[date.month - 1]} '
      '${_banglaDigits('${date.year}')}';
}

String _banglaDigits(String value) {
  const digits = <String, String>{
    '0': '০',
    '1': '১',
    '2': '২',
    '3': '৩',
    '4': '৪',
    '5': '৫',
    '6': '৬',
    '7': '৭',
    '8': '৮',
    '9': '৯',
  };
  return value
      .split('')
      .map((character) => digits[character] ?? character)
      .join();
}

const _banglaUi = <String, String>{
  'Home': 'হোম',
  'Search': 'খুঁজুন',
  'Quiz': 'কুইজ',
  'Saved': 'সংরক্ষিত',
  'Profile': 'প্রোফাইল',
  'Today': 'আজ',
  'National': 'জাতীয়',
  'International': 'আন্তর্জাতিক',
  'Business': 'ব্যবসা',
  'Sports': 'খেলাধুলা',
  'Science': 'বিজ্ঞান',
  'Technology': 'প্রযুক্তি',
  'Science & Tech': 'বিজ্ঞান ও প্রযুক্তি',
  'SCIENCE & TECH': 'বিজ্ঞান ও প্রযুক্তি',
  'All': 'সব',
  'All topics': 'সব বিষয়',
  'All briefings': 'সব সংবাদ সংক্ষেপ',
  'Back': 'ফিরে যান',
  'Cancel': 'বাতিল',
  'Close': 'বন্ধ করুন',
  'Start': 'শুরু করুন',
  'Review': 'পুনরালোচনা',
  'Settings': 'সেটিংস',
  'Account': 'অ্যাকাউন্ট',
  'Sign in': 'সাইন ইন',
  'Sign out': 'সাইন আউট',
  'Sign out?': 'সাইন আউট করবেন?',
  'Sign in required': 'সাইন ইন প্রয়োজন',
  'Sign in to access your saved briefings.':
      'সংরক্ষিত সংবাদ দেখতে সাইন ইন করুন।',
  'Sign in to access your profile and stored progress.':
      'প্রোফাইল ও সংরক্ষিত অগ্রগতি দেখতে সাইন ইন করুন।',
  'You will need to sign in again to access your saved progress.':
      'সংরক্ষিত অগ্রগতি দেখতে আবার সাইন ইন করতে হবে।',
  'Welcome back': 'আবারও স্বাগতম',
  'Create your profile': 'আপনার প্রোফাইল তৈরি করুন',
  'Reset your password': 'পাসওয়ার্ড পুনরায় সেট করুন',
  'Create account': 'অ্যাকাউন্ট তৈরি করুন',
  'Reset password': 'পাসওয়ার্ড পুনরায় সেট করুন',
  'Return to sign in': 'সাইন ইন পাতায় ফিরুন',
  'Send reset instructions': 'রিসেট নির্দেশনা পাঠান',
  'Forgot password?': 'পাসওয়ার্ড ভুলে গেছেন?',
  'Full name': 'পূর্ণ নাম',
  'Email address': 'ইমেইল ঠিকানা',
  'Password': 'পাসওয়ার্ড',
  'Confirm password': 'পাসওয়ার্ড নিশ্চিত করুন',
  'Don’t have an account?': 'অ্যাকাউন্ট নেই?',
  'Already have an account?': 'ইতিমধ্যে অ্যাকাউন্ট আছে?',
  'Signed in successfully.': 'সফলভাবে সাইন ইন হয়েছে।',
  'Account created successfully.': 'অ্যাকাউন্ট সফলভাবে তৈরি হয়েছে।',
  'Enter your full name.': 'আপনার পূর্ণ নাম লিখুন।',
  'Enter a valid email address.': 'সঠিক ইমেইল ঠিকানা লিখুন।',
  'Password must contain at least 6 characters.':
      'পাসওয়ার্ডে অন্তত ৬টি অক্ষর থাকতে হবে।',
  'Passwords do not match.': 'পাসওয়ার্ড দুটি মিলছে না।',
  'The email address or password is incorrect.':
      'ইমেইল ঠিকানা বা পাসওয়ার্ড সঠিক নয়।',
  'Something went wrong. Please try again.':
      'কিছু সমস্যা হয়েছে। আবার চেষ্টা করুন।',
  'Check your internet connection and try again.':
      'ইন্টারনেট সংযোগ পরীক্ষা করে আবার চেষ্টা করুন।',
  'Too many attempts. Wait a moment and try again.':
      'অনেকবার চেষ্টা করা হয়েছে। কিছুক্ষণ পর আবার চেষ্টা করুন।',
  'Continue as guest': 'অতিথি হিসেবে চালিয়ে যান',
  'Sign in to save': 'সংরক্ষণ করতে সাইন ইন করুন',
  'Language': 'ভাষা',
  'English': 'English',
  'Choose the language used for briefings and quizzes.':
      'সংবাদ সংক্ষেপ ও কুইজের ভাষা বেছে নিন।',
  'Bangla and English content is available for generated briefings and quizzes.':
      'তৈরি করা সংবাদ সংক্ষেপ ও কুইজ বাংলা ও ইংরেজি—দুই ভাষাতেই পাওয়া যায়।',
  'Notifications': 'নোটিফিকেশন',
  'Important news': 'গুরুত্বপূর্ণ সংবাদ',
  'Exam reminders': 'পরীক্ষার রিমাইন্ডার',
  'Daily briefing': 'দৈনিক সংবাদ সংক্ষেপ',
  'Receive alerts for important current-affairs stories.':
      'গুরুত্বপূর্ণ সাম্প্রতিক বিষয়ের সংবাদে নোটিফিকেশন পান।',
  'Receive reminders about available quizzes and exams.':
      'নতুন কুইজ ও পরীক্ষার রিমাইন্ডার পান।',
  'Receive a reminder when the daily briefing is ready.':
      'দৈনিক সংবাদ সংক্ষেপ প্রস্তুত হলে রিমাইন্ডার পান।',
  'Signed-in preferences and learning records are synchronized securely with Firebase.':
      'সাইন ইন করা ব্যবহারকারীর পছন্দ ও শেখার তথ্য Firebase-এ নিরাপদে সমন্বিত থাকে।',
  'My profile': 'আমার প্রোফাইল',
  'Verified Firebase account': 'যাচাইকৃত Firebase অ্যাকাউন্ট',
  'Learning progress': 'শেখার অগ্রগতি',
  'Exams completed': 'সম্পন্ন পরীক্ষা',
  'Average score': 'গড় স্কোর',
  'Saved stories': 'সংরক্ষিত সংবাদ',
  'Day streak': 'ধারাবাহিক দিন',
  'Quiz scores and saved stories below are loaded from your account.':
      'নিচের কুইজ স্কোর ও সংরক্ষিত সংবাদ আপনার অ্যাকাউন্ট থেকে লোড হয়েছে।',
  'Exam history': 'পরীক্ষার ইতিহাস',
  'Saved briefings': 'সংরক্ষিত সংবাদ সংক্ষেপ',
  'Notifications and reminders': 'নোটিফিকেশন ও রিমাইন্ডার',
  'Today’s briefings': 'আজকের সংবাদ সংক্ষেপ',
  'Today’s news': 'আজকের সংবাদ',
  'Today’s top stories': 'আজকের প্রধান সংবাদ',
  'Today’s newspaper desk': 'আজকের সংবাদপত্র ডেস্ক',
  'Good morning. Here’s what matters today.':
      'সুপ্রভাত। আজকের গুরুত্বপূর্ণ বিষয়গুলো দেখে নিন।',
  'Your exam-focused daily briefing, prepared in about five minutes.':
      'প্রায় পাঁচ মিনিটে পড়ার মতো পরীক্ষাকেন্দ্রিক দৈনিক সংবাদ সংক্ষেপ।',
  'Swipe through today’s newspapers and explore the briefings.':
      'আজকের সংবাদপত্রগুলো দেখুন এবং সংক্ষেপগুলো পড়ুন।',
  'Short, exam-focused briefings selected for you':
      'আপনার জন্য বাছাই করা সংক্ষিপ্ত পরীক্ষাকেন্দ্রিক সংবাদ',
  'Read briefing': 'সংক্ষেপ পড়ুন',
  'Read full briefing': 'সম্পূর্ণ সংক্ষেপ পড়ুন',
  'View all news': 'সব সংবাদ দেখুন',
  'View other newspapers': 'অন্য সংবাদপত্র দেখুন',
  'Front page preview': 'প্রথম পাতার ঝলক',
  'News briefing': 'সংবাদ সংক্ষেপ',
  'The story in brief': 'সংক্ষেপে ঘটনা',
  'Exam takeaway': 'পরীক্ষার জন্য যা মনে রাখবেন',
  'Quick revision': 'দ্রুত পুনরালোচনা',
  'Key terms': 'গুরুত্বপূর্ণ শব্দ',
  'More from today': 'আজকের আরও সংবাদ',
  'AI-assisted exam summary': 'এআই-সহায়ক পরীক্ষার সারাংশ',
  'Save bookmark': 'বুকমার্ক করুন',
  'Remove bookmark': 'বুকমার্ক সরান',
  'Slide newspapers': 'সংবাদপত্রগুলো সরান',
  'Use light theme': 'হালকা থিম ব্যবহার করুন',
  'Use dark theme': 'গাঢ় থিম ব্যবহার করুন',
  'Briefing saved to bookmarks': 'সংবাদ সংক্ষেপ বুকমার্কে সংরক্ষিত হয়েছে',
  'Briefing removed from bookmarks': 'সংবাদ সংক্ষেপ বুকমার্ক থেকে সরানো হয়েছে',
  'No briefings available': 'কোনো সংবাদ সংক্ষেপ নেই',
  'No briefings found': 'কোনো সংবাদ সংক্ষেপ পাওয়া যায়নি',
  'New exam-focused stories will appear here when they are added.':
      'নতুন পরীক্ষাকেন্দ্রিক সংবাদ যোগ হলে এখানে দেখা যাবে।',
  'Search news': 'সংবাদ খুঁজুন',
  'Search news, category or newspaper': 'সংবাদ, বিভাগ বা সংবাদপত্র খুঁজুন',
  'Search by headline, category, summary or newspaper.':
      'শিরোনাম, বিভাগ, সারাংশ বা সংবাদপত্র দিয়ে খুঁজুন।',
  'Clear search': 'খোঁজ মুছুন',
  'Try another headline, category or newspaper name.':
      'অন্য শিরোনাম, বিভাগ বা সংবাদপত্রের নাম দিয়ে চেষ্টা করুন।',
  'No saved briefings': 'কোনো সংরক্ষিত সংবাদ নেই',
  'Open a news briefing and select the bookmark icon to save it for later revision.':
      'পরে পড়ার জন্য কোনো সংবাদ খুলে বুকমার্ক আইকন চাপুন।',
  'Briefing removed from saved stories': 'সংরক্ষিত সংবাদ থেকে সরানো হয়েছে',
  'Fact bank': 'তথ্যভান্ডার',
  'Today’s one-line fact bank': 'আজকের এক লাইনের তথ্যভান্ডার',
  'Today’s one-line facts': 'আজকের এক লাইনের তথ্য',
  'Open fact bank': 'তথ্যভান্ডার খুলুন',
  'Quiz centre': 'কুইজ কেন্দ্র',
  'Daily quiz': 'দৈনিক কুইজ',
  'Practice by topic': 'বিষয়ভিত্তিক অনুশীলন',
  'Test what you learned today': 'আজ যা শিখেছেন তা যাচাই করুন',
  'Take the daily exam or practise individual current-affairs topics.':
      'দৈনিক পরীক্ষা দিন অথবা সাম্প্রতিক বিষয়ের অনুশীলন করুন।',
  'Start daily quiz': 'দৈনিক কুইজ শুরু করুন',
  'Start practice': 'অনুশীলন শুরু করুন',
  'Start article quiz': 'সংবাদভিত্তিক কুইজ শুরু করুন',
  'Check your understanding': 'আপনার বোঝাপড়া যাচাই করুন',
  'Review the summary and key facts before starting.':
      'শুরু করার আগে সারাংশ ও গুরুত্বপূর্ণ তথ্য দেখে নিন।',
  'Select an answer before continuing.':
      'চালিয়ে যাওয়ার আগে একটি উত্তর বেছে নিন।',
  'Next question': 'পরের প্রশ্ন',
  'Finish quiz': 'কুইজ শেষ করুন',
  'Quiz completed!': 'কুইজ সম্পন্ন!',
  'Try again': 'আবার চেষ্টা করুন',
  'Leave quiz': 'কুইজ থেকে বের হন',
  'Quiz unavailable': 'কুইজ পাওয়া যাচ্ছে না',
  'No questions are available for this quiz.': 'এই কুইজে কোনো প্রশ্ন নেই।',
  'Quiz attempt saved to your profile.': 'কুইজের ফল প্রোফাইলে সংরক্ষিত হয়েছে।',
  'Guest attempt is not saved. Sign in to track your progress.':
      'অতিথির ফল সংরক্ষিত হয় না। অগ্রগতি রাখতে সাইন ইন করুন।',
  'DAILY QUIZ': 'দৈনিক কুইজ',
  'ARTICLE QUIZ': 'সংবাদভিত্তিক কুইজ',
  'PRACTICE QUIZ': 'অনুশীলনী কুইজ',
  'Your exam attempts': 'আপনার পরীক্ষার ফল',
  'No exam history': 'পরীক্ষার কোনো ইতিহাস নেই',
  'No saved attempt': 'সংরক্ষিত ফল নেই',
  'Complete a quiz while signed in and your attempt will appear here.':
      'সাইন ইন করে কুইজ শেষ করলে ফল এখানে দেখা যাবে।',
  'Complete a quiz to create your progress chart.':
      'অগ্রগতির চার্ট তৈরি করতে একটি কুইজ সম্পন্ন করুন।',
  'Quiz accuracy': 'কুইজে সঠিকতার হার',
  'View progress': 'অগ্রগতি দেখুন',
  'Open quiz hub': 'কুইজ কেন্দ্র খুলুন',
  'How NewsLLM works': 'NewsLLM যেভাবে কাজ করে',
  'How it works': 'কীভাবে কাজ করে',
  'Learn, revise and test': 'শিখুন, ঝালিয়ে নিন ও যাচাই করুন',
  'A smarter way to prepare current affairs':
      'সাম্প্রতিক বিষয় প্রস্তুতির আরও স্মার্ট উপায়',
  'News that helps you ': 'যে সংবাদ আপনাকে ',
  'win exams': 'পরীক্ষায় এগিয়ে রাখে',
  'Start learning free': 'বিনামূল্যে শেখা শুরু করুন',
  'See how it works': 'কীভাবে কাজ করে দেখুন',
  'Browse briefings': 'সংবাদ সংক্ষেপ দেখুন',
  'Get started': 'শুরু করুন',
  '1. Read concise briefings': '১. সংক্ষিপ্ত সংবাদ পড়ুন',
  '2. Revise important facts': '২. গুরুত্বপূর্ণ তথ্য ঝালিয়ে নিন',
  '3. Test yourself with quizzes': '৩. কুইজ দিয়ে নিজেকে যাচাই করুন',
  'Exam-focused summaries': 'পরীক্ষাকেন্দ্রিক সারাংশ',
  'One-line facts': 'এক লাইনের তথ্য',
  'Smart MCQ practice': 'স্মার্ট এমসিকিউ অনুশীলন',
  'Bangla & English': 'বাংলা ও ইংরেজি',
  'Bangla and English': 'বাংলা ও ইংরেজি',
  'Learn in the language that feels natural': 'স্বচ্ছন্দ ভাষায় শিখুন',
  'Switch between Bangla and English summaries whenever you need.':
      'প্রয়োজনে বাংলা ও ইংরেজি সারাংশের মধ্যে বদল করুন।',
  'Daily news. Important facts. Better preparation.':
      'দৈনিক সংবাদ। গুরুত্বপূর্ণ তথ্য। আরও ভালো প্রস্তুতি।',
  'About': 'আমাদের সম্পর্কে',
  'Privacy': 'গোপনীয়তা',
  'Contact': 'যোগাযোগ',
  'Ready for today’s quiz?': 'আজকের কুইজের জন্য প্রস্তুত?',
  'Ready to make today’s news count?': 'আজকের সংবাদ কাজে লাগাতে প্রস্তুত?',
  'Keep your preparation moving': 'প্রস্তুতি এগিয়ে নিন',
  'Continue learning and understand your weekly progress':
      'শেখা চালিয়ে যান এবং সাপ্তাহিক অগ্রগতি বুঝুন',
  'Practice freely and sign in when you want to save progress':
      'বিনামূল্যে অনুশীলন করুন; অগ্রগতি রাখতে সাইন ইন করুন',
  'GUEST LEARNING': 'অতিথি হিসেবে শেখা',
  'EVERYTHING YOU NEED': 'আপনার প্রয়োজনীয় সবকিছু',
  'BUILT FOR COMPETITIVE EXAMS': 'প্রতিযোগিতামূলক পরীক্ষার জন্য তৈরি',
  'National affairs practice': 'জাতীয় বিষয়াবলি অনুশীলন',
  'International affairs practice': 'আন্তর্জাতিক বিষয়াবলি অনুশীলন',
  'Business and economy practice': 'ব্যবসা ও অর্থনীতি অনুশীলন',
  'Science and technology practice': 'বিজ্ঞান ও প্রযুক্তি অনুশীলন',
  'Test your understanding of important national affairs.':
      'গুরুত্বপূর্ণ জাতীয় বিষয়ে আপনার বোঝাপড়া যাচাই করুন।',
  'Review trade, diplomacy and international cooperation.':
      'বাণিজ্য, কূটনীতি ও আন্তর্জাতিক সহযোগিতা ঝালিয়ে নিন।',
  'Practice questions on business and digital finance.':
      'ব্যবসা ও ডিজিটাল অর্থনীতির প্রশ্ন অনুশীলন করুন।',
  'Explore technology, satellites and scientific innovation.':
      'প্রযুক্তি, স্যাটেলাইট ও বৈজ্ঞানিক উদ্ভাবন জানুন।',
  'Daily news quiz — 20 August 2026': 'দৈনিক সংবাদ কুইজ — ২০ আগস্ট ২০২৬',
  '5 questions based on today’s important news.':
      'আজকের গুরুত্বপূর্ণ সংবাদের ওপর ৫টি প্রশ্ন।',
  '5 questions • About 3 minutes': '৫টি প্রশ্ন • প্রায় ৩ মিনিট',
  'What is the main purpose of Bangladesh’s green growth roadmap?':
      'বাংলাদেশের সবুজ প্রবৃদ্ধি রোডম্যাপের প্রধান উদ্দেশ্য কী?',
  'To develop a climate-resilient economy': 'জলবায়ু-সহনশীল অর্থনীতি গড়ে তোলা',
  'To reduce renewable-energy production': 'নবায়নযোগ্য জ্বালানি উৎপাদন কমানো',
  'To restrict employment opportunities': 'কর্মসংস্থানের সুযোগ সীমিত করা',
  'To replace all existing industries': 'বিদ্যমান সব শিল্প প্রতিস্থাপন করা',
  'The roadmap focuses on sustainable development and a climate-resilient economy.':
      'রোডম্যাপটি টেকসই উন্নয়ন ও জলবায়ু-সহনশীল অর্থনীতিতে গুরুত্ব দেয়।',
  'Which area is prioritised by the green growth roadmap?':
      'সবুজ প্রবৃদ্ধি রোডম্যাপে কোন ক্ষেত্রকে অগ্রাধিকার দেওয়া হয়েছে?',
  'Renewable energy': 'নবায়নযোগ্য জ্বালানি',
  'Luxury imports': 'বিলাসপণ্য আমদানি',
  'Private entertainment': 'ব্যক্তিগত বিনোদন',
  'International tourism only': 'শুধু আন্তর্জাতিক পর্যটন',
  'Renewable energy is one of the roadmap’s main priorities.':
      'নবায়নযোগ্য জ্বালানি রোডম্যাপটির অন্যতম প্রধান অগ্রাধিকার।',
  'What did regional leaders recently discuss strengthening?':
      'আঞ্চলিক নেতারা সম্প্রতি কোন বিষয় শক্তিশালী করার আলোচনা করেছেন?',
  'Economic cooperation': 'অর্থনৈতিক সহযোগিতা',
  'Military competition': 'সামরিক প্রতিযোগিতা',
  'Travel restrictions': 'ভ্রমণ নিষেধাজ্ঞা',
  'Import bans': 'আমদানি নিষেধাজ্ঞা',
  'The leaders discussed trade, technology and stronger economic cooperation.':
      'নেতারা বাণিজ্য, প্রযুক্তি ও শক্তিশালী অর্থনৈতিক সহযোগিতা নিয়ে আলোচনা করেছেন।',
  'Why are digital payment services continuing to expand?':
      'ডিজিটাল পেমেন্ট সেবা কেন প্রসারিত হচ্ছে?',
  'Why are digital payment services expanding?':
      'ডিজিটাল পেমেন্ট সেবা কেন প্রসারিত হচ্ছে?',
  'To make transactions faster and more accessible':
      'লেনদেন দ্রুত ও আরও সহজলভ্য করতে',
  'To eliminate all physical businesses': 'সব প্রচলিত ব্যবসা বন্ধ করতে',
  'To reduce access to banking services': 'ব্যাংকিং সেবায় প্রবেশ কমাতে',
  'To prevent online transactions': 'অনলাইন লেনদেন বন্ধ করতে',
  'Digital payments aim to make transactions faster, safer and more accessible.':
      'ডিজিটাল পেমেন্টের লক্ষ্য লেনদেন দ্রুত, নিরাপদ ও সহজলভ্য করা।',
  'Digital payments improve speed, accessibility and convenience.':
      'ডিজিটাল পেমেন্ট গতি, সহজলভ্যতা ও সুবিধা বাড়ায়।',
  'How can satellite data improve disaster management?':
      'স্যাটেলাইট তথ্য কীভাবে দুর্যোগ ব্যবস্থাপনা উন্নত করতে পারে?',
  'How can satellite data support disaster management?':
      'স্যাটেলাইট তথ্য কীভাবে দুর্যোগ ব্যবস্থাপনায় সহায়তা করতে পারে?',
  'By providing faster and more accurate warnings':
      'দ্রুত ও আরও নির্ভুল সতর্কতা দিয়ে',
  'By improving monitoring and early warnings':
      'পর্যবেক্ষণ ও আগাম সতর্কতা উন্নত করে',
  'By preventing every natural disaster': 'সব প্রাকৃতিক দুর্যোগ প্রতিরোধ করে',
  'By replacing emergency services': 'জরুরি সেবা প্রতিস্থাপন করে',
  'By reducing access to weather information': 'আবহাওয়ার তথ্যপ্রাপ্তি কমিয়ে',
  'Satellite data helps authorities issue faster and more accurate warnings.':
      'স্যাটেলাইট তথ্য কর্তৃপক্ষকে দ্রুত ও নির্ভুল সতর্কতা দিতে সহায়তা করে।',
  'Satellite data provides observations that support monitoring and warning systems.':
      'স্যাটেলাইট তথ্য পর্যবেক্ষণ ও সতর্কীকরণ ব্যবস্থাকে সহায়তা করে।',
  'What is a major goal of a national green-growth roadmap?':
      'জাতীয় সবুজ প্রবৃদ্ধি রোডম্যাপের একটি প্রধান লক্ষ্য কী?',
  'Building a climate-resilient economy': 'জলবায়ু-সহনশীল অর্থনীতি গড়ে তোলা',
  'Reducing renewable-energy use': 'নবায়নযোগ্য জ্বালানির ব্যবহার কমানো',
  'Stopping infrastructure development': 'অবকাঠামো উন্নয়ন বন্ধ করা',
  'Limiting employment opportunities': 'কর্মসংস্থানের সুযোগ সীমিত করা',
  'Green growth connects economic development with environmental sustainability.':
      'সবুজ প্রবৃদ্ধি অর্থনৈতিক উন্নয়নকে পরিবেশগত টেকসইতার সঙ্গে যুক্ত করে।',
  'Which sector is commonly included in digital development programmes?':
      'ডিজিটাল উন্নয়ন কর্মসূচিতে সাধারণত কোন খাত অন্তর্ভুক্ত থাকে?',
  'Education and public services': 'শিক্ষা ও সরকারি সেবা',
  'Celebrity entertainment only': 'শুধু তারকাদের বিনোদন',
  'Foreign tourism only': 'শুধু বিদেশি পর্যটন',
  'Professional sports only': 'শুধু পেশাদার খেলাধুলা',
  'Digital development commonly improves education and public-service accessibility.':
      'ডিজিটাল উন্নয়ন সাধারণত শিক্ষা ও সরকারি সেবার সহজলভ্যতা বাড়ায়।',
  'Why are climate-resilient infrastructure projects important?':
      'জলবায়ু-সহনশীল অবকাঠামো প্রকল্প কেন গুরুত্বপূর্ণ?',
  'They help communities withstand environmental risks':
      'এগুলো জনগোষ্ঠীকে পরিবেশগত ঝুঁকি মোকাবিলায় সহায়তা করে',
  'They remove the need for public planning':
      'এগুলো সরকারি পরিকল্পনার প্রয়োজন দূর করে',
  'They prevent every natural disaster': 'এগুলো সব প্রাকৃতিক দুর্যোগ ঠেকায়',
  'They reduce access to essential services': 'এগুলো জরুরি সেবার সুযোগ কমায়',
  'Resilient infrastructure reduces vulnerability and supports recovery.':
      'সহনশীল অবকাঠামো ঝুঁকি কমায় এবং পুনরুদ্ধারে সহায়তা করে।',
  'What should students identify when revising a national policy?':
      'জাতীয় নীতি পড়ার সময় শিক্ষার্থীদের কী শনাক্ত করা উচিত?',
  'Objective, authority and expected impact':
      'উদ্দেশ্য, দায়িত্বপ্রাপ্ত কর্তৃপক্ষ ও প্রত্যাশিত প্রভাব',
  'Only the headline font': 'শুধু শিরোনামের ফন্ট',
  'Only the publication date': 'শুধু প্রকাশের তারিখ',
  'Unrelated international events': 'অসম্পর্কিত আন্তর্জাতিক ঘটনা',
  'Objective, responsible authority and impact are central examination points.':
      'উদ্দেশ্য, দায়িত্বপ্রাপ্ত কর্তৃপক্ষ ও প্রভাব পরীক্ষার গুরুত্বপূর্ণ বিষয়।',
  'Why do countries participate in regional economic cooperation?':
      'দেশগুলো কেন আঞ্চলিক অর্থনৈতিক সহযোগিতায় অংশ নেয়?',
  'To improve trade and shared development': 'বাণিজ্য ও যৌথ উন্নয়ন বাড়াতে',
  'To eliminate all international communication':
      'সব আন্তর্জাতিক যোগাযোগ বন্ধ করতে',
  'To prevent technological collaboration': 'প্রযুক্তিগত সহযোগিতা ঠেকাতে',
  'To close every regional market': 'সব আঞ্চলিক বাজার বন্ধ করতে',
  'Regional cooperation can strengthen trade, investment and development.':
      'আঞ্চলিক সহযোগিতা বাণিজ্য, বিনিয়োগ ও উন্নয়ন শক্তিশালী করতে পারে।',
  'What is an important purpose of international climate partnerships?':
      'আন্তর্জাতিক জলবায়ু অংশীদারত্বের একটি গুরুত্বপূর্ণ উদ্দেশ্য কী?',
  'Sharing resources, research and solutions':
      'সম্পদ, গবেষণা ও সমাধান ভাগাভাগি করা',
  'Stopping environmental research': 'পরিবেশ গবেষণা বন্ধ করা',
  'Preventing renewable-energy investment':
      'নবায়নযোগ্য জ্বালানিতে বিনিয়োগ ঠেকানো',
  'Replacing every national institution': 'সব জাতীয় প্রতিষ্ঠান প্রতিস্থাপন করা',
  'Climate challenges often require shared knowledge, funding and coordinated action.':
      'জলবায়ু সমস্যা মোকাবিলায় যৌথ জ্ঞান, অর্থায়ন ও সমন্বিত পদক্ষেপ প্রয়োজন।',
  'Which activity represents diplomatic cooperation?':
      'কোন কাজটি কূটনৈতিক সহযোগিতার উদাহরণ?',
  'Countries negotiating a shared agreement': 'দেশগুলোর যৌথ চুক্তি নিয়ে আলোচনা',
  'A company changing its logo': 'একটি প্রতিষ্ঠানের লোগো পরিবর্তন',
  'A local sports team selecting players': 'স্থানীয় দলের খেলোয়াড় নির্বাচন',
  'A person purchasing a mobile phone': 'একজন ব্যক্তির মোবাইল ফোন কেনা',
  'Negotiation between countries is a central diplomatic activity.':
      'দেশগুলোর মধ্যে আলোচনা কূটনীতির একটি প্রধান কাজ।',
  'To eliminate all financial institutions': 'সব আর্থিক প্রতিষ্ঠান বন্ধ করতে',
  'To make payments less secure': 'পেমেন্ট কম নিরাপদ করতে',
  'How can technology support small businesses?':
      'প্রযুক্তি কীভাবে ছোট ব্যবসাকে সহায়তা করতে পারে?',
  'By helping manage customers, sales and records':
      'গ্রাহক, বিক্রয় ও হিসাব পরিচালনায় সহায়তা করে',
  'By preventing communication with customers':
      'গ্রাহকের সঙ্গে যোগাযোগ বন্ধ করে',
  'By removing every business employee': 'সব কর্মী বাদ দিয়ে',
  'By stopping financial planning': 'আর্থিক পরিকল্পনা বন্ধ করে',
  'Digital tools can improve business administration and decision-making.':
      'ডিজিটাল সরঞ্জাম ব্যবসা পরিচালনা ও সিদ্ধান্ত গ্রহণ উন্নত করতে পারে।',
  'What is a possible benefit of efficient solar technology?':
      'দক্ষ সৌর প্রযুক্তির একটি সম্ভাব্য সুবিধা কী?',
  'More renewable-energy production at lower cost':
      'কম খরচে বেশি নবায়নযোগ্য জ্বালানি উৎপাদন',
  'Permanent elimination of sunlight': 'সূর্যালোক স্থায়ীভাবে দূর করা',
  'Less access to clean energy': 'পরিচ্ছন্ন জ্বালানির সুযোগ কমানো',
  'An end to scientific research': 'বৈজ্ঞানিক গবেষণা বন্ধ করা',
  'Efficiency improvements can increase output and reduce energy costs.':
      'দক্ষতা বাড়লে উৎপাদন বাড়ে এবং জ্বালানি ব্যয় কমে।',
  'How can artificial intelligence support medical research?':
      'কৃত্রিম বুদ্ধিমত্তা কীভাবে চিকিৎসা গবেষণায় সহায়তা করতে পারে?',
  'By helping analyze complex information': 'জটিল তথ্য বিশ্লেষণে সহায়তা করে',
  'By guaranteeing every treatment will work':
      'সব চিকিৎসা কার্যকর হবে নিশ্চিত করে',
  'By removing the need for medical experts':
      'চিকিৎসা বিশেষজ্ঞের প্রয়োজন দূর করে',
  'By preventing the collection of evidence': 'প্রমাণ সংগ্রহ বন্ধ করে',
  'AI can assist researchers with analysis, but it does not replace medical expertise.':
      'এআই গবেষকদের বিশ্লেষণে সহায়তা করতে পারে, তবে চিকিৎসা বিশেষজ্ঞের বিকল্প নয়।',
  'Which headline belongs to this briefing?':
      'এই সংবাদ সংক্ষেপের শিরোনাম কোনটি?',
  'Which news source published this briefing?':
      'কোন সংবাদমাধ্যম এটি প্রকাশ করেছে?',
  'Which statement best summarizes this briefing?':
      'কোন বক্তব্যটি এই সংক্ষেপকে সবচেয়ে ভালোভাবে তুলে ধরে?',
  'This is the headline of the briefing you just studied.':
      'এটিই আপনি যে সংবাদ সংক্ষেপ পড়েছেন তার শিরোনাম।',
  'The source is displayed at the top of the news briefing.':
      'সংবাদমাধ্যমের নাম সংক্ষেপের ওপরে দেখানো আছে।',
  'The correct option contains the central summary of the article.':
      'সঠিক বিকল্পটিতে সংবাদের মূল সারাংশ রয়েছে।',
  'NATIONAL': 'জাতীয়',
  'INTERNATIONAL': 'আন্তর্জাতিক',
  'BUSINESS': 'ব্যবসা',
  'SPORTS': 'খেলাধুলা',
  'SCIENCE': 'বিজ্ঞান',
  'TECHNOLOGY': 'প্রযুক্তি',
};

class Text extends material.StatelessWidget {
  const Text(
    this.data, {
    super.key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
  }) : textSpan = null;

  const Text.rich(
    this.textSpan, {
    super.key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
  }) : data = null;

  final String? data;
  final material.InlineSpan? textSpan;
  final material.TextStyle? style;
  final material.StrutStyle? strutStyle;
  final material.TextAlign? textAlign;
  final material.TextDirection? textDirection;
  final material.Locale? locale;
  final bool? softWrap;
  final material.TextOverflow? overflow;
  final material.TextScaler? textScaler;
  final int? maxLines;
  final String? semanticsLabel;
  final material.TextWidthBasis? textWidthBasis;
  final material.TextHeightBehavior? textHeightBehavior;
  final material.Color? selectionColor;

  @override
  material.Widget build(material.BuildContext context) {
    return material.AnimatedBuilder(
      animation: AppSession.instance,
      builder: (context, child) {
        if (data != null) {
          return material.Text(
            localizedUi(data!),
            style: style,
            strutStyle: strutStyle,
            textAlign: textAlign,
            textDirection: textDirection,
            locale: locale,
            softWrap: softWrap,
            overflow: overflow,
            textScaler: textScaler,
            maxLines: maxLines,
            semanticsLabel: semanticsLabel == null
                ? null
                : localizedUi(semanticsLabel!),
            textWidthBasis: textWidthBasis,
            textHeightBehavior: textHeightBehavior,
            selectionColor: selectionColor,
          );
        }

        return material.Text.rich(
          _localizedSpan(textSpan!),
          style: style,
          strutStyle: strutStyle,
          textAlign: textAlign,
          textDirection: textDirection,
          locale: locale,
          softWrap: softWrap,
          overflow: overflow,
          textScaler: textScaler,
          maxLines: maxLines,
          semanticsLabel: semanticsLabel == null
              ? null
              : localizedUi(semanticsLabel!),
          textWidthBasis: textWidthBasis,
          textHeightBehavior: textHeightBehavior,
          selectionColor: selectionColor,
        );
      },
    );
  }
}

material.InlineSpan _localizedSpan(material.InlineSpan span) {
  if (span is! material.TextSpan) {
    return span;
  }

  return material.TextSpan(
    text: span.text == null ? null : localizedUi(span.text!),
    children: span.children?.map(_localizedSpan).toList(growable: false),
    style: span.style,
    recognizer: span.recognizer,
    semanticsLabel: span.semanticsLabel,
  );
}
