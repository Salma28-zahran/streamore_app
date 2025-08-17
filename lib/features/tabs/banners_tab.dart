import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:streamore_app/core/provider/banners_provider.dart';


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
    final theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ----------------- FOLDERS SECTION -----------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Folders".tr(),
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: theme.textTheme.bodyLarge?.color, //Colors.grey
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                        onPressed: _addFolder,
                      ),
                      IconButton(
                        icon: Icon(
                          showFolders
                              ? Icons.keyboard_arrow_down_outlined
                              : Icons.keyboard_arrow_up_outlined,
                          color: theme.textTheme.bodyLarge?.color,
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
              if (showAddFolderCard) _buildAddFolderCard(),
              if (showFolders)
                ValueListenableBuilder<List<Folder>>(
                  valueListenable: folders,
                  builder: (context, folderList, _) {
                    if (folderList.isEmpty) {
                      return Text(
                        "no_folders_yet".tr(),
                        style: TextStyle(
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: folderList.length,
                      itemBuilder: (context, index) {
                        final folder = folderList[index];
                        return KeyedSubtree(
                          key: ValueKey("folder_$index"),
                          child: GestureDetector(
                            onTap: () {
                              Provider.of<BannersProvider>(
                                context,
                                listen: false,
                              ).setBFolderClicked(true);
                              DefaultTabController.of(context).animateTo(1);
                            },
                            child: _buildItemTile(
                              context,
                              title: folder.name,
                              count: folder.itemCount,
                              isEditing: folder.isEditing,
                              onSubmit: (value) => _submitFolderName(value),
                              onEdit:
                                  () => setState(() => folder.isEditing = true),
                              onRemove: () {
                                folderList.removeAt(index);
                                folders.notifyListeners();
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),

              const SizedBox(height: 24),

              /// ----------------- TICKERS SECTION -----------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "tickers".tr(),
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                        onPressed: _addTicker,
                      ),
                      IconButton(
                        icon: Icon(
                          showTickers
                              ? Icons.keyboard_arrow_down_outlined
                              : Icons.keyboard_arrow_up_outlined,
                          color: theme.textTheme.bodyLarge?.color,
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
              if (showAddTickerCard) _buildAddTickerCard(),
              if (showTickers)
                ValueListenableBuilder<List<TickerItem>>(
                  valueListenable: tickers,
                  builder: (context, tickerList, _) {
                    if (tickerList.isEmpty) {
                      return Text(
                        "no_tickers_yet".tr(),
                        style: TextStyle(
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: tickerList.length,
                      itemBuilder: (context, index) {
                        final ticker = tickerList[index];
                        return KeyedSubtree(
                          key: ValueKey("ticker_$index"),
                          child: GestureDetector(
                            onTap: () {
                              Provider.of<BannersProvider>(
                                context,
                                listen: false,
                              ).setTFolderClicked(true);
                              DefaultTabController.of(context).animateTo(1);
                            },
                            child: _buildItemTile(
                              context,
                              title: ticker.name,
                              count: ticker.itemCount,
                              isEditing: ticker.isEditing,
                              onSubmit: (value) => _submitTickerName(value),
                              onEdit:
                                  () => setState(() => ticker.isEditing = true),
                              onRemove: () {
                                tickerList.removeAt(index);
                                tickers.notifyListeners();
                              },
                            ),
                          ),
                        );
                      },
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
      height: 90,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              Theme.of(context).textTheme.bodyLarge?.color ??
              Colors.grey.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.drag_indicator, color: Colors.grey),
          const SizedBox(width: 16),
          Icon(
            Icons.folder_outlined,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
          const SizedBox(width: 16),
          Expanded(
            child:
                isEditing
                    ? TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: "folder_name".tr(),
                        hintStyle: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
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
                          title ?? "Unnamed Folder",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$count ${'items'.plural(count)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                      ],
                    ),
          ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
            onSelected: (value) {
              if (value == 'edit'.tr()) {
                onEdit();
              } else if (value == 'remove'.tr()) {
                onRemove();
              }
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: 'edit'.tr(),
                    child: Row(
                      children: [
                        const Icon(Icons.edit, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text('edit'.tr()),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'remove'.tr(),
                    child: Row(
                      children: [
                        const Icon(Icons.delete, color: Colors.red),
                        const SizedBox(width: 8),
                        Text(
                          'remove'.tr(),
                          style: const TextStyle(color: Colors.red),
                        ),
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
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        border: Border.all(
          color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.grey,
        ),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Column(
        children: [
          TextField(
            controller: folderController,
            decoration: InputDecoration(
              hintText: "Folders".tr(),
              hintStyle: TextStyle(
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade600
                        : Colors.grey.shade400,
                fontWeight: FontWeight.bold,
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 3,
                horizontal: 12,
              ),
            ),
            style: TextStyle(
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.black
                      : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    showAddFolderCard = false;
                    folderController.clear();
                  });
                },
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Text(
                  "Cancel".tr(),
                  style: TextStyle(
                    color:
                        Theme.of(context).textTheme.bodyLarge?.color ??
                        Colors.grey,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  _submitFolderName(folderController.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Add".tr(),
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
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        border: Border.all(
          color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.grey,
        ),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Column(
        children: [
          TextField(
            controller: tickerController,
            decoration: InputDecoration(
              hintText: "Ticker Name".tr(),
              hintStyle: TextStyle(
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade600
                        : Colors.grey.shade400,
                fontWeight: FontWeight.bold,
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 3,
                horizontal: 12,
              ),
            ),
            style: TextStyle(
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.black
                      : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    showAddTickerCard = false;
                    folderController.clear();
                  });
                },
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Text(
                  "Cancel".tr(),
                  style: TextStyle(
                    color:
                        Theme.of(context).textTheme.bodyLarge?.color ??
                        Colors.grey,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  _submitTickerName(tickerController.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Add".tr(),
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