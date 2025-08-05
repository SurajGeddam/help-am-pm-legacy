import 'package:flutter_bloc/flutter_bloc.dart';

enum LoadingIndicatorEvent { loadingStarted, loadingFinished }

enum LoadingIndicatorState { loading, loaded }

class LoadingIndicatorBloc
    extends Bloc<LoadingIndicatorEvent, LoadingIndicatorState> {
  LoadingIndicatorBloc() : super(LoadingIndicatorState.loaded) {
    on<LoadingIndicatorEvent>((event, emit) {
      if (event == LoadingIndicatorEvent.loadingStarted) {
        emit(LoadingIndicatorState.loading);
      } else if (event == LoadingIndicatorEvent.loadingFinished) {
        emit(LoadingIndicatorState.loaded);
      }
    });
  }
}
