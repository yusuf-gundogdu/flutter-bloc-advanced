import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc_advance/data/models/menu.dart';
import 'package:flutter_bloc_advance/data/repository/login_repository.dart';
import 'package:flutter_bloc_advance/data/repository/menu_repository.dart';
import 'package:flutter_bloc_advance/presentation/common_widgets/drawer/drawer_bloc/drawer.dart';
import 'package:flutter_bloc_advance/utils/menu_list_cache.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../test_utils.dart';
import 'drawer_bloc_test.mocks.dart';

/// BLoc Test for DrawerBloc
///
/// Tests: <p>
/// 1. State test <p>
/// 2. Event test <p>
/// 3. Bloc test <p>
@GenerateMocks([LoginRepository, MenuRepository])
void main() {
  //region setup
  late LoginRepository loginRepository;
  late MenuRepository menuRepository;

  setUpAll(() async {
    await TestUtils().setupUnitTest();
    loginRepository = MockLoginRepository();
    menuRepository = MockMenuRepository();
  });

  tearDown(() async {
    await TestUtils().tearDownUnitTest();
  });
  //endregion setup

  //region state
  /// Drawer State Tests
  group("DrawerState", () {
    const menus = [Menu(id: "test", name: "test")];
    const isLogout = false;

    test("supports value comparisons", () {
      expect(const DrawerState(menus: menus, isLogout: isLogout), const DrawerState(menus: menus, isLogout: isLogout));
    });

    test("DrawerState copyWith", () {
      expect(const DrawerState().copyWith(), const DrawerState());
      expect(const DrawerState().copyWith(menus: menus), const DrawerState(menus: menus));
    });
  });
  //endregion state

  //region event
  /// Drawer Event Tests
  group("DrawerEvent", () {
    test("supports value comparisons", () {
      expect(LoadMenus(), LoadMenus());
      expect(RefreshMenus(), RefreshMenus());
      expect(Logout(), Logout());
    });
    test("props", () {
      expect(LoadMenus().props, []);
      expect(RefreshMenus().props, []);
      expect(Logout().props, []);
    });
  });
  //endregion event

  //region bloc
  /// Drawer Bloc Tests
  group("Drawer Bloc", () {
    group("LoadMenu", () {
      tearDown(() {
        MenuListCache.menus = [];
      });
      const input = [Menu(id: "test", name: "test")];
      final output = Future.value(input);
      final event = LoadMenus();
      const loadingState = DrawerState(menus: []);
      const successState = DrawerState(menus: input);
      //const failureState = DrawerState(menus: []);
      blocTest<DrawerBloc, DrawerState>(
        "emits [loading, success] when LoadMenus is added",
        setUp: () {
          when(menuRepository.getMenus()).thenAnswer((_) => output);
          MenuListCache.menus = [];
        },
        build: () => DrawerBloc(loginRepository: loginRepository, menuRepository: menuRepository),
        act: (bloc) => bloc..add(event),
        expect: () => [loadingState, successState],
      );

      blocTest<DrawerBloc, DrawerState>(
        "emits [loading, failure] when LoadMenus is added",
        setUp: () {
          when(menuRepository.getMenus()).thenThrow(Exception("Error"));
          MenuListCache.menus = [];
        },
        build: () => DrawerBloc(loginRepository: loginRepository, menuRepository: menuRepository),
        act: (bloc) => bloc..add(event),
        expect: () => [loadingState],
      );
    });

    group("RefreshMenu", () {
      const input = [Menu(id: "test", name: "test")];
      final output = Future.value(input);
      final event = RefreshMenus();
      const loadingState = DrawerState(menus: []);
      const successState = DrawerState(menus: input);
      //const failureState = DrawerState(menus: []);
      blocTest<DrawerBloc, DrawerState>(
        "emits [loading, success] when RefreshMenus is added",
        setUp: () {
          when(menuRepository.getMenus()).thenAnswer((_) => output);
          MenuListCache.menus = [];
        },
        build: () => DrawerBloc(loginRepository: loginRepository, menuRepository: menuRepository),
        act: (bloc) => bloc..add(event),
        expect: () => [loadingState, successState],
      );

      blocTest<DrawerBloc, DrawerState>(
        "emits [loading, failure] when RefreshMenus is added",
        setUp: () {
          when(menuRepository.getMenus()).thenThrow(Exception("Error"));
          MenuListCache.menus = [];
        },
        build: () => DrawerBloc(loginRepository: loginRepository, menuRepository: menuRepository),
        act: (bloc) => bloc..add(event),
        expect: () => [loadingState],
      );
    });

    group("Logout", () {
      final event = Logout();
      const state = DrawerState();
      const successState = DrawerState(isLogout: true);
      blocTest<DrawerBloc, DrawerState>(
        "emits [success] when Logout is added",
        setUp: () {
          when(loginRepository.logout()).thenAnswer((_) => Future.value());
          MenuListCache.menus = [];
        },
        build: () => DrawerBloc(loginRepository: loginRepository, menuRepository: menuRepository),
        act: (bloc) => bloc..add(event),
        expect: () => [const DrawerState(),successState],
      );

      blocTest<DrawerBloc, DrawerState>(
        "emits [success] when Logout is added",
        setUp: () {
          when(loginRepository.logout()).thenThrow(Exception("Error"));
          MenuListCache.menus = [];
        },
        build: () => DrawerBloc(loginRepository: loginRepository, menuRepository: menuRepository),
        act: (bloc) => bloc..add(event),
        expect: () => [state],
      );
    });
  });
}