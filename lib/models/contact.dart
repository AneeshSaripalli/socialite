import "package:flutter/material.dart";

class Contact {
  final String firstName;
  final String lastName;
  final String description;
  final String phoneNumber;
  final String id;

  Contact(
      {@required this.id,
      @required this.firstName,
      @required this.lastName,
      @required this.description,
      @required this.phoneNumber});

  Contact.fromMap(Map<String, dynamic> data)
      : this(
          id: data['id'],
          firstName: data['fname'],
          lastName: data['lname'],
          description: data['desc'],
          phoneNumber: data['number'],
        );

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "fname": firstName,
      "lname": lastName,
      "desc": description,
      "number": phoneNumber,
    };
  }
}
