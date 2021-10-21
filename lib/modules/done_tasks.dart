import 'tasks.dart';

class DoneTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var doneTasks = AppCubit.get(context).doneTasks;
        return buildListViewTask(doneTasks);
      },
    );
  }
}
