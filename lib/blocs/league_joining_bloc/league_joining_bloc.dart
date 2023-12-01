import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

part 'league_joining_event.dart';
part 'league_joining_state.dart';

class LeagueJoiningBloc extends Bloc<LeagueJoiningEvent, LeagueJoiningState> {

  final String uid = FirebaseAuth.instance.currentUser!.uid;

  LeagueJoiningBloc() : super(LeagueJoiningInitialState()) {
    on<JoinLeagueButtonClickedEvent>((event, emit) {
      emit(LeagueJoiningCodeInputState());
    });
    on<CheckLeagueJoinPrerequisitesEvent>((event, emit) async {
      emit (LeagueJoiningLoadingState());
      try {
        print("here1");
        final response = await http.post(
          Uri.parse(dotenv.env['CHECK_LEAGUE_JOIN_PREREQUISITES_URL']!),
          body: {
            'uid': uid,
            'leagueCode': event.leagueCode,
          },
        );
        print("here2");
        print(response);
        print(response.body);
        print("decoding now lesgo: ");
        final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
        print("PRINTING DATA: ");
        print(data);
        if (data.containsKey('error')) {
          emit(LeagueJoiningFailedState(message: data['error'] as String));
        } else {
          emit(LeagueJoiningSuccessState(
            leagueId: data['leagueId'] as String,
            leagueName: data['leagueName'] as String,
            pointsNeeded: data['pointsNeededToJoin'] as int,
          ),);
        }
      } catch (e) {
        print("error caught");
        print(e);
        emit(LeagueJoiningFailedState(message: e.toString()));
      }
    });
    on<ConfirmJoinLeagueEvent>((event, emit) async {
      emit(LeagueJoiningLoadingState());
      try {
        print("1");
        final response = await http.post(
          Uri.parse(dotenv.env['JOIN_LEAGUE_URL']!),
          body: {
            'uid': uid,
            'leagueId': event.leagueId,
          },
        );
        print("2");
        print(response.body);
        final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
        print("3");
        print(data);
        if (data.containsKey('success') && data['success'] == true) {
          emit(LeagueJoiningConfirmationSuccessState());
        } else {
          emit(LeagueJoiningFailedState(message: 'Failed to join the league.'));
        }
      } catch (e) {
        print(e);
        emit(LeagueJoiningFailedState(message: 'An error occurred while joining the league.'));
      }
    });
    on<CancelLeagueJoinEvent>((event, emit) {
      emit(LeagueJoiningInitialState());
    });
  }
}
