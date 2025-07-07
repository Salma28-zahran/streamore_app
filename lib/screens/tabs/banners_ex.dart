import 'package:flutter/material.dart';
import 'package:streamore_app/screens/tabs/banners_ex.dart';
import 'package:streamore_app/screens/tabs/banners_tab.dart';

class BannersContant extends StatefulWidget {
  final Folder folder;

  const BannersContant({super.key, required this.folder});

  @override
  _BannersContantState createState() => _BannersContantState();
}

class _BannersContantState extends State<BannersContant> {
  bool showAddBannerCard = false; 
  TextEditingController bannerController = TextEditingController();
  List<String> banners = []; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); 
          },
        ),
        title: Text(
          widget.folder.name ?? 'Untitled Folder',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              setState(() {
                showAddBannerCard = !showAddBannerCard; 
              });
            },
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (banners.isNotEmpty)
              ...banners.map((banner) {
                return ListTile(
                  title: Text(banner),
                  trailing: Icon(Icons.check, color: Colors.green),
                );
              }).toList(),

            if (showAddBannerCard)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    children: [
                      TextField(
                        controller: bannerController,
                        decoration: InputDecoration(
                          hintText: 'Banner Content',
                          hintStyle: TextStyle(color: Colors.black38),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                showAddBannerCard = false; 
                              });
                            },
                            child: Text(
                              "Cancel",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (bannerController.text.trim().isNotEmpty) {
                                setState(() {
                                  banners.add(bannerController.text.trim());
                                  bannerController.clear();
                                  showAddBannerCard = false; 
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
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
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showFolderContent(BuildContext context, Folder folder) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                folder.name ?? 'Untitled Folder',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ...banners.map((banner) {
                return ListTile(
                  title: Text(banner),
                  subtitle: Text("Click to show on screen"),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}
