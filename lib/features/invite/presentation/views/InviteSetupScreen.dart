import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamore_app/features/invite/bloc/invite_cubit.dart';
import 'package:streamore_app/features/invite/bloc/invite_state.dart';
import 'package:streamore_app/widgets/permissions/camera/camera-permission.dart';
import 'package:streamore_app/widgets/permissions/mic/mic-permission.dart';

class InviteSetupScreen extends StatefulWidget {
  static const String routeName = "/invite";

  InviteSetupScreen({super.key});

  @override
  State<InviteSetupScreen> createState() => _InviteSetupScreenState();
}

class _InviteSetupScreenState extends State<InviteSetupScreen> {
  final TextEditingController nameController = TextEditingController();
  bool isMicOn = false;
  bool isCameraOn = false;

  @override
  Widget build(BuildContext context) {
   
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (_) => InviteCubit()..loadInvite(),
      child: BlocListener<InviteCubit, InviteState>(
        listener: (context, state) {
          if (state is InviteJoinSuccess) {
            final liveKitToken = state.liveKitToken;

            /// ⬅️ الخطوة الجاية: permissions + LiveKit connect
            debugPrint("LIVEKIT TOKEN: $liveKitToken");
          }
        },
        child: Scaffold(
          appBar: AppBar(),
          body: SafeArea(
            child: BlocBuilder<InviteCubit, InviteState>(
              builder: (context, state) {

                /// ⏳ LOADING
                if (state is InviteLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                /// ❌ ERROR
                if (state is InviteError) {
                  return Center(child: Text(state.message));
                }

                /// ✅ LOADED
                if (state is InviteLoaded) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// 🔥 Stream Info
                        Text(
                          state.streamName,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          "Participants: ${state.participants}",
                          style: TextStyle(color: Colors.grey[600]),
                        ),

                        const SizedBox(height: 20),

                        /// 🎥 Preview
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.videocam_off,
                                    color: Colors.grey, size: 40),
                                SizedBox(height: 8),
                                Text(
                                  "Camera is off",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          "Setup your audio and video before entering the studio.",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "Make sure your mic and camera are ready.",
                          style: TextStyle(color: Colors.grey[600]),
                        ),

                        const SizedBox(height: 20),

                        /// 👤 Name Input
                        TextField(
                          controller: nameController,
                          maxLength: 100,
                          decoration: InputDecoration(
                            hintText: "Display Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        /// 🚀 BUTTON
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              final name = nameController.text.trim();

                              if (name.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Name is required"),
                                  ),
                                );
                                return;
                              }

                              context
                                  .read<InviteCubit>()
                                  .joinStream(name);
                            },
                            child: const Text("Enter Studio"),
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// 🔊 Status
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  requestMicPermission(context, () {
                                    setState(() {
                                      isMicOn = true;
                                    });
                                  });
                                },
                                child: _statusCard(
                                  title: "AUDIO",
                                  subtitle: isMicOn ? "Microphone On" : "Tap to enable",
                                  color: isMicOn ? Colors.green : Colors.grey,
                                  icon: Icons.mic,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  requestCameraPermission(context, () {
                                    setState(() {
                                      isCameraOn = true;
                                    });
                                  });
                                },
                                child: _statusCard(
                                  title: "CAMERA",
                                  subtitle: isCameraOn ? "Camera is On" : "Camera is off",
                                  color: isCameraOn ? Colors.green : Colors.red,
                                  icon: isCameraOn ? Icons.videocam : Icons.videocam_off,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _statusCard({
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 12)),
              Text(
                subtitle,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}