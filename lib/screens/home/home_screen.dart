import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media/bloc/my_user_bloc/my_user_bloc.dart';
import 'package:social_media/bloc/sign_in_bloc/sign_in_bloc.dart';
import 'package:social_media/bloc/update_user_info_bloc/bloc/update_user_info_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<UpdateUserInfoBloc, UpdateUserInfoState>(
      listener: (context, state) {
        if (state is UploadPictureSuccess) {
          context.read<MyUserBloc>().state.user!.picture = state.userImage;
        }
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          shape: CircleBorder(),
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          backgroundColor: theme.appBarTheme.backgroundColor,
          title: BlocBuilder<MyUserBloc, MyUserState>(
            builder: (context, state) {
              if (state.status == MyUserStatus.success) {
                return Row(
                  spacing: 10,
                  children: [
                    state.user!.picture == ''
                        ? GestureDetector(
                          onTap: () async {
                            final ImagePicker picker = ImagePicker();
                            final XFile? image = await picker.pickImage(
                              source: ImageSource.gallery,
                              maxHeight: 500,
                              maxWidth: 500,
                              imageQuality: 40,
                            );
                            if (image != null) {
                              CroppedFile? croppedFile = await ImageCropper()
                                  .cropImage(
                                    sourcePath: image.path,
                                    aspectRatio: CropAspectRatio(
                                      ratioX: 1,
                                      ratioY: 1,
                                    ),
                                    uiSettings: [
                                      AndroidUiSettings(
                                        toolbarTitle: 'Cropper',
                                        toolbarColor: Colors.black,
                                        toolbarWidgetColor: Colors.white,
                                        initAspectRatio:
                                            CropAspectRatioPreset.original,
                                        lockAspectRatio: false,
                                      ),
                                      IOSUiSettings(title: 'Cropper'),
                                    ],
                                  );
                              if (croppedFile != null) {
                                setState(() {
                                  context.read<UpdateUserInfoBloc>().add(
                                    UploadPicture(
                                      croppedFile.path,
                                      context.read<MyUserBloc>().state.user!.id,
                                    ),
                                  );
                                });
                              }
                            }
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.person),
                          ),
                        )
                        : GestureDetector(
                          onTap: () async {
                            final ImagePicker picker = ImagePicker();
                            final XFile? image = await picker.pickImage(
                              source: ImageSource.gallery,
                              maxHeight: 500,
                              maxWidth: 500,
                              imageQuality: 40,
                            );
                            if (image != null) {
                              CroppedFile? croppedFile = await ImageCropper()
                                  .cropImage(
                                    sourcePath: image.path,
                                    aspectRatio: CropAspectRatio(
                                      ratioX: 1,
                                      ratioY: 1,
                                    ),
                                    uiSettings: [
                                      AndroidUiSettings(
                                        toolbarTitle: 'Cropper',
                                        toolbarColor: Colors.black,
                                        toolbarWidgetColor: Colors.white,
                                        initAspectRatio:
                                            CropAspectRatioPreset.original,
                                        lockAspectRatio: false,
                                      ),
                                      IOSUiSettings(title: 'Cropper'),
                                    ],
                                  );
                              if (croppedFile != null) {
                                setState(() {
                                  context.read<UpdateUserInfoBloc>().add(
                                    UploadPicture(
                                      croppedFile.path,
                                      context.read<MyUserBloc>().state.user!.id,
                                    ),
                                  );
                                });
                              }
                            }
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(state.user!.picture!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Text('Welcome user')
                  ],
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                context.read<SignInBloc>().add(SignOutRequired());
              },
              icon: Icon(Icons.login),
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: 8,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    spacing: 10,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 10),
                          Column(
                            spacing: 5,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'User',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'date when post created',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        'This design features a cute, sketched teddy bear lying on a rectangular pillow, wearing striped pajamas. The illustration has a vintage, hand-drawn aesthetic, with fine linework and a relaxed vibe. The bear is positioned horizontally, symbolizing comfort and rest.',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
