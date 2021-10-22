import 'package:flutter/widgets.dart';

abstract class MyfvPage {
  /// The full Myfile address, as used in the address bar of the browser and
  /// for lookup purposes.
  final String address;
  /// The address to use in lookups.
  /// Some checks will need to be done to this against the one in the address 
  /// bar (i.e. against the canonical/aliases used) before this variable gets
  /// used.
  /// This stores the direct URL or file path that will be used to, or has
  /// been used to, look up the Myfile.
  final String? lookupAddress;
  MyfvPage({required this.address, this.lookupAddress});
}
/// An [UnloadedPage] is an object representing a page, be it a Myfile or a Web
/// site, that has not been loaded yet. 
class UnloadedPage implements MyfvPage {
  /// The address to use in lookups.
  /// Some checks will need to be done to this against the one in the address 
  /// bar (i.e. against the canonical/aliases used) before this variable gets
  /// used.
  /// This stores the direct URL or file path that will be used to, or has
  /// been used to, look up the Myfile.
  final String? lookupAddress;

  UnloadedPage(this.address, {this.lookupAddress}) 
  : super();

  /// The full URL or Myfile address, as used in the address bar of the
  /// browser and for lookup purposes.
  final String address;
}
class LoadedWebPage implements MyfvPage {
  /// The web URL shown.
  final String address;
  final Key? tabKey;
  /// Whether the connection is being made over HTTPS or a similar secure protocol.
  final bool isHttps;

  LoadedWebPage(this.address, {this.lookupAddress, this.tabKey, this.isHttps = false}) 
  : assert(lookupAddress == null || lookupAddress == address), super();

  /// The address to use in lookups.
  /// For loaded webpages, this should be identical to the [address].
  final String? lookupAddress;
  
  /// TODO: use providers or something to preserve webview state
}
class LoadedMyfilePage implements MyfvPage {
  /// The full Myfile address, as used in the address bar of the browser and
  /// for lookup purposes.
  final String address;

  final Key? tabKey;
  
  /// The address to use in lookups.
  /// Some checks will need to be done to this against the one in the address 
  /// bar (i.e. against the canonical/aliases used) before this variable gets
  /// used.
  /// This stores the direct URL or file path that will be used to, or has
  /// been used to, look up the Myfile.
  final String? lookupAddress;

  /// The loaded-and-parsed Myfile.
  final dynamic parsedMyfile;

  LoadedMyfilePage(this.parsedMyfile, {
    required this.address,
    this.lookupAddress,
    this.tabKey
  }) : super(); 
}