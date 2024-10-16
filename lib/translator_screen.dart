import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:language_translator/language_model.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator/translator.dart';
import 'package:flutter_tts/flutter_tts.dart';



class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({super.key});

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  
  bool startVoiceToText = false;
  TextEditingController inputTextController = TextEditingController();
  TextEditingController outputTextController = TextEditingController();

  String fromLanguage = "en";
  String toLanguage = "bn";

  List<Language> languages = [
    Language("English", "en"),
    Language("Bengali", "bn"),
    Language("Spanish", "es"),
    Language("French", "fr"),
    Language("German", "de"),
    Language("Chinese", "zh"),
    Language("Hindi", "hi"),
    Language("Arabic", "ar"),
    Language("Russian", "ru"),
    Language("Japanese", "ja"),
    Language("Portuguese", "pt"),
    Language("Italian", "it"),
    Language("Korean", "ko"),
    Language("Turkish", "tr"),
  ];

  Future<void> translate() async {
    await GoogleTranslator()
        .translate(inputTextController.text, from: fromLanguage, to: toLanguage)
        .then((s) {
      outputTextController.text = s.text;
      setState(() {});
    });
  }


  Future<void> speechToText()async{

    startVoiceToText = !startVoiceToText;
    setState(() {});

    SpeechToText speech = SpeechToText();
    if(startVoiceToText){
      bool available = await speech.initialize();
      if ( available ) {
          speech.listen( 
            // ignore: deprecated_member_use
            onResult: (value){
            inputTextController.text = value.recognizedWords;
            setState(() {});
          });
      }
      else {
          print("The user has denied the use of speech recognition.");
      }
    }else{
        // some time later...
        speech.stop();
    }
  }

  Future textToSpeak() async{
      FlutterTts flutterTts = FlutterTts();
      var result = await flutterTts.speak(outputTextController.text);
      //if (result == 1) setState(() => ttsState = TtsState.playing);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Language Translate",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownButton<String>(

                          value: fromLanguage,
                          padding: EdgeInsets.zero,
                          underline: Container(),
                          items: languages
                              .map((e) => DropdownMenuItem<String>(
                                    value: e.code,
                                    child: Text(e.name),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            fromLanguage = value!;
                            setState(() {});
                          }),
                      const Icon(Icons.swap_horiz_rounded),
                      DropdownButton<String>(
                          value: toLanguage,
                          padding: EdgeInsets.zero,
                          underline: Container(),
                          items: languages
                              .map((e) => DropdownMenuItem<String>(
                                    value: e.code,
                                    child: Text(e.name),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            toLanguage = value!;
                            setState(() {});
                          }),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),



              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    languages
                        .singleWhere(
                            (language) => language.code == fromLanguage)
                        .name,
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  const Spacer(),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                        highlightColor: Colors.blue,
                        onPressed: () async {
                          ClipboardData? clipboardData =
                              await Clipboard.getData(Clipboard.kTextPlain);
                          inputTextController.text =
                              clipboardData?.text ?? "No Text";

                          translate();    
                        },
                        icon: const Icon(Icons.paste_rounded)),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                        highlightColor: Colors.blue,
                        onPressed: () {
                            speechToText();
                        },
                        icon: Icon(
                          Icons.keyboard_voice_rounded,
                          color: startVoiceToText ? Colors.red : null,
                        )),
                  ),
                ],
              ),


              const SizedBox(
                height: 5,
              ),



              TextFormField(
                controller: inputTextController,
                minLines: 5,
                maxLines: 10,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                    hintText: "Type your text here...",
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 2,
                        )),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 2,
                        )),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2,
                        ))),
              ),



              const SizedBox(
                height: 10,
              ),



              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    languages
                        .singleWhere((language) => language.code == toLanguage)
                        .name,
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  const Spacer(),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                        highlightColor: Colors.blue,
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: outputTextController.text));
                        },
                        icon: const Icon(Icons.copy)),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                        highlightColor: Colors.blue,
                        onPressed: () {
                          textToSpeak();
                        },
                        icon: const Icon(Icons.volume_up)),
                  ),
                ],
              ),


              const SizedBox(
                height: 5,
              ),


              TextFormField(
                controller: outputTextController,
                minLines: 5,
                maxLines: 10,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                    hintText: "Result text...",
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 2,
                        )),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 2,
                        )),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2,
                        ))),
              ),
              
              const SizedBox(
                height: 20,
              ),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => translate(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  child: const Text(
                    "Translate",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )


            ],
          ),
        ),
      ),
    );
  }
}
