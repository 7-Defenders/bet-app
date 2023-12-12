part of 'league_joining_bloc.dart';

@immutable
abstract class LeagueJoiningState {}

class LeagueJoiningInitialState extends LeagueJoiningState {}

class LeagueJoiningCodeInputState extends LeagueJoiningState {}

class LeagueJoiningLoadingState extends LeagueJoiningState {}

class LeagueJoiningSuccessState extends LeagueJoiningState {
  final String leagueName;
  final int pointsNeeded;
  final String leagueId;

  LeagueJoiningSuccessState({required this.leagueName, required this.pointsNeeded, required this.leagueId});
}

class LeagueJoiningFailedState extends LeagueJoiningState {
  final String message;

  LeagueJoiningFailedState({required this.message});
}

class LeagueJoiningConfirmationSuccessState extends LeagueJoiningState{}
