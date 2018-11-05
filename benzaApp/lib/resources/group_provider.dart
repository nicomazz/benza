import 'dart:async';
import 'dart:convert';

import 'package:benza/models/Group.dart';
import 'package:benza/models/Offer.dart';
import 'package:benza/resources/mock/group_mock_provider.dart';
import 'package:http/http.dart' show Client, Response;

const BASE_BENZA_URL = "http://localhost";

class GroupDataProvider {
  //Client client = Client();
  Client client = getMockGroupProvider();

  Future<Group> fetchGroup(int groupId) async {
    final response = await client.get("$BASE_BENZA_URL/group/$groupId");
    if (response.statusCode == 200)
      return Group.fromJson(json.decode(response.body));
    else
      throw Exception('Failed to load post');
  }

  Future<Response> postGroup(Group group) async {
    final response =
        await client.post("$BASE_BENZA_URL/group/${group.id}", body: group);
    return response;
  }

  Future<Response> deleteGroup(Group group) async {
    final response = await client.delete("$BASE_BENZA_URL/group/${group.id}");
    return response;
  }

  Future<Response> addToGroup(String user_id, String group_id) async {
    return await client
        .post("$BASE_BENZA_URL/user_group/${user_id}/${group_id}");
  }

  Future<Response> deleteFromGroup(String user_id, String group_id) async {
    return await client
        .delete("$BASE_BENZA_URL/user_group/${user_id}/${group_id}");
  }

  Future<Response> addGroupOffer(Offer offer, String group_id) async {
    final response = await client
        .post("$BASE_BENZA_URL/group_offer/${group_id}",body:offer);
    return response;
  }

  Future<List<Offer>> getGroupOffers(String group_id) async {
    final response = await client
        .get("$BASE_BENZA_URL/group_offer/$group_id");

    if (response.statusCode == 200) {
      var j = json.decode(response.body);
      var offerList = (json.decode(j) as List)
          .map((data) => new Offer.fromJson(data))
          .toList();

      return offerList;
    }
    else
      throw Exception('Failed to load post');
  }

  Future<Response> deleteOffer(String offer_id) async {
    return await client
        .delete("$BASE_BENZA_URL/group_offer/$offer_id");
  }
}
