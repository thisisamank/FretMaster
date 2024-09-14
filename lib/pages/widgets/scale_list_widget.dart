import 'package:dyte_uikit_flutter_starter_app/core/scale.dart';
import 'package:dyte_uikit_flutter_starter_app/notifier/note_notifier.dart';
import 'package:flutter/material.dart';

class ScaleListWidget extends StatefulWidget {
  final Notes selectedNote;
  final Scales selectedScale;
  final bool showChords; // Whether to show chords or notes

  const ScaleListWidget({
    super.key,
    required this.selectedNote,
    required this.selectedScale,
    this.showChords = false, // Default is to show notes
  });

  @override
  _ScaleListWidgetState createState() => _ScaleListWidgetState();
}

class _ScaleListWidgetState extends State<ScaleListWidget> {
  late final NoteNotifier _noteNotifier;
  List<String> _items = [];

  @override
  void initState() {
    super.initState();
    _noteNotifier = NoteNotifier(widget.selectedNote, widget.selectedScale);
    _fetchItems();
  }

  void _fetchItems() {
    _noteNotifier.changeNoteAndScale(widget.selectedNote, widget.selectedScale);
    // Depending on whether to show notes or chords, we fetch the respective list
    if (widget.showChords) {
      _items = _noteNotifier.getChords().map((chord) => '${chord.number} ${chord.root}${chord.type}').toList();
    } else {
      _items = _noteNotifier.getNotes();
    }
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant ScaleListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedNote != widget.selectedNote ||
        oldWidget.selectedScale != widget.selectedScale ||
        oldWidget.showChords != widget.showChords) {
      _fetchItems();
    }
  }

  @override
  void dispose() {
    _noteNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Building ScaleListWidget");
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.showChords ? 'Chords of the Scale' : 'Notes of the Scale',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 200,
            height: 30,
            child: ListView.builder(
              scrollDirection: Axis.horizontal, // Set scroll direction to horizontal
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                      _items[index],
                      style: const TextStyle(fontSize: 16),
                    ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
