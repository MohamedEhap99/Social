import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/networks/local/cache_helper.dart';
import 'package:social_app/shared/styles/cubit/states.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit():super(initialState());
  static AppCubit get(context)=>BlocProvider.of(context);

  bool isDark=false;
  void ChangeAppMode({bool?fromShared}){
    if(fromShared!=null){
      isDark=fromShared;
      emit(AppChangeAppModeState());
    }
    else {
      isDark=!isDark;
      CacheHelper.saveData(key: 'isDark', value:isDark).then((value){
        emit(AppChangeAppModeState());
      });
    }


  }
}