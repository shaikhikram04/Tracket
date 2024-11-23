import 'package:flutter/material.dart';
import 'package:tracket/screens/authentication/user_auth.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: height),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 15),
                Image.asset(
                  'assets/images/Tracket_logo.png',
                  height: height * 0.25,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 17,
                    vertical: 12,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: 350,
                    ),
                    child: Card(
                      color: Theme.of(context).cardColor,
                      child: Column(
                        children: [
                          TabBar(
                            controller: _tabController,
                            tabs: const [
                              Tab(
                                child: Text(
                                  'User',
                                  style: TextStyle(fontSize: 21),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  'Player',
                                  style: TextStyle(fontSize: 21),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 436 ,
                            child: TabBarView(
                              controller: _tabController,
                              children: const [
                                UserAuth(),
                                Text('Login as Player.'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
