import 'tasks.dart';

class NewTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var newTasks = AppCubit.get(context).newTasks;
        return buildListViewTask(newTasks);
      },
    );
  }
}
