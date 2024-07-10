// ignore_for_file: must_be_immutable

part of craft_dynamic;

class LoadUtil extends StatelessWidget {
  List<Color> colors;

  LoadUtil({super.key, this.colors = const []});

  @override
  Widget build(BuildContext context) => SpinKitWave(
        size: 54,
        itemBuilder: (BuildContext context, int index) {
          Color? isEvenColor, isOddColor;
          bool useCustomColor = false;
          if (colors.length >= 2) {
            isEvenColor = colors[0];
            isOddColor = colors[1];
            useCustomColor = true;
          }

          return DecoratedBox(
            decoration: BoxDecoration(
              color: index.isEven
                  ? useCustomColor
                      ? isEvenColor
                      : APIService.appSecondaryColor
                  : useCustomColor
                      ? isOddColor
                      : APIService.appPrimaryColor,
            ),
          );
        },
      );
}

class CircularLoadUtil extends StatelessWidget {
  List<Color> colors;

  CircularLoadUtil({super.key, this.colors = const []});

  @override
  Widget build(BuildContext context) => SpinKitCircle(
        size: 54,
        itemBuilder: (BuildContext context, int index) {
          Color? isEvenColor, isOddColor;
          bool useCustomColor = false;
          if (colors.length >= 2) {
            isEvenColor = colors[0];
            isOddColor = colors[1];
            useCustomColor = true;
          }

          return DecoratedBox(
            decoration: BoxDecoration(
              color: index.isEven
                  ? useCustomColor
                      ? isEvenColor
                      : APIService.appSecondaryColor
                  : useCustomColor
                      ? isOddColor
                      : APIService.appPrimaryColor,
            ),
          );
        },
      );
}

class ThreeLoadUtil extends StatelessWidget {
  List<Color> colors;
  double? size;

  ThreeLoadUtil({super.key, this.colors = const [], this.size});

  @override
  Widget build(BuildContext context) => SpinKitThreeBounce(
        size: size ?? 28,
        itemBuilder: (BuildContext context, int index) {
          Color? isEvenColor, isOddColor;
          bool useCustomColor = false;
          if (colors.length >= 2) {
            isEvenColor = colors[0];
            isOddColor = colors[1];
            useCustomColor = true;
          }

          return DecoratedBox(
            decoration: BoxDecoration(
              color: index.isEven
                  ? useCustomColor
                      ? isEvenColor
                      : APIService.appSecondaryColor
                  : useCustomColor
                      ? isOddColor
                      : APIService.appPrimaryColor,
            ),
          );
        },
      );
}

class PulseLoadUtil extends StatelessWidget {
  List<Color> colors;
  double? size;

  PulseLoadUtil({super.key, this.colors = const [], this.size});

  @override
  Widget build(BuildContext context) => SpinKitPulse(
        size: size ?? 28,
        itemBuilder: (BuildContext context, int index) {
          Color? isEvenColor, isOddColor;
          bool useCustomColor = false;
          if (colors.length >= 2) {
            isEvenColor = colors[0];
            isOddColor = colors[1];
            useCustomColor = true;
          }

          return DecoratedBox(
            decoration: BoxDecoration(
              color: index.isEven
                  ? useCustomColor
                      ? isEvenColor
                      : APIService.appSecondaryColor
                  : useCustomColor
                      ? isOddColor
                      : APIService.appPrimaryColor,
            ),
          );
        },
      );
}

class EmptyUtil extends StatelessWidget {
  String? text;

  EmptyUtil({super.key, this.text});

  @override
  Widget build(BuildContext context) => Center(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "packages/craft_dynamic/assets/images/empty.png",
            height: 64,
            width: 64,
            fit: BoxFit.cover,
          ),
          const SizedBox(
            height: 14,
          ),
          Text(
            text ?? "Nothing found!",
            style: TextStyle(color: Theme.of(context).primaryColor),
          )
        ],
      ));
}

class GlobalLoader extends StatelessWidget {
  const GlobalLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          color: Theme.of(context).primaryColor.withOpacity(.1),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularLoadUtil(),
              const SizedBox(
                height: 12,
              ),
              const Text(
                "Please wait...",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              )
            ],
          )),
        ));
  }
}
