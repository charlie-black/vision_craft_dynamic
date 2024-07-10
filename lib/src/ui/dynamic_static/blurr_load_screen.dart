part of craft_dynamic;

class BlurrLoadScreen extends StatefulWidget {
  final Widget mainWidget;
  const BlurrLoadScreen({super.key, required this.mainWidget});

  @override
  State<StatefulWidget> createState() => _BlurrLoadScreenState();
}

class _BlurrLoadScreenState extends State<BlurrLoadScreen> {
  @override
  Widget build(BuildContext context) => Stack(
        fit: StackFit.expand,
        children: [
          widget.mainWidget,
          Obx(() => isCallingService.value
              ? ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 0.6, sigmaY: 0.6),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12.0)),
                          color: Colors.grey.shade200.withOpacity(.4)),
                    ),
                  ),
                )
              : const SizedBox()),
          Obx(() => isCallingService.value
              ? Positioned(
                  right: 0,
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: LoadUtil(),
                )
              : const SizedBox()),
        ],
      );
}
