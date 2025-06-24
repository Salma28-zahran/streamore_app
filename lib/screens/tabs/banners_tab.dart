import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Folder {
  String? name;
  int itemCount;
  bool isEditing;

  Folder({this.name, this.isEditing = true, this.itemCount = 0});
}

class TickerItem {
  String? name;
  int itemCount;
  bool isEditing;

  TickerItem({this.name, this.isEditing = true, this.itemCount = 0});
}

class BannersTab extends StatefulWidget {
  const BannersTab({super.key});
  static const String routeName = "/banners";

  @override
  State<BannersTab> createState() => _BannersTabState();
}

class _BannersTabState extends State<BannersTab> {
  final ValueNotifier<List<Folder>> folders = ValueNotifier([]);
  final ValueNotifier<List<TickerItem>> tickers = ValueNotifier([]);

  bool showFolders = true;
  bool showTickers = true;

  void _addFolder() {
    folders.value = [...folders.value, Folder()];
  }

  void _submitFolderName(int index, String value) {
    folders.value[index].name = value;
    folders.value[index].isEditing = false;
    folders.notifyListeners();
  }

  void _addTicker() {
    tickers.value = [...tickers.value, TickerItem()];
  }

  void _submitTickerName(int index, String value) {
    tickers.value[index].name = value;
    tickers.value[index].isEditing = false;
    tickers.notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Folders section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Folders",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: Theme.of(context).appBarTheme.foregroundColor,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add, color: Colors.black),
                        onPressed: _addFolder,
                      ),
                      IconButton(
                        icon: Icon(
                          showFolders
                              ? Icons.keyboard_arrow_up_outlined
                              : Icons.keyboard_arrow_down_outlined,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            showFolders = !showFolders;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (showFolders)
                ValueListenableBuilder<List<Folder>>(
                  valueListenable: folders,
                  builder: (context, folderList, _) {
                    if (folderList.isEmpty) {
                      return const Text("No folders yet");
                    }
                    return SizedBox(
                      height: folderList.length * 86,
                      child: ReorderableListView.builder(
                        itemCount: folderList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        onReorder: (oldIndex, newIndex) {
                          if (newIndex > oldIndex) newIndex -= 1;
                          final item = folderList.removeAt(oldIndex);
                          folderList.insert(newIndex, item);
                          folders.notifyListeners();
                        },
                        itemBuilder: (context, index) {
                          final folder = folderList[index];
                          return KeyedSubtree(
                            key: ValueKey("folder_$index"),
                            child: _buildItemTile(
                              context,
                              title: folder.name,
                              count: folder.itemCount,
                              isEditing: folder.isEditing,
                              onSubmit: (value) =>
                                  _submitFolderName(index, value),
                              onEdit: () =>
                                  setState(() => folder.isEditing = true),
                              onRemove: () {
                                folderList.removeAt(index);
                                folders.notifyListeners();
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              const SizedBox(height: 24),
          
              // Tickers section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tickers",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: Theme.of(context).appBarTheme.foregroundColor,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add, color: Colors.black),
                        onPressed: _addTicker,
                      ),
                      IconButton(
                        icon: Icon(
                          showTickers
                              ? Icons.keyboard_arrow_up_outlined
                              : Icons.keyboard_arrow_down_outlined,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            showTickers = !showTickers;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 3),
              if (showTickers)
                ValueListenableBuilder<List<TickerItem>>(
                  valueListenable: tickers,
                  builder: (context, tickerList, _) {
                    if (tickerList.isEmpty) {
                      return const Text("No tickers yet");
                    }
                    return SizedBox(
                      height: tickerList.length * 86,
                      child: ReorderableListView.builder(
                        itemCount: tickerList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        onReorder: (oldIndex, newIndex) {
                          if (newIndex > oldIndex) newIndex -= 1;
                          final item = tickerList.removeAt(oldIndex);
                          tickerList.insert(newIndex, item);
                          tickers.notifyListeners();
                        },
                        itemBuilder: (context, index) {
                          final ticker = tickerList[index];
                          return KeyedSubtree(
                            key: ValueKey("ticker_$index"),
                            child: _buildItemTile(
                              context,
                              title: ticker.name,
                              count: ticker.itemCount,
                              isEditing: ticker.isEditing,
                              onSubmit: (value) =>
                                  _submitTickerName(index, value),
                              onEdit: () =>
                                  setState(() => ticker.isEditing = true),
                              onRemove: () {
                                tickerList.removeAt(index);
                                tickers.notifyListeners();
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemTile(
      BuildContext context, {
        required String? title,
        required int count,
        required bool isEditing,
        required Function(String) onSubmit,
        required VoidCallback onEdit,
        required VoidCallback onRemove,
      }) {
    return Container(
      width: double.infinity,
      height: 70,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.drag_handle, color: Colors.grey),
          const SizedBox(width: 8),
          const Icon(Icons.folder_outlined, color: Colors.black),
          const SizedBox(width: 12),
          Expanded(
            child: isEditing
                ? TextField(
              autofocus: true,
              decoration: const InputDecoration(
                hintText: "Name...",
                border: InputBorder.none,
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  onSubmit(value);
                }
              },
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title ?? "Unnamed",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$count item${count == 1 ? '' : 's'}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onSelected: (value) {
              if (value == 'edit') {
                onEdit();
              } else if (value == 'remove') {
                onRemove();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Colors.grey),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'remove',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Remove', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
