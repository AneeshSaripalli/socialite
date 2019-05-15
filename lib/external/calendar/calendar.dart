import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:google_sign_in/google_sign_in.dart'
    show GoogleSignIn, GoogleSignInAccount;
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/auth_io.dart';

import './google_http_client.dart';

//...

Future<Map<String, dynamic>> parseJsonFromAssets(String assetsPath) async {
  print('--- Parse json from: $assetsPath');
  return rootBundle
      .loadString(assetsPath)
      .then((jsonStr) => jsonDecode(jsonStr));
}

const _SCOPES = const [CalendarApi.CalendarScope];

class CalendarWrapper {
  static CalendarWrapper _single;

  static CalendarWrapper _singleton(GoogleSignInAccount _acc) {
    if (_single == null) _single = CalendarWrapper._internal(_acc);

    return _single;
  }

  GoogleSignInAccount _account;

  CalendarApi _api;

  void init() async {
    final _credentials = ServiceAccountCredentials.fromJson(
        await rootBundle.loadString("assets/googleapi/credentials.json"));

    clientViaServiceAccount(_credentials, _SCOPES).then((client) {
      _api = new CalendarApi(client);
      _api.events.list("Classes").then((events) {
        print("Received ${events.items.length} bucket names:");
        print(events.toJson());
      });

      tryAddEvent();
    });
  }

  void useClientAcc() async {
    final String contacts_id = _account.email;
    final String summary = "Socialite";

    print("Curr user ${_account.toString()}");

    final authHeaders = await _account.authHeaders;
    final httpClient = new GoogleHttpClient(authHeaders);

    CalendarApi calClient = CalendarApi(httpClient);
    CalendarList list = await calClient.calendarList.list();

    String id;

    bool hasBdays = false;
    for (CalendarListEntry c in list.items) {
      print("ID is ${c.id}");
      id = c.id;
      hasBdays |= (c.summary == summary);
    }

    if (!hasBdays) {
      id = (await calClient.calendars
              .insert(Calendar.fromJson({"summary": summary})))
          .id;
    }

    await calClient.events.quickAdd(id, "some text ehre");
  }

  void tryAddEvent() {
    Map<dynamic, dynamic> event = {};

    Event e = Event();
    e.id = "test event";
  }

  CalendarWrapper._internal(GoogleSignInAccount account) {
    this._account = account;
    useClientAcc();
  }

  factory CalendarWrapper(GoogleSignInAccount _acc) {
    return _singleton(_acc);
  }
}
