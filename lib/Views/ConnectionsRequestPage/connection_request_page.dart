import 'package:easy_localization/easy_localization.dart';
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:vocal_lens/Controllers/user_controller.dart';

class ConnectionRequestPage extends StatelessWidget {
  const ConnectionRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Flexify.back(),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueGrey.shade900,
        title: Text(tr('connection_requests')),
      ),
      body: FutureBuilder(
        future: userController.fetchConnectionRequests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (userController.receivedRequests.isEmpty) {
            return Center(
              child: Text(
                tr('no_connection_requests'),
                style: TextStyle(color: Colors.white54, fontSize: 16.sp),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: userController.receivedRequests.length,
              itemBuilder: (context, index) {
                String senderUid =
                    userController.receivedRequests[index]['from'];

                return FutureBuilder<String>(
                  future: userController
                      .getUserName(senderUid), // Fetch username from UID
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ListTile(
                        title: Text(
                          tr('loading_username'),
                          style:
                              TextStyle(color: Colors.white54, fontSize: 14.sp),
                        ),
                      );
                    } else {
                      String username = snapshot.data ?? tr('unknown_user');
                      return Card(
                        margin: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 5.h),
                        color: Colors.blueGrey.shade800,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            child: Text(username[0].toUpperCase(),
                                style: TextStyle(color: Colors.white)),
                          ),
                          title: Text(username,
                              style: TextStyle(color: Colors.white)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.check,
                                    color: Colors.greenAccent),
                                onPressed: () {
                                  userController.acceptRequest(senderUid);
                                  Fluttertoast.showToast(
                                      msg: tr('request_accepted'));
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.close,
                                    color: Colors.redAccent),
                                onPressed: () {
                                  userController.rejectRequest(senderUid);
                                  Fluttertoast.showToast(
                                      msg: tr('request_declined'));
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
      backgroundColor: Colors.black,
    );
  }
}
