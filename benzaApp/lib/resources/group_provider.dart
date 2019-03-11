import 'dart:async';
import 'dart:convert';

import 'package:benza/models/Group.dart';
import 'package:benza/models/Offer.dart';
import 'package:http/http.dart' show Client, Response;

// IP for the emulator to access your machine's localhost (+port for group service)
const BASE_BENZA_URL = "http://10.0.2.2:4100";

/// Group namespace:
///- `getAllGroups()` -> returns a list of json-encoded maps, with each map representing a group.
///- `postGroup()`-> takes a json-encoded Group object. Creates an entry in the db.
///
class GroupDataProvider {
  Client client = Client();

  Future<List<Group>> getAllGroups() async {
    final response = await client.get("$BASE_BENZA_URL/group/", headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      print("\n------------ getAllGroups() response.body ------------\n${response.body}\n");
      return groupFromJson(response.body);
    } else {
      throw Exception('Failed to load list of all groups :(');
    }
  }

  Future<Response> postGroup(group) async {
    print("encoded group is: ${json.encode(group)}");
    final response = await client.post("$BASE_BENZA_URL/group/", headers: {"Content-Type": "application/json"}, body: json.encode(group));
    if (response.statusCode == 200) {
      print("\n------------ postGroup() response.body ------------\n${response.body}\n");}
    return response;
  }


  Future<Group> getGroup(int groupId) async {
    final response = await client.get("$BASE_BENZA_URL/group/$groupId");
    if (response.statusCode == 200) {
      print(response.body);
      return Group.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load the group :(');
    }
  }

  Future<Response> deleteGroup(Group groupId) async {
    final response = await client.delete("$BASE_BENZA_URL/group/$groupId");
    return response;
  }

  Future<Response> addOffer(String groupId, Offer offer) async {
    final response = await client
        .post("$BASE_BENZA_URL/offer/$groupId", body: offer);
    return response;
  }

  Future<Response> addToGroup(String groupId, String userId) async {
    return await client
        .post("$BASE_BENZA_URL/group/$groupId/$userId", headers: {"Content-Type": "application/json"});
  }

//  Future<Response> deleteFromGroup(String user_id, String group_id) async {
//    return await client
//        .delete("$BASE_BENZA_URL/user_group/$user_id/$group_id");
//  }

  Future<List<Offer>> getGroupOffers(String groupId) async {
    final response = await client.get("$BASE_BENZA_URL/group_offer/$groupId");

    if (response.statusCode == 200) {
      var j = json.decode(response.body);
      var offerList = (json.decode(j) as List)
          .map((data) => new Offer.fromJson(data))
          .toList();

      return offerList;
    } else
      throw Exception('Failed to load post');
  }

  Future<Response> deleteOffer(String offerId) async {
    return await client.delete("$BASE_BENZA_URL/group_offer/$offerId");
  }
}
