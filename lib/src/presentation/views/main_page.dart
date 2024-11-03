import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/main_page/main_page_cubit.dart';
import '../../config/router/app_router.dart';
import '../../locator.dart'; // Import locator

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
        backgroundColor: Colors.deepPurple,
      ),
      body: BlocProvider(
        create: (_) => MainPageCubit(locator<Dio>())
          ..fetchItems(), // Pass Dio instance from locator
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Search Movies',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (query) =>
                    context.read<MainPageCubit>().filterItems(query),
              ),
            ),
            Expanded(
              child: BlocBuilder<MainPageCubit, MainPageState>(
                builder: (context, state) {
                  if (state is MainPageLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is MainPageError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else if (state is MainPageLoaded) {
                    return ListView.builder(
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            state.items[index],
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios,
                              color: Colors.deepPurple),
                          onTap: () => context.router.push(
                            DetailPageRoute(item: state.items[index]),
                          ),
                        );
                      },
                    );
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
