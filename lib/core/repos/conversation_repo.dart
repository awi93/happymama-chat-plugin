import 'dart:convert';

import 'package:chat_service/core/errors/server_response_error_exception.dart';
import 'package:chat_service/core/models/bases/cud_response.dart';
import 'package:chat_service/core/models/bases/paging.dart';
import 'package:chat_service/core/models/tables/member_exchange_route.dart';
import 'package:chat_service/core/models/tables/member_online_status.dart';
import 'package:chat_service/core/models/views/vw_conversation_message.dart';
import 'package:chat_service/core/models/views/vw_member_online_status.dart';
import 'package:chat_service/core/models/views/vw_user_active_conversation.dart';
import 'package:chat_service/core/repos/base_repo.dart';
import 'package:chat_service/core/utils/util.dart';
import 'package:dart_amqp/dart_amqp.dart';

class ConversationRepo extends BaseRepo {

  static ConversationRepo _instance;

  static ConversationRepo instance() {
    if(_instance == null)
      _instance = new ConversationRepo();

    return _instance;
  }

  Future<CUDResponse<MemberOnlineStatus>> saveMemberOnlineStatus (String memberId) async {
    String _tokenString = await Util.secureStorage.read(key: "access_token");

    String url = Util.remoteConfig.getString("api_url") + "/members/" + memberId + "/online-statuses";

    final response = await Util.httpClient.post(url, headers: {
      "authorization" : "Bearer " + _tokenString
    }, body: {}).timeout(Duration(seconds: 10));

    if (response.statusCode == 201) {
      final Map<String, dynamic> json = jsonDecode(response.body);

      MemberOnlineStatus data = MemberOnlineStatus.fromJson(json["data"]);

      final CUDResponse<MemberOnlineStatus> create = new CUDResponse<MemberOnlineStatus>(json["id"].toString(), data);

      return create;
    }
    else {
      final Map<String, dynamic> error = jsonDecode(response.body);
      throw ServerResponseErrorException(response.statusCode, error["error"], (error.containsKey("errors"))?error["errors"]:null);
    }

  }

  Future<VwMemberOnlineStatus> fetchMemberOnlineStatus (String memberId) async {
    String _tokenString = await Util.secureStorage.read(key: "access_token");

    String url = Util.remoteConfig.getString("api_url") + "/members/" + memberId + "/online-statuses";

    final response = await Util.httpClient.get(url, headers: {
      "authorization" : "Bearer " + _tokenString
    }).timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);

      VwMemberOnlineStatus data = VwMemberOnlineStatus.fromJson(json);

