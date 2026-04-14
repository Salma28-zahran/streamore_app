import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamore_app/features/livekit/bloc/livekit_cubit.dart';
import 'package:streamore_app/features/livekit/presentation/widgets/ParticipantTile.dart';

import '../../bloc/livekit_state.dart';

class LiveKitScreen extends StatefulWidget {
  final String url;
  final String token;

  const LiveKitScreen({
    super.key,
    required this.url,
    required this.token,
  });

  @override
  State<LiveKitScreen> createState() => _LiveKitScreenState();
}

class _LiveKitScreenState extends State<LiveKitScreen> {
  late LiveKitCubit cubit;

  @override
  void dispose() {
    cubit.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        cubit = LiveKitCubit();
        cubit.init(url: widget.url, token: widget.token);
        return cubit;
      },
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<LiveKitCubit, LiveKitState>(
            builder: (context, state) {
              ///  Loading
              if (state is LiveKitLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              ///  Error
              if (state is LiveKitError) {
                return Center(child: Text(state.message));
              }

              ///  Connected
              if (state is LiveKitConnected) {
                final participants = state.participants;

                return GridView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: participants.length,
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: participants.length <= 1 ? 1 : 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    return ParticipantTile(
                      participant: participants[index],
                    );
                  },
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}