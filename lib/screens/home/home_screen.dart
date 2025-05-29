import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:post_repository/post_repository.dart';
import 'package:social_media/bloc/create_post_bloc/create_post_bloc.dart';
import 'package:social_media/bloc/get_post_bloc/get_post_bloc.dart';
import 'package:social_media/bloc/my_user_bloc/my_user_bloc.dart';
import 'package:social_media/bloc/sign_in_bloc/sign_in_bloc.dart';
import 'package:social_media/bloc/update_user_info_bloc/bloc/update_user_info_bloc.dart';
import 'package:social_media/screens/home/post_screen.dart';

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
        floatingActionButton: BlocBuilder<MyUserBloc, MyUserState>(
          builder: (context, state) {
            if (state.status == MyUserStatus.success) {
              return FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (context) => BlocProvider<CreatePostBloc>(
                            create:
                                (context) => CreatePostBloc(
                                  postRepo: FirebasePostRepository(),
                                ),
                            child: PostScreen(state.user!),
                          ),
                    ),
                  );
                },
                shape: CircleBorder(),
                child: Icon(Icons.add),
              );
            } else {
              return FloatingActionButton(
                onPressed: null,
                shape: CircleBorder(),
                child: Icon(Icons.clear),
              );
            }
          },
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
                    Text('Welcome back!'),
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
        body: BlocBuilder<GetPostBloc, GetPostState>(
          builder: (context, state) {
            if (state is GetPostSuccess) {
              return ListView.builder(
                itemCount: state.posts.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      spacing: 5,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(
                                    state.posts[index].myUser.picture!,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              spacing: 5,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.posts[index].myUser.name,
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  DateFormat(
                                    'yyyy-MM-dd HH:mm:ss',
                                  ).format(state.posts[index].createAt),
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            state.posts[index].post,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (state is GetPostLoading) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Center(child: Text('An error has occured'));
            }
          },
        ),
      ),
    );
  }
}
