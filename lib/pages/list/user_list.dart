import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/user.dart';
import '../../database/database_helper.dart';
import '../../controller/users_controller.dart';

class UserList extends StatefulWidget {
	@override
	_UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {

	DatabaseHelper databaseHelper = DatabaseHelper();
	UsersController users = UsersController();

	List<User> userList;
	int count = 0;

	@override
	Widget build(BuildContext context) {

		if (userList == null) {
			userList = List<User>();
			updateListView();
		}

    return Scaffold(
			appBar: AppBar(title: Text('Users')),
			body: getNoteListView()
		);
	}

	ListView getNoteListView() {
		TextStyle titleStyle = Theme.of(context).textTheme.subhead;
		return ListView.builder(
			itemCount: count,
			itemBuilder: (BuildContext context, int position) => Card(
				color: Colors.white,
				elevation: 2.0,
				child: ListTile(
						title: Text(
							this.userList[position].phone +' : '+
							this.userList[position].studentId +' : '+
							this.userList[position].name  +' : '+
							this.userList[position].email +' : '+
							this.userList[position].confirm.toString(),
							style: titleStyle
						),
						subtitle: Text(
							this.userList[position].password +' : '+
							this.userList[position].pin
						),
						trailing: GestureDetector(
							child: Icon(Icons.delete, color: Colors.grey,),
							onTap: () => _delete(context, userList[position]),
						)
				)
			)
		);
	}

  void updateListView() {
		final Future<Database> dbFuture = databaseHelper.initializeDatabase();
		dbFuture.then((database) {
			Future<List<User>> userListFuture = users.getUserList();
			userListFuture.then((userList) {
				setState(() {
				  this.userList = userList;
				  this.count = userList.length;
				});
			});
		});
  }

	void _delete(BuildContext context, User user) async {
		int result = await users.deleteAccount(user.id);
		if (result != 0) {
			_showSnackBar(context, 'User Deleted Successfully');
			updateListView();
		}
	}

	void _showSnackBar(BuildContext context, String message) {
		final snackBar = SnackBar(content: Text(message));
		Scaffold.of(context).showSnackBar(snackBar);
	}

}
