import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:streamore_app/core/apis/StreamFlow/StreamFlowCubit.dart';
import 'package:streamore_app/core/apis/StreamFlow/StreamFlowState.dart';
import 'package:streamore_app/core/helpers/storage_helper.dart';

class LiveStreamDialog extends StatefulWidget {
  const LiveStreamDialog({
    super.key,
  });

  @override
  State<LiveStreamDialog> createState() =>
      _LiveStreamDialogState();
}

class _LiveStreamDialogState extends State<LiveStreamDialog> {
  String selectedSource = 'live';

  bool isDestinationPage = false;

  bool _isStartingFacebook = false;

  // ============================================================
  // FACEBOOK STREAM DATA
  // ============================================================

  static const String facebookRtmpUrl =
      'rtmps://live-api-s.facebook.com:443/rtmp/';

  static const String facebookRtmpKey =
      'FB-27282145804819847-0-Ab6iqZ2J4IoD3ZXZQLDHiIL0';

  static const String facebookStreamUrl =
      'https://www.facebook.com';

  // ============================================================
  // OPEN DESTINATIONS PAGE
  // ============================================================

  void _openDestinationsPage() {
    if (_isStartingFacebook) {
      return;
    }

    setState(() {
      isDestinationPage = true;
    });
  }

  // ============================================================
  // START FACEBOOK FULL STREAM FLOW
  // ============================================================

  Future<void> _startFacebookStreaming(
      BuildContext context,
      ) async {
    if (_isStartingFacebook) {
      debugPrint(
        '⚠️ FACEBOOK STREAM FLOW ALREADY RUNNING',
      );

      return;
    }

    final StreamFlowCubit streamFlowCubit =
    context.read<StreamFlowCubit>();

    if (streamFlowCubit.state is StreamFlowLoading) {
      debugPrint(
        '⚠️ STREAM FLOW CUBIT IS ALREADY LOADING',
      );

      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _isStartingFacebook = true;
    });

