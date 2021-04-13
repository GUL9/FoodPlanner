library globals;

import 'dart:async';
import 'package:grocerylister/util/nlp_server_communicator.dart';

NLPServerCommunicator nlpServerComm = NLPServerCommunicator('78.70.59.52', 1337);
StreamController planStream = StreamController.broadcast();
StreamController recipeStream = StreamController.broadcast();