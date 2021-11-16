import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:socialapp/components/components.dart';
import 'package:socialapp/cubit/social/social_cubit.dart';
import 'package:socialapp/cubit/social/social_states.dart';
import 'package:socialapp/presentation/social/screens/posts.dart';
import 'package:socialapp/presentation/social/screens/search.dart';

//
class SocialLayout extends StatelessWidget {
  const SocialLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if (state is SocialNewPostState) navigateTo(context, PostScreen());
      },
      builder: (context, state) {
        var _cubit = SocialCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(_cubit.titles[_cubit.currentIndex]),
            actions: [
              IconButton(
                  onPressed: () {
                    navigateTo(context, SearchScreen());
                  },
                  icon: Icon(Icons.notifications_none_sharp)),
              IconButton(
                  onPressed: () {
                    navigateTo(context, SearchScreen());
                  },
                  icon: Icon(Icons.search_outlined))
            ],
          ),
          body: _cubit.bottomScreen[_cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _cubit.currentIndex,
            onTap: (index) => _cubit.changeBottom(index),
            items: _cubit.bottomItem,
          ),
        );
      },
    );
  }
}
//  if (!FirebaseAuth.instance.currentUser!.emailVerified)
//                     Container(
//                       color: Colors.amber.withOpacity(0.6),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                         child: Row(
//                           children: [
//                             Icon(Icons.info_outline),
//                             SizedBox(
//                               width: 15.0,
//                             ),
//                             Expanded(
//                               child: Text('please verify your email'),
//                             ),
//                             SizedBox(
//                               width: 20.0,
//                             ),
//                             defaultTextButton(
//                                 function: () {
//                                   FirebaseAuth.instance.currentUser!
//                                       .sendEmailVerification()
//                                       .then((value) {
//                                     showToast(
//                                         message: 'check your email',
//                                         state: ToastStates.SUCCESS);
//                                   }).catchError((error) {});
//                                 },
//                                 text: 'SEND')
//                           ],
//                         ),
//                       ),
//                     )
