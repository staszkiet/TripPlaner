import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripplaner/trip.dart';

class GlobalProviders extends StatelessWidget {
  const GlobalProviders({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TripProvider()),
      ],
      child: child,
    );
  }
}
