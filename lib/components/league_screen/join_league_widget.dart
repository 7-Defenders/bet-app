import 'package:app/blocs/league_joining_bloc/league_joining_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JoinLeagueWidget extends StatefulWidget {
  JoinLeagueWidget({Key? key}) : super(key: key);

  @override
  State<JoinLeagueWidget> createState() => _JoinLeagueWidgetState();
}

class _JoinLeagueWidgetState extends State<JoinLeagueWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LeagueJoiningBloc, LeagueJoiningState>(
      builder: (context, state) {
        if (state is LeagueJoiningLoadingState) {
          return _showLoadingDialog();
        } else if (state is LeagueJoiningInitialState) {
          return _buildInitialUI(context);
        } else if (state is LeagueJoiningCodeInputState) {
          final TextEditingController leagueCodeController = TextEditingController();
          Future.delayed(Duration.zero, () { // avoids "setState() or markNeedsBuild() called during build"
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => _buildLeagueCodeInputDialog(context, leagueCodeController),
            );
          });
          return _buildInitialUI(context);
        } else if (state is LeagueJoiningSuccessState) {
          Future.delayed(Duration.zero, () { // avoids "setState() or markNeedsBuild() called during build"
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => _buildSuccessDialog(state),
            );
          });
          return _buildInitialUI(context); // this is under the dialog
        } else if (state is LeagueJoiningFailedState) {
          Future.delayed(Duration.zero, () {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => _buildFailedDialog(state),
            );
          });
          return _buildInitialUI(context);
        } else if (state is LeagueJoiningConfirmationSuccessState) {
          Future.delayed(Duration.zero, () {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => _buildConfirmationSuccessDialog(),
            );
          });
          return _buildInitialUI(context);
        } else {
          return _buildInitialUI(context);
        }
      },
      listener: (context, state) {
      },
    );
  }

  Widget _buildInitialUI(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        BlocProvider.of<LeagueJoiningBloc>(context).add(JoinLeagueButtonClickedEvent());
      },
      child: const Text('Join League'),
    );
  }

  Widget _showLoadingDialog() {
    return CircularProgressIndicator(backgroundColor: Colors.black.withOpacity(0.5),);
  }

  Widget _buildLeagueCodeInputDialog(BuildContext context, TextEditingController leagueCodeController) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Enter League Code'),
          const SizedBox(height: 8.0),
          TextFormField(
            controller: leagueCodeController,
            decoration: const InputDecoration(hintText: 'League Code'),
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  BlocProvider.of<LeagueJoiningBloc>(context).add(CancelLeagueJoinEvent());
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Trigger the league joining process
                  BlocProvider.of<LeagueJoiningBloc>(context).add(
                    CheckLeagueJoinPrerequisitesEvent(
                      leagueCode: leagueCodeController.text,
                    ),
                  );
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Join'),
              ),
            ],
          ),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    );
  }

  Widget _buildFailedDialog(LeagueJoiningFailedState state) {
    return AlertDialog(
      title: const Text('Error joining league'),
      content: SingleChildScrollView(child: Text(state.message)),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
            // BlocProvider.of<LeagueJoiningBloc>(context).add(CancelLeagueJoinEvent());
          },
          child: const Text('Ok'),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    );
  }

  Widget _buildSuccessDialog(LeagueJoiningSuccessState state) {
    return AlertDialog(
      title: Text('League Name: ${state.leagueName}'),
      content: Text('Points Needed to Join: ${state.pointsNeeded}'),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
            BlocProvider.of<LeagueJoiningBloc>(context).add(CancelLeagueJoinEvent());
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // Trigger the second cloud function to confirm join
            BlocProvider.of<LeagueJoiningBloc>(context).add(ConfirmJoinLeagueEvent(leagueId: state.leagueId));
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Confirm Join'),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    );
  }

  Widget _buildConfirmationSuccessDialog() {
    return AlertDialog(
      title: const Text('Success'),
      content: const Text('You have successfully joined the league!'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
            BlocProvider.of<LeagueJoiningBloc>(context).add(CancelLeagueJoinEvent());
          },
          child: const Text('Ok'),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    );
  }
}
