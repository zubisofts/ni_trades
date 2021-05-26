part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class SwitchThemeEvent extends AppEvent {
  final bool isDarkTheme;

  SwitchThemeEvent({required this.isDarkTheme});

  @override
  List<Object> get props => [isDarkTheme];
}

class GetThemeEvent extends AppEvent {

  GetThemeEvent();

  @override
  List<Object> get props => [];
}
