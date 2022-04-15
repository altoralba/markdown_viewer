import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';
import 'dart:js' as js;

class Editor extends StatefulWidget {
  const Editor({Key? key}) : super(key: key);

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  String title = '';
  String markdownBody = '';
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Write Blog Post'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 30,
              color: Theme.of(context).secondaryHeaderColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Markdown Formatting can be found here:',
                  ),
                  TextButton(
                      onPressed: () => js.context.callMethod('open',
                          ['https://www.markdownguide.org/basic-syntax/']),
                      child: const Text('Markdown Guide')),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 1, child: markdownEditor()),
                Expanded(flex: 1, child: markdownRender()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget markdownEditor() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          TextField(
              onChanged: (value) => setState(() => title = value),
              controller: titleController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal)),
                  labelText: 'Title',
                  prefixText: ' ')),
          const SizedBox(height: 15),
          MarkdownTextInput(
            (String value) => setState(() => markdownBody = value),
            markdownBody,
            label: 'Blog Post',
            maxLines: 20,
            actions: MarkdownType.values,
            controller: bodyController,
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              bodyController.clear();
            },
            child: const Text('Clear'),
          )
        ],
      ),
    );
  }

  Widget markdownRender() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title == ''
                ? Container()
                : Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            const SizedBox(height: 10.0),
            MarkdownBody(
              data: markdownBody,
              shrinkWrap: true,
            ),
          ],
        ),
      ),
    );
  }
}
