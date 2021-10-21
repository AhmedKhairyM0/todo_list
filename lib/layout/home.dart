import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class Home extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(listener: (context, state) {
        if (state is AppInsertDatabaseState) {
          Navigator.of(context).pop();
        }
      }, builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(cubit.titleAppBar[cubit.currentIndex]),
          ),
          body: state is! AppGetDatabaseLoadingState
              ? cubit.screens[cubit.currentIndex]
              : CircularProgressIndicator(),
          floatingActionButton: cubit.currentIndex > 0 ? null : buildFloatingActionButton(cubit),
          bottomNavigationBar: buildBottomNavigationBar(cubit),
        );
      }),
    );
  }

  BottomNavigationBar buildBottomNavigationBar(AppCubit cubit) {
    return BottomNavigationBar(
          onTap: (value) {
            cubit.changeIndex(value);
          },
          currentIndex: cubit.currentIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.menu_outlined), label: 'Tasks'),
            BottomNavigationBarItem(
                icon: Icon(Icons.check_circle_outline_outlined),
                label: 'Done'),
            BottomNavigationBarItem(
                icon: Icon(Icons.archive_outlined), label: 'Archive'),
          ],
        );
  }

  FloatingActionButton buildFloatingActionButton(AppCubit cubit) {
    return FloatingActionButton(
          child: Icon(cubit.isBottomSheetShown ? Icons.add : Icons.edit),
          onPressed: () {
            if (cubit.isBottomSheetShown) {
              if (formKey.currentState!.validate()) {
                cubit.insertIntoDatebase(
                  title: titleController.text,
                  date: dateController.text,
                  time: timeController.text,
                );

                cubit.switchButtonSheet(false);
              }
            } else {
              cubit.switchButtonSheet(true);

              scaffoldKey.currentState!
                  .showBottomSheet((context) => buildBottomSheet(context))
                  .closed
                  .then((value) {
                cubit.switchButtonSheet(false);
                resetTextField();
              });
            }
          },
        );
  }

  void resetTextField() {
    titleController.text = '';
    dateController.text = '';
    timeController.text = '';
  }

  Widget buildBottomSheet(context) {
    return Container(
      height: 250,
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            defaultTextField(
              controller: titleController,
              prefix: Icons.title,
              hint: 'Task Title',
              validate: (value) {
                if (value!.isEmpty) {
                  return 'Title must not be empty';
                }
              },
            ),
            defaultTextField(
                controller: dateController,
                prefix: Icons.calendar_today,
                hint: 'Task Date',
                readOnly: true,
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2040),
                  ).then((value) {
                    if (value != null) {
                      dateController.text = DateFormat.yMMMd().format(value);
                    }
                  });
                }),
            defaultTextField(
                controller: timeController,
                prefix: Icons.watch_later_outlined,
                hint: 'Task Time',
                readOnly: true,
                onTap: () {
                  showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  ).then(
                      (value) => timeController.text = value!.format(context));
                }),
          ],
        ),
      ),
    );
  }
}
