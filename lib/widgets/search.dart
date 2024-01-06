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
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 8),
      child: Column(
        children: [
          searchBar(context),
          isExpanded ? searchFilters(context) : const SizedBox(height: 8),
        ],
      ),
    );
  }

  List<String> allTags = ["Активные", "Фиючерсы", "Профессиональные", "Другое"];
  Set<String> selectedTags = {};

  searchFilters(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Wrap(
        spacing: 5.0,
        children: List.generate(
          allTags.length,
          (index) {
            return Container(
              padding: const EdgeInsets.all(2),
              child: ChoiceChip(
                labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                selectedColor: Theme.of(context).primaryColor.withOpacity(0.25),
                visualDensity: VisualDensity.compact,
                showCheckmark: true,
                label: Text(allTags[index]),
                selected: selectedTags.contains(allTags[index]),
                onSelected: (selected) {
                  toggleTag(allTags[index]);
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
    );
  }

  SearchBar searchBar(BuildContext context) {
    return SearchBar(
      padding: const MaterialStatePropertyAll<EdgeInsets>(
          EdgeInsets.symmetric(horizontal: 12.0)),
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      backgroundColor: MaterialStateProperty.all(Colors.transparent),
      elevation: MaterialStateProperty.all(0),
      constraints:
          const BoxConstraints(maxWidth: 300, minHeight: 49, maxHeight: 49),
      leading: const Icon(Icons.search, size: 20),
      trailing: [
        IconButton(
          icon: const Icon(Icons.more_vert_rounded),
          onPressed: () {
            isExpanded = !isExpanded;
            setState(() {});
          },
        ),
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

  void toggleTag(String tag) {
    if (selectedTags.contains(tag)) {
      selectedTags.remove(tag);
    } else {
      selectedTags.add(tag);
    }
  }
}
