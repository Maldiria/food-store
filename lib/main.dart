
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_food_store/app_router.dart';
import 'package:dio/dio.dart';

import 'package:flutter_food_store/bloc/auth/auth_bloc.dart';
import 'package:flutter_food_store/bloc/cart/cart_bloc.dart';
import 'package:flutter_food_store/bloc/category/category_cubit.dart';
import 'package:flutter_food_store/bloc/location/location_cubit.dart';
import 'package:flutter_food_store/bloc/order/order_cubit.dart';
import 'package:flutter_food_store/bloc/product/product_cubit.dart';
import 'package:flutter_food_store/bloc/product_populer/product_populer_cubit.dart';
import 'package:flutter_food_store/bloc/profile/profile_bloc.dart';
import 'package:flutter_food_store/bloc/slider/slider_cubit.dart';

import 'package:flutter_food_store/core/constants/app_config.dart';
import 'package:flutter_food_store/core/utils/auth_interceptor.dart';

import 'package:flutter_food_store/resource/remote/auth_remote_resource.dart';
import 'package:flutter_food_store/resource/remote/cart_remote_resource.dart';
import 'package:flutter_food_store/resource/remote/checkout_remote_resource.dart';
import 'package:flutter_food_store/resource/remote/home_remote_resource.dart';
import 'package:flutter_food_store/resource/remote/order_remote_resource.dart';
import 'package:flutter_food_store/resource/remote/profile_remote_resource.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final dio = Dio(BaseOptions(
    baseUrl: AppConfig.API_PATH,
  ));

  final homeRemoteResource = HomeRemoteResource(dio);
  final profileRemoteResource = ProfileRemoteResource(dio);
  final authRemoteResource = AuthRemoteResource(dio);
  final orderRemoteResource = OrderRemoteResource(dio);
  final cartRemoteResource = CartRemoteResource(dio);
  final checkoutRemoteResource = CheckoutRemoteResource(dio);

  final authBloc = AuthBloc(authRemoteResource)
    ..add(AuthEvent.checkLoginStatus());

  dio.interceptors.add(AuthInterceptor(authBloc));

  final appRouter = AppRouter(
    authBloc: authBloc,
    orderRemoteResource: orderRemoteResource,
    homeRemoteResource: homeRemoteResource,
    checkoutRemoteResource: checkoutRemoteResource,
  );

  runApp(MyApp(
    appRouter: appRouter,
    authBloc: authBloc,
    profileRemoteResource: profileRemoteResource,
    orderRemoteResource: orderRemoteResource,
    homeRemoteResource: homeRemoteResource,
    cartRemoteResource: cartRemoteResource,
    checkoutRemoteResource: checkoutRemoteResource,
  ));
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;
  final AuthBloc authBloc;
  final ProfileRemoteResource profileRemoteResource;
  final OrderRemoteResource orderRemoteResource;
  final HomeRemoteResource homeRemoteResource;
  final CartRemoteResource cartRemoteResource;
  final CheckoutRemoteResource checkoutRemoteResource;

  const MyApp({
    super.key,
    required this.appRouter,
    required this.authBloc,
    required this.profileRemoteResource,
    required this.orderRemoteResource,
    required this.homeRemoteResource,
    required this.cartRemoteResource,
    required this.checkoutRemoteResource,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: authBloc),

        BlocProvider(
          create: (context) => ProfileBloc(profileRemoteResource),
        ),

        BlocProvider(
          create: (context) => OrderCubit(orderRemoteResource),
        ),

        BlocProvider(
          create: (context) => SliderCubit(homeRemoteResource)
            ..fecthSlider(),
        ),

        BlocProvider(
          create: (context) => CategoryCubit(homeRemoteResource)
            ..fetchCategory(),
        ),

        BlocProvider(
          create: (context) => ProductCubit(homeRemoteResource)
            ..fetchProduct(),
        ),

        BlocProvider(
          create: (context) => ProductPopulerCubit(homeRemoteResource)
            ..fetchProductPopuler(),
        ),

        BlocProvider(
          create: (context) => CartBloc(cartRemoteResource),
        ),

        // Provider untuk LocationCubit
        BlocProvider(
          create: (context) => LocationCubit(checkoutRemoteResource),
        ),
      ],
      child: MaterialApp.router(
        title: 'Food Store',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.grey.shade100,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.orange,
          ),
          useMaterial3: true,
        ),
        routerConfig: appRouter.router,
      ),
    );
  }
}
