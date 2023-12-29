import 'package:remove_emoji/remove_emoji.dart';

import '../modelFile/emoji/emoji.dart';
import '../modelFile/en/en.dart';
import '../modelFile/french/french.dart';
import '../modelFile/german/german.dart';
import '../modelFile/italian/italian.dart';

/**
 * Created by Parth Sheth.
 * Created on 03/10/23 at 4:35 pm
 */
enum LanguageCode { english, italian, french, german }

class SentimentAnalysisEmoji {


  List<String> filterText(String text, bool emoji) {
    List<String> duList = emoji
        ? text
        .toLowerCase()
        .replaceAll('\n', ' ')
        .replaceAll('s\s+', ' ')
        .replaceAll(RegExp(r'[.,\/#!?$%\^&\*;:{}=_`\"~()]'), '')
        .trim()
        .split(' ')
        : text
        .toLowerCase()
        .replaceAll('\n', ' ')
        .replaceAll('s\s+', ' ')
        .replaceAll(RegExp(r'[.,\/#!?$%\^&\*;:{}=_`\"~()]'), '')
        // .removEmoji
        .trim()
        .split(' ');

    Set<String> duSet = {};
    for (var element in duList) {
      duSet.add(element);
    }

    List<String> analysedList = [];
    for (var element in duSet) {
      analysedList.add(element);
    }

    return analysedList;
  }
  Map<String, dynamic> analysis(String text,{bool emoji = false,LanguageCode languageCode = LanguageCode.english}) {
    try {
      if (text.isEmpty == true) {
        throw ('err');
      }
      print('BEFORE TEXT $text');
      Map<dynamic, int> sentiments = {};
      if (emoji) sentiments.addAll(emojis);

      switch (languageCode) {

      /// english
        case LanguageCode.english:
          sentiments.addAll(englishLanguage);
          break;

      /// italian
        case LanguageCode.italian:
          sentiments.addAll(it);
          break;

      /// french
        case LanguageCode.french:
          sentiments.addAll(fr);
          break;

      /// german
        case LanguageCode.german:
          sentiments.addAll(de);
          break;
        default:
          throw ('err');
      }


      sentiments.addAll(englishLanguage);
      var goodSentiment = [];
      var badSentiment = [];
      var score = 0;

      var wordList = filterText(text, emoji);
      print('AFTER TEXT $wordList');

      for (var i = 0; i < wordList.length; i++) {
        sentiments.forEach((key, value) {
          if (key == wordList[i]) {
            score += value;
            if (score < 0) {
              badSentiment.add([key, value]);
            } else {
              goodSentiment.add([key, value]);
            }
          }
        });
      }
      var result = {
        'score': score,
        'goodSentiment': goodSentiment,
        'badSentiment': badSentiment
      };
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }
}
