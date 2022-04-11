import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:vase/config/features.dart';
import 'package:vase/config/theme.dart';
import 'package:vase/features/numpad/numpad_view.dart';

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  Function(int) _onPageChanged(ValueNotifier navBarIdx) => (int idx) {
        navBarIdx.value = idx;
      };

  @override
  Widget build(BuildContext context) {
    final navBarIndex = useState(0);
    final pageController = usePageController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Image.asset(
          'assets/images/logo.png',
          width: 40,
          height: 40,
        ),
        centerTitle: true,
        actions: [
          Visibility(
            visible: FeatureFlags.profiles,
            child: IconButton(
              splashRadius: AppTheme.splashRadius,
              onPressed: () {},
              icon: const Icon(Icons.face),
            ),
          ),
          Visibility(
            visible: FeatureFlags.notifications,
            child: IconButton(
              splashRadius: AppTheme.splashRadius,
              onPressed: () {},
              icon: const Icon(Icons.notifications),
            ),
          ),
          IconButton(
            splashRadius: AppTheme.splashRadius,
            onPressed: () {
              context.push('/settings');
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: _onPageChanged(navBarIndex),
        children: const [NumpadView()],
      ),
    );
  }
}
