import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  Search({
    super.key,
    required this.onChange,
    required this.tags,
    required this.callback,
    this.trailing,
  });

  final void Function(String) onChange;
  final void Function(List<String>) callback;
  // final List<String> tags;
  List<String> tags;
  final Widget? trailing;

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<String> selectedTags = [];
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0, top: 8),
      child: Column(
        children: [
          searchBar(context),
          isExpanded ? searchFilters(context) : const SizedBox(height: 8),
        ],
      ),
    );
  }

  searchFilters(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 125.0, // Ограничение высоты до 120
        ),
        child: SingleChildScrollView(
          child: Wrap(
            // spacing: 5.0,
            children: List.generate(
              widget.tags.length,
              (index) {
                return Container(
                  padding: const EdgeInsets.all(2),
                  child: ChoiceChip(
                    labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                    selectedColor:
                        Theme.of(context).primaryColor.withOpacity(0.25),
                    visualDensity: VisualDensity.compact,
                    showCheckmark: false,
                    label: Text(
                      widget.tags[index],
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: 13),
                    ),
                    selected: selectedTags.contains(widget.tags[index]),
                    onSelected: (selected) {
                      toggleTag(widget.tags[index]);
                      widget.callback(selectedTags);
                      setState(() {});
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: const BorderSide(color: Colors.transparent),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  SearchBar searchBar(
    BuildContext context, {
    double iconSize = 20,
  }) {
    return SearchBar(
      padding: const WidgetStatePropertyAll<EdgeInsets>(
          EdgeInsets.only(left: 12, right: 2)),
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      backgroundColor: WidgetStateProperty.all(Colors.transparent),
      elevation: WidgetStateProperty.all(0),
      constraints:
          const BoxConstraints(maxWidth: 300, minHeight: 44, maxHeight: 44),
      leading: Icon(Icons.search, size: iconSize),
      textStyle:
          WidgetStateProperty.all(Theme.of(context).textTheme.bodyMedium),
      trailing: [
        IconButton(
          icon: Icon(Icons.more_vert_rounded, size: iconSize),
          onPressed: () {
            isExpanded = !isExpanded;
            setState(() {});
          },
        ),
        // Дополнительные трейлинги
        widget.trailing ?? const SizedBox(),
      ],
      side: WidgetStateProperty.all(
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

  void toggleTag(String tag) {
    if (selectedTags.contains(tag)) {
      selectedTags.remove(tag);
    } else {
      selectedTags.add(tag);
    }
  }
}
