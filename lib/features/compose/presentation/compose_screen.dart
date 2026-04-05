import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../inbox/data/email_model.dart';
import '../../inbox/provider/email_provider.dart';
import '../provider/compose_provider.dart';

class ComposeScreen extends ConsumerStatefulWidget {
  const ComposeScreen({super.key});

  @override
  ConsumerState<ComposeScreen> createState() =>
      _ComposeScreenState();
}

class _ComposeScreenState extends ConsumerState<ComposeScreen> {

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(composeProvider.notifier).loadEmail();
    });
  }


  @override
  Widget build(BuildContext context) {
    final state = ref.watch(composeProvider);
    final notifier = ref.read(composeProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar:AppBar(
        backgroundColor:Colors.white,
        // elevation: 0,
        toolbarHeight: 60.0,
        // automaticallyImplyLeading: false,
        title: Row(
          children: [

            Expanded(child: SizedBox()),



            GestureDetector(
              onTap: (){
                final newEmail = Email(
                  id: DateTime.now().toString(),
                  sender: "Me",
                  subject: notifier.subjectController.text,
                  body: notifier.bodyController.text,
                  time: DateTime.now(),
                );

                ref.read(emailProvider.notifier).addEmail(newEmail);

                ref.invalidate(composeProvider);

                Navigator.pop(context); //  go back to inbox

              },
              child: Padding(
                padding: const EdgeInsets.only(right:15.0),
                child: Icon(Icons.send_outlined,color: Colors.black, size: 27.0,),
              ),
            ),

          ],
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
            children: [

              Row(
                children: [

                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 25.0, bottom: 15.0),
                    child: Text("From", style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.normal),),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0, left: 30.0, bottom: 15.0),
                      child: Text(state.email, style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.normal),),
                    ),
                  ),
                ],
              ),

              Container(
                height: 1.0,
                width: MediaQuery.of(context).size.width,
                color: HexColor("#D1D5DB"),
              ),

              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      children: [

                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20.0, left: 25.0, bottom: 15.0),
                            child: Text("To", style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.normal),),
                          ),
                        ),

                        Expanded(
                          flex: 6,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 7.0, left: 15.0, bottom: 5.0),
                            child: TextFormField(
                              controller: notifier.toController,
                              keyboardType: TextInputType.emailAddress,
                              cursorColor: Colors.black,
                              style: TextStyle(fontSize: 16.0, color: Colors.black),
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                hintText: "email",
                                hintStyle: TextStyle(
                                  color: HexColor("#ABABAB"),
                                  fontSize: 16.0,
                                ),
                                // REMOVE ALL BORDERS
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                counterText: '',
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),


                    Container(
                      height: 1.0,
                      width: MediaQuery.of(context).size.width,
                      color: HexColor("#D1D5DB"),
                    ),


                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, left: 15.0, bottom: 5.0, right: 20.0),
                      child: TextFormField(
                        controller: notifier.subjectController,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        maxLines: null,
                        minLines: 1,
                        cursorColor: Colors.black,
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                        textAlign: TextAlign.justify,
                        decoration: InputDecoration(
                          hintText: "Subject",
                          hintStyle: TextStyle(
                            color: HexColor("#ABABAB"),
                            fontSize: 16.0,
                          ),
                          // REMOVE ALL BORDERS
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          counterText: '',
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        ),
                      ),
                    ),


                    Container(
                      height: 1.0,
                      width: MediaQuery.of(context).size.width,
                      color: HexColor("#D1D5DB"),
                    ),



                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, left: 15.0, bottom: 5.0, right: 20.0),
                      child: TextFormField(
                        controller: notifier.bodyController,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        maxLines: null,
                        minLines: 1,
                        cursorColor: Colors.black,
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                        textAlign: TextAlign.justify,
                        decoration: InputDecoration(
                          hintText: "Compose email",
                          hintStyle: TextStyle(
                            color: HexColor("#ABABAB"),
                            fontSize: 16.0,
                          ),
                          // REMOVE ALL BORDERS
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          counterText: '',
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        ),
                      ),
                    ),


                  ],
                ),
              ),

              const SizedBox(height: 20),

            ],
          ),
      ),
    );
  }
}