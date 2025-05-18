import 'dart:io';
import 'package:shelf/shelf.dart';

Future<Response> serveSwaggerUI(Request request) async {
  final file = File('swagger_ui.html');
  if (await file.exists()) {
    final content = await file.readAsString();
    return Response.ok(content, headers: {'Content-Type': 'text/html'});
  } else {
    return Response.notFound('Swagger UI page not found');
  }
}

Future<Response> serveOpenApiSpec(Request request) async {
  final file = File('api/openapi.yaml');
  if (await file.exists()) {
    final content = await file.readAsString();
    return Response.ok(content, headers: {'Content-Type': 'application/yaml'});
  } else {
    return Response.notFound('OpenAPI spec not found');
  }
}
