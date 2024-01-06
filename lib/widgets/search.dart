import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({
    super.key,
    required this.onChange,
  });

  final void Function(String) onChange;

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  // final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      child: searchBar(context),
    );
  }

  SearchBar searchBar(BuildContext context) {
    return SearchBar(
      padding: const MaterialStatePropertyAll<EdgeInsets>(
          EdgeInsets.symmetric(horizontal: 12.0)),
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      // controller: textController,
      backgroundColor: MaterialStateProperty.all(Colors.transparent),
      elevation: MaterialStateProperty.all(0),
      constraints:
          const BoxConstraints(maxWidth: 300, minHeight: 49, maxHeight: 49),
      leading: const Icon(Icons.search, size: 20),
      trailing: [
        IconButton(
          icon: const Icon(Icons.more_vert_rounded),
          onPressed: () {
            Navigator.of(context).pushNamed('/searchFiltersPage');
          },
        ),
        // todo сделать по нажатию на кнопки фильтры вылезающие под поиском и фильтрация в реальном времени
        // IconButton(
        //   icon: const Icon(Icons.clear_rounded),
        //   onPressed: () {
        //     // todo починить отображение после нажатия сюда пропадает все
        //     //  из списка, чтобы вернуть начать печатать надо
        //     textController.text = '';
        //     setState(() {});
        //   },
        // ),
      ],
      side: MaterialStateProperty.all(
        BorderSide(
          color: Theme.of(context).primaryColor.withOpacity(0.4),
          width: 1.5,
        ),
      ),
      onChanged: (value) {
        widget.onChange(value);
      },
    );
  }
}
