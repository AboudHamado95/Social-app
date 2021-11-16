// ignore_for_file: must_be_immutable
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/components/components.dart';
import 'package:socialapp/cubit/social/social_cubit.dart';
import 'package:socialapp/cubit/social/social_states.dart';

class EditProfile extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var _cubit = SocialCubit.get(context);
        nameController.text = _cubit.socialModel!.name!;
        bioController.text = _cubit.socialModel!.bio!;
        phoneController.text = _cubit.socialModel!.phone!;

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: defaultAppBar(
              context: context,
              title: 'Edit Profile',
              actions: [
                defaultTextButton(
                    function: () {
                      _cubit.updateUser(
                          name: nameController.text,
                          phone: phoneController.text,
                          bio: bioController.text);
                    },
                    text: 'UPDATE'),
                SizedBox(
                  width: 15.0,
                )
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (state is SocialUserUpdateLoadingState)
                    LinearProgressIndicator(),
                  Container(
                    height: 190.0,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Stack(
                              alignment: AlignmentDirectional.topEnd,
                              children: [
                                Container(
                                    height: 140.0,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(4.0),
                                        topRight: Radius.circular(4.0),
                                      ),
                                      image: DecorationImage(
                                          image: _cubit.coverImage == null
                                              ? NetworkImage(
                                                  '${_cubit.socialModel!.cover}')
                                              : FileImage(_cubit.coverImage!)
                                                  as ImageProvider,
                                          fit: BoxFit.cover),
                                    )),
                                IconButton(
                                  onPressed: () => _cubit.getCoverImage(),
                                  icon: CircleAvatar(
                                    radius: 20.0,
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      size: 16.0,
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                        Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 64,
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                child: CircleAvatar(
                                    radius: 60.0,
                                    backgroundImage: _cubit.profileImage == null
                                        ? NetworkImage(
                                            '${_cubit.socialModel!.image}')
                                        : FileImage(_cubit.profileImage!)
                                            as ImageProvider),
                              ),
                              IconButton(
                                onPressed: () => _cubit.getProfileImage(),
                                icon: CircleAvatar(
                                  radius: 20.0,
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    size: 16.0,
                                  ),
                                ),
                              ),
                            ]),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  if (_cubit.profileImage != null || _cubit.coverImage != null)
                    Row(
                      children: [
                        if (_cubit.profileImage != null)
                          Expanded(
                              child: defaultButton(
                                  function: () {
                                    _cubit.uploadProfileImage(
                                        name: nameController.text,
                                        phone: phoneController.text,
                                        bio: bioController.text);
                                  },
                                  text: 'upload profile')),
                        SizedBox(
                          width: 5.0,
                        ),
                        if (_cubit.coverImage != null)
                          Expanded(
                              child: defaultButton(
                                  function: () {
                                    _cubit.uploadCoverImage(
                                        name: nameController.text,
                                        phone: phoneController.text,
                                        bio: bioController.text);
                                  },
                                  text: 'upload cover'))
                      ],
                    ),
                  SizedBox(
                    height: 15.0,
                  ),
                  defaultFormFeild(
                    controller: nameController,
                    type: TextInputType.name,
                    returnValidate: 'name must not be empty',
                    label: 'Name',
                    prefix: Icons.person,
                    onSubmit: (text) {},
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  defaultFormFeild(
                    controller: bioController,
                    type: TextInputType.name,
                    returnValidate: 'bio must not be empty',
                    label: 'Bio',
                    prefix: Icons.info_outline,
                    onSubmit: (text) {},
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  defaultFormFeild(
                    controller: phoneController,
                    type: TextInputType.phone,
                    returnValidate: 'phone must not be empty',
                    label: 'Phone',
                    prefix: Icons.phone,
                    onSubmit: (text) {},
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
