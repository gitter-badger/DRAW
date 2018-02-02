// Copyright (c) 2017, the Dart Reddit API Wrapper project authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a BSD-style license that
// can be found in the LICENSE file.

import 'dart:async';
import 'package:color/color.dart';

import '../api_paths.dart';
import '../base.dart';
import '../reddit.dart';
import '../user.dart';
import '../exceptions.dart';
import 'redditor.dart';
import 'subreddit.dart';

/// [key_color]: RGB Hex color code of the form i.e "#FFFFFF".

enum MultiredditVisibility { hidden, private, public }
String multiredditVisibilityToString(MultiredditVisibility v) {
  switch (v) {
    case MultiredditVisibility.hidden:
      return "hidden";
      break;
    case MultiredditVisibility.private:
      return "private";
      break;
    case MultiredditVisibility.public:
      return "public";
      break;
    default:
      throw new DRAWInternalError('Visiblitity: $v is not supported');
  }
}

enum MultiredditWeightingScheme { classic, fresh }

String multiredditWeightingSchemeToString(MultiredditWeightingScheme ws) {
  switch (ws) {
    case MultiredditWeightingScheme.classic:
      return "classic";
      break;
    case MultiredditWeightingScheme.fresh:
      return "fresh";
      break;
    default:
      throw new DRAWInternalError('WeightingScheme: $ws is not supported');
  }
}

//For Reference: "https://www.reddit.com/dev/api/#PUT_api_multi_{multipath}".
enum MultiredditIconName {
  artAndDesign,
  ask,
  books,
  business,
  cars,
  comic,
  cuteAnimals,
  diy,
  entertainment,
  foodAndDrink,
  funny,
  games,
  grooming,
  health,
  lifeAdvice,
  military,
  modelsPinup,
  music,
  news,
  philosophy,
  picturesAndGifs,
  science,
  shopping,
  sports,
  style,
  tech,
  travel,
  unusualStories,
  video,
  emptyString,
  none,
}

String multiredditIconNameToString(MultiredditIconName iconName) {
  switch (iconName) {
    case MultiredditIconName.artAndDesign:
      return "art and design";
      break;
    case MultiredditIconName.ask:
      return "ask";
      break;
    case MultiredditIconName.books:
      return "books";
      break;
    case MultiredditIconName.business:
      return "business";
      break;
    case MultiredditIconName.cars:
      return "cars";
      break;
    case MultiredditIconName.comic:
      return "comics";
      break;
    case MultiredditIconName.cuteAnimals:
      return "cute animals";
      break;
    case MultiredditIconName.diy:
      return "diy";
      break;
    case MultiredditIconName.entertainment:
      return "entertainment";
      break;
    case MultiredditIconName.foodAndDrink:
      return "food and drink";
      break;
    case MultiredditIconName.funny:
      return "funny";
      break;
    case MultiredditIconName.games:
      return "games";
      break;
    case MultiredditIconName.grooming:
      return "grooming";
      break;
    case MultiredditIconName.health:
      return "health";
      break;
    case MultiredditIconName.lifeAdvice:
      return "life advice";
      break;
    case MultiredditIconName.military:
      return "military";
      break;
    case MultiredditIconName.modelsPinup:
      return "models pinup";
      break;
    case MultiredditIconName.music:
      return "music";
      break;
    case MultiredditIconName.news:
      return "news";
      break;
    case MultiredditIconName.philosophy:
      return "philosophy";
      break;
    case MultiredditIconName.picturesAndGifs:
      return "pictures and gifs";
      break;
    case MultiredditIconName.science:
      return "science";
      break;
    case MultiredditIconName.shopping:
      return "shopping";
      break;
    case MultiredditIconName.sports:
      return "sports";
      break;
    case MultiredditIconName.style:
      return "style";
      break;
    case MultiredditIconName.tech:
      return "tech";
      break;
    case MultiredditIconName.travel:
      return "travel";
      break;
    case MultiredditIconName.unusualStories:
      return "unusual stories";
      break;
    case MultiredditIconName.video:
      return "video";
      break;
    case MultiredditIconName.emptyString:
      return "";
      break;
    case MultiredditIconName.none:
      return "None";
      break;
    default:
      throw new DRAWInternalError('IconName: $iconName is not supported');
  }
}

/// A class which repersents a Multireddit, which is a collection of
/// [Subreddit]s. This is not yet implemented.
//TODO(kchopra): Implement subreddit list storage.
class Multireddit extends RedditBase {
  static const String _kColor = "key_color";
  static const String _kDescriptionMd = "description_md";
  static const String _kDisplayName = 'display_name';
  static const String _kFrom = "from";
  static const String _kIconName = 'icon_name';
  static const String _kMultiApi = 'multireddit_api';
  static const String _kMultiredditCopy = 'multireddit_copy';
  static const String _kMultiredditRename = 'multireddit_rename';
  static const String _kMultiredditUpdate = 'multireddit_update';
  static const String _kSubreddits = "subreddits";
  static const String _kTo = "to";
  static const String _kVisibility = "visibility";
  static const String _kWeightingScheme = "weighting_scheme";
  static const int _redditorNameInPathIndex = 2;

  static RegExp get multiredditRegExp => _multiredditRegExp;
  static final RegExp _multiredditRegExp = new RegExp(r'{multi}');

  Redditor _author;

  String _displayName;
  String _infoPath;
  String _name;
  String _path;

  String get displayName => _displayName;
  String get name => _name;
  String get path => _path ?? '/';

