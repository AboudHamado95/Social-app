import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:socialapp/cubit/social/social_cubit.dart';
import 'package:socialapp/cubit/social/social_states.dart';
import 'package:socialapp/models/post.dart';
import 'package:socialapp/styles/colors/colors.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var _cubit = SocialCubit.get(context);
        return Conditional.single(
          context: context,
          conditionBuilder: (context) =>
              _cubit.posts.length > 0 && _cubit.userModel != null,
          widgetBuilder: (context) => SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 10.0,
                  margin: EdgeInsets.all(8.0),
                  child: Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        Image(
                          image: NetworkImage(
                              'https://assets-global.website-files.com/5b5aa355afe474a8b1329a37/5b983ec8d826746dbdde7949_1509990774-communication-both-ways-article.png'),
                          fit: BoxFit.cover,
                          height: 200.0,
                          width: double.infinity,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'comminicate with friends',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        )
                      ]),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) =>
                      buildPostItem(context, _cubit.posts[index], index),
                  separatorBuilder: (context, index) => SizedBox(height: 10.0),
                  itemCount: _cubit.posts.length,
                ),
                SizedBox(height: 8.0)
              ],
            ),
          ),
          fallbackBuilder: (context) => Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget buildPostItem(context, PostModel model, index) => Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 5.0,
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20.0,
                    backgroundImage: NetworkImage(model.image!),
                  ),
                  SizedBox(width: 15.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              model.name!,
                              style: TextStyle(height: 1.0),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Icon(
                              Icons.check_circle,
                              color: defaultColor,
                              size: 16.0,
                            )
                          ],
                        ),
                        Text(
                          model.dateTime!,
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(height: 1.3),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 15.0),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.more_horiz,
                        size: 16.0,
                      ))
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Container(
                  width: double.infinity,
                  height: 1.0,
                  color: Colors.grey[300],
                ),
              ),
              Text(
                model.text!,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
              //   child: Container(
              //     width: double.infinity,
              //     child: Wrap(
              //       children: [
              //         Container(
              //           height: 25.0,
              //           child: MaterialButton(
              //             minWidth: 1.0,
              //             padding: EdgeInsets.zero,
              //             onPressed: () {},
              //             child: Text(
              //               '#Software',
              //               style: Theme.of(context)
              //                   .textTheme
              //                   .caption!
              //                   .copyWith(color: defaultColor),
              //             ),
              //           ),
              //         ),
              //         Container(
              //           height: 25.0,
              //           child: MaterialButton(
              //             minWidth: 1.0,
              //             padding: EdgeInsets.zero,
              //             onPressed: () {},
              //             child: Text(
              //               '#Flutter',
              //               style: Theme.of(context)
              //                   .textTheme
              //                   .caption!
              //                   .copyWith(color: defaultColor),
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              if (model.postImage != '')
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Container(
                      height: 200.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        image: DecorationImage(
                            image: NetworkImage(model.postImage!),
                            fit: BoxFit.cover),
                      )),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.favorite_border_outlined,
                                size: 16.0,
                                color: Colors.red,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                '${SocialCubit.get(context).likes[index]}',
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.message_rounded,
                                size: 16.0,
                                color: Colors.yellow,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                '0 comment',
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.grey[300],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                            // SocialCubit.get(context).commentPost(index),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 15.0,
                              backgroundImage: NetworkImage(
                                  SocialCubit.get(context).userModel!.image!),
                            ),
                            SizedBox(width: 15.0),
                            Text(
                              'write a comment ...',
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(height: 1.3),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        SocialCubit.get(context)
                            .likePost(SocialCubit.get(context).postsId[index]);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.favorite_border_outlined,
                              size: 16.0,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              'like',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
