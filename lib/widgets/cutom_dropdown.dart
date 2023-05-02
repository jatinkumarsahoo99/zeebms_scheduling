import 'package:flutter/material.dart';

class DropDownValue {
  final String label;
  final dynamic value;

  DropDownValue({required this.label, required this.value});
}

class CustomDropDown extends StatefulWidget {
  final List<DropDownValue> options;
  final Function(DropDownValue?) onSelected;
  final String hint;
  final double widthRatio;
  final bool showSearchBar;
  final bool showProgressBar;
  final String? searchHintText;
  final Widget? emptyResultWidget;
  final Widget? progressIndicator;
  final TextStyle? hintTextStyle;
  final TextStyle? selectedItemTextStyle;
  final Color? selectedItemColor;
  final Color? dropdownColor;
  final EdgeInsetsGeometry? contentPadding;

  const CustomDropDown({
    Key? key,
    required this.options,
    required this.onSelected,
    required this.hint,
    this.widthRatio = 0.5,
    this.showSearchBar = true,
    this.showProgressBar = false,
    this.searchHintText,
    this.emptyResultWidget,
    this.progressIndicator,
    this.hintTextStyle,
    this.selectedItemTextStyle,
    this.selectedItemColor,
    this.dropdownColor,
    this.contentPadding,
  }) : super(key: key);

  @override
  _CustomDropDownState createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  DropDownValue? _selectedOption;
  TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<DropDownValue> _filteredOptions = [];

  @override
  void initState() {
    _filteredOptions = widget.options;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _showDropDownMenu,
      child: Container(
        width: MediaQuery.of(context).size.width * widget.widthRatio,
        padding: widget.contentPadding ?? const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                _selectedOption?.label ?? widget.hint,
                style: _selectedOption != null
                    ? widget.selectedItemTextStyle ??
                        TextStyle(
                            color: widget.selectedItemColor ??
                                Theme.of(context).primaryColor)
                    : widget.hintTextStyle ?? TextStyle(color: Colors.grey),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 10.0),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  void _showDropDownMenu() async {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    final double buttonHeight = renderBox.size.height;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double availableHeight = screenHeight - offset.dy - buttonHeight;
    final double maxHeight = availableHeight - 20.0;

    final result = await showMenu(
      context: context,
      position: RelativeRect.fromSize(
        Rect.fromPoints(
            offset,
            Offset(
                offset.dx +
                    MediaQuery.of(context).size.width * widget.widthRatio,
                offset.dy + buttonHeight)),
        Size(MediaQuery.of(context).size.width * widget.widthRatio,
            buttonHeight),
      ),
      items: [
        if (widget.showSearchBar)
          PopupMenuItem(
            child: _buildSearchBar(),
            enabled: false,
          ),
        ..._filteredOptions.map(
          (option) => PopupMenuItem(
            child: Text(
              option.label,
              style: option == _selectedOption
                  ? widget.selectedItemTextStyle ??
                      TextStyle(
                        color: widget.selectedItemColor ??
                            Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      )
                  : null,
            ),
            value: option,
          ),
        ),
        if (widget.showProgressBar && !_isSearching && _filteredOptions.isEmpty)
          PopupMenuItem(
            child: widget.emptyResultWidget ?? Text('No record found'),
            enabled: false,
          ),
      ],
      elevation: 8.0,
      color: widget.dropdownColor ?? Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );

    if (result != null) {
      setState(() {
        _selectedOption = result;
      });
      widget.onSelected(result);
    }
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: widget.searchHintText ?? 'Search',
        border: InputBorder.none,
        prefixIcon: Icon(Icons.search),
      ),
      onChanged: (value) {
        setState(() {
          _isSearching = true;
        });
        _filterOptions(value);
      },
    );
  }

  void _filterOptions(String query) {
    final List<DropDownValue> filteredList = [];
    for (var option in widget.options) {
      if (option.label.toLowerCase().contains(query.toLowerCase())) {
        filteredList.add(option);
      }
    }
    setState(() {
      _filteredOptions = filteredList;
      _isSearching = false;
    });
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        height: 20.0,
        child: widget.progressIndicator ?? LinearProgressIndicator(),
      ),
    );
  }
}
