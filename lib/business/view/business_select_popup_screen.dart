import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeya_hackthon_a/business/model/business_model.dart';
import 'package:seeya_hackthon_a/business/provider/business_provider.dart';
import 'package:seeya_hackthon_a/user/provider/user_provider.dart';

class BusinessSelectPopupScreen extends ConsumerStatefulWidget {
  const BusinessSelectPopupScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<BusinessSelectPopupScreen> createState() => _BusinessSelectPopupScreenState();
}

class _BusinessSelectPopupScreenState extends ConsumerState<BusinessSelectPopupScreen> {
  String? groupVal;

  @override
  Widget build(BuildContext context) {
    final businessModel = ref.read(userProvider)?.businessModel;

    return AlertDialog(
      title: Text("사업자 선택", style: TextStyle(fontSize: 20),),
      content: Container(
        height: MediaQuery.of(context).size.height / 2,
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: Container(
                  width: MediaQuery.of(context).size.width / 1,
                  child: Column(
                    children: [
                      RadioListTile(
                        title: Text("${businessModel?.businessTitle}"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${businessModel?.businessNumber}"),
                            Text("${businessModel?.businessCategory}"),
                            Text("${businessModel?.businessName}"),
                            Text("${businessModel?.businessAddress}"),
                          ],
                        ),
                        onChanged: (value) {
                          setState(() {
                            groupVal = value!;
                          });
                        },
                        groupValue: groupVal,
                        value: businessModel?.businessNumber,
                      ),
                    ],
                  ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      actions: <Widget>[
        Container(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); //창 닫기
            },
            child: Text("닫기"),
          ),
        ),
        Container(
          child: ElevatedButton(
            onPressed: () {
              ref.read(businessProvider.notifier).getBusinessByBusinessNumber(groupVal);

              Navigator.of(context).pop(); //창 닫기
            },
            child: Text("선택"),
          ),
        ),
      ],
    );
  }
}
