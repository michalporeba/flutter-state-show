import 'package:flutter/material.dart';
// import 'starting_point.dart';
// import 'statefull_direct.dart';
// import 'scoped_poco.dart';
// import 'scoped_state.dart';
// import 'redux.dart';
import 'bloc.dart';

void main() {
  runApp(const SampleStateApp(home: Home()));
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Experiments with state',
        theme: ThemeData(
          primarySwatch: Colors.grey
        ),
        home:  Scaffold(
          appBar: AppBar(title: const Text('state management example')),
          body: SafeArea(
            child: Center(
              child: Column(
                children: [
                  const Spacer(),
                  const Padding(
                    padding: EdgeInsets.all(32),
                    child: TheSquare(),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        const MySlider(attribute: 'width'),
                        const MySlider(attribute: 'height'),
                        const Padding(padding: EdgeInsets.all(8)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children:const [
                            ColorButton(color: Colors.red, label: 'red'),
                            ColorButton(color: Colors.green, label: 'green'),
                            ColorButton(color: Colors.blue, label: 'blue')
                          ]
                        )
                      ]
                    )
                  ),
                ]
              )
            ),
          )
      )
    );
  }
}
