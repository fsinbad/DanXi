/*
 *     Copyright (C) 2021  DanXi-Dev
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

import 'package:dan_xi/generated/l10n.dart';
import 'package:dan_xi/model/danke/course_review.dart';
import 'package:dan_xi/page/home_page.dart';
import 'package:dan_xi/page/platform_subpage.dart';
import 'package:dan_xi/page/subpage_treehole.dart';
import 'package:dan_xi/provider/fduhole_provider.dart';
import 'package:dan_xi/provider/settings_provider.dart';
import 'package:dan_xi/provider/state_provider.dart';
import 'package:dan_xi/repository/danke/curriculum_board_repository.dart';
import 'package:dan_xi/repository/opentreehole/opentreehole_repository.dart';
import 'package:dan_xi/util/master_detail_view.dart';
import 'package:dan_xi/widget/danke/course_list_widget.dart';
import 'package:dan_xi/widget/danke/course_search_bar.dart';
import 'package:dan_xi/widget/danke/course_widgets.dart';
import 'package:dan_xi/widget/danke/random_review_widgets.dart';
import 'package:dan_xi/widget/libraries/error_page_widget.dart';
import 'package:dan_xi/widget/libraries/future_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';

class DankeSubPage extends PlatformSubpage<DankeSubPage> {
  @override
  DankeSubPageState createState() => DankeSubPageState();

  const DankeSubPage({Key? key}) : super(key: key);

  @override
  Create<Widget> get title => (cxt) => Text(S.of(cxt).curriculum);
}

class DankeSubPageState extends PlatformSubpageState<DankeSubPage> {
  // When searching is idle, show random reviews
  bool idle = true;
  String searchText = '';
  CourseReview? _randomReview;

  FileImage? _backgroundImage;
  final GlobalKey<RefreshIndicatorState> indicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget buildPage(BuildContext context) {
    if (overallWord == null) {
      overallWord = S.of(context).curriculum_ratings_overall_words.split(';');
      contentWord = S.of(context).curriculum_ratings_content_words.split(';');
      workloadWord = S.of(context).curriculum_ratings_workload_words.split(';');
      assessmentWord =
          S.of(context).curriculum_ratings_assessment_words.split(';');
    }

    _backgroundImage = SettingsProvider.getInstance().backgroundImage;
    return Container(
      // padding top
      decoration: _backgroundImage == null
          ? null
          : BoxDecoration(
              image:
                  DecorationImage(image: _backgroundImage!, fit: BoxFit.cover)),
      child: RefreshIndicator(
          key: indicatorKey,
          edgeOffset: MediaQuery.of(context).padding.top,
          color: Theme.of(context).colorScheme.secondary,
          backgroundColor: Theme.of(context).dialogBackgroundColor,
          onRefresh: () async {
            HapticFeedback.mediumImpact();
            await _loadRandomReview(forceRefetch: true);
            setState(() {});
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CourseSearchBar(
                onSearch: (String text) {
                  // Avoid unnecessary rebuilding
                  if (text != searchText) {
                    setState(
                      () {
                        idle = text.isEmpty;
                        searchText = text;
                      },
                    );
                  }
                },
              ),
              Expanded(child: _buildPageContent(context)),
            ],
            // button
          )),
    );
  }

  Future<CourseReview?> _loadRandomReview({bool forceRefetch = false}) async {
    if (!context.read<FDUHoleProvider>().isUserInitialized) {
      await OpenTreeHoleRepository.getInstance().initializeRepo();
      settingsPageKey.currentState?.setState(() {});
    }

    if (forceRefetch) {
      _randomReview =
          await CurriculumBoardRepository.getInstance().getRandomReview();
    } else {
      _randomReview ??=
          await CurriculumBoardRepository.getInstance().getRandomReview();
    }

    return _randomReview;
  }

  Widget _buildPageContent(BuildContext context) {
    return idle
        ? ListView(children: [
            FutureWidget<CourseReview?>(
                future: _loadRandomReview(),
                successBuilder: (context, snapshot) => RandomReviewWidgets(
                    review: snapshot.data!,
                    onTap: () async => await smartNavigatorPush(
                            context, "/danke/courseDetail", arguments: {
                          "group_id": snapshot.data!.groupId,
                          "locate": snapshot.data
                        })),
                errorBuilder: (BuildContext context,
                    AsyncSnapshot<CourseReview?> snapshot) {
                  if (snapshot.error is NotLoginError) {
                    return Column(children: [
                      Text(S.of(context).require_login),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PlatformElevatedButton(
                          onPressed: () async {
                            await smartNavigatorPush(context, "/bbs/login",
                                arguments: {
                                  "info": StateProvider.personInfo.value!
                                });
                            onLogin();
                          },
                          child: Text(S.of(context).login),
                        ),
                      ),
                    ]);
                  } else {
                    return ErrorPageWidget.buildWidget(context, snapshot.error,
                        stackTrace: snapshot.stackTrace,
                        onTap: () => setState(() {}));
                  }
                },
                loadingBuilder: Center(
                  child: PlatformCircularProgressIndicator(),
                ))
          ])
        : CourseListWidget(searchKeyword: searchText);
  }
}
