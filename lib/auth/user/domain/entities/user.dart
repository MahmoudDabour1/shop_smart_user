import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class User extends Equatable {
  final String userId, userName, userImage, userEmail;
  final Timestamp createdAt;
  final List userCart, userWish;

  const User({
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.userEmail,
    required this.createdAt,
    required this.userCart,
    required this.userWish,
  });

  @override
  List<Object> get props => [
        userId,
        createdAt,
        userCart,
        userName,
        userImage,
        userEmail,
        userWish,
      ];
}
