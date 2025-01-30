import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const CryptoCurrenciesApp());
}

class CryptoCurrenciesApp extends StatelessWidget {
  const CryptoCurrenciesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CryptoCurrencies',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
            backgroundColor: const Color.fromARGB(255, 23, 21, 21),
            titleTextStyle: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
            scrolledUnderElevation: 0.0),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.yellow,
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 35, 31, 31),
        useMaterial3: true,
        dividerColor: Colors.white10,
        textTheme: TextTheme(
          bodyMedium: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
          bodySmall: TextStyle(
              // ignore: deprecated_member_use
              color: Colors.white.withOpacity(0.4),
              fontSize: 14,
              fontWeight: FontWeight.w700),
        ),
      ),
      home: const MyHomePage(title: 'Crypto Currencies'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        primary: true,
      ),
      body: ListView.separated(
          itemCount: 10,
          separatorBuilder: (context, i) => Divider(
                color: Theme.of(context).dividerColor,
              ),
          itemBuilder: (context, i) => ListTile(
                leading: SvgPicture.asset(
                  'assets/bitcoin.svg',
                  width: 40,
                  height: 40,
                ),
                title: Text("Bitcoin",
                    style: Theme.of(context).textTheme.bodyMedium),
                subtitle: Text(
                  "200000\$",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                trailing: Icon(Icons.arrow_forward_ios),
              )),
    );
  }
}