  Multireddit.parse(Reddit reddit, Map data)
      : super.loadData(reddit, data['data']) {
    _name = data['data']['name'];
    _author = new Redditor.name(
        reddit, data['data']['path'].split('/')[_redditorNameInPathIndex]);
    _path = apiPath['multireddit']
        .replaceAll(_multiredditRegExp, _name)
        .replaceAll(User.userRegExp, _author.displayName);
    _infoPath = apiPath[_kMultiApi]
        .replaceAll(_multiredditRegExp, _name)
        .replaceAll(User.userRegExp, _author.displayName);
  }

  /// Returns a slug version of the [title].
  static String sluggify(String title) {
    if (title == null) {
      return null;
    }
    final RegExp _invalidRegExp = new RegExp(r'(\s|\W|_)+');
    var titleScoped = title.replaceAll(_invalidRegExp, '_').trim();
    if (titleScoped.length > 21) {
      titleScoped = titleScoped.substring(21);
      final lastWord = titleScoped.lastIndexOf('_');
      //TODO(ckartik): Test this well.
      if (lastWord > 0) {
        titleScoped = titleScoped.substring(lastWord);
      }
    }
    return titleScoped ?? '_';
  }

  /// Add a [Subreddit] to this [Multireddit].
  ///
  /// [subreddit] is the name of the [Subreddit] to be added to this [Multireddit].
  Future add({String subreddit, Subreddit subredditInstance}) async {
    subreddit = subredditInstance?.displayName;
    if (subreddit == null) return;
    final url = apiPath[_kMultiredditUpdate]
        .replaceAll(User.userRegExp, _author.displayName)
        .replaceAll(_multiredditRegExp, _name)
        .replaceAll(Subreddit.subredditRegExp, subreddit);
    final data = {'model': "{'name': $subreddit}"};
    // TODO(ckartik): Check if it may be more applicable to use POST here.
    // Direct Link: (https://www.reddit.com/dev/api/#DELETE_api_multi_{multipath}).
    await reddit.put(url, body: data);
    // TODO(ckartik): Research if we should GET subreddits.
  }

  /// Copy this [Multireddit], and return the new [Multireddit].
  ///
  /// [displayName] is an optional string that will become the display name of the new
  /// multireddit and be used as the source for the [name]. If [displayName] is not
  /// provided, the [name] and [displayName] of the muti being copied will be used.
  Future<Multireddit> copy([String displayName]) async {
    final url = apiPath[_kMultiredditCopy];
    final name = sluggify(displayName) ?? _name;

    displayName ??= _displayName;

    final data = {
      _kDisplayName: displayName,
      _kFrom: _path,
      _kTo: apiPath['multiredit']
          .replaceAll(_multiredditRegExp, name)
          .replaceAll(User.userRegExp, reddit.user.me()),
    };
    return await reddit.post(url, data);
  }

  /// Delete this [Multireddit].
  Future delete() async {
    await reddit.delete(_infoPath);
  }

  /// Remove a [Subreddit] from this [Multireddit].
  ///
  /// [subreddit] contains the name of the subreddit to be deleted.
  Future remove({String subreddit, Subreddit subredditInstance}) async {
    subreddit = subredditInstance?.displayName;
    if (subreddit == null) return;
    final url = apiPath[_kMultiredditUpdate]
        .replaceAll(_multiredditRegExp, _name)
        .replaceAll(User.userRegExp, _author)
        .replaceAll(Subreddit.subredditRegExp, subreddit);
    final data = {'model': "{'name': $subreddit}"};
    await reddit.delete(url, body: data);
  }

  /// Rename this [Multireddit].
  ///
  /// [displayName] is the new display for this [Multireddit].
  /// The [name] will be auto generated from the displayName.
  Future rename(displayName) async {
    final url = apiPath[_kMultiredditRename];
    final data = {
      _kFrom: _path,
      _kDisplayName: _displayName,
    };
    await reddit.post(url, data);
    _displayName = displayName;
  }

  /// Update this [Multireddit].
  Future update(
      {final String displayName,
      final List<String> subreddits,
      final String descriptionMd,
      final MultiredditIconName iconName,
      final Color color,
      final MultiredditVisibility visibility,
      final MultiredditWeightingScheme weightingScheme}) async {
    final newSettings = {};
    if (displayName != null) {
      newSettings[_kDisplayName] = displayName;
    }
    final newSubredditList =
        subreddits?.map((item) => {'name': item})?.toList();
    if (newSubredditList != null) {
      newSettings[_kSubreddits] = newSubredditList;
    }
    if (descriptionMd != null) {
      newSettings[_kDescriptionMd] = descriptionMd;
    }
    if (iconName != null) {
      newSettings[_kIconName] = multiredditIconNameToString(iconName);
    }
    if (visibility != null) {
      newSettings[_kVisibility] = multiredditVisibilityToString(visibility);
    }
    if (weightingScheme != null) {
      newSettings[_kWeightingScheme] =
          multiredditWeightingSchemeToString(weightingScheme);
    }
    if (color != null) {
      newSettings[_kcolor] = color.getHexColor().toString();
    }
    //Link to api docs: https://www.reddit.com/dev/api/#PUT_api_multi_{multipath}
    final res = await reddit.put(_infoPath, body: newSettings.toString());
    final Multireddit newMulti = new Multireddit.parse(reddit, res['data']);
    _displayName = newMulti.displayName;
    _name = newMulti.name;
  }
}
