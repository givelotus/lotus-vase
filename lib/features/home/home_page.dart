import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:vase/config/features.dart';
import 'package:vase/config/theme.dart';
import 'package:vase/features/numpad/numpad_view.dart';
import 'package:vase/features/wallet/wallet_view.dart';

class HomePage extends HookWidget {
  const HomePage();

  Function(int) _navigationTapped(PageController controller) => (int idx) {
        controller.animateToPage(idx,
            duration: Duration(milliseconds: 200), curve: Curves.easeIn);
      };

  Function(int) _onPageChanged(ValueNotifier navBarIdx) => (int idx) {
        navBarIdx.value = idx;
      };

  @override
  Widget build(BuildContext context) {
    final navBarIndex = useState(0);
    final pageController = usePageController();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  splashRadius: AppTheme.splashRadius,
                  onPressed: () {
                    context.push('/qrscan');
                  },
                  icon: Icon(Icons.qr_code_scanner),
                ),
                const Spacer(),
                Visibility(
                  visible: FeatureFlags.profiles,
                  child: IconButton(
                    splashRadius: AppTheme.splashRadius,
                    onPressed: () {},
                    icon: Icon(Icons.face),
                  ),
                ),
                Visibility(
                  visible: FeatureFlags.notifications,
                  child: IconButton(
                    splashRadius: AppTheme.splashRadius,
                    onPressed: () {},
                    icon: Icon(Icons.notifications),
                  ),
                ),
                IconButton(
                  splashRadius: AppTheme.splashRadius,
                  onPressed: () {
                    context.push('/settings');
                  },
                  icon: Icon(Icons.settings),
                ),
              ],
            ),
            Expanded(
              child: PageView(
                controller: pageController,
                onPageChanged: _onPageChanged(navBarIndex),
                children: [
                  NumpadView(),
                  // WalletView(),
                ],
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   onTap: _navigationTapped(pageController),
      //   currentIndex: navBarIndex.value,
      //   showSelectedLabels: false,
      //   showUnselectedLabels: false,
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.app_registration_rounded),
      //       label: 'Transfer',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.wallet_travel),
      //       label: 'Wallet',
      //     ),
      //   ],
      // ),
    );
  }
}
