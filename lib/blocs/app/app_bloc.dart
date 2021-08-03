import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ni_trades/theme/app_theme.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppInitial());

  @override
  Stream<AppState> mapEventToState(
    AppEvent event,
  ) async* {
    if (event is SwitchThemeEvent) {
      yield* _mapSwitchThemeEventToState(event.isDarkTheme);
    }

    if (event is GetThemeEvent) {
      var themeValue = await AppTheme.themeValue;
      yield ThemeRetrievedState(isDarkTheme: themeValue);
    }
  }

  Stream<AppState> _mapSwitchThemeEventToState(bool isDarktheme) async* {
    var themeValue = await AppTheme.setThemeValue(isDarktheme);
    yield ThemeRetrievedState(isDarkTheme: themeValue);
  }
}
