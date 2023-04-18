import 'package:flutter/material.dart';

class ChangableText extends StatefulWidget {
  const ChangableText(
      {Key? key,
      this.intialtext,
      this.onChange,
      this.onDoubleTap,
      this.focusColor})
      : super(key: key);
  final String? intialtext;
  final Function? onDoubleTap;
  final Color? focusColor;
  final Function? onChange;
  @override
  State<ChangableText> createState() => _ChangableTextState();
}

class _ChangableTextState extends State<ChangableText> {
  TextEditingController _textEditingController = TextEditingController();
  bool _isEditingText = false;

  String _text = "";
  @override
  void initState() {
    _text = widget.intialtext ?? "";
    _textEditingController.text = widget.intialtext ?? "";

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isEditingText
        ? Center(
            child: Focus(
              onFocusChange: (focus) {
                if (focus) {
                  setState(() {
                    _isEditingText = true;
                  });
                } else {
                  widget.onChange!(_textEditingController.text);
                  setState(() {
                    _isEditingText = false;
                    _text = _textEditingController.text;
                  });
                }
              },
              child: TextField(
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    focusColor: widget.focusColor),
                onSubmitted: (newValue) {
                  widget.onChange!(newValue);
                  setState(() {
                    _isEditingText = false;
                    _text = newValue;
                  });
                },
                autofocus: true,
                controller: _textEditingController,
              ),
            ),
          )
        : InkWell(
            focusColor: widget.focusColor,
            onDoubleTap: () {
              widget.onDoubleTap!();
            },
            onTap: () {
              setState(() {
                _isEditingText = true;
              });
            },
            child: _text.isEmpty
                ? Container()
                : Text(
                    _text,
                  ));
  }
}
