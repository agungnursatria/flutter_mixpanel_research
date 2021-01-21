import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutuate_mixpanel/flutuate_mixpanel.dart';

const String MIXPANEL_TOKEN = "417b6c02d4979f59023cafc395b35850";

void main() {
  String mixpanelToken = MIXPANEL_TOKEN;

  print(mixpanelToken);
  runApp(MyApp(mixpanelToken));
}

class MyApp extends StatefulWidget {
  final String _mixpanelToken;

  MyApp(this._mixpanelToken);

  @override
  _MyAppState createState() => _MyAppState(_mixpanelToken);
}

class _MyAppState extends State<MyApp> {
  MixpanelAPI _mixpanel;
  String _mixpanelToken;
  String _resultMessage = '';

  _MyAppState(this._mixpanelToken);

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> content;
    if (_mixpanelToken == null || _mixpanelToken.trim().length == 0) {
      content = [Text('Your Mixpanel Token was not informed')];
    } else {
      content = createButtons(context);
    }
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutuate.io Mixpanel Plugin Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                _resultMessage,
                key: Key('resultMessage'),
              ),
              Column(
                children: content,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> createButtons(BuildContext context) {
    return [
      buttonGetInstance(context),
      buttonTrackEvent(context),
      buttonTrackEvent2(context),
      buttonRegisterSuperProperties(context),
      buttonGetDeviceInfo(context),
      buttonGetDistinctId(context),
      buttonReset(context),
      buttonFlush(context),
    ];
  }

  Widget buttonGetInstance(BuildContext context) => ElevatedButton(
      key: Key('getInstance'),
      child: Text('Get an instance of Mixpanel plugin'),
      onPressed: () => getInstance());

  Widget buttonTrackEvent(BuildContext context) => ElevatedButton(
      key: Key('trackEvent'),
      child: Text('Track an event'),
      onPressed: () => trackEvent());

  Widget buttonTrackEvent2(BuildContext context) => ElevatedButton(
      key: Key('trackEvent2'),
      child: Text('Track an event 2'),
      onPressed: () => trackEvent2());

  Widget buttonRegisterSuperProperties(BuildContext context) => ElevatedButton(
      key: Key('registerSuperProperties'),
      child: Text('Register Super Properties'),
      onPressed: () => registerSuperProperties());

  Widget buttonReset(BuildContext context) => ElevatedButton(
      key: Key('reset'), child: Text('Reset'), onPressed: () => reset());

  Widget buttonGetDeviceInfo(BuildContext context) => ElevatedButton(
      key: Key('getDeviceInfo'),
      child: Text('Get device info'),
      onPressed: () => getDeviceInfo());

  Widget buttonGetDistinctId(BuildContext context) => ElevatedButton(
      key: Key('getDistinctId'),
      child: Text('Get distinct id'),
      onPressed: () => getDistinctId());

  Widget buttonFlush(BuildContext context) => ElevatedButton(
      key: Key('flush'), child: Text('Flush'), onPressed: () => flush());

  void getInstance() {
    MixpanelAPI.getInstance(_mixpanelToken).then((mixpanel) {
      _mixpanel = mixpanel;
      _mixpanel.identify('0822123123123');
      _mixpanel.people.setProperty('userId', '1');
      setState(() {
        _resultMessage = 'Instance created with success!';
      });
    });
  }

  void trackEvent() {
    Map<String, String> properties = {"Button Pressed": "A button was pressed"};
    _mixpanel.track('Flutuate.io Mixpanel Plugin Event', properties);
    setState(() {
      _resultMessage = 'Event sent with success!';
    });
  }

  void trackEvent2() {
    Map<String, String> properties = {"Button Pressed": "B button was pressed"};
    _mixpanel.track('Flutuate.io Mixpanel Plugin Event 2', properties);
    setState(() {
      _resultMessage = 'Event sent with success!';
    });
  }

  void registerSuperProperties() {
    Map<String, String> properties = {
      "Plugin": "flutuate_mixpanel",
    };
    _mixpanel.registerSuperProperties(properties);
    setState(() {
      _resultMessage = 'Register Super Properties with success!';
    });
  }

  void reset() {
    _mixpanel.reset();
  }

  void getDeviceInfo() async {
    Map<String, String> devInfo = await _mixpanel.getDeviceInfo();
    print(devInfo);
    setState(() {
      _resultMessage = devInfo.toString();
    });
  }

  void getDistinctId() async {
    String distinctId = await _mixpanel.getDistinctId();
    print(distinctId);
    setState(() {
      _resultMessage = distinctId;
    });
  }

  void flush() {
    _mixpanel.flush();
    setState(() {
      _resultMessage = 'Flushed with success!';
    });
  }
}
