import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ni_trades/model/user_model.dart';

class UserProfileScreen extends StatelessWidget {
  final User user;

  const UserProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // No appBar property provided, only the body.
      body: CustomScrollView(
          // Add the app bar and list of items as slivers in the next steps.
          slivers: <Widget>[
            SliverAppBar(
              title: Text('My Profile'),
              floating: true,
              backwardsCompatibility: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              snap: true,
              expandedHeight: 300,
              flexibleSpace: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: SvgPicture.asset(
                      'assets/images/profile_bg_dots.svg',
                      fit: BoxFit.fill,
                      colorBlendMode: BlendMode.colorDodge,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                  Container(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ClipOval(
                              child: Container(
                                width: 100,
                                height: 100,
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: user.photo,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 16.0,
                            ),
                            Text(
                              '${user.firstName} ${user.lastName}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              '${user.email}',
                              style: TextStyle(
                                  fontSize: 14.0,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate(
              (context, index) => ListTile(title: Text('Item #$index')),
              // Builds 1000 ListTiles
              childCount: 1000,
            ))
          ]),
    );
  }
}
