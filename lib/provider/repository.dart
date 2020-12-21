import 'package:ac_app/model/temprature_model.dart';

import 'api_provider.dart';

class Repository {
  final apiProvider = ApiProvider();

  Future<TempratureModel> actSetDefaultTemp({Map<String, dynamic> body}) =>
      apiProvider.setDefaultTemprature(body: body);

  Future<TempratureModel> actGetTemp() =>
      apiProvider.getTemprature();
}
