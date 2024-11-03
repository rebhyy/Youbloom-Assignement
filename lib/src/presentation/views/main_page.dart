import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/main_page/main_page_cubit.dart';
import '../../config/router/app_router.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Main Page')),
      body: BlocProvider(
        create: (_) => MainPageCubit()..fetchItems(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(labelText: 'Search'),
                onChanged: (query) =>
                    context.read<MainPageCubit>().filterItems(query),
              ),
            ),
            Expanded(
              child: BlocBuilder<MainPageCubit, List<String>>(
                builder: (context, items) {
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(items[index]),
                        onTap: () => context.router.push(
                          DetailPageRoute(
                              item: items[index]), 
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
