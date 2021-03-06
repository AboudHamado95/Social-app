import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialapp/constants/constants.dart';
import 'package:socialapp/cubit/social/social_states.dart';
import 'package:socialapp/models/message.dart';
import 'package:socialapp/models/post.dart';
import 'package:socialapp/models/user.dart';
import 'package:socialapp/presentation/social/screens/chats.dart';
import 'package:socialapp/presentation/social/screens/feeds.dart';
import 'package:socialapp/presentation/social/screens/posts.dart';
import 'package:socialapp/presentation/social/screens/settings.dart';
import 'package:socialapp/presentation/social/screens/users.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  SocialUser? userModel;

  void getUserData() {
    emit(SocialGetUserLoadingState());

    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      print(value.data());
      userModel = SocialUser.fromJson(value.data()!);
      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      emit(SocialGetUserErrorState(error.toString()));
    });
  }

  List<String> titles = ['Home', 'Chats', 'Posts', 'Users', 'Settings'];

  int currentIndex = 0;

  List<Widget> bottomScreen = [
    FeedsScreen(),
    ChatsScreen(),
    PostScreen(),
    UsersScreen(),
    SettingsScreen(),
  ];
  List<BottomNavigationBarItem> bottomItem = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.apps), label: 'Chats'),
    BottomNavigationBarItem(
        icon: Icon(Icons.file_copy_outlined), label: 'Posts'),
    BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Users'),
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
  ];
  void changeBottom(int index) {
    if (index == 1) getUsers();
    if (index == 2)
      emit(SocialNewPostState());
    else {
      currentIndex = index;
      emit(SocialChangeBottomNavState());
    }
  }

  File? profileImage;
  ImagePicker imagePicker = ImagePicker();
  Future getProfileImage() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      emit(SocialProfileImagePickedErrorState());
      return 'No image selected.';
    }
    final imageTemporary = File(pickedFile.path);
    profileImage = imageTemporary;
    emit(SocialProfileImagePickedSuccessState());
  }

  File? coverImage;
  Future getCoverImage() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      emit(SocialCoverPickedErrorState());
      return 'No image selected.';
    }
    final imageTemporary = File(pickedFile.path);
    coverImage = imageTemporary;
    emit(SocialCoverPickedSuccessState());
  }

  void uploadProfileImage(
      {required String name, required String phone, required String bio}) {
    emit(SocialUserUpdateLoadingState());
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    storage
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateUser(name: name, phone: phone, bio: bio, image: value);
      }).catchError((error) {
        emit(SocialUploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadProfileImageErrorState());
    });
  }

  void uploadCoverImage(
      {required String name, required String phone, required String bio}) {
    emit(SocialUserUpdateLoadingState());
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    storage
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateUser(name: name, phone: phone, bio: bio, cover: value);
      }).catchError((error) {
        emit(SocialUploadCoverErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadCoverErrorState());
    });
  }

  void updateUser(
      {required String name,
      required String phone,
      required String bio,
      String? image,
      String? cover}) {
    SocialUser model = SocialUser(
        uId: userModel!.uId,
        name: name,
        email: userModel!.email,
        phone: phone,
        image: image ?? userModel!.image,
        cover: cover ?? userModel!.cover,
        bio: bio,
        isEmailVerified: false);
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
    }).catchError((error) {
      emit(SocialUserUpdateErrorState());
    });
  }

  File? postImage;
  Future getPostImage() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      emit(SocialPostImagePickedErrorState());
      return 'No image selected.';
    }
    final imageTemporary = File(pickedFile.path);
    postImage = imageTemporary;
    emit(SocialPostImagePickedSuccessState());
  }

  void removePostImage() {
    postImage = null;
    emit(SocialRemovePostImageState());
  }

  void uploadPostImage({
    required String dateTime,
    required String text,
  }) {
    emit(SocialCreatePostLoadingState());
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    storage
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(dateTime: dateTime, text: text, postImage: value.toString());
      }).catchError((error) {
        emit(SocialCreatePostErrorState());
      });
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

  void createPost(
      {required String dateTime, required String text, String? postImage}) {
    emit(SocialCreatePostLoadingState());
    PostModel model = PostModel(
        uId: userModel!.uId,
        name: userModel!.name,
        image: userModel!.image,
        dateTime: dateTime,
        text: text,
        postImage: postImage ?? '');
    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
      emit(SocialCreatePostSuccessState());
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

  List<PostModel> posts = [];
  List<String> postsId = [];
  List<int> likes = [];
  // List<int> comments = [];

  void getPosts() {
    emit(SocialGetPostLoadingState());

    FirebaseFirestore.instance.collection('posts').get().then((value) {
      value.docs.forEach((element) {
        element.reference.collection('likes').get().then((value) {
          likes.add(value.docs.length);
          postsId.add(element.id);
          posts.add(PostModel.fromJson(element.data()));
          emit(SocialGetPostSuccessState());
        }).catchError((error) {});
      });
    }).catchError((error) {
      emit(SocialGetPostErrorState(error.toString()));
    });
  }

  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uId)
        .set({'like': true}).then((value) {
      emit(SocialLikePostSuccessState());
    }).catchError((error) {
      emit(SocialLikePostErrorState(error));
    });
  }

  // void commentPost(String postId) {
  //   FirebaseFirestore.instance
  //       .collection('posts')
  //       .doc(postId)
  //       .collection('comments')
  //       .doc(userModel!.uId)
  //       .set({'comment': true}).then((value) {
  //     emit(SocialLikePostSuccessState());
  //   }).catchError((error) {
  //     emit(SocialLikePostErrorState(error));
  //   });
  // }
  List<SocialUser> users = [];
  void getUsers() {
    emit(SocialGetAllUsersLoadingState());
    if (users.length == 0)
      FirebaseFirestore.instance.collection('users').get().then((value) {
        value.docs.forEach((element) {
          if (element.data()['uId'] != userModel!.uId)
            users.add(SocialUser.fromJson(element.data()));
        });
        emit(SocialGetAllUsersSuccessState());
      }).catchError((error) {
        emit(SocialGetAllUsersErrorState(error.toString()));
      });
  }

  void sendMessage(
      {required String receivedId,
      required String dateTime,
      required String text}) {
    MessageModel messageModel = MessageModel(
        senderId: userModel!.uId,
        receiverId: receivedId,
        dateTime: dateTime,
        text: text);
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receivedId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(receivedId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });
  }

  List<MessageModel> messages = [];
  void getMessages({required String receivedId}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receivedId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });
      emit(SocialGetMessagesSuccessState());
    });
  }
}
