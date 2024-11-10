import 'package:flutter/material.dart';
import '../../../../core/core.dart';
import '../../../magazines_details/presentation/screens/magazines_details_screen.dart';
import '../widgets/all_editions_list_view.dart';
import '../widgets/infinite_draggable_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    this.enableEntryAnimation = false,
    this.initialIndex = 0,
  });

  final bool enableEntryAnimation;
  final int initialIndex;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final List<Magazine> magazines = Magazine.fakeMagazinesList;
  late int currentIndex;

  @override
  void initState() {
    currentIndex = widget.initialIndex;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void openMagazineDetail(
    BuildContext context,
    int index,
  ) {
    setState(() => currentIndex = index);
    MagazinesDetailsScreen.push(
      context,
      magazines: magazines,
      index: currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ViceUIConsts.gradientDecoration,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _AppBar(),
        body: Column(
          children: [
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(ViceIcons.search),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'THE ARCHIVE',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
                child: InifiniteDraggableSlider(
              itemBuilder: (BuildContext context, int index) =>
                  MagazineCoverImage(
                      magazine: Magazine.fakeMagazinesList[index]),
              itemCount: Magazine.fakeMagazinesList.length,
            )),
            const SizedBox(height: 72),
            SizedBox(
              height: 140,
              child: AllEditionsListView(magazines: magazines),
            ),
            const SizedBox(height: 12),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: SizedBox(
            height: kToolbarHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(ViceIcons.home),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(ViceIcons.settings),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(ViceIcons.share),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(ViceIcons.heart),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSize {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      clipBehavior: Clip.none,
      title: Image.asset(
        'assets/img/vice/vice-logo.png',
        height: 30,
        color: Colors.white,
      ),
      actions: const [
        MenuButton(),
      ],
    );
  }

  @override
  Widget get child => this;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
