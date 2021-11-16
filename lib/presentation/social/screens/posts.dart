import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/components/components.dart';
import 'package:socialapp/cubit/social/social_cubit.dart';
import 'package:socialapp/cubit/social/social_states.dart';

// ignore: must_be_immutable
class PostScreen extends StatelessWidget {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var _cubit = SocialCubit.get(context);
        DateTime dateTime = DateTime.now();
        return Scaffold(
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: defaultAppBar(
                  context: context,
                  title: 'Create Post',
                  actions: [
                    defaultTextButton(
                        function: () {
                          if (_cubit.postImage == null) {
                            _cubit.createPost(
                                dateTime: dateTime.toString(),
                                text: textController.text);
                          } else {
                            _cubit.uploadPostImage(
                                dateTime: dateTime.toString(),
                                text: textController.text);
                          }
                        },
                        text: 'Post')
                  ])),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                if (state is SocialCreatePostLoadingState)
                  LinearProgressIndicator(),
                if (state is SocialCreatePostLoadingState)
                  SizedBox(
                    height: 10.0,
                  ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage(
                          'https://learn.g2.com/hubfs/iStock-1014745430.jpg'),
                    ),
                    SizedBox(width: 15.0),
                    Expanded(
                      child: Text(
                        'Abdulrahman Hamado',
                        style: TextStyle(height: 1.0),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TextFormField(
                    controller: textController,
                    decoration: InputDecoration(
                        hintText: 'what is in your mind ...',
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                if (_cubit.postImage != null)
                  Stack(alignment: AlignmentDirectional.topEnd, children: [
                    Container(
                        height: 140.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          image: DecorationImage(
                              image: FileImage(_cubit.postImage!),
                              fit: BoxFit.cover),
                        )),
                    IconButton(
                      onPressed: () => _cubit.removePostImage(),
                      icon: CircleAvatar(
                        radius: 20.0,
                        child: Icon(
                          Icons.close,
                          size: 16.0,
                        ),
                      ),
                    ),
                  ]),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          _cubit.getPostImage();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.photo),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text('add photo')
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Expanded(
                        child: TextButton(
                            onPressed: () {}, child: Text('# tags'))),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
