import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../models/diamond_model.dart';
 
abstract class CartEvent extends Equatable {
  const CartEvent();
 
  @override
  List<Object> get props => [];
}
 
class AddToCart extends CartEvent {
  final Diamond diamond;
  final BuildContext context;
 
  const AddToCart(this.diamond, {required this.context});
 
  @override
  List<Object> get props => [diamond];
}
 
class RemoveFromCart extends CartEvent {
  final Diamond diamond;
 
  const RemoveFromCart(this.diamond);
 
  @override
  List<Object> get props => [diamond];
}
 
class ClearCart extends CartEvent {}