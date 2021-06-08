import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ni_trades/blocs/bloc/auth_bloc.dart';
import 'package:ni_trades/blocs/data/data_bloc.dart';
import 'package:ni_trades/model/user_model.dart';
import 'package:ni_trades/repository/data_repo.dart';
import 'package:ni_trades/screens/auth_screen/change_password.dart';

class UserProfileScreen extends StatelessWidget {
  final User user;

  UserProfileScreen({Key? key, required this.user}) : super(key: key);

  final picker = ImagePicker();

  Future<File?> getImage(BuildContext context) async {
    try {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        File? croppedFile = await ImageCropper.cropImage(
            sourcePath: pickedFile.path,
            compressQuality: 70,
            compressFormat: ImageCompressFormat.jpg,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              // CropAspectRatioPreset.ratio3x2,
              // CropAspectRatioPreset.original,
              // CropAspectRatioPreset.ratio4x3,
              // CropAspectRatioPreset.ratio16x9
            ],
            androidUiSettings: AndroidUiSettings(
                toolbarTitle: 'NI Trade Cropper',
                toolbarColor: Theme.of(context).colorScheme.secondary,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            iosUiSettings: IOSUiSettings(
              minimumAspectRatio: 1.0,
            ));
        if (croppedFile != null) {
          return croppedFile;
        } else {
          return null;
        }
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // context.read<AuthBloc>()3.add(GetCurrentUserEvent());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Personal Information',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        elevation: 0.0,
        actions: [
          IconButton(
              onPressed: () {
                context.read<AuthBloc>().add(LogoutUserEvent());
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.exit_to_app_outlined))
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    StreamBuilder<User>(
                        stream: DataService().user,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Hero(
                              tag: 'profile-image',
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration:
                                    BoxDecoration(shape: BoxShape.circle),
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot.data!.photo,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        SpinKitDualRing(
                                            size: 24.0,
                                            lineWidth: 2,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                  ),
                                ),
                              ),
                            );
                            // return CircleAvatar(
                            //   radius: 50.0,
                            //   backgroundImage:
                            //       NetworkImage('${snapshot.data!.photo}'),
                            // );
                          }

                          return Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: user.photo,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => SpinKitDualRing(
                                    size: 24.0,
                                    lineWidth: 2,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              ),
                            ),
                          );
                        }),
                    BlocListener<DataBloc, DataState>(
                      listener: (context, state) {
                        if (state is UpdateUserPhotoLoadingState) {
                          showLoader(context);
                        }

                        if (state is UpdateUserPhotoFailureState) {
                          Navigator.of(context).pop();
                          showFailureToast(context, state.error);
                        }

                        if (state is UserPhotoUpdatedState) {
                          Navigator.of(context).pop();
                        }
                      },
                      child: Positioned(
                        right: -8.0,
                        bottom: 0.0,
                        child: FloatingActionButton(
                          onPressed: () async {
                            var file = await getImage(context);
                            if (file != null) {
                              context
                                  .read<DataBloc>()
                                  .add(UpdateUserPhotoEvent(user, file));
                            }
                          },
                          elevation: 1.0,
                          mini: true,
                          child: Icon(
                            Icons.edit,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Divider(
                height: 0.1,
                color: Colors.blueGrey[400],
              ),
              SizedBox(height: 16.0),
              Text('First Name',
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withOpacity(0.7),
                  )),
              SizedBox(height: 16.0),
              Text('${user.firstName}',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0)),
              SizedBox(height: 32.0),
              Text('Last Name',
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withOpacity(0.7),
                  )),
              SizedBox(height: 16.0),
              Text('${user.lastName}',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0)),
              SizedBox(height: 32.0),
              Text('Address',
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withOpacity(0.7),
                  )),
              SizedBox(height: 16.0),
              Text('${user.address}',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0)),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Image.asset(
                    'assets/images/nigeria_flag_icon.png',
                    width: 35.0,
                  ),
                  SizedBox(width: 16.0),
                  Text('${user.phoneNumber}',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0)),
                ],
              ),
              SizedBox(height: 32.0),
              Text('Email Address',
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withOpacity(0.7),
                  )),
              SizedBox(height: 16.0),
              Text('${user.email}',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0)),
              SizedBox(height: 32.0),
              Text('Password',
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withOpacity(0.7),
                  )),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('*************',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0)),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ChangePasswordScreen(),
                      ));
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showFailureToast(BuildContext context, String error) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('$error')));
  }

  void showLoader(BuildContext context) {
    AwesomeDialog(
        context: context,
        dialogType: DialogType.NO_HEADER,
        dialogBackgroundColor: Colors.transparent,
        dismissOnBackKeyPress: false,
        dismissOnTouchOutside: false,
        body: Center(
          child: Container(
            padding: EdgeInsets.all(32.0),
            // color: Theme.of(context).scaffoldBackgroundColor,
            child: SpinKitDualRing(
              color: Theme.of(context).colorScheme.secondary,
              lineWidth: 2,
              size: 32,
            ),
          ),
        )).show();
  }
}
