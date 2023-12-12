part of 'league_joining_bloc.dart';

@immutable
abstract class LeagueJoiningEvent {}

class JoinLeagueButtonClickedEvent extends LeagueJoiningEvent {}

class CheckLeagueJoinPrerequisitesEvent extends LeagueJoiningEvent {
  final String leagueCode;

  CheckLeagueJoinPrerequisitesEvent({required this.leagueCode});
}

class ConfirmJoinLeagueEvent extends LeagueJoiningEvent {
  final String leagueId;

  ConfirmJoinLeagueEvent({required this.leagueId});
}

class CancelLeagueJoinEvent extends LeagueJoiningEvent {}
