import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';
import "package:hex/hex.dart";

class KeyInterface{
  static Future<List<String>> generateKey()async {
    var rng = Random.secure();
    Credentials creds = EthPrivateKey.createRandom(rng);
    Wallet wallet = Wallet.createNew(creds, "qwerty", rng);
    var address = await creds.extractAddress();
    print("address:"+address.toString());
    var add = EthereumAddress.fromHex(address.toString());
    print(add);
    String ppk = HEX.encode(wallet.privateKey.privateKey);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var arr = [ppk, address.hex];
    return arr;
  }
}