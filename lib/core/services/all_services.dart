import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ridigo/core/model/post.dart';
import 'package:ridigo/ui/map/model/map_model.dart';

import '../../common/api_base_url.dart';
import '../../common/api_end_points.dart';
import '../../ui/community_chat/model/chat_model.dart';
import '../../ui/community_chat/model/group_model.dart';
import '../model/user.dart';

class AllServices {
  final user = FirebaseAuth.instance.currentUser!;
  Dio dio = Dio();

  //-------------------------Group Section-------------------------
  Future<List<Group>?> getGroup() async {
    final token = await user.getIdToken();
    try {
      Response response = await dio.get(kBaseUrl + ApiEndPoints.getgroup,
          options: Options(headers: {
            'authorization': 'Bearer $token',
          }));
      log(response.statusCode.toString(), name: 'getGroup');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<Group> jsonData =
            (response.data as List).map((e) => Group.fromJson(e)).toList();
        final List<Group> groupList = [];
        for (var data in jsonData) {
          final members = List<String>.from(data.members);
          if (!members.contains('${user.email}')) {
            groupList.add(data);
          }
        }
        return groupList;
      } else {
        return null;
      }
    } on DioError catch (e) {
      log(e.message, name: 'get groups');
    }
    return null;
  }

  Future<List<Group>?> joinedGroups() async {
    final token = await user.getIdToken();
    try {
      Response response = await dio.get(kBaseUrl + ApiEndPoints.getgroup,
          options: Options(headers: {
            'authorization': 'Bearer $token',
          }));
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<Group> jsonData =
            (response.data as List).map((e) => Group.fromJson(e)).toList();
        final List<Group> filteredData = [];
        for (var data in jsonData) {
          final members = List<String>.from(data.members);
          if (members.contains('${user.email}')) {
            filteredData.add(data);
          }
        }
        return filteredData;
      } else {
        return null;
      }
    } on DioError catch (e) {
      log(e.message, name: 'joinedGroups');
    }
    return null;
  }

  Future<void> createGroup({roomName}) async {
    final token = await user.getIdToken();
    try {
      log('create Group');
      Response response = await dio.post(kBaseUrl + ApiEndPoints.createGroup,
          data: '{"adminName":"${user.email}","roomName":"$roomName"}',
          options: Options(headers: {
            'authorization': 'Bearer $token',
          }));

      if (response.statusCode == 200 || response.statusCode == 201) {
        log(response.data.toString(), name: 'createGp');
      }
    } on DioError catch (e) {
      log(e.message);
    }
  }

  Future<void> joinGroup({groupId}) async {
    final token = await user.getIdToken();

    try {
      Response response = await dio.post(kBaseUrl + ApiEndPoints.joinGroup,
          data: '{"selection":"$groupId","username":"${user.email}"}',
          options: Options(headers: {
            'authorization': 'Bearer $token',
          }));
      if (response.statusCode == 200 || response.statusCode == 201) {
        log(response.data.toString());
        getGroup();
      }
    } on DioError catch (e) {
      log(e.message);
    }
  }

  Future<Group?> openGroup({groupId}) async {
    final token = await user.getIdToken();
    try {
      Response response = await dio.post(kBaseUrl + ApiEndPoints.openGroup,
          data: {"details": "$groupId"},
          options: Options(headers: {
            'authorization': 'Bearer $token',
          }));
      if (response.statusCode == 200 || response.statusCode == 201) {
        // log(response.data.toString());
        return Group.fromJson(response.data);
      } else {
        return null;
      }
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<void> uploadImage({Group? data}) async {
    final user = FirebaseAuth.instance.currentUser;
    final token = await user!.getIdToken();
    final picker = ImagePicker();
    final id = data!.id;
    File? pickedImage;
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      pickedImage = File(pickedFile.path);
      final FormData formData = FormData.fromMap({
        "id": id,
        "postImage": await MultipartFile.fromFile(pickedImage.path,
            contentType: MediaType('Image', 'JPEG')),
      });

      try {
        Response response =
            await dio.post(kBaseUrl + ApiEndPoints.editGroupImage,
                data: formData,
                options: Options(headers: {
                  'authorization': 'Bearer $token',
                }));
        if (response.statusCode == 200 || response.statusCode == 201) {
          log(response.data.toString(), name: 'profile image');
        }
      } on DioError catch (e) {
        log(e.message);
      }
    }
  }

//-------------------------Chat Section------------------------

  Future<List<ChatModel>?> getMessages({required groupId}) async {
    final token = await user.getIdToken();
    try {
      Response response = await dio.post(kBaseUrl + ApiEndPoints.message,
          data: {"details": "$groupId"},
          options: Options(headers: {
            'authorization': 'Bearer $token',
          }));
      log(response.statusCode.toString(), name: 'get messages');
      if (response.statusCode == 200 || response.statusCode == 201) {
        List<ChatModel> messageList =
            (response.data as List).map((e) => ChatModel.fromJson(e)).toList();
        return messageList;
      } else {
        return null;
      }
    } on DioError catch (e) {
      log(e.message);
    }
    return null;
  }

/*-------------------------User section-----------------------*/
  Future<UserModel?> getUser() async {
    final token = await user.getIdToken();
    try {
      Response response = await dio.post(kBaseUrl + ApiEndPoints.showProfile,
          data: {"email": "${user.email}"},
          options: Options(headers: {
            'authorization': 'Bearer $token',
          }));
      if (response.statusCode == 200 || response.statusCode == 201) {
        // log(response.data.toString());
        return UserModel.fromJson(response.data);
      } else {
        return null;
      }
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<void> uploadProfileImage(context) async {
    final user = FirebaseAuth.instance.currentUser;
    final token = await user!.getIdToken();
    final picker = ImagePicker();
    File? pickedImage;
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      pickedImage = File(pickedFile.path);
      final FormData formData = FormData.fromMap({
        "postImage": await MultipartFile.fromFile(pickedImage.path,
            contentType: MediaType('Image', 'JPEG')),
        "email": "${user.email}"
      });
      try {
        Response response =
            await dio.post(kBaseUrl + ApiEndPoints.editProfileImage,
                data: formData,
                options: Options(headers: {
                  'authorization': 'Bearer $token',
                }));
        if (response.statusCode == 200 || response.statusCode == 201) {
          log(response.data.toString(), name: 'profile image');
        }
      } on DioError catch (e) {
        log(e.message);
      }
    }
  }

  //User Posts
  Future<List<UserPost>?> getPosts() async {
    final token = await user.getIdToken();
    try {
      Response response = await dio.get(kBaseUrl + ApiEndPoints.getPosts,
          options: Options(headers: {
            'authorization': 'Bearer $token',
          }));
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<UserPost> postList = (response.data as List)
            .map(
              (e) => UserPost.fromJson(e),
            )
            .toList();
        // log(response.data.toString());
        return postList;
      } else {
        return null;
      }
    } on DioError catch (e) {
      log(e.message);
    }
    return null;
  }

  void addPost(
      {required String title,
      required String desctription,
      required String details,
      required String event,
      required String registrationEndsOn,
      required File image}) async {
    final pickedImage = File(image.path);
    final token = await user.getIdToken();
    final FormData formData = FormData.fromMap({
      "postImage": await MultipartFile.fromFile(pickedImage.path,
          contentType: MediaType('Image', 'JPEG')),
      "title": title,
      "details": details,
      "description": desctription,
      "event": event,
      "registrationEndsOn": registrationEndsOn,
    });
    try {
      Response response = await dio.post(kBaseUrl + ApiEndPoints.addPost,
          data: formData,
          options: Options(headers: {
            'authorization': 'Bearer $token',
          }));
      if (response.statusCode == 200 || response.statusCode == 201) {
        log(response.data.toString(), name: 'addPost');
      }
    } on DioError catch (e) {
      log(e.message);
    }
  }

  void registerUserPost({postId, groupId}) async {
    final token = await user.getIdToken();
    try {
      Response response = await dio.post(kBaseUrl + ApiEndPoints.regUserPost,
          data: {"email": user.email, "id": postId},
          options: Options(headers: {
            'authorization': 'Bearer $token',
          }));
      if (response.statusCode == 200 || response.statusCode == 201) {
        joinGroup(groupId: groupId);
        log(response.statusCode.toString(), name: 'regUserPost');
      }
    } on DioError catch (e) {
      log(e.message);
    }
  }

//-----------------WishLIst-------------------
  void addToWishList({required String postId}) async {
    final token = await user.getIdToken();
    try {
      Response response = await dio.post(kBaseUrl + ApiEndPoints.addToWishlist,
          data: {'email': user.email, "id": postId},
          options: Options(headers: {
            'authorization': 'Bearer $token',
          }));
      if (response.statusCode == 200 || response.statusCode == 201) {
        log(response.data.toString());
      }
    } on DioError catch (e) {
      log(e.message);
    }
  }

  void removeFromWishList({required String postId}) async {
    final token = await user.getIdToken();
    try {
      Response response =
          await dio.post(kBaseUrl + ApiEndPoints.removeFromWishlist,
              data: {'email': user.email, "id": postId},
              options: Options(headers: {
                'authorization': 'Bearer $token',
              }));
      if (response.statusCode == 200 || response.statusCode == 201) {
        log(response.data.toString());
      }
    } on DioError catch (e) {
      log(e.message);
    }
  }

//------------------Map section-----------------------
  Future<List<MapModel>?> getMapPins() async {
    final token = await user.getIdToken();
    try {
      Response response = await dio.get(kBaseUrl + ApiEndPoints.getMapPin,
          options: Options(headers: {
            'authorization': 'Bearer $token',
          }));
      if (response.statusCode == 200 || response.statusCode == 201) {
        List<MapModel> mapMarkersList =
            (response.data as List).map((e) => MapModel.fromJson(e)).toList();
        log(response.data.toString(), name: 'getMapPins');
        return mapMarkersList;
      } else {
        return null;
      }
    } on DioError catch (e) {
      log(e.message);
    }
    return null;
  }

  void addMapPin({latitude, longitude, description, title}) async {
    final token = await user.getIdToken();

    try {
      Response response = await dio.post(kBaseUrl + ApiEndPoints.getMapPin,
          data: {
            "username": user.email,
            "title": title,
            "description": description,
            "latitude": latitude,
            "longitude": longitude
          },
          options: Options(headers: {
            'authorization': 'Bearer $token',
          }));
      if (response.statusCode == 200 || response.statusCode == 201) {
        log(response.data.toString(), name: 'addMapPin');
      }
    } on DioError catch (e) {
      log(e.message);
    }
  }
}
