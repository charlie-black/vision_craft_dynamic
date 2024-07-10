part of craft_dynamic;

class ListDataScreen extends StatelessWidget {
  final Widget widget;
  final String title;

  const ListDataScreen({super.key, required this.widget, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (() {
            Navigator.of(context).pop();
          }),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(title),
      ),
      body: widget,
    );
  }
}
