// import 'package:speech_to_text/speech_to_text.dart';
// import 'dart:developer';

// class SpeechToTextHandler {
//   SpeechToText speechToText = SpeechToText();
//   bool isListening = false;

//   Future<void> listenToSpeech(String languageFromCountry, Function speechToTextHandleFunc) async {
//     if (!isListening) {
//       bool available = await speechToText.initialize(
//         onStatus: (status) => log(status),
//         onError: (error) => log(error.errorMsg),
//       );
//       if (available) {
//         isListening = true;
//         List locales = await speechToText.locales();
//         await speechToText.listen(
//             cancelOnError: true,
//             localeId: languageFromCountry == null ? null : locales.firstWhere((locale) => locale.name.contains(languageFromCountry)).localeId,
//             onResult: (input) {
//               if (input.finalResult) {
//                 speechToText.stop();
//                 isListening = false;
//                 speechToTextHandleFunc(input.recognizedWords);
//               }
//             });
//       }
//     } else {
//       speechToText.stop();
//       isListening = false;
//     }
//   }
// }
