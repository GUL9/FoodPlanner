import 'dart:io';
import 'dart:developer' as developer;
import 'dart:typed_data';

class NLPServerCommunicator {
  InternetAddress serverAddress;
  int port;

  NLPServerCommunicator(String serverIp, int port) {
    this.serverAddress = InternetAddress(serverIp);
    this.port = port;
  }

  Future<void> requestForIngredient(String languageToProcess, Function answerHandleFunc) async {
    final socket = await Socket.connect(serverAddress, port).timeout(Duration(seconds: 3));
    socket.writeln(languageToProcess);
    socket.listen(
        (Uint8List data) {
          String ingredientTokens = String.fromCharCodes(data);
          List<String> tokens = ingredientTokens.split(',');
          answerHandleFunc(tokens);
        },
        onError: (error) {
          developer.log("Error on connecting to NLP server");
          socket.destroy();
        },
        onDone: () {
          developer.log("Received data from NLP server");
          socket.destroy();
        });
  }
}