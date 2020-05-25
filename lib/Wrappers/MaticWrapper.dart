import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MaticWrapper {
  static const rpcUrl = "https://testnetv3.matic.network";
  static const contractAddress = "0x394eFa37FD3dFEc83c1126F143Ac861A5204626A";
  static Future<bool> addTime(int openingh, int openingm, int closingh, int closingm, String hash )async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var pvt = prefs.getString("privateKey");
    Credentials credentials = EthPrivateKey.fromHex(pvt);
    var address = await credentials.extractAddress();
    print(address);
    final client = Web3Client(rpcUrl, http.Client());
    var abi = await rootBundle.loadString("assets/matic.json");
    final contract  =  DeployedContract(ContractAbi.fromJson(abi, "Matic"),EthereumAddress.fromHex(contractAddress));
    var addDetail  = contract.function('addDetails');
    var response = await client.sendTransaction(
      credentials,
      Transaction.callContract(
          contract: contract,
          function: addDetail,
          gasPrice: EtherAmount.zero(),
          maxGas: 222000,
          parameters: [BigInt.from(openingh), BigInt.from(openingm),BigInt.from(closingh),BigInt.from(closingm) , hash]
      ),
      chainId: 15001,
    );
    print(response);
    await client.dispose();
    return true;
  }
  static Future<List> fetchList(String hash)async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var pvt = prefs.getString("privateKey");
    Credentials credentials = EthPrivateKey.fromHex(pvt);
    var address = await credentials.extractAddress();
    print(address);
    final client = Web3Client(rpcUrl, http.Client());
    var abi = await rootBundle.loadString("assets/matic.json");
    final contract  =  DeployedContract(ContractAbi.fromJson(abi, "Matic"),EthereumAddress.fromHex(contractAddress));
    var arr  = contract.function('getDetaild');
    var response = await client.call(contract: contract, function: arr, params: [hash,]);
    print(response);
    await client.dispose();
    return response;
  }
  static Future<List> getAddress(String hash)async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var pvt = prefs.getString("privateKey");
    Credentials credentials = EthPrivateKey.fromHex(pvt);
    var address = await credentials.extractAddress();
    print(address);
    final client = Web3Client(rpcUrl, http.Client());
    var abi = await rootBundle.loadString("assets/matic.json");
    final contract  =  DeployedContract(ContractAbi.fromJson(abi, "Matic"),EthereumAddress.fromHex(contractAddress));
    var arr  = contract.function('getAddr');
    var response = await client.call(contract: contract, function: arr, params: [hash,]);
    print(response);
    await client.dispose();
    return response;
  }
  static Future<bool> upvote(String address, String hash )async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var pvt = prefs.getString("privateKey");
    Credentials credentials = EthPrivateKey.fromHex(pvt);
    var address = await credentials.extractAddress();
    print(address);
    final client = Web3Client(rpcUrl, http.Client());
    var abi = await rootBundle.loadString("assets/matic.json");
    final contract  =  DeployedContract(ContractAbi.fromJson(abi, "Matic"),EthereumAddress.fromHex(contractAddress));
    var addDetail  = contract.function('upvoteDetail');
    var response = await client.sendTransaction(
      credentials,
      Transaction.callContract(
          contract: contract,
          function: addDetail,
          gasPrice: EtherAmount.zero(),
          maxGas: 222000,
          parameters: [hash, address]
      ),
      chainId: 15001,
    );
    print(response);
    await client.dispose();
    return true;
  }
  static Future<bool> downvote(String address, String hash )async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var pvt = prefs.getString("privateKey");
    Credentials credentials = EthPrivateKey.fromHex(pvt);
    var address = await credentials.extractAddress();
    print(address);
    final client = Web3Client(rpcUrl, http.Client());
    var abi = await rootBundle.loadString("assets/matic.json");
    final contract  =  DeployedContract(ContractAbi.fromJson(abi, "Matic"),EthereumAddress.fromHex(contractAddress));
    var addDetail  = contract.function('downvoteDetail');
    var response = await client.sendTransaction(
      credentials,
      Transaction.callContract(
          contract: contract,
          function: addDetail,
          gasPrice: EtherAmount.zero(),
          maxGas: 222000,
          parameters: [hash, address]
      ),
      chainId: 15001,
    );
    print(response);
    await client.dispose();
    return true;
  }

}
//0x221855917ec26c5f9f11107b62c3086333bd12b63e7ec8f24a446a73389d65fb