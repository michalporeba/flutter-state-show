# flutter-state-show

A simple application consisting of two sliders, a few buttons and a controlled by them square to show how different state management methods in flutter compare to each other. 

The application has the common starting point and layout, all defined in the `main.dart` regardless of the state implementation. To change the state implementation all is required is to change the imports. 

All the specific implementations follow the same file layout to make it easy to compare. 

This are the currently implementions

* [direct statefull](./flutter_state_show/lib/statefull_direct.dart) - widgets modifying each others state directly (an anti example).
* [scoped state - poco](./flutter_state_show/lib/scoped_poco.dart) - a simple exmaple of scoped state, but with a very simple POCO state object. 
* [scoped state - better model](./flutter_state_show/lib/scoped_state) - a better example of scoped state. 
* [redux](./flutter_state_show/lib/redux.dart) - state management the redux way. 
* [BLoC - cubit](./flutter_state_show/lib/cubit.dart) - the simpler of two BLoC options. 
* [BLoC - proper](./flutter_state_show/lib/bloc.dart) - the more complex and powerful of the BLoC state management approaches. 