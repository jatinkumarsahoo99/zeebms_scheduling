// Helper widget, to dispatch Notifications when a right-click is detected on some child
import 'package:flutter/widgets.dart';

import '../../focusable.dart';
import '../context_menus.dart';

/// Wraps any widget in a GestureDetector and calls [ContextMenuOverlay].show
class ContextMenuRegion extends StatelessWidget {
  const ContextMenuRegion(
      {Key? key,
      required this.child,
      required this.contextMenu,
      required this.onTapClick,
      this.onSecondaryTap,
      this.onDoubleTapPress,
      this.onLongPress,
      this.isEnabled = true,
      this.enableLongPress = true})
      : super(key: key);
  final Widget child;
  final Widget contextMenu;
  final Function onTapClick;
  final Function? onDoubleTapPress;
  final Function? onLongPress;
  final Function? onSecondaryTap;
  final bool isEnabled;
  final bool enableLongPress;
  @override
  Widget build(BuildContext context) {
    void showMenu() {
      // calculate widget position on screen
      context.contextMenuOverlay.show(contextMenu);
    }

    if (isEnabled == false) return child;
    return FadButton(
      child: child,
      onTapClick: () {
        onTapClick();
      },
      onDoubleTapPress: () {
        if (onDoubleTapPress != null) {
          onDoubleTapPress!();
        }
      },
      onSecondaryPress: (){
        if(onSecondaryTap!=null) {
          onSecondaryTap!();
        }
        showMenu();
      } ,
      // onLongPress: enableLongPress ? showMenu : null,
      onLongPress: () {
        if (onLongPress != null) {
          onLongPress!();
        }
      },
    );
    // return GestureDetector(
    //   behavior: HitTestBehavior.translucent,
    //   onTap: (){
    //     onTapClick();
    //   },
    //   onDoubleTap: (){
    //     if(onDoubleTapPress!=null) {
    //       onDoubleTapPress!();
    //     }
    //   },
    //   onSecondaryTap: showMenu,
    //   // onLongPress: enableLongPress ? showMenu : null,
    //   onLongPress: (){
    //     if(onLongPress!=null){
    //       onLongPress!();
    //     }
    //   },
    //   child: child,
    // );
  }
}
