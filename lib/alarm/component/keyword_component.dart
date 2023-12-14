
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class KeywordComponent extends ConsumerStatefulWidget {
  const KeywordComponent({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() { return KeywordComponentState(); }
}

class KeywordComponentState extends ConsumerState<KeywordComponent> {

  KeywordComponentState();

  @override
  Widget build(BuildContext context) {
    return Row();
  }

}