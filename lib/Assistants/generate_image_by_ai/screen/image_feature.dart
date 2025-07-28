// ignore_for_file: unused_field, prefer_const_constructors, unused_element

// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

// import '../../controller/image_controller.dart';
import '../../../chat-with-ai-bot/widget/custom_btn.dart';
import '../aiImageProvider/generate_ai_imageProvider.dart';
import '../../../chat-with-ai-bot/helper/global.dart';
import '../../../chat-with-ai-bot/widget/custom_loading.dart';

class ImageFeature extends StatefulWidget {
  const ImageFeature({super.key});

  @override
  State<ImageFeature> createState() => _ImageFeatureState();
}

class _ImageFeatureState extends State<ImageFeature> {

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<GenerateAiImageprovider>(context);

    mq = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(title: const Text('AI Image Creator'), actions: [
           imageProvider.status == Status.complete
                ? IconButton(
                    padding: const EdgeInsets.only(right: 6),
                    onPressed: (){},
                    icon: Icon(Icons.share))
                : SizedBox(), 
        ]),
        floatingActionButton: imageProvider.status == Status.complete
            ? Padding(
                padding: const EdgeInsets.only(
                  right: 6,
                  bottom: 6,
                ),
                child: FloatingActionButton(
                    onPressed: () {},
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Icon(Icons.save_alt_rounded, size: 26)),
              )
            : const SizedBox(),
        body: ListView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(
                top: mq.height * .02,
                bottom: mq.height * .1,
                left: mq.width * .04,
                right: mq.width * .04
              ),
            children: [
              TextFormField(
                controller: imageProvider.imageController,
                textAlign: TextAlign.center,
                minLines: 2,
                maxLines: null,
                onTapOutside: (e) => FocusScope.of(context).unfocus(),
                decoration: InputDecoration(
                    hintText:
                        'Imagine something wonderful & innovative \n Type here & will create for you 😊',
                    hintStyle: TextStyle(fontSize: 14),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    )
                  ),
              ),
              //ai image
              Container(
                height: mq.height * .5,
                margin: EdgeInsets.symmetric(vertical: mq.height * .015),
                alignment: Alignment.center,
                child: _aiImage(imageProvider: imageProvider),
              ),
              
              CustomBtn(onTap: imageProvider.displayAiGeneratedImage, text: 'Create')
            ]));
  }

  Widget _aiImage({required GenerateAiImageprovider imageProvider}) => ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: switch (imageProvider.status) {
        Status.none =>
        Lottie.asset('assets/lottie/ai_play.json', height: mq.height * .3),
        Status.complete => imageProvider.generatedImage,
        Status.loading => const CustomLoading()
      });
}
