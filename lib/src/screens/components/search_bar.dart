import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final VoidCallback? onTap;
  final Function(String)? onSubmitted;
  final Color? color;

  SearchBar({Key? key, this.onTap, this.onSubmitted, this.color})
      : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  String hintText = 'Search for a random joke';

  @override
  void initState() {
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        hintText = '';
      } else {
        hintText = 'Search for a random joke';
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _color = widget.color ?? const Color(0x993C3C43);

    _searchStringValidator(String? value) {
      if (value == null || value.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter some text')),
        );
        return 'Please enter some text';
      } else if (value.trimLeft().trimRight().length < 3) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('At least 3 chars, please')),
        );
        return "At least 3 chars, please";
      }
      return null;
    }

    return Container(
      padding: const EdgeInsets.only(
        left: 8,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFFAFAFA),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        autocorrect: false,
        maxLines: 1,
        decoration: InputDecoration(
            icon: SizedBox(
                height: 26,
                width: 26,
                child: Icon(Icons.search, size: 26, color: _color)),
            suffixIcon: SizedBox(
              width: 26,
              height: 26,
              child: IconButton(
                  icon: Icon(Icons.cancel_sharp, size: 18, color: _color),
                  onPressed: () => _controller.text = " "),
            ),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding:
                const EdgeInsets.only(left: -10, bottom: 0, top: 0, right: 8),
            hintText: hintText),
        style: Theme.of(context).textTheme.headline2?.copyWith(color: _color),
        cursorColor: _color,
        onTap: () {
          if (widget.onTap != null) {
            widget.onTap!();
          }
        },
        onEditingComplete: () {
          if (_searchStringValidator(_controller.text) == null) {
            if (widget.onSubmitted != null) {
              widget.onSubmitted!(_controller.text.trimLeft().trimRight());
            }
          }
        },
      ),
    );
  }
}
