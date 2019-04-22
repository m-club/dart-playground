import 'dart:async';
import 'dart:io';
import 'dart:math' show Random;

Random intGenerator = Random();
int myNumber = intGenerator.nextInt(10);

Future main() async {
  print("I'm thinking of a number: $myNumber");

  HttpServer server = await HttpServer.bind(
    InternetAddress.loopbackIPv4,
    4041,
  );
  await for (var request in server) {
    handleRequest(request);
  }
}

void handleRequest(HttpRequest request) {
  try {
    if (request.method == 'GET') {
      handleGet(request);
    } else {
      request.response
        ..statusCode = HttpStatus.methodNotAllowed
        ..write('Unsupported request: ${request.method}.')
        ..close();
    }
  } catch (e) {
    print('Exception in handleRequest: $e');
  }
  print('Request handled.');
}

void handleGet(HttpRequest request) {
  final guess = request.uri.queryParameters['q'];
  final response = request.response;
  response.statusCode = HttpStatus.ok;
  if (guess == myNumber.toString()) {
    response
      ..writeln('true')
      ..writeln("I'm thinking of another number.")
      ..close();
    myNumber = intGenerator.nextInt(10);
    print("I'm thinking of another number: $myNumber");
  } else {
    response
      ..writeln('false')
      ..close();
  }
}