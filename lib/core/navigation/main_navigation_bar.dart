import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:newsllm/core/session/app_session.dart';
import 'package:newsllm/features/auth/presentation/pages/auth_page.dart';
import 'package:newsllm/features/bookmarks/presentation/pages/bookmarks_page.dart';
import 'package:newsllm/features/home/presentation/pages/home_page.dart';
import 'package:newsllm/features/profile/presentation/pages/profile_page.dart';
import 'package:newsllm/features/quiz/presentation/pages/quiz_hub_page.dart';
import 'package:newsllm/features/search/presentation/pages/search_page.dart';
import 'package:newsllm/core/theme/theme_context.dart';

enum MainDestination { home, search, quiz, saved, profile }

class NavigationVisibilityController extends ChangeNotifier {
  NavigationVisibilityController._();

  static final NavigationVisibilityController instance =
      NavigationVisibilityController._();

  bool _visible = true;

  bool get visible => _visible;

  void handleScrollNotification(ScrollNotification notification) {
    if (notification.metrics.axis != Axis.vertical) {
      return;
    }

    final atTop = notification.metrics.extentBefore <= 0;
    final atBottom = notification.metrics.extentAfter <= 0;

    if (atTop || atBottom) {
      show();
      return;
    }

    if (notification is UserScrollNotification) {
      if (notification.direction == ScrollDirection.reverse) {
        hide();
      } else if (notification.direction == ScrollDirection.forward) {
        show();
      }
    }
  }

  void show() {
    if (_visible) {
      return;
    }

    _visible = true;
    notifyListeners();
  }

  void hide() {
    if (!_visible) {
      return;
    }

    _visible = false;
    notifyListeners();
  }
}

class MainNavigationBar extends StatelessWidget {
  const MainNavigationBar({super.key, required this.currentDestination});

  final MainDestination currentDestination;

  Future<void> _selectDestination(
    BuildContext context,
    MainDestination destination,
  ) async {
    NavigationVisibilityController.instance.show();

    if (destination == currentDestination) {
      return;
    }

    if (destination == MainDestination.saved ||
        destination == MainDestination.profile) {
      if (!AppSession.instance.isSignedIn) {
        final shouldSignIn = await showDialog<bool>(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              title: Text('Sign in required'),
              content: Text(
                destination == MainDestination.saved
                    ? 'Sign in to access your saved briefings.'
                    : 'Sign in to access your profile and stored progress.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop(false);
                  },
                  child: Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop(true);
                  },
                  child: Text('Sign in'),
                ),
              ],
            );
          },
        );

        if (shouldSignIn != true || !context.mounted) {
          return;
        }

        await Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => AuthPage()));

        if (!context.mounted || !AppSession.instance.isSignedIn) {
          return;
        }
      }
    }

    if (!context.mounted) {
      return;
    }

    final page = _pageFor(destination);

    if (currentDestination == MainDestination.home) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
      return;
    }

    if (destination == MainDestination.home) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomePage()),
        (route) => false,
      );
      return;
    }

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (context) => page));
  }

  Widget _pageFor(MainDestination destination) {
    switch (destination) {
      case MainDestination.home:
        return HomePage();
      case MainDestination.search:
        return SearchPage();
      case MainDestination.quiz:
        return QuizHubPage();
      case MainDestination.saved:
        return BookmarksPage();
      case MainDestination.profile:
        return ProfilePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: NavigationVisibilityController.instance,
      builder: (context, child) {
        final visible = NavigationVisibilityController.instance.visible;

        return AnimatedSize(
          duration: Duration(milliseconds: 240),
          curve: Curves.easeInOut,
          alignment: Alignment.bottomCenter,
          child: visible
              ? SafeArea(
                  minimum: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Center(
                    heightFactor: 1,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 720),
                      child: Container(
                        decoration: BoxDecoration(
                          color: context.elevatedSurfaceColor,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: context.borderColor),
                          boxShadow: [
                            BoxShadow(
                              color: context.isDarkTheme
                                  ? Colors.black.withValues(alpha: 0.45)
                                  : Color(0x260F172A),
                              blurRadius: 24,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: NavigationBar(
                          height: 72,
                          backgroundColor: context.elevatedSurfaceColor,
                          surfaceTintColor: Colors.transparent,
                          indicatorColor: context.blueTintColor,
                          selectedIndex: currentDestination.index,
                          onDestinationSelected: (index) {
                            _selectDestination(
                              context,
                              MainDestination.values[index],
                            );
                          },
                          destinations: [
                            NavigationDestination(
                              icon: Icon(Icons.home_outlined),
                              selectedIcon: Icon(Icons.home_rounded),
                              label: 'Home',
                            ),
                            NavigationDestination(
                              icon: Icon(Icons.search_rounded),
                              label: 'Search',
                            ),
                            NavigationDestination(
                              icon: Icon(Icons.quiz_outlined),
                              selectedIcon: Icon(Icons.quiz_rounded),
                              label: 'Quiz',
                            ),
                            NavigationDestination(
                              icon: Icon(Icons.bookmark_border_rounded),
                              selectedIcon: Icon(Icons.bookmark_rounded),
                              label: 'Saved',
                            ),
                            NavigationDestination(
                              icon: Icon(Icons.person_outline_rounded),
                              selectedIcon: Icon(Icons.person_rounded),
                              label: 'Profile',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : SizedBox(width: double.infinity, height: 0),
        );
      },
    );
  }
}
