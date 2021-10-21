
import 'tasks.dart';

class ArchivedTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var archivedTasks = AppCubit.get(context).archivedTasks;
        return buildListViewTask(archivedTasks);
      },
    );
  }
}
