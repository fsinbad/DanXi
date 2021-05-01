/*
 *     Copyright (C) 2021  w568w
 *
 *     This program is free software: you can redistribute it and/or modify
 *     it under the terms of the GNU General Public License as published by
 *     the Free Software Foundation, either version 3 of the License, or
 *     (at your option) any later version.
 *
 *     This program is distributed in the hope that it will be useful,
 *     but WITHOUT ANY WARRANTY; without even the implied warranty of
 *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *     GNU General Public License for more details.
 *
 *     You should have received a copy of the GNU General Public License
 *     along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'dart:async';

import 'package:dan_xi/common/constant.dart';
import 'package:dan_xi/feature/aao_notice_feature.dart';
import 'package:dan_xi/feature/dining_hall_crowdedness_feature.dart';
import 'package:dan_xi/feature/ecard_balance_feature.dart';
import 'package:dan_xi/feature/empty_classroom_feature.dart';
import 'package:dan_xi/feature/fudan_daily_feature.dart';
import 'package:dan_xi/feature/welcome_feature.dart';
import 'package:dan_xi/generated/l10n.dart';
import 'package:dan_xi/page/platform_subpage.dart';
import 'package:dan_xi/public_extension_methods.dart';
import 'package:dan_xi/util/platform_universal.dart';
import 'package:dan_xi/util/screen_proxy.dart';
import 'package:dan_xi/widget/feature_item/feature_list_item.dart';
import 'package:dan_xi/widget/qr_code_dialog/qr_code_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

class HomeSubpage extends PlatformSubpage {
  @override
  bool get needPadding => true;

  @override
  _HomeSubpageState createState() => _HomeSubpageState();

  HomeSubpage({Key key});
}

class RefreshHomepageEvent {}

class _HomeSubpageState extends State<HomeSubpage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  static StreamSubscription _refreshSubscription;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    if (_refreshSubscription == null) {
      _refreshSubscription = Constant.eventBus
          .on<RefreshHomepageEvent>()
          .listen((_) => refreshSelf());
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_refreshSubscription != null) _refreshSubscription.cancel();
    _refreshSubscription = null;
  }

  //Get current brightness with _brightness
  double _brightness = 1.0;

  initPlatformState() async {
    double brightness = await ScreenProxy.brightness;
    setState(() => _brightness = brightness);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return RefreshIndicator(
        onRefresh: () async => refreshSelf(),
        child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView(
              padding: EdgeInsets.all(4),
              children: <Widget>[
                Card(
                    child: Column(
                  children: [
                    FeatureListItem(feature: WelcomeFeature()),
                    Divider(),
                    FeatureListItem(feature: EcardBalanceFeature()),
                    FeatureListItem(feature: DiningHallCrowdednessFeature()),
                    FeatureListItem(feature: FudanAAONoticesFeature()),
                    FeatureListItem(feature: EmptyClassroomFeature()),
                  ],
                )),
                Card(child: FeatureListItem(feature: FudanDailyFeature())),
                Card(
                  child: ListTile(
                    title: Text(S.of(context).fudan_qr_code),
                    leading: PlatformX.isAndroid
                        ? const Icon(Icons.qr_code)
                        : const Icon(SFSymbols.qrcode),
                    subtitle: Text(S.of(context).tap_to_view),
                    onTap: () {
                      QRHelper.showQRCode(
                          context, context.personInfo, _brightness);
                    },
                  ),
                )
              ],
            )));
  }
}
