import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({super.key, required this.textController});

  final TextEditingController textController;

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      child: SearchBar(
        controller: widget.textController,
        elevation: MaterialStateProperty.all(0),
        constraints:
            const BoxConstraints(maxWidth: 250, minHeight: 40, maxHeight: 40),
        leading: const Icon(Icons.search, size: 20),
        hintText: "Введите инструмент",
        trailing: [
          InkWell(
            child: const Icon(Icons.clear_rounded, size: 20),
            onTap: () {
              widget.textController.text = '';
              setState(() {});
            },
          ),
        ],
        side: MaterialStateProperty.all(BorderSide(
          color: Theme.of(context).primaryColor.withOpacity(0.4),
          width: 1.5,
        )),
        onTap: () {
          debugPrint("search tapped");
        },
      ),
    );
  }
}
