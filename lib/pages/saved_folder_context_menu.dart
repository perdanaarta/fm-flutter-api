
import 'package:flutter/material.dart';

class SavedFolderContextMenu extends StatelessWidget {
  final String folder;
  final VoidCallback onRename;
  final VoidCallback onDelete;

  const SavedFolderContextMenu({
    super.key,
    required this.folder,
    required this.onRename,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Manage "$folder"',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Rename'),
            onTap: onRename,
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Delete', style: TextStyle(color: Colors.red)),
            onTap: onDelete,
          ),
        ],
      ),
    );
  }
}
