part of craft_dynamic;

class SearchModuleScreen extends StatefulWidget {
  const SearchModuleScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SearchModuleScreenState();
}

class _SearchModuleScreenState extends State<SearchModuleScreen> {
  final _moduleRepository = ModuleRepository();
  final _searchController = TextEditingController();

  searchModules(String moduleName) =>
      _moduleRepository.searchModuleItem(moduleName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            child: WidgetFactory.buildTextField(
                context,
                TextFormFieldProperties(
                    autofocus: true,
                    isEnabled: true,
                    controller: _searchController,
                    textInputType: TextInputType.text,
                    onChange: (value) {
                      if (value != null && value.length >= 2) {
                        setState(() {});
                      }
                    },
                    inputDecoration: const InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(color: Colors.transparent)),
                        hintText: "Search item",
                        suffixIcon: Icon(Icons.search),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 12,
                        ))),
                (p0) => null)),
      ),
      body: FutureBuilder<List<ModuleItem>>(
        future: searchModules(_searchController.text),
        builder:
            (BuildContext context, AsyncSnapshot<List<ModuleItem>> snapshot) {
          Widget child = const Center(
            child: Text("Start typing to search for items"),
          );

          if (snapshot.hasData) {
            List<ModuleItem>? modules = snapshot.data;
            if (modules != null && modules.isNotEmpty) {
              child = GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  itemCount: modules.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 4,
                      childAspectRatio: 16 / 16,
                      crossAxisCount: 3),
                  itemBuilder: (context, index) => ModuleItemWidget(
                      moduleItem: modules[index], isSearch: true));
            } else {
              if (_searchController.text.length >= 2) {
                child = const Center(
                  child: Text("No items were found!"),
                );
              }
            }
          }
          return child;
        },
      ),
    );
  }
}
