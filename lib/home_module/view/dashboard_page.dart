import 'dart:async';
import 'dart:developer';

import 'package:RentMyStay_user/home_module/view/home_page.dart';
import 'package:RentMyStay_user/home_module/viewModel/home_viewModel.dart';
import 'package:RentMyStay_user/my_stays/view/mystay_listing_page.dart';
import 'package:RentMyStay_user/property_module/view/wish_list_page.dart';
import 'package:RentMyStay_user/property_module/viewModel/property_viewModel.dart';
import 'package:RentMyStay_user/utils/service/bottom_navigation_provider.dart';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../my_stays/viewmodel/mystay_viewmodel.dart';
import '../../profile_Module/view/profile_page.dart';
import '../../profile_Module/viewmodel/profile_view_model.dart';
import '../../property_module/view/search_page.dart';
import '../../theme/custom_theme.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late BottomNavigationProvider _bottomNavigationProvider;
  late StreamSubscription<ConnectivityResult> _connectivitySubs;
  final Connectivity _connectivity = Connectivity();
  bool _connectionStatus = true;

  Future<void> initConnectionStatus() async {
    ConnectivityResult result = ConnectivityResult.none;
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      log(e.toString());
    }
    if (!mounted) {
      return null;
    }

    _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        setState(() => _connectionStatus = true);
        break;
      case ConnectivityResult.mobile:
        setState(() => _connectionStatus = true);
        break;
      case ConnectivityResult.none:
        setState(() => _connectionStatus = false);
        break;
      case ConnectivityResult.ethernet:
        setState(() => _connectionStatus = true);
        break;
      default:
        setState(() => _connectionStatus = false);
        break;
    }
  }
  @override
  void initState() {
    super.initState();
    initConnectionStatus();
    _connectivitySubs =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _bottomNavigationProvider =
        Provider.of<BottomNavigationProvider>(context, listen: false);
  }
  @override
  void dispose() {
    _connectivitySubs.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _connectionStatus?Scaffold(
      body: Consumer<BottomNavigationProvider>(
        builder: (context, value, child) {
          switch (value.selectedIndex) {
            case 0:
              return ChangeNotifierProvider(
                create: (_) => HomeViewModel(),
                child: HomePage(),
              );
            case 1:
              return ChangeNotifierProvider(
                  create: (_) => PropertyViewModel(),
                  child: SearchPage(
                    fromBottom: true,
                  ));
            case 2:
              return ChangeNotifierProvider(
                create: (_) => PropertyViewModel(),
                child: WishListPage(fromBottom: true),
              );
            case 3:
              return ChangeNotifierProvider(
                create: (_) => MyStayViewModel(),
                child: MyStayListPage(fromBottom: true),
              );
            case 4:
              return ChangeNotifierProvider(
                create: (_) => ProfileViewModel(),
                child: ProfilePage(fromBottom: true),
              );
            default:
              return Container();
          }
        },
      ),
      bottomNavigationBar: Consumer<BottomNavigationProvider>(
        builder: (context, value, child) {
          return CurvedNavigationBar(
            onTap: (value) {
              log('ONTAp :: $value');
              _bottomNavigationProvider.shiftBottom(index: value);
            },
            index: _bottomNavigationProvider.selectedIndex,
            height: 50,
            backgroundColor: Colors.white,
            buttonBackgroundColor: CustomTheme.appTheme,
            color: CustomTheme.appTheme,
            animationDuration: const Duration(milliseconds: 100),
            items:  <Widget>[
              Icon(
                Icons.home_rounded,
                size:  MediaQuery.of(context).size.height*0.03,
                color: Colors.white,
              ),
              Icon(
                Icons.search_rounded,
                size:  MediaQuery.of(context).size.height*0.03,
                color: Colors.white,
              ),
              Icon(
                Icons.favorite_outline_rounded,
                size:  MediaQuery.of(context).size.height*0.03,
                color: Colors.white,
              ),
              Icon(
                Icons.work_outline_outlined,
                size:  MediaQuery.of(context).size.height*0.03,
                color: Colors.white,
              ),
              Icon(
                Icons.person_outline_rounded,
                size:  MediaQuery.of(context).size.height*0.03,
                color: Colors.white,
              )
            ],
          );
        },
      ),
    ):RMSWidgets.networkErrorPage(context: context);
  }
}
