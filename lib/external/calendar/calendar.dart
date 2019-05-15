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

class Calendar {
  static Calendar _single;

  static Calendar _singleton(GoogleSignInAccount _acc) {
    if (_single == null) _single = Calendar._internal(_acc);

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
    final String contacts_id = "socialite-contacts-calendar-id";

    print("Curr user ${_account.toString()}");

    final authHeaders = await _account.authHeaders;
    final httpClient = new GoogleHttpClient(authHeaders);

    CalendarApi calClient = CalendarApi(httpClient);

    final CalendarList data = await calClient.calendarList.list();

    CalendarListEntry contacts;

    for (CalendarListEntry cle in data.items) {
      Map<String, Object> cleJSON = cle.toJson();
      print(cleJSON);

      if (cleJSON['id'] == contacts_id) {
        contacts = cle;
      }
    }

    String cleJSON =
        r'''{"accessRole": "owner", "backgroundColor": "#9fe1e7", "colorId": "15", "conferenceProperties": {"allowedConferenceSolutionTypes": ["eventHangout"]}, "defaultReminders": [{"method": "popup", "minutes": 30}], "etag": "1536330683280000", "foregroundColor": "#000000", "id": "socialitecalendarx`", "kind": "calendar#calendarListEntry", "notificationSettings": {"notifications": [{"method": "email", "type": "eventCreation"}, {"method": "email", "type": "eventChange"}, {"method": "email", "type": "eventCancellation"}, {"method": "email", "type": "eventResponse"}]}, "primary": false, "selected": true, "summary": "spammail2k01@gmail.com", "timeZone": "America/Chicago"}''';

    CalendarListEntry calendarListEntry =
        CalendarListEntry.fromJson(jsonDecode(cleJSON));

    if (contacts == null) {
      final result =
          await calClient.calendarList.insert(calendarListEntry).then((value) {
        print("Value ${value.toJson()}");
      }).catchError((err) => print("Error $err"));
      print(result);
    } else {
      print("existed");
    }
  }

  void tryAddEvent() {
    Map<dynamic, dynamic> event = {};

    Event e = Event();
    e.id = "test event";
  }

  Calendar._internal(GoogleSignInAccount account) {
    this._account = account;
    useClientAcc();
  }

  factory Calendar(GoogleSignInAccount _acc) {
    return _singleton(_acc);
  }
}
