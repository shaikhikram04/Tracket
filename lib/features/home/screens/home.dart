import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/common/widgets/app_bar/T_app_bar.dart';
import 'package:tracket/features/authentication/services/firebase_auth_methods.dart';
import 'package:tracket/features/home/drawer/main_drawer.dart';
import 'package:tracket/features/home/utils/constants.dart';
import 'package:tracket/features/home/widgets/bottom_navigation_bar.dart';
import 'package:tracket/features/home/widgets/notification_icon.dart';
import 'package:tracket/features/players/providers/player_provider.dart';
import 'package:tracket/utils/constants/text_strings.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

/// HomeScreen is the main navigation hub for the application
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  var _selectedIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Use a more optimal approach to load data after build
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadPlayerData());
  }

  /// Loads player data from Firebase and updates the player provider
  Future<void> _loadPlayerData() async {
    if (!mounted) return;

    setState(() {
      _selectedIndex = HomeConstants.loadingScreenIndex;
      _isLoading = true;
    });

    try {
      final player = await FirebaseAuthMethods().getUserDetail;
      if (mounted) {
        ref.read(playerProvider.notifier).setPlayer(player);
      }
    } catch (error) {
      if (mounted) {
        THelperFunction.showErrorSnackBar('${TTextStrings.loadingPlayerDataError} $error', context);
      }
    } finally {
      if (mounted) {
        setState(() {
          _selectedIndex = 0;
          _isLoading = false;
        });
      }
    }
  }

  /// Updates the selected navigation index
  void _selectItem(int index) {
    if (_isLoading) return;
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the actual index for title and bottom navigation
    final navigationIndex = _selectedIndex % HomeConstants.titles.length;
    final title = HomeConstants.titles[navigationIndex];
    
    return Scaffold(
      appBar: TAppBar(title: title, actions: const [NotificationIcon(hasNotification: false)]),
      drawer: const MainDrawer(),
      body: IndexedStack(index: _selectedIndex, children: HomeConstants.screens),
      bottomNavigationBar: TBottomNavigationBar(navigationIndex: navigationIndex, onTap: _selectItem),
    );
  }
}
