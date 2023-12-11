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
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      child: SearchBar(
        controller: textController,
        elevation: MaterialStateProperty.all(0),
        constraints:
            const BoxConstraints(maxWidth: 250, minHeight: 40, maxHeight: 40),
        leading: const Icon(Icons.search, size: 20),
        hintText: "Введите инструмент",
        trailing: [
          InkWell(
            child: const Icon(Icons.clear_rounded, size: 20),
            onTap: () {
              textController.text = '';
              setState(() {});
            },
          ),
        ],
        side: MaterialStateProperty.all(BorderSide(
          color: Theme.of(context).primaryColor.withOpacity(0.4),
          width: 1.5,
        )),
        onChanged: (value) {
          widget.onChange(value);
        },
        onTap: () {
          // debugPrint("search tapped");
        },
      ),
    );
  }
}
