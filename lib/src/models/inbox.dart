// Copyright (c) 2018, the Dart Reddit API Wrapper project authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a BSD-style license that
// can be found in the LICENSE file.

import 'dart:async';
import 'dart:math';

import 'package:draw/src/api_paths.dart';
import 'package:draw/src/base_impl.dart';
import 'package:draw/src/exceptions.dart';
import 'package:draw/src/reddit.dart';
import 'package:draw/src/util.dart';
import 'package:draw/src/listing/listing_generator.dart';
import 'package:draw/src/models/comment.dart';
import 'package:draw/src/models/message.dart';

import 'dart:convert';

class Inbox extends RedditBase {
  static final _messagesRegExp = new RegExp(r'{id}');

  Inbox(Reddit reddit) : super(reddit);

  Stream<Message> all() =>
      ListingGenerator.createBasicGenerator(reddit, apiPath['inbox']);

  Future collapse(List items) => _itemHelper('collapse', items);

  Stream<Comment> commentReplies() =>
      ListingGenerator.createBasicGenerator(reddit, apiPath['comment_replies']);

  Future markRead(List items) => _itemHelper(apiPath['read_message'], items);

  Future markUnread(List items) =>
      _itemHelper(apiPath['unread_message'], items);

  Future _itemHelper(String api, List items) async {
    var start = 0;
    var end = min(items.length, 25);
    while (true) {
      final sublist = items.sublist(start, end);
      final data = {
        'id': sublist.map((e) => e.fullname).join(','),
      };
      await reddit.post(api, data, discardResponse: true);
      start = end;
      end = min(items.length, end + 25);
      if (start == end) {
        break;
      }
    }
  }

  Stream<Comment> mentions() =>
      ListingGenerator.createBasicGenerator(reddit, apiPath['mentions']);

  Future<Message> message(String messageId) async {
    final listing = await reddit.get(
        apiPath['message'].replaceAll(_messagesRegExp, messageId));
    final messages = <Message>[];
    final message = listing['listing'][0];
    messages.add(message);
    messages.addAll(await message.replies);
    for (final m in messages) {
      if (await m.fullname == messageId) {
        return m;
      }
    }
    return null;
  }

  Stream<Message> messages() =>
      ListingGenerator.createBasicGenerator(reddit, apiPath['messages']);

  Stream<Message> sent() =>
      ListingGenerator.createBasicGenerator(reddit, apiPath['sent']);

  Stream stream({int pauseAfter}) =>
      streamGenerator(unread, pauseAfter: pauseAfter);

  Stream<Comment> submissionReplies() =>
      ListingGenerator.createBasicGenerator(
          reddit, apiPath['submission_replies']);

  Future uncollapse(List items) => _itemHelper('uncollapse', items);

  Stream unread({int limit, bool markRead = false}) {
    final params = {
      'mark': markRead.toString(),
    };
    return ListingGenerator.generator(
        reddit, apiPath['unread'], params: params, limit: limit);
  }
}
