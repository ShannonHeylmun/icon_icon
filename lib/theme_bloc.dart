import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc()
    : super(ThemeMode.system == ThemeMode.dark ? ThemeDark() : ThemeLight()) {
    on<SetInitialTheme>((event, emit) async {
      emit(ThemeMode.system == ThemeMode.dark ? ThemeDark() : ThemeLight());
    });

    on<ChangeTheme>((event, emit) async {
      emit(state is ThemeLight ? ThemeDark() : ThemeLight());
    });
  }
}

Future<bool> isDark() async {
  return ThemeMode.system == ThemeMode.dark;
}

abstract class ThemeEvent {}

class SetInitialTheme extends ThemeEvent {}

class ChangeTheme extends ThemeEvent {}

abstract class ThemeState {}

class ThemeDark extends ThemeState {}

class ThemeLight extends ThemeState {}
