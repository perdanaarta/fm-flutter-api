import 'package:flutter/material.dart';
import 'package:flutter_api/pages/saved_folder_context_menu.dart';
import '../services/saved_news_service.dart';
import '../models/news_article.dart';
import 'news_card.dart';

class SavedNewsPage extends StatefulWidget {
  const SavedNewsPage({super.key});

  @override
  State<SavedNewsPage> createState() => _SavedNewsPageState();
}

class _SavedNewsPageState extends State<SavedNewsPage> {
  late Future<List<String>> _folders = SavedNewsService.getFolders();
  String? _selectedFolder;

  @override
  void initState() {
    super.initState();
    _folders = SavedNewsService.getFolders();
    _loadFolders();
  }

  void _loadFolders() async {
    final folders = await SavedNewsService.getFolders();
    if (mounted) {
      setState(() {
        _folders = Future.value(folders);
        _selectedFolder = folders.isNotEmpty ? folders.first : null;
      });
    }
  }

  void _createNewFolder() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Create New Folder'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Folder name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (controller.text.isNotEmpty) {
                  Navigator.pop(dialogContext);
                  await SavedNewsService.createFolder(controller.text);
                  if (mounted) {
                    _loadFolders();
                  }
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _deleteFolder(String folder) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Folder'),
        content: Text(
          'Delete folder "$folder"? Articles will be moved to Default folder.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await SavedNewsService.deleteFolder(folder);
              if (mounted) {
                _loadFolders();
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _renameFolder(String folder) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final controller = TextEditingController(text: folder);
        return AlertDialog(
          title: const Text('Rename Folder'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'New folder name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (controller.text.isNotEmpty && controller.text != folder) {
                  Navigator.pop(dialogContext);
                  await SavedNewsService.renameFolder(folder, controller.text);
                  if (mounted) {
                    _loadFolders();
                  }
                }
              },
              child: const Text('Rename'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved News'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Clear All'),
                  content: const Text(
                    'Are you sure you want to delete all saved articles?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        SavedNewsService.clearAll();
                        _loadFolders();
                        Navigator.pop(context);
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: _folders,
        builder: (context, folderSnapshot) {
          if (folderSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!folderSnapshot.hasData || folderSnapshot.data!.isEmpty) {
            return const Center(child: Text('No folders'));
          }

          final folders = folderSnapshot.data!;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...folders.map((folder) {
                        final isSelected = _selectedFolder == folder;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: GestureDetector(
                            onLongPress: folder != 'Default'
                                ? () {
                                    final scaffoldContext = context;
                                    showModalBottomSheet(
                                      context: scaffoldContext,
                                      builder: (sheetContext) =>
                                          SavedFolderContextMenu(
                                            folder: folder,
                                            onRename: () {
                                              Navigator.pop(sheetContext);
                                              _renameFolder(folder);
                                            },
                                            onDelete: () {
                                              Navigator.pop(sheetContext);
                                              _deleteFolder(folder);
                                            },
                                          ),
                                    );
                                  }
                                : null,
                            child: FilterChip(
                              label: Text(folder),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedFolder = folder;
                                });
                              },
                            ),
                          ),
                        );
                      }),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ActionChip(
                          avatar: const Icon(Icons.add),
                          label: const Text('New Folder'),
                          onPressed: _createNewFolder,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: _selectedFolder != null
                    ? FutureBuilder<List<NewsArticle>>(
                        future: SavedNewsService.getSavedArticles(
                          _selectedFolder,
                        ),
                        builder: (context, articleSnapshot) {
                          if (articleSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (!articleSnapshot.hasData ||
                              articleSnapshot.data!.isEmpty) {
                            return const Center(
                              child: Text('No articles in this folder'),
                            );
                          }

                          final articles = articleSnapshot.data!;
                          return ListView.builder(
                            itemCount: articles.length,
                            itemBuilder: (context, index) {
                              return NewsCard(
                                article: articles[index],
                                onSavedChanged: _loadFolders,
                              );
                            },
                          );
                        },
                      )
                    : const Center(child: Text('Select a folder')),
              ),
            ],
          );
        },
      ),
    );
  }
}
