import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:streamore_app/core/provider/my_provider.dart';
import 'package:streamore_app/features/auth/bloc/auth_cubit.dart';
import 'package:streamore_app/features/auth/bloc/auth_states.dart';
import 'package:streamore_app/widgets/account_widgets/account_custombox.dart';

import '../../../../widgets/account_widgets/account_delete_section.dar.dart';
import '../../../../widgets/account_widgets/account_main_section.dart';

class AccountTab extends StatefulWidget {
  const AccountTab({super.key});

  @override
  State<AccountTab> createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab> {
  late ValueNotifier<bool> isFormFilledNotifier;

  final _controllers = List.generate(6, (_) => TextEditingController());
  final _focusNodes = List.generate(6, (_) => FocusNode());

  bool get isFormFilled =>
      _controllers.every((c) => c.text.trim().isNotEmpty);

  @override
  void initState() {
    super.initState();
    isFormFilledNotifier = ValueNotifier(false);
    for (var c in _controllers) {
      c.addListener(_checkFormFilled);
    }
  }

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    for (var n in _focusNodes) n.dispose();
    isFormFilledNotifier.dispose();
    super.dispose();
  }

  void _checkFormFilled() {
    isFormFilledNotifier.value =
        _controllers.every((c) => c.text.trim().isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w = mq.size.width;
    final h = mq.size.height;

    return BlocProvider(
      create: (_) => AuthCubit(),

      child: BlocListener<AuthCubit, AuthStates>(
        listener: (context, state) {
          if (state is LogOutSuccessState) {
            Navigator.pushReplacementNamed(context, '/signin');
          } else if (state is FailedToLogOutState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        child: Consumer<MyProvider>(
          builder: (context, myprovider, _) {
            final isDark = myprovider.themeMode == ThemeMode.dark;

            return Padding(
              padding:
              EdgeInsets.symmetric(horizontal: w * 0.06, vertical: h * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AccountMainSection(
                    isDark: isDark,
                    w: w,
                    h: h,
                  ),
                  AccountDeleteSection(
                    isDark: isDark,
                    w: w,
                    h: h,
                    controllers: _controllers,
                    focusNodes: _focusNodes,
                    isFormFilledNotifier: isFormFilledNotifier,
                    checkFormFilled: _checkFormFilled,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
