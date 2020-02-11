import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
class EthWrapper {
  static const rpcUrl = "https://rinkeby.infura.io/v3/0e4ce57afbd04131b6842f08265b4d4b";
  static const token = "0x07685afc0c088f4b2236bf228c39c0336ed89e67";
  static const registry = "0x92ae8d38990aaA0E5180f7161A68dF54395952a1";
  static const voting = "0xe7a3fc437f8c0b4658ca8add30d87b7141f6e628";
  Future<List> regAllowance() async {
    final client = Web3Client(rpcUrl, http.Client());
    var abi = await rootBundle.loadString("assets/token.json");
    final contract  =  DeployedContract(ContractAbi.fromJson(abi, "StandardTOken"),EthereumAddress.fromHex(token));
    var allowance  = contract.function('allowance');
    var response = await client.call(
      contract: contract,
      function: allowance ,
      params: [EthereumAddress.fromHex("0x2Ee331840018465bD7Fe74aA4E442b9EA407fBBE"), EthereumAddress.fromHex(registry)],
    );
    var response2 = await client.call(
      contract: contract,
      function: allowance ,
      params: [EthereumAddress.fromHex("0x2Ee331840018465bD7Fe74aA4E442b9EA407fBBE"), EthereumAddress.fromHex(voting)],
    );
    var balance   = contract.function('balanceOf');
    var response3 = await client.call(
      contract: contract,
      function: balance ,
      params: [EthereumAddress.fromHex("0x2Ee331840018465bD7Fe74aA4E442b9EA407fBBE")],
    );
    print(response.toString());
    print(response3.toString());
    BigInt vr = BigInt.from(BigInt.parse(response.toString().substring(1,response.toString().length-1))/BigInt.from(1000000000000000));
    BigInt vr2 = BigInt.from(BigInt.parse(response2.toString().substring(1,response.toString().length-1))/BigInt.from(1000000000000000));
    BigInt vr3 = BigInt.from(BigInt.parse(response3.toString().substring(1,response.toString().length-1))/BigInt.from(100000000000000));
    double bal = vr.toDouble()/1000.0;
    double bal2 = vr2.toDouble()/1000.0;
    double bal3 = vr3.toDouble()/1000.0;
    await client.dispose();
    return [bal,bal2,bal3];
  }
  Future<String> approveReg (double amount)async {
    var pvt = "6843DC59D41289CC20E905180F6702621DCB9798B4413C031F8CB6EF0D9FC3E0";
    Credentials credentials = EthPrivateKey.fromHex(pvt);
    final client = Web3Client(rpcUrl, http.Client());
    var abi = await rootBundle.loadString("assets/token.json");
    final contract  =  DeployedContract(ContractAbi.fromJson(abi, "StandardTOken"),EthereumAddress.fromHex(token));
    var approve  = contract.function('approve');
    var response = await client.sendTransaction(
      credentials,
      Transaction.callContract(
          contract: contract,
          function: approve,
          gasPrice: EtherAmount.inWei(BigInt.from(10000000000)),
          maxGas: 4000000,
          parameters: [EthereumAddress.fromHex(registry),BigInt.from(amount*1000)*BigInt.from(1000000000000000)]
      ),
      chainId: 4,
    );
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("hash", response);
    prefs.setBool("transacting", true);
    await client.dispose();
    return response;
  }
  Future<String> approveVote (double amount)async {
    var pvt = "6843DC59D41289CC20E905180F6702621DCB9798B4413C031F8CB6EF0D9FC3E0";
    Credentials credentials = EthPrivateKey.fromHex(pvt);
    final client = Web3Client(rpcUrl, http.Client());
    var abi = await rootBundle.loadString("assets/token.json");
    final contract  =  DeployedContract(ContractAbi.fromJson(abi, "StandardTOken"),EthereumAddress.fromHex(token));
    var approve  = contract.function('approve');
    var response = await client.sendTransaction(
      credentials,
      Transaction.callContract(
          contract: contract,
          function: approve,
          gasPrice: EtherAmount.inWei(BigInt.from(10000000000)),
          maxGas: 4000000,
          parameters: [EthereumAddress.fromHex(voting),BigInt.from(amount*1000)*BigInt.from(1000000000000000)]
      ),
      chainId: 4,
    );
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("hash", response);
    prefs.setBool("transacting", true);
    await client.dispose();
    return response;
  }

  Future<dynamic> newChallenge(String hash, double stake, String data) async {
    var pvt = "6843DC59D41289CC20E905180F6702621DCB9798B4413C031F8CB6EF0D9FC3E0";
    Credentials credentials = EthPrivateKey.fromHex(pvt);
    final client = Web3Client(rpcUrl, http.Client());
    var abi = await rootBundle.loadString("assets/registry.json");
    print(hash.length);
    var ls= hexToBytes(hash);
    //var uint8list= Uint8List.fromList(hash.codeUnits);
    print(ls);
    final contract  =  DeployedContract(ContractAbi.fromJson(abi, "registry"),EthereumAddress.fromHex(registry));
    var challenge  = contract.function('challenge');
    var response = await client.sendTransaction(
      credentials,
      Transaction.callContract(
          contract: contract,
          function: challenge,
          gasPrice: EtherAmount.inWei(BigInt.from(10000000000)),
          maxGas: 4000000,
          parameters: [ls,BigInt.from(stake*1000)*BigInt.from(1000000000000000),data]
      ),
      chainId: 4,
    );
    print(response);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("hash", response);
    prefs.setBool("transacting", true);
    await client.dispose();
    return response;
  }

}