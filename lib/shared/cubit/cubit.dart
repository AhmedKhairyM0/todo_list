import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived_tasks.dart';
import 'package:todo_app/modules/done_tasks.dart';
import 'package:todo_app/modules/new_tasks.dart';
import 'package:todo_app/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  List<String> titleAppBar = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  var database;

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void changeIndex(value) {
    currentIndex = value;
    emit(AppChangeBottomNavBarState());
  }

  void createDatabase() {
    openDatabase(
      'todo1.db',
      version: 1,
      onCreate: (db, version) {
        db
            .execute(
                'CREATE TABLE tasks ( id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT);')
            .then((value) {});
      },
      onOpen: (db) {
        getDataFromDatabase(db);
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertIntoDatebase(
      {@required String? title,
      @required String? date,
      @required String? time}) {
    database.rawInsert(
        'INSERT INTO tasks (title, date, time, status) VALUES(?,?,?,?)',
        [title, date, time, 'new']).then((value) {
      emit(AppInsertDatabaseState());

      getDataFromDatabase(database);
    });
  }

  void getDataFromDatabase(Database database) {
    emit(AppGetDatabaseLoadingState());

    database.rawQuery('SELECT * FROM tasks').then((value) {
      newTasks.clear();
      archivedTasks.clear();
      doneTasks.clear();
      value.forEach((element) {
        if (element['status'] == 'new')
          newTasks.add(element);
        else if (element['status'] == 'archived')
          archivedTasks.add(element);
        else if (element['status'] == 'done') doneTasks.add(element);
      });
      emit(AppGetDatabaseState());
    });
  }

  updateStatus(status, id) {
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?', [status, id]).then((value) {
      emit(AppUpdateDatabaseState());

      getDataFromDatabase(database);
      emit(AppGetDatabaseLoadingState());
    });
  }

  deleteTaskFromDatabase(int id) {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  bool isBottomSheetShown = false;
  switchButtonSheet(value) {
    isBottomSheetShown = value;
    emit(AppSwitchBottomSheetState());
  }
}
