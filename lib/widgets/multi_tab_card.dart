import 'package:flutter/material.dart';

class MultiTabCard extends StatefulWidget {
  MultiTabCard(
      {Key? key,
      required this.onChanged,
      required this.tabs,
      this.defaultTab = ""})
      : super(key: key);
  final List<String> tabs;
  final String defaultTab;
  final void Function(String item) onChanged;
  @override
  State<MultiTabCard> createState() => _MultiTabCardState();
}

class _MultiTabCardState extends State<MultiTabCard> {
  String selectedTab = "";
  @override
  void initState() {
    selectedTab = widget.tabs[0];
    selectedTab = widget.defaultTab;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var tab in widget.tabs)
            InkWell(
              onTap: () {
                setState(() {
                  selectedTab = tab;
                });
                widget.onChanged(tab);
              },
              child: Container(
                decoration: BoxDecoration(
                    color:
                        selectedTab == tab ? Colors.deepPurple : Colors.white,
                    border: Border.all(color: Colors.grey)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    tab,
                    style: selectedTab == tab
                        ? TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)
                        : TextStyle(),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
