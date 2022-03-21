import 'dart:developer';

import 'package:RentMyStay_user/home_module/view/home_page.dart';
import 'package:RentMyStay_user/home_module/viewModel/home_viewModel.dart';
import 'package:RentMyStay_user/my_stays/view/mystay_listing_page.dart';
import 'package:RentMyStay_user/property_module/view/wish_list_page.dart';
import 'package:RentMyStay_user/property_module/viewModel/property_viewModel.dart';
import 'package:RentMyStay_user/utils/service/bottom_navigation_provider.dart';
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

  @override
  void initState() {
    super.initState();
    _bottomNavigationProvider =
        Provider.of<BottomNavigationProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            items: const <Widget>[
              Icon(
                Icons.home_rounded,
                size: 30,
                color: Colors.white,
              ),
              Icon(
                Icons.search_rounded,
                size: 30,
                color: Colors.white,
              ),
              Icon(
                Icons.favorite_outline_rounded,
                size: 30,
                color: Colors.white,
              ),
              Icon(
                Icons.house_outlined,
                size: 30,
                color: Colors.white,
              ),
              Icon(
                Icons.person_outline_rounded,
                size: 30,
                color: Colors.white,
              )
            ],
          );
        },
      ),
    );
  }
}
