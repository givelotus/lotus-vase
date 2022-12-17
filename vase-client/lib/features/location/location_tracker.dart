import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:location/location.dart';

AsyncSnapshot<T> useMemoizedFuture<T>(Future<T>? Function() fn) {
  final future = useMemoized(fn, const []);
  return useFuture(future);
}

class LocationSolicitor extends HookWidget {
  const LocationSolicitor({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final locationFuture = useMemoizedFuture(getLoc);
    print(locationFuture.data);
    return child;
  }
}

Future<LocationData?> getLoc() async {
  Location location = Location();

  bool serviceEnabled;
  PermissionStatus permissionGranted;

  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return null;
    }
  }

  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return null;
    }
  }

  return await location.getLocation();
}
