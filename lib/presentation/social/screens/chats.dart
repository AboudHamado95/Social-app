import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:socialapp/components/components.dart';
import 'package:socialapp/cubit/social/social_cubit.dart';
import 'package:socialapp/cubit/social/social_states.dart';
import 'package:socialapp/models/user.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var _cubit = SocialCubit.get(context);
        return Conditional.single(
            context: (context),
            conditionBuilder: (context) => _cubit.users.length > 0,
            widgetBuilder: (context) => ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemCount: _cubit.users.length,
                  separatorBuilder: (context, index) => myDivider(),
                  itemBuilder: (context, index) =>
                      buildChatItem(_cubit.users[index]),
                ),
            fallbackBuilder: (context) =>
                Center(child: CircularProgressIndicator()));
      },
    );
  }

  Widget buildChatItem(SocialUser model) => InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20.0,
                backgroundImage: NetworkImage(model.image!),
              ),
              SizedBox(width: 15.0),
              Expanded(
                child: Text(
                  model.name!,
                  style: TextStyle(height: 1.0),
                ),
              ),
            ],
          ),
        ),
      );
}