      return data;
    }
    else {
      final Map<String, dynamic> error = jsonDecode(response.body);
      throw ServerResponseErrorException(response.statusCode, error["error"], (error.containsKey("errors"))?error["errors"]:null);
    }

  }

  Future<Paging<VwUserActiveConversation>> fetchActiveConversations (String memberId, {Map<String, String> query}) async {
    String _tokenString = await Util.secureStorage.read(key: "access_token");

    String url = Util.remoteConfig.getString("api_url") + "/members/" + memberId + "/active-conversations";

    url = processUrl(url, query);

    final response = await Util.httpClient.get(url, headers: {
      "authorization": "Bearer " + _tokenString
    }).timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);

      List<VwUserActiveConversation> datas = new List();
      for (Map<String, dynamic> data in json["data"]) {
        datas.add(VwUserActiveConversation.fromJson(data));
      }

      Paging<VwUserActiveConversation> paging = new Paging(
          json["current_page"],
          (json["from"] == null) ? 0 : json["from"],
          (json["to"] == null) ? 0 : json["to"],
          (json["per_page"] == null) ? 0 : int.parse(json["per_page"]),
          (json["total"] == null) ? 0 : json["total"],
          (json["last_page"] == null) ? 0 : json["last_page"],
          (json["first_page_url"] == null) ? null : json["first_page_url"],
          (json["last_page_url"] == null) ? null : json["last_page_url"],
          (json["next_page_url"] == null) ? null : json["next_page_url"],
          (json["last_page_url"] == null) ? null : json["last_page_url"],
          (json["path"] == null) ? null : json["path"],
          datas);

      return paging;
    }
    else {
      final Map<String, dynamic> error = jsonDecode(response.body);
      throw ServerResponseErrorException(response. statusCode, error["error"],
          (error.containsKey("errors")) ? error["errors"] : null);
    }

  }

  Future<CUDResponse<VwUserActiveConversation>> deleteActiveConversation (String memberId, String id) async {
    String _tokenString = await Util.secureStorage.read(key: "access_token");

    String url = Util.remoteConfig.getString("api_url") + "/members/" + memberId + "/active-conversations/" + id;

    final response = await Util.httpClient.delete(url, headers: {
      "authorization" : "Bearer " + _tokenString
    }).timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);

      VwUserActiveConversation data = VwUserActiveConversation.fromJson(json["data"]);

      final CUDResponse<VwUserActiveConversation> create = new CUDResponse<
          VwUserActiveConversation>(json["id"].toString(), data);

      return create;
    }
    else {
      final Map<String, dynamic> error = jsonDecode(response.body);
      throw ServerResponseErrorException(response.statusCode, error["error"], (error.containsKey("errors"))?error["errors"]:null);
    }
  }

  Future<Paging<VwConversationMessage>> fetchConversationMessages (String memberId, String conversationId, {Map<String, String> query}) async {
    String _tokenString = await Util.secureStorage.read(key: "access_token");

    String url = Util.remoteConfig.getString("api_url") + "/members/" +
        memberId + "/active-conversations/" + conversationId + "/messages";

    url = processUrl(url, query);

    final response = await Util.httpClient.get(url, headers: {
      "authorization": "Bearer " + _tokenString
    }).timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);

      List<VwConversationMessage> datas = new List();
      for (Map<String, dynamic> data in json["data"]) {
        datas.add(VwConversationMessage.fromJson(data));
      }

      Paging<VwConversationMessage> paging = new Paging(
          json["current_page"],
          (json["from"] == null) ? 0 : json["from"],
          (json["to"] == null) ? 0 : json["to"],
          (json["per_page"] == null) ? 0 : int.parse(json["per_page"]),
          (json["total"] == null) ? 0 : json["total"],
          (json["last_page"] == null) ? 0 : json["last_page"],
          (json["first_page_url"] == null) ? null : json["first_page_url"],
          (json["last_page_url"] == null) ? null : json["last_page_url"],
          (json["next_page_url"] == null) ? null : json["next_page_url"],
          (json["last_page_url"] == null) ? null : json["last_page_url"],
          (json["path"] == null) ? null : json["path"],
          datas);

      return paging;
    }
  }

  Future<MemberExchangeRoute> fetchMemberExchangeRoute(String memberId) async {
    String _tokenString = await Util.secureStorage.read(key: "access_token");

    String url = Util.remoteConfig.getString("api_url") + "/members/" + memberId + "/exchange-routes";

    final response = await Util.httpClient.get(url, headers: {
      "authorization" : "Bearer " + _tokenString
    }).timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);

      MemberExchangeRoute data = MemberExchangeRoute.fromJson(json);

      return data;
    }
    else {
      final Map<String, dynamic> error = jsonDecode(response.body);
      throw ServerResponseErrorException(response.statusCode, error["error"], (error.containsKey("errors"))?error["errors"]:null);
    }
  }

  Future<void> pushMessageStatus (VwConversationMessage data, String memberId, String status) async {
    String host = Util.remoteConfig.getString("amqp_url");
    Client client = new Client(settings: ConnectionSettings(
        host: host,
        port: 5672,
        authProvider: AmqPlainAuthenticator(Util.RABBIT_USERNAME, Util.RABBIT_PASSWORD)
    ));

    Channel channel = await client.channel();
    Exchange exchange = await channel.exchange("conversation.outgoing", ExchangeType.FANOUT);

    Map<String, dynamic> message = {
      "type" : "STATUS",
      "data" : {
        "id" : data.id,
        "conversation_id" : data.conversationId,
        "sender_id" : memberId,
        "message" : status
      }
    };

    exchange.publish(jsonEncode(message), null);

    channel.close();
    client.close();
  }

  Future<void> pushMessage (VwConversationMessage data) async {
    String host = Util.remoteConfig.getString("amqp_url");
    Client client = new Client(settings: ConnectionSettings(
        host: host,
        port: 5672,
        authProvider: AmqPlainAuthenticator(Util.RABBIT_USERNAME, Util.RABBIT_PASSWORD)
    ));

    Channel channel = await client.channel();
    Exchange exchange = await channel.exchange("conversation.outgoing", ExchangeType.FANOUT);

    Map<String, dynamic> message = {
      "type" : "MESSAGE",
      "data" : {
        "id" : data.id,
        "conversation_id" : data.conversationId,
        "sender_id" : data.senderId,
        "message" : data.message
      }
    };

    exchange.publish(jsonEncode(message), null);

    channel.close();
    client.close();
  }

}