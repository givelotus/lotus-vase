import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:vase/features/numpad/numpad_view.dart';
import 'package:vase/features/wallet/wallet_view.dart';

class HomePage extends HookWidget {
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
        child: PageView(
          controller: pageController,
          onPageChanged: _onPageChanged(navBarIndex),
          children: [
            WalletView(),
            NumpadView(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _navigationTapped(pageController),
        currentIndex: navBarIndex.value,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet_travel),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.app_registration_rounded),
            label: 'Transfer',
          ),
        ],
      ),
    );
  }
}
