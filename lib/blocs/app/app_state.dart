part of 'app_bloc.dart';

abstract class AppState extends Equatable {
  const AppState();

  @override
  List<Object> get props => [];
}

class AppInitial extends AppState {}

class ThemeRetrievedState extends AppState {
  final bool isDarkTheme;

  ThemeRetrievedState({required this.isDarkTheme});

  @override
  List<Object> get props => [isDarkTheme];
}
