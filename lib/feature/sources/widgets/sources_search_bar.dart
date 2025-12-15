import 'package:flutter/material.dart';
import 'package:flutter_news_app/common/decorations/input_decorations/custom_input_decoration.dart';
import 'package:flutter_news_app/config/localization/string_constants.dart';

class SourcesSearchBar extends StatefulWidget {
  final TextEditingController controller;

  const SourcesSearchBar({required this.controller, super.key});

  @override
  State<SourcesSearchBar> createState() => _SourcesSearchBarState();
}

class _SourcesSearchBarState extends State<SourcesSearchBar> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
    _hasText = widget.controller.text.isNotEmpty;
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.isNotEmpty;
    if (_hasText != hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  void _clearSearch() {
    widget.controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: CustomInputDecoration.customInputDecoration(
        context: context,
        hintText: StringConstants.searchSourceHint,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _hasText
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: _clearSearch,
              )
            : null,
      ),
    );
  }
}
