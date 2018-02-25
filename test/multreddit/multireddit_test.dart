
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a BSD-style license that
// can be found in the LICENSE file.

import 'dart:async';

import 'package:draw/draw.dart';
import 'package:test/test.dart';

import '../test_utils.dart';

Future main() async {
  test('lib/subreddit/banned', () async {
    final reddit = await createRedditTestInstance(
        'test/multireddit/lib_multireddit_banned.json',
        live: true);
    Map data = {'name': 'drawapitesting'};

    Map testData = {'data': data};
//    final multireddit = new Multireddit.parse(reddit, );
  });
}
