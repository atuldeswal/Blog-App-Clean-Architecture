part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _ininBlog();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );

  // Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  serviceLocator.registerLazySingleton(() => supabase.client);

  // serviceLocator.registerLazySingleton(() => Hive.box(name: 'blogs'));

  serviceLocator.registerFactory(() => InternetConnection());

  // Core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(serviceLocator()),
  );
}

void _initAuth() {
  // Data Source
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImp(serviceLocator()),
    )
    // Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(serviceLocator(), serviceLocator()),
    )
    // Usecases
    ..registerFactory(() => UserSignUp(serviceLocator()))
    ..registerFactory(() => UserLogin(serviceLocator()))
    ..registerFactory(() => CurrentUser(serviceLocator()))
    // Bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}

void _ininBlog() {
  // Data Source
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(serviceLocator()),
    )
    // ..registerFactory<BlogLocalDataSource>(
    //   () => BlogLocalDataSourceImpl(serviceLocator()),
    // )
    // Repository
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
        // serviceLocator(),
      ),
    )
    // Usecases
    ..registerFactory(() => UploadBlog(serviceLocator()))
    ..registerFactory(() => GetAllBlogs(serviceLocator()))
    ..registerFactory(() => GetUserBlogs(serviceLocator()))
    ..registerFactory(() => LogoutUser(serviceLocator()))
    ..registerFactory(() => DeleteBlog(serviceLocator()))
    ..registerFactory(() => UpdateBlog(serviceLocator()))
    ..registerFactory(() => GetNextBlog(serviceLocator()))
    ..registerFactory(() => ToggleFavorite(serviceLocator()))
    ..registerFactory(() => GetFavoriteBlogs(serviceLocator()))
    ..registerFactory(() => DeleteUserAccount(serviceLocator()))
    ..registerFactory(() => UpdateUserProfile(serviceLocator()))
    ..registerFactory(() => GetUserProfile(serviceLocator()))
    ..registerFactory(() => FollowUser(serviceLocator()))
    ..registerFactory(() => UnfollowUser(serviceLocator()))
    ..registerFactory(() => GetFollowCount(serviceLocator()))
    ..registerFactory(() => IsFollowing(serviceLocator()))
    // Bloc
    ..registerLazySingleton(
      () => BlogBloc(
        uploadBlog: serviceLocator(),
        getAllBlogs: serviceLocator(),
        deleteBlog: serviceLocator(),
        updateBlog: serviceLocator(),
        toggleFavorite: serviceLocator(),
        getFavoriteBlogs: serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => ProfileBloc(
        getUserBlogs: serviceLocator(),
        logoutUser: serviceLocator(),
        deleteUserAccound: serviceLocator(),
        updateUserProfile: serviceLocator(),
        getUserProfile: serviceLocator(),
        followUser: serviceLocator(),
        unfollowUser: serviceLocator(),
        isFollowing: serviceLocator(),
        getFollowCount: serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => BlogNavigationCubit(getNextBlog: serviceLocator()),
    );
}
