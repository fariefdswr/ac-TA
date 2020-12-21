import 'package:ac_app/model/temprature_model.dart';
import 'package:ac_app/provider/repository.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class TempratureBloc {
  final _repository = Repository();
  final _setDefaultTemprature = BehaviorSubject<TempratureModel>();
  final _setTemprature = PublishSubject<String>();
  final _setLoading = PublishSubject<bool>();

  Stream<TempratureModel> get setDefaultTempratureBloc =>
      _setDefaultTemprature.stream;

  Stream<String> get setTempratureBloc => _setTemprature.stream;

  Stream<bool> get setLoadingBloc => _setLoading.stream;

  setDefaultTemprature(Map<String, dynamic> body) async {
    setLoading(true);
    TempratureModel model = await _repository.actSetDefaultTemp(body: body);
    _setDefaultTemprature.sink.add(model);
    setLoading(false);
  }

  getTemprature() async {
    TempratureModel model = await _repository.actGetTemp();
    _setDefaultTemprature.sink.add(model);
  }

  setTemprature(String temp) async {
    _setTemprature.sink.add(temp);
  }

  setLoading(bool isLoading) async {
    _setLoading.sink.add(isLoading);
  }

  dispose() {
    _setDefaultTemprature.close();
    _setTemprature.close();
    _setLoading.close();
  }
}

final bloc = TempratureBloc();
