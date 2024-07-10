// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:local_session_timeout/local_session_timeout.dart';

class SessionTimeoutManager extends StatefulWidget {
  final MySessionConfig _sessionConfig;
  final Stream<SessionState> _sessionStateStream;
  final Widget child;
  final Duration userActivityDebounceDuration;

  const SessionTimeoutManager(
      {Key? key,
      required sessionConfig,
      required this.child,
      sessionStateStream,
      this.userActivityDebounceDuration = const Duration(seconds: 10)})
      : _sessionConfig = sessionConfig,
        _sessionStateStream = sessionStateStream,
        super(key: key);

  @override
  _SessionTimeoutManagerState createState() => _SessionTimeoutManagerState();
}

class _SessionTimeoutManagerState extends State<SessionTimeoutManager>
    with WidgetsBindingObserver {
  Timer? _appLostFocusTimer;
  Timer? _userInactivityTimer;
  bool _isListening = false;
  bool _userTapActivityRecordEnabled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    widget._sessionStateStream.listen((SessionState sessionState) {
      if (sessionState == SessionState.startListening) {
        if (mounted) {
          setState(() {
            _isListening = true;
            _userTapActivityRecordEnabled = true;
          });
        }

        recordPointerEvent();
      } else if (sessionState == SessionState.stopListening) {
        _closeAllTimers();
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      if (widget._sessionConfig.invalidateSessionForAppLostFocus != null) {
        _appLostFocusTimer ??= _setTimeout(
          () => widget._sessionConfig.pushAppFocusTimeout(),
          duration: widget._sessionConfig.invalidateSessionForAppLostFocus!,
        );
      }
    } else if (state == AppLifecycleState.resumed) {
      if (_appLostFocusTimer != null) {
        _clearTimeout(_appLostFocusTimer!);
        _appLostFocusTimer = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Attach Listener only if user wants to invalidate session on user inactivity
    return widget._sessionConfig.invalidateSessionForUserInactiviity != null
        ? Listener(
            onPointerDown: (_) {
              recordPointerEvent();
            },
            child: widget.child,
          )
        : const SizedBox();
  }

  void recordPointerEvent() {
    if (_userTapActivityRecordEnabled) {
      _userInactivityTimer?.cancel();
      _userInactivityTimer = _setTimeout(
        () => widget._sessionConfig.pushUserInactivityTimeout(),
        duration: widget._sessionConfig.invalidateSessionForUserInactiviity!,
      );

      if (mounted) {
        setState(() {
          _userTapActivityRecordEnabled = false;
        });
      }

      Timer(
        widget.userActivityDebounceDuration,
        () {
          if (mounted) {
            setState(() => _userTapActivityRecordEnabled = true);
          }
        },
      );
    }
  }

  void _closeAllTimers() {
    if (_isListening == false) {
      return;
    }

    if (_appLostFocusTimer != null) {
      _clearTimeout(_appLostFocusTimer!);
    }

    if (_userInactivityTimer != null) {
      _clearTimeout(_userInactivityTimer!);
    }

    setState(() {
      _isListening = false;
      _userTapActivityRecordEnabled = false;
    });
  }

  Timer _setTimeout(callback, {required Duration duration}) {
    return Timer(duration, callback);
  }

  void _clearTimeout(Timer t) {
    t.cancel();
  }
}

enum SessionTimeoutState { appFocusTimeout, userInactivityTimeout }

class MySessionConfig {
  /// Immediately invalidates the sesion after [invalidateSessionForUserInactiviity] duration of user inactivity
  ///
  /// If null, never invalidates the session for user inactivity
  final Duration? invalidateSessionForUserInactiviity;

  ///  mmediately invalidates the sesion after [invalidateSessionForAppLostFocus] duration of app losing focus
  ///
  /// If null, never invalidates the session for app losing focus
  final Duration? invalidateSessionForAppLostFocus;

  MySessionConfig({
    this.invalidateSessionForUserInactiviity,
    this.invalidateSessionForAppLostFocus,
  });

  final _controller = StreamController<SessionTimeoutState>();

  /// Stream yields Map if session is valid, else null
  Stream<SessionTimeoutState> get stream => _controller.stream;

  /// invalidate session and pass [SessionTimeoutState.appFocusTimeout] through stream
  void pushAppFocusTimeout() {
    _controller.sink.add(SessionTimeoutState.appFocusTimeout);
  }

  /// invalidate session and pass [SessionTimeoutState.userInactivityTimeout] through stream
  void pushUserInactivityTimeout() {
    _controller.sink.add(SessionTimeoutState.userInactivityTimeout);
  }
}
