import 'package:flutter/material.dart';
import 'package:accordion_widget/accordion_widget.dart';

void main() => runApp(ExampleApp());

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Accordion Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accordion Demo'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(18),
              child: Text(
                'Это пример аккордиона с иконкой, расположенной справа: ',
              ),
            ),
            Divider(height: 1),
            AccordionWidget(
              title: Text(
                'Sample 1',
              ),
              child: SampleContent(),
              iconLocation: AccordionWidgetIconLocation.Right,
            ),
            Divider(height: 1),
            Padding(
              padding: EdgeInsets.all(18),
              child: Text(
                'Это пример аккордиона с иконкой, расположенной слева: ',
              ),
            ),
            Divider(height: 1),
            AccordionWidget(
              title: Text(
                'Sample 2',
              ),
              child: SampleContent(),
              iconLocation: AccordionWidgetIconLocation.Left,
            ),
            Divider(height: 1),
          ],
        ),
      ),
    );
  }
}

class SampleContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Image.asset('image.png'),
    );
  }
}
