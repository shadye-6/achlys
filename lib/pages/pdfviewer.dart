import 'dart:io';
import 'package:achlys/colorThemes/colors.dart';
import 'package:achlys/widgets/pdfdrawer.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PdfViewerPage extends StatefulWidget {
  final File file;

  const PdfViewerPage({super.key, required this.file});

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  late PdfViewerController _controller;
  bool _autoScroll = false;
  bool _isPaused = false;
  double scrollSpeed = 3.0;

  List<String> _favorites = [];
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _controller = PdfViewerController();
    _restoreLastPage();
    _loadFavorites();
  }

  Future<void> _restoreLastPage() async {
    final prefs = await SharedPreferences.getInstance();
    final lastPage = prefs.getInt('page_${widget.file.path}') ?? 1;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.jumpToPage(lastPage);
    });
  }

  Future<void> _saveCurrentPage(int page) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('page_${widget.file.path}', page);
  }

  void _startAutoScroll() async {
    while (_autoScroll && !_isPaused && mounted) {
      await Future.delayed(const Duration(milliseconds: 20));
      if (!_isPaused && mounted) {
        _controller.jumpTo(
          yOffset: _controller.scrollOffset.dy + scrollSpeed,
        );
      }
    }
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    _favorites = prefs.getStringList('favorite_pdfs') ?? [];
    setState(() {
      _isFavorite = _favorites.contains(widget.file.path);
    });
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_isFavorite) {
        _favorites.remove(widget.file.path);
      } else {
        if (_favorites.length >= 10) {
          _favorites.removeAt(0); // remove oldest
        }
        _favorites.add(widget.file.path);
      }
      _isFavorite = !_isFavorite;
    });
    await prefs.setStringList('favorite_pdfs', _favorites);
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      drawer: PdfViewerDrawer(
        autoScroll: _autoScroll,
        scrollSpeed: scrollSpeed,
        onToggleAutoScroll: (val) {
          setState(() {
            _autoScroll = val;
            if (_autoScroll) _startAutoScroll();
          });
        },
        onScrollSpeedChanged: (val) {
          setState(() {
            scrollSpeed = val;
          });
        },
        filePath: widget.file.path,
        onToggleFavorite: _toggleFavorite,
        isFavorite: _isFavorite,
      ),
      appBar: isLandscape
          ? null
          : AppBar(
              backgroundColor: colorThemes[0]['colorLight'],
              title: Center(
                child: Text(
                  widget.file.path.split('/').last,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(fontSize: 18, color: colorThemes[0]['colorDark']),
                ),
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close),
                color: colorThemes[0]['colorDark'],
              ),
              actions: [
                Builder(
                  builder: (context) => IconButton(
                    icon: Icon(Icons.more_vert, color: colorThemes[0]['colorDark']),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
              ],
            ),
      body: GestureDetector(
        onLongPressStart: (_) => setState(() => _isPaused = true),
        onLongPressEnd: (_) {
          setState(() => _isPaused = false);
          if (_autoScroll) _startAutoScroll();
        },
        child: SfPdfViewer.file(
          widget.file,
          controller: _controller,
          onPageChanged: (details) => _saveCurrentPage(details.newPageNumber),
        ),
      ),
    );
  }
}
