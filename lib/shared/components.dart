import 'package:flutter/material.dart';

import 'cubit/cubit.dart';

Widget defaultTextField({
  @required TextEditingController? controller,
  TextInputType type = TextInputType.text,
  Function(String)? onChanged,
  Function(String)? onSubmit,
  void Function()? onTap,
  String? Function(String?)? validate,
  @required IconData? prefix,
  @required String? hint,
  bool isPassword = false,
  Widget? suffix,
  bool readOnly = false,
}) =>
    Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        obscureText: isPassword,
        onChanged: onChanged,
        onFieldSubmitted: onSubmit,
        onTap: onTap,
        readOnly: readOnly,
        validator: validate,
        decoration: InputDecoration(
          prefixIcon: Icon(prefix),
          suffixIcon: suffix,
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
          border: OutlineInputBorder(),
        ),
      ),
    );

Widget buildTaskItem(Map model, BuildContext context) {
  var children = [
    CircleAvatar(
      radius: 40.0,
      child: Text(
        '${model['time']}',
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    ),
    SizedBox(
      width: 15,
    ),
    Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${model['title']}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '${model['date']}',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    )
  ];
  var doneTaskIcon = IconButton(
    padding: EdgeInsets.symmetric(horizontal: 0.0),
    icon: Icon(
      Icons.check_box,
      color: Colors.green,
    ),
    onPressed: () {
      AppCubit.get(context).updateStatus('done', model['id']);
    },
  );

  var archivedTaskIcon = IconButton(
    padding: EdgeInsets.symmetric(horizontal: 0.0),
    icon: Icon(
      Icons.archive,
      color: Colors.grey[500],
    ),
    onPressed: () {
      AppCubit.get(context).updateStatus('archived', model['id']);
    },
  );

  if (model['status'] == 'archived' || model['status'] == 'new')
    children.add(doneTaskIcon);
  if (model['status'] == 'done' || model['status'] == 'new')
    children.add(archivedTaskIcon);

  return Dismissible(
    key: Key('${model['id']}'),
    direction: DismissDirection.horizontal,
    onDismissed: (direction) {
      AppCubit.get(context).deleteTaskFromDatabase(model['id']);
    },
    child: Padding(
      padding: EdgeInsets.all(8),
      child: Row(
        children: children,
      ),
    ),
  );
}

Widget buildListViewTask(List<Map<dynamic, dynamic>> tasks) {
  return tasks.length > 0
      ? ListView.separated(
          itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
          separatorBuilder: (context, index) =>
              Divider(thickness: 1, height: 0.0),
          itemCount: tasks.length,
        )
      : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.menu,
                size: 100,
                color: Colors.grey,
              ),
              Text('No Tasks Yet, Please add your tasks..',
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey)),
            ],
          ),
        );
}
