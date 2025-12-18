part of '../view/select_sources_view.dart';

/// SOURCE SEARCH BAR
class _SourcesSearchBar extends StatefulWidget {
  final TextEditingController controller;

  const _SourcesSearchBar({required this.controller});

  @override
  State<_SourcesSearchBar> createState() => _SourcesSearchBarState();
}

class _SourcesSearchBarState extends State<_SourcesSearchBar> {
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
            ? IconButton(icon: const Icon(Icons.clear), onPressed: _clearSearch)
            : null,
      ),
    );
  }
}
