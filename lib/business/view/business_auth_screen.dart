import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seeya_hackthon_a/_common/layout/default_layout.dart';
import 'package:seeya_hackthon_a/business/provider/business_provider.dart';

class BusinessAuthScreen extends ConsumerStatefulWidget {
  const BusinessAuthScreen({super.key});

  @override
  ConsumerState<BusinessAuthScreen> createState() => _BusinessAuthScreenState();
}

class _BusinessAuthScreenState extends ConsumerState<BusinessAuthScreen> {
  final picker = ImagePicker();
  XFile? image; // 카메라로 촬영한 이미지를 저장할 변수

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(businessProvider);

    return DefaultLayout(
      sideBarOffYn: true,
      title: "사업자 계정 인증",
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
          child: Column(
            children: [
              // 사업자 등록번호
              TextFormField(
                onChanged: (value) {
                  state.businessNumber = value;
                },
                controller: TextEditingController(
                  text: state.businessNumber
                ),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  icon: Icon(Icons.onetwothree),
                  label: Text("사업자 등록번호"),
                ),
              ),

              // 상호명
              TextFormField(
                onChanged: (value) {
                  state.businessTitle = value;
                },
                controller: TextEditingController(
                  text: state.businessTitle
                ),
                decoration: const InputDecoration(
                  icon: Icon(Icons.abc),
                  label: Text("상호명"),
                ),
              ),

              // 주소
              TextFormField(
                onChanged: (value) {
                  state.businessAddress = value;
                },
                controller: TextEditingController(
                  text: state.businessAddress
                ),
                decoration: const InputDecoration(
                  icon: Icon(Icons.abc),
                  label: Text("주소"),
                ),
              ),

              // 업종
              TextFormField(
                onChanged: (value) {
                  state.businessCategory = value;
                },
                controller: TextEditingController(
                  text: state.businessCategory
                ),
                decoration: const InputDecoration(
                  icon: Icon(Icons.abc),
                  label: Text("업종"),
                ),
              ),
              
              // 대표자명
              TextFormField(
                onChanged: (value) {
                  state.businessName = value;
                },
                controller: TextEditingController(
                  text: state.businessName
                ),
                decoration: const InputDecoration(
                  icon: Icon(Icons.abc),
                  label: const Text("대표자명"),
                ),
              ),

              // 첨부 사진
              TextFormField(
                onTap: () async {
                  image = await picker.pickImage(source: ImageSource.gallery);
                  if(image != null) {
                    ref.read(businessProvider.notifier).uploadDocImage(image!.path);
                  }
                },
                decoration: const InputDecoration(
                  icon: Icon(Icons.photo),
                  label: Text("사업자등록증 사진 첨부"),
                ),
                readOnly: true,
                // readOnly: true,
              ),
              Container(
                height: MediaQuery.of(context).size.height / 2.75,
                child: state.businessImagePath == "none" || state.businessImagePath == null ? const Center(child: Text("사진을 첨부해주세요")) : Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
                  child: Image.file(File(state.businessImagePath ?? "none")),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      ref.read(businessProvider.notifier).cancelBusinessAuth(context);
                    },
                    child: const Text("취소")
                  ),
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(businessProvider.notifier).applyBusinessAuth(state, context).then(
                        (value) {
                          if(context.canPop()) {
                            context.pop();
                          }

                          if(state.applyState == "apply") {
                            Fluttertoast.showToast(
                              msg: "신청서가 접수되었습니다.\n인증까지 약 2~3일이 소요될 수 있습니다.",
                              gravity: ToastGravity.CENTER,
                              backgroundColor: Colors.white,
                              toastLength: Toast.LENGTH_LONG
                            );
                          }
                        }
                      );

                    }, 
                    child: const Text("인증 신청")
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
