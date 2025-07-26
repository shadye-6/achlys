import 'dart:io';
import 'package:achlys/colorThemes/colors.dart';
import 'package:achlys/widgets/pdfdrawer.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p; // Add this import

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
  double scrollSpeed = 0.5;

  Set<String> _favorites = {};
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
    final favs = prefs.getStringList('favorite_pdfs') ?? [];
    final isFav = favs.contains(widget.file.path);

    setState(() {
      _favorites = favs.toSet();
      _isFavorite = isFav;
    });
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final currentPath = widget.file.path;
    bool newIsFavorite = _isFavorite;
    Set<String> newFavorites = Set.from(_favorites);

    if (_isFavorite) {
      newFavorites.remove(currentPath);
      newIsFavorite = false;
    } else {
      if (newFavorites.length >= 10) {
        newFavorites = newFavorites.skip(1).toSet(); // remove oldest
      }
      newFavorites.add(currentPath);
      newIsFavorite = true;
    }

    setState(() {
      _favorites = newFavorites;
      _isFavorite = newIsFavorite;
    });

    await prefs.setStringList('favorite_pdfs', _favorites.toList());
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
                  p.basename(widget.file.path), // Use p.basename
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
