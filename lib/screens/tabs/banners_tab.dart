import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streamore_app/screens/tabs/banners_ex.dart';

class Folder {
  String? name;
  int itemCount;
  bool isEditing;

  Folder({this.name, this.isEditing = false, this.itemCount = 0});
}

class TickerItem {
  String? name;
  int itemCount;
  bool isEditing;

  TickerItem({this.name, this.isEditing = false, this.itemCount = 0});
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
  bool showAddFolderCard = false;
  bool showAddTickerCard = false;

  TextEditingController folderController = TextEditingController();
  TextEditingController tickerController = TextEditingController();

  void _addFolder() {
    setState(() {
      showAddFolderCard = true;
    });
  }

  void _addTicker() {
    setState(() {
      showAddTickerCard = true;
    });
  }

  void _submitFolderName(String value) {
    if (value.trim().isNotEmpty) {
      final newFolder = Folder(name: value);
      folders.value = [...folders.value, newFolder];
      folderController.clear();
      setState(() {
        showAddFolderCard = false;
      });
    }
  }

  void _submitTickerName(String value) {
    if (value.trim().isNotEmpty) {
      final newTicker = TickerItem(name: value);
      tickers.value = [...tickers.value, newTicker];
      tickerController.clear();
      setState(() {
        showAddTickerCard = false;
      });
    }
  }

  @override
void dispose() {
  folderController.dispose();
  tickerController.dispose();
  super.dispose();
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
                    "Banners".tr(),
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
              if (showAddFolderCard)
                _buildAddFolderCard(),
              if (showFolders)
                ValueListenableBuilder<List<Folder>>(
  valueListenable: folders,
  builder: (context, folderList, _) {
    if (folderList.isEmpty) {
      return Text("no_folders_yet".tr());
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
            key: ValueKey("folder_$index".tr()),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => BannersContant(folder: folder),
  ),
);

              },
              child: _buildItemTile(
                context,
                title: folder.name,
                count: folder.itemCount,
                isEditing: folder.isEditing,
                onSubmit: (value) => _submitFolderName(value),
                onEdit: () => setState(() => folder.isEditing = true),
                onRemove: () {
                  folderList.removeAt(index);
                  folders.notifyListeners();
                },
              ),
            ),
          );
        },
      ),
    );
  },
),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "tickers".tr(),
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
              if (showAddTickerCard)
                _buildAddTickerCard(),
              if (showTickers)
                ValueListenableBuilder<List<TickerItem>>(
                  valueListenable: tickers,
                  builder: (context, tickerList, _) {
                    if (tickerList.isEmpty) {
                      return Text("no_tickers_yet".tr());
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
                            key: ValueKey("ticker_$index".tr()),
                            child: _buildItemTile(
                              context,
                              title: ticker.name,
                              count: ticker.itemCount,
                              isEditing: ticker.isEditing,
                              onSubmit: (value) =>
                                  _submitTickerName(value),
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
                    decoration: InputDecoration(
                      hintText: "name".tr(),
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
                        title ?? "unnamed".tr(),
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
              if (value == 'edit'.tr()) {
                onEdit();
              } else if (value == 'remove'.tr()) {
                onRemove();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit'.tr(),
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Colors.grey),
                    SizedBox(width: 8),
                    Text('edit'.tr()),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'remove'.tr(),
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('remove'.tr(), style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddFolderCard() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          TextField(
            controller: folderController,
            decoration: InputDecoration(
              hintText: "Folder Name",
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.zero, 
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    showAddFolderCard = false;
                  });
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _submitFolderName(folderController.text); 
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, 
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero, 
                  ),
                ),
                child: Text(
                  "Add",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddTickerCard() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          TextField(
            controller: tickerController,
            decoration: InputDecoration(
              hintText: "Ticker Name",
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.zero, 
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    showAddTickerCard = false;
                  });
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _submitTickerName(tickerController.text); 
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, 
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero, 
                  ),
                ),
                child: Text(
                  "Add",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