    try {
      debugPrint('');
      debugPrint('======================================');
      debugPrint('📘 FACEBOOK BUTTON CLICKED');
      debugPrint('======================================');

      // ==========================================================
      // VALIDATE FACEBOOK RTMP URL
      // ==========================================================

      if (facebookRtmpUrl.trim().isEmpty) {
        throw Exception(
          'Facebook RTMP URL is empty',
        );
      }

      // ==========================================================
      // VALIDATE FACEBOOK STREAM KEY
      // ==========================================================

      if (facebookRtmpKey.trim().isEmpty ||
          facebookRtmpKey ==
              'YOUR_FACEBOOK_STREAM_KEY') {
        throw Exception(
          'ضع Facebook Stream Key الصحيح داخل الكود',
        );
      }

      // ==========================================================

      // ==========================================================

      final int? storedAccountId =
      await StorageHelper.getAccountId();

      if (storedAccountId == null ||
          storedAccountId <= 0) {
        throw Exception(
          'Account ID not found. Please login again.',
        );
      }

      // ==========================================================
      // GET AUTH TOKEN
      // ==========================================================

      final String? authToken =
      await StorageHelper.getToken();

      if (authToken == null ||
          authToken.trim().isEmpty) {
        throw Exception(
          'Authentication token not found. Please login again.',
        );
      }

      // ==========================================================
      // GET CSRF TOKEN
      // ==========================================================

      final String csrfToken =
          (await StorageHelper.getCsrf()) ?? '';

      debugPrint(
        '👤 STORED ACCOUNT ID => $storedAccountId',
      );

      debugPrint(
        '🌍 FACEBOOK RTMP URL => $facebookRtmpUrl',
      );

      debugPrint(
        '🔑 FACEBOOK STREAM KEY => AVAILABLE',
      );

      debugPrint(
        '🔐 AUTH TOKEN => AVAILABLE',
      );

      debugPrint(
        '🛡️ CSRF TOKEN => '
            '${csrfToken.isEmpty ? 'NOT PROVIDED' : 'AVAILABLE'}',
      );

      // ==========================================================
      // RUN COMPLETE STREAM FLOW
      // ==========================================================

      await streamFlowCubit.startFullFlow(
        accountId: storedAccountId,
        name: 'Facebook Live Stream',
        description:
        'Streaming from Streamore application',
        layoutType: 'user',
        csrfToken: csrfToken,
        authToken: authToken.trim(),
        facebookRtmpUrl:
        facebookRtmpUrl.trim(),
        facebookRtmpKey:
        facebookRtmpKey.trim(),
        facebookStreamUrl:
        facebookStreamUrl.trim(),
      );
    } catch (error, stackTrace) {
      debugPrint('');
      debugPrint('======================================');
      debugPrint('❌ FACEBOOK BUTTON STREAM ERROR');
      debugPrint('======================================');

      debugPrint(
        '❌ ERROR => $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString().replaceFirst(
              'Exception: ',
              '',
            ),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isStartingFacebook = false;
        });
      }
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
      BuildContext context,
      ) {
    final Size size =
        MediaQuery.of(context).size;

    final double width = size.width;
    final double height = size.height;

    final bool isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final Color textColor =
    isDark ? Colors.white : Colors.black;

    final Color secondaryTextColor =
    isDark
        ? Colors.white70
        : Colors.black87;

    return BlocListener<
        StreamFlowCubit,
        StreamFlowState>(
      listener: (
          BuildContext context,
          StreamFlowState state,
          ) {
        // ========================================================
        // STREAM SUCCESS
        // ========================================================

        if (state is StreamFlowSuccess) {
          debugPrint(
            '✅ ${state.message}',
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
              ),
            ),
          );

          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        }

        // ========================================================
        // STREAM ERROR
        // ========================================================

        if (state is StreamFlowError) {
          debugPrint(
            '❌ ${state.error}',
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.error,
              ),
            ),
          );
        }
      },
      child: Dialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: width * 0.045,
        ),
        backgroundColor:
        isDark
            ? const Color(0xFF071332)
            : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            width * 0.045,
          ),
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(
            width * 0.045,
          ),
          decoration: BoxDecoration(
            color:
            isDark
                ? const Color(
              0xFF071332,
            )
                : Colors.white,
            borderRadius:
            BorderRadius.circular(
              width * 0.045,
            ),
            border: Border.all(
              color: const Color(
                0xFF17356E,
              ),
            ),
          ),
          child:
          isDestinationPage
              ? _buildDestinationPage(
            context,
            width,
            height,
            isDark,
            textColor,
            secondaryTextColor,
          )
              : _buildLivePage(
            context,
            width,
            height,
            isDark,
            textColor,
            secondaryTextColor,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // LIVE PAGE
  // ============================================================

  Widget _buildLivePage(
      BuildContext context,
      double width,
      double height,
      bool isDark,
      Color textColor,
      Color secondaryTextColor,
      ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        // ======================================================
        // HEADER
        // ======================================================

        Row(
          children: [
            Expanded(
              child: Text(
                'start_live_stream'.tr(),
                style: TextStyle(
                  color: textColor,
                  fontSize:
                  width * 0.055,
                  fontWeight:
                  FontWeight.w700,
                ),
              ),
            ),
            InkWell(
              onTap:
              _isStartingFacebook
                  ? null
                  : () {
                Navigator.pop(
                  context,
                );
              },
              borderRadius:
              BorderRadius.circular(
                50,
              ),
              child: Padding(
                padding: EdgeInsets.all(
                  width * 0.008,
                ),
                child: Icon(
                  Icons.close,
                  color:
                  secondaryTextColor,
                  size: width * 0.06,
                ),
              ),
            ),
          ],
        ),

        SizedBox(
          height: height * 0.01,
        ),

        Text(
          'live_stream_description'.tr(),
          style: TextStyle(
            color: const Color(
              0xFF8EB5E4,
            ),
            fontSize:
            width * 0.035,
          ),
        ),

        SizedBox(
          height: height * 0.028,
        ),

        Text(
          'source'.tr(),
          style: TextStyle(
            color:
            isDark
                ? Colors.white54
                : Colors.black54,
            fontSize:
            width * 0.038,
            fontWeight:
            FontWeight.w600,
          ),
        ),

        SizedBox(
          height: height * 0.018,
        ),

        Wrap(
          spacing: width * 0.045,
          runSpacing: height * 0.012,
          children: [
            _radioOption(
              value: 'live',
              label: 'live'.tr(),
              textColor: textColor,
              width: width,
            ),
            _radioOption(
              value:
              'pre_recorded_video',
              label:
              'pre_recorded_video'
                  .tr(),
              textColor: textColor,
              width: width,
            ),
          ],
        ),

        SizedBox(
          height: height * 0.03,
        ),

        Column(
          children: [
            Center(
              child: SizedBox(
                width: width * 0.50,
                height:
                height * 0.055,
                child:
                OutlinedButton.icon(
                  style:
                  OutlinedButton.styleFrom(
                    side:
                    const BorderSide(
                      color: Color(
                        0xFF1D6EFF,
                      ),
                    ),
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius
                          .circular(
                        width * 0.03,
                      ),
                    ),
                  ),
                  onPressed:
                  _isStartingFacebook
                      ? null
                      : _openDestinationsPage,
                  icon: Icon(
                    Icons.add,
                    color: const Color(
                      0xFF1D6EFF,
                    ),
                    size: width * 0.05,
                  ),
                  label: Text(
                    'add_destination'
                        .tr(),
                    style: TextStyle(
                      color:
                      const Color(
                        0xFF1D6EFF,
                      ),
                      fontSize:
                      width * 0.038,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(
              height: height * 0.012,
            ),

            Center(
              child: SizedBox(
                width: width * 0.50,
                height:
                height * 0.055,
                child: ElevatedButton(
                  style:
                  ElevatedButton.styleFrom(
                    backgroundColor:
                    const Color(
                      0xFF1D6EFF,
                    ),
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius
                          .circular(
                        width * 0.025,
                      ),
                    ),
                  ),
                  onPressed:
                  _isStartingFacebook
                      ? null
                      : _openDestinationsPage,
                  child: Text(
                    'start_streaming'
                        .tr(),
                    style: TextStyle(
                      fontSize:
                      width * 0.038,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(
              height: height * 0.008,
            ),

            TextButton(
              onPressed:
              _isStartingFacebook
                  ? null
                  : () {
                Navigator.pop(
                  context,
                );
              },
              child: Text(
                'skip_for_now'.tr(),
                style: TextStyle(
                  color:
                  const Color(
                    0xFF8EB5E4,
                  ),
                  fontSize:
                  width * 0.035,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // DESTINATION PAGE
  // ============================================================

  Widget _buildDestinationPage(
      BuildContext context,
      double width,
      double height,
      bool isDark,
      Color textColor,
      Color secondaryTextColor,
      ) {
    return Directionality(
      textDirection:
      ui.TextDirection.ltr,
      child: LayoutBuilder(
        builder: (
            BuildContext context,
            BoxConstraints constraints,
            ) {
          final double availableWidth =
              constraints.maxWidth;

          final double iconsSpacing =
          availableWidth >= 700
              ? 40
              : 14;

          final double calculatedIconSize =
              (availableWidth -
                  (iconsSpacing * 3)) /
                  4;

          final double iconSize =
          calculatedIconSize
              .clamp(
            58.0,
            112.0,
          )
              .toDouble();

          final double titleSize =
          (availableWidth * 0.04)
              .clamp(
            23.0,
            37.0,
          )
              .toDouble();

          final double footerSize =
          (availableWidth * 0.033)
              .clamp(
            16.0,
            32.0,
          )
              .toDouble();

          return SingleChildScrollView(
            child: Column(
              mainAxisSize:
              MainAxisSize.min,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                // =================================================
                // HEADER
                // =================================================

                Row(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .center,
                  children: [
                    Expanded(
                      child: Text(
                        'add_destination'
                            .tr(),
                        style: TextStyle(
                          color: textColor,
                          fontSize:
                          titleSize,
                          fontWeight:
                          FontWeight
                              .w700,
                          height: 1,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed:
                      _isStartingFacebook
                          ? null
                          : () {
                        setState(() {
                          isDestinationPage =
                          false;
                        });
                      },
                      style:
                      TextButton.styleFrom(
                        foregroundColor:
                        isDark
                            ? Colors
                            .white60
                            : const Color(
                          0xFF999999,
                        ),
                        padding:
                        EdgeInsets.symmetric(
                          horizontal:
                          width *
                              0.012,
                          vertical:
                          height *
                              0.006,
                        ),
                      ),
                      child: Text(
                        'back'.tr(),
                        style: TextStyle(
                          fontSize:
                          (availableWidth *
                              0.03)
                              .clamp(
                            17.0,
                            30.0,
                          )
                              .toDouble(),
                          fontWeight:
                          FontWeight
                              .w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.012,
                    ),
                    InkWell(
                      onTap:
                      _isStartingFacebook
                          ? null
                          : () {
                        Navigator.pop(
                          context,
                        );
                      },
                      borderRadius:
                      BorderRadius
                          .circular(
                        50,
                      ),
                      child: Padding(
                        padding:
                        EdgeInsets.all(
                          width * 0.008,
                        ),
                        child: Icon(
                          Icons.close,
                          color:
                          secondaryTextColor,
                          size:
                          (availableWidth *
                              0.035)
                              .clamp(
                            25.0,
                            34.0,
                          )
                              .toDouble(),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: height * 0.052,
                ),

                // =================================================
                // FACEBOOK - LINKEDIN - YOUTUBE - X
                // =================================================

                Row(
                  mainAxisSize:
                  MainAxisSize.min,
                  children: [
                    _destinationIcon(
                      icon:
                      FontAwesomeIcons
                          .facebookF,
                      backgroundColor:
                      const Color(
                        0xFF1877F2,
                      ),
                      size: iconSize,
                      isLoading:
                      _isStartingFacebook,
                      onTap: () async {
                        await _startFacebookStreaming(
                          context,
                        );
                      },
                    ),
                    SizedBox(
                      width: iconsSpacing,
                    ),
                    _destinationIcon(
                      icon:
                      FontAwesomeIcons
                          .linkedinIn,
                      backgroundColor:
                      const Color(
                        0xFF0A66C2,
                      ),
                      size: iconSize,
                      onTap: () {
                        debugPrint(
                          'LinkedIn selected',
                        );
                      },
                    ),
                    SizedBox(
                      width: iconsSpacing,
                    ),
                    _destinationIcon(
                      icon:
                      FontAwesomeIcons
                          .youtube,
                      backgroundColor:
                      const Color(
                        0xFFFF0000,
                      ),
                      size: iconSize,
                      onTap: () {
                        debugPrint(
                          'YouTube selected',
                        );
                      },
                    ),
                    SizedBox(
                      width: iconsSpacing,
                    ),
                    _destinationIcon(
                      icon:
                      FontAwesomeIcons
                          .xTwitter,
                      backgroundColor:
                      Colors.black,
                      size: iconSize,
                      onTap: () {
                        debugPrint(
                          'X selected',
                        );
                      },
                    ),
                  ],
                ),

                SizedBox(
                  height: height * 0.038,
                ),

                // =================================================
                // INSTAGRAM - TWITCH
                // =================================================

                Row(
                  mainAxisSize:
                  MainAxisSize.min,
                  children: [
                    _destinationIcon(
                      icon:
                      FontAwesomeIcons
                          .instagram,
                      size: iconSize,
                      gradient:
                      const LinearGradient(
                        begin:
                        Alignment
                            .bottomLeft,
                        end:
                        Alignment
                            .topRight,
                        colors: [
                          Color(
                            0xFFFFD600,
                          ),
                          Color(
                            0xFFFF7A00,
                          ),
                          Color(
                            0xFFFF0169,
                          ),
                          Color(
                            0xFFD300C5,
                          ),
                          Color(
                            0xFF7638FA,
                          ),
                        ],
                      ),
                      onTap: () {
                        debugPrint(
                          'Instagram selected',
                        );
                      },
                    ),
                    SizedBox(
                      width: iconsSpacing,
                    ),
                    _destinationIcon(
                      icon:
                      FontAwesomeIcons
                          .twitch,
                      backgroundColor:
                      const Color(
                        0xFF9146FF,
                      ),
                      size: iconSize,
                      onTap: () {
                        debugPrint(
                          'Twitch selected',
                        );
                      },
                    ),
                  ],
                ),

                SizedBox(
                  height: height * 0.045,
                ),

                // =================================================
                // CUSTOM RTMP
                // =================================================

                InkWell(
                  onTap:
                  _isStartingFacebook
                      ? null
                      : () {
                    debugPrint(
                      'Custom RTMP selected',
                    );
                  },
                  borderRadius:
                  BorderRadius.circular(
                    13,
                  ),
                  child: Container(
                    width:
                    availableWidth < 500
                        ? double.infinity
                        : availableWidth *
                        0.36,
                    constraints:
                    const BoxConstraints(
                      minWidth: 280,
                      maxWidth: 335,
                    ),
                    height:
                    availableWidth < 500
                        ? 82
                        : 100,
                    padding:
                    EdgeInsets.symmetric(
                      horizontal:
                      availableWidth < 500
                          ? 18
                          : 22,
                    ),
                    decoration:
                    BoxDecoration(
                      color:
                      Colors.transparent,
                      borderRadius:
                      BorderRadius
                          .circular(
                        13,
                      ),
                      border: Border.all(
                        color: textColor,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.dns_outlined,
                          color: textColor,
                          size:
                          availableWidth <
                              500
                              ? 40
                              : 56,
                        ),
                        SizedBox(
                          width:
                          availableWidth <
                              500
                              ? 16
                              : 27,
                        ),
                        Expanded(
                          child: Text(
                            'custom_rtmp'
                                .tr(),
                            maxLines: 1,
                            overflow:
                            TextOverflow
                                .ellipsis,
                            style:
                            TextStyle(
                              color:
                              textColor,
                              fontSize:
                              (availableWidth *
                                  0.034)
                                  .clamp(
                                19.0,
                                32.0,
                              )
                                  .toDouble(),
                              fontWeight:
                              FontWeight
                                  .w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  height: height * 0.052,
                ),

                Text(
                  'destination_platform_hint'
                      .tr(),
                  style: TextStyle(
                    color: textColor,
                    fontSize:
                    footerSize,
                    fontWeight:
                    FontWeight.w400,
                    height: 1.25,
                  ),
                ),

                SizedBox(
                  height: height * 0.02,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // DESTINATION ICON
  // ============================================================

  Widget _destinationIcon({
    required IconData icon,
    required double size,
    required VoidCallback onTap,
    Color backgroundColor =
        Colors.black,
    Color iconColor =
        Colors.white,
    Gradient? gradient,
    bool isLoading = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap:
        _isStartingFacebook
            ? null
            : onTap,
        customBorder:
        const CircleBorder(),
        child: Container(
          width: size,
          height: size,
          alignment:
          Alignment.center,
          decoration:
          BoxDecoration(
            shape: BoxShape.circle,
            color:
            gradient == null
                ? backgroundColor
                : null,
            gradient: gradient,
          ),
          child:
          isLoading
              ? SizedBox(
            width:
            size * 0.30,
            height:
            size * 0.30,
            child:
            const CircularProgressIndicator(
              strokeWidth: 3,
              color: Colors.white,
            ),
          )
              : FaIcon(
            icon,
            color: iconColor,
            size: size * 0.50,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // RADIO OPTION
  // ============================================================

  Widget _radioOption({
    required String value,
    required String label,
    required Color textColor,
    required double width,
  }) {
    final bool isSelected =
        selectedSource == value;

    return GestureDetector(
      onTap:
      _isStartingFacebook
          ? null
          : () {
        setState(() {
          selectedSource =
              value;
        });
      },
      child: Row(
        mainAxisSize:
        MainAxisSize.min,
        children: [
          Container(
            width: width * 0.045,
            height:
            width * 0.045,
            decoration:
            BoxDecoration(
              shape:
              BoxShape.circle,
              border: Border.all(
                color:
                const Color(
                  0xFF1D6EFF,
                ),
              ),
            ),
            child:
            isSelected
                ? Center(
              child:
              Container(
                width:
                width *
                    0.022,
                height:
                width *
                    0.022,
                decoration:
                const BoxDecoration(
                  shape:
                  BoxShape
                      .circle,
                  color:
                  Color(
                    0xFF1D6EFF,
                  ),
                ),
              ),
            )
                : null,
          ),
          SizedBox(
            width: width * 0.02,
          ),
          Text(
            label,
            style: TextStyle(
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}