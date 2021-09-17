import 'package:flutter/material.dart';
import 'package:flutter_test_project/app/screens/screen_manager/home_screen_view_model.dart';
import 'package:flutter_test_project/model/custom_user.dart';
import 'package:flutter_test_project/services/database.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.viewModel}) : super(key: key);

  final HomeScreenViewModel viewModel;

  static Widget create(BuildContext context) {
    return ChangeNotifierProvider<HomeScreenViewModel>(
      create: (_) => HomeScreenViewModel(),
      child: Consumer<HomeScreenViewModel>(
        builder: (_, viewModel, __) => HomePage(viewModel: viewModel),
      ),
    );
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? _levelFromDB;
  @override
  void initState() {
    super.initState();
    setCurrentLevelToDBLevel();
  }

  Future<void> setCurrentLevelToDBLevel() async {
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    final _dbLevel = await database.getLevel();
    _levelFromDB = int.tryParse(_dbLevel.level);
    setState(() {
      //set current level to Database level
      widget.viewModel.level = _levelFromDB ?? 0;
    });
  }

  Widget _showLoaderOrText(int value) {
    if (_levelFromDB == null) {
      return const CircularProgressIndicator();
    }
    return Text(
      value.toString(),
      style: const TextStyle(fontSize: 40.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    //read current user displayName
    String userName = context.read<CustomUser>().displayName;
    //get current level
    int? level = widget.viewModel.level;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Let\'s play'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => widget.viewModel.signOut(context),
            icon: const Icon(Icons.logout_sharp),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Welcome $userName',
            style: const TextStyle(fontSize: 15.0),
          ),
          const SizedBox(
            height: 100,
          ),
          _showLoaderOrText(level),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton.extended(
                icon: const Icon(Icons.arrow_upward_sharp),
                onPressed: () => widget.viewModel.incrementLevel(context),
                label: const Text(
                  'Level up',
                ),
              ),
              FloatingActionButton.extended(
                icon: const Icon(Icons.arrow_downward_sharp),
                onPressed: () => widget.viewModel.decrementLevel(context),
                label: const Text(
                  'Level down',
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          FloatingActionButton.extended(
            icon: const Icon(Icons.save_sharp),
            onPressed: () => widget.viewModel.submit(context),
            label: const Text(
              'Save Level',
            ),
          )
        ],
      ),
    );
  }
}
