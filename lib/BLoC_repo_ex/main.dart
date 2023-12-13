// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:lotosui/BLoC_repo_ex/bloc.dart';

// import 'repository.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: Main(),
//     );
//   }
// }

// class Main extends StatefulWidget {
//   const Main({super.key});

//   @override
//   State<Main> createState() => _MainState();
// }

// class _MainState extends State<Main> {
//   final AppIdeasRepository repo = AppIdeasRepository();

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => SomeBloc(repo: repo, socket: null),
//       child: Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           title: const Text("Main"),
//         ),
//         body: BlocBuilder<SomeBloc, States>(
//           builder: (context, state) {
//             if (state is SomeUpdated) {
//               return newMethod(context, state.title);
//             }
//             return newMethod(context, -1);
//           },
//         ),
//       ),
//     );
//   }

//   Center newMethod(BuildContext context, int text) {
//     return Center(
//       child: Column(
//         children: [
//           Text("$text"),
//           ElevatedButton(
//             onPressed: () {
//               context.read<SomeBloc>().add(SomeChangeEvent());
//             },
//             child: Text("Connect"),
//           )
//         ],
//       ),
//     );
//   }
// }
