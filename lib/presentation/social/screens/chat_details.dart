import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:socialapp/cubit/social/social_cubit.dart';
import 'package:socialapp/cubit/social/social_states.dart';
import 'package:socialapp/models/message.dart';
import 'package:socialapp/models/user.dart';
import 'package:socialapp/styles/colors/colors.dart';

// ignore: must_be_immutable
class ChatDetails extends StatelessWidget {
  final SocialUser userModel;

  ChatDetails({Key? key, required this.userModel}) : super(key: key);
  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getMessages(receivedId: userModel.uId!);
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var _cubit = SocialCubit.get(context);
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0.0,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage(userModel.image!),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Text(userModel.name!),
                  ],
                ),
              ),
              body: Conditional.single(
                context: context,
                conditionBuilder: (context) => _cubit.messages.length > 0,
                widgetBuilder: (context) => Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                            itemBuilder: (context, index) {
                              var message =
                                  SocialCubit.get(context).messages[index];
                              if (_cubit.userModel!.uId == message.receiverId)
                                return buildMessage(message);
                              else
                                return buildMyMessage(message);
                            },
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 15.0),
                            itemCount: _cubit.messages.length),
                      ),
                      Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey[400]!, width: 1.0),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: messageController,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'type your message here ...'),
                                ),
                              ),
                              Container(
                                color: defaultColor,
                                width: 50.0,
                                child: MaterialButton(
                                  onPressed: () => _cubit.sendMessage(
                                      receivedId: userModel.uId!,
                                      dateTime: DateTime.now().toString(),
                                      text: messageController.text),
                                  child: Icon(Icons.send,
                                      size: 16.0, color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                fallbackBuilder: (context) => Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildMessage(MessageModel model) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadiusDirectional.only(
                    bottomEnd: Radius.circular(10.0),
                    bottomStart: Radius.circular(10.0),
                    topEnd: Radius.circular(10.0))),
            child: Text(model.text!)),
      );
  Widget buildMyMessage(MessageModel model) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            decoration: BoxDecoration(
                color: defaultColor.withOpacity(0.2),
                borderRadius: BorderRadiusDirectional.only(
                    bottomEnd: Radius.circular(10.0),
                    bottomStart: Radius.circular(10.0),
                    topStart: Radius.circular(10.0))),
            child: Text(model.text!)),
      );
}
