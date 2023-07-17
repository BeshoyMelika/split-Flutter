import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:split/core/widgets/base_stateful_screen_widget.dart';
import 'package:split/feature/appbar/appbar.dart';
import 'package:split/feature/home/bloc/home_screen_bloc.dart';
import 'package:split/feature/home/helper/home_screen_helper.dart';
import 'package:split/feature/home/widget/currency_picker_form_field_widget.dart';
import 'package:split/feature/home/widget/image_picker_form_field_widget.dart';
import 'package:split/feature/home/widget/new_group_type_items_list_form_field_widget.dart';
import 'package:split/feature/home/widget/home_elevated_button_custom.dart';
import 'package:split/feature/home/widget/text_from_field_custom.dart';
import 'package:split/feature/widgets/app_text_widget.dart';
import 'package:split/models/group_model.dart';
import 'package:split/res/app_colors.dart';
import 'package:split/res/app_icons.dart';
import 'package:split/utils/locale/app_localization_keys.dart';
import 'package:split/utils/widgets/text_with_asterisk_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => HomeScreenBloc(),
        child: const HomeScreenWithBloc());
  }
}

class HomeScreenWithBloc extends BaseStatefulScreenWidget {
  const HomeScreenWithBloc({Key? key}) : super(key: key);

  @override
  BaseScreenState<HomeScreenWithBloc> baseScreenCreateState() =>
      _HomeScreenWithBlocState();
}

class _HomeScreenWithBlocState extends BaseScreenState<HomeScreenWithBloc> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  HomeScreenHelper homeScreenHelper = HomeScreenHelper();
  AutovalidateMode validationMode = AutovalidateMode.disabled;
  GroupModel groupModel = GroupModel.groupModel;

  @override
  Widget baseScreenBuild(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColors.homeScreenBackground,
      appBar: AppBarWidget(title: translate(LocalizationKeys.createNewGroup)!),
      body: BlocConsumer<HomeScreenBloc, HomeScreenState>(
        listener: (context, state) {
          if (state is NotValidHomeScreenState) {
            validationMode = AutovalidateMode.always;
          } else if (state is ValidationDoneSuccessfullyHomeScreenState) {
            _onValidationDoneSuccessfully();
          } else if (state is LoadingHomeScreenState) {
            _loadingHomeScreenState();
          } else if (state is ErrorCaughtHomeScreenState) {
            _errorCaughtHomeScreenState();
          } else if (state is NewGroupCreatedSuccessfullyState) {
            _newGroupCreatedSuccessfully();
          }
        },
        builder: (context, state) {
          return Form(
            autovalidateMode: validationMode,
            key: formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 19.w, vertical: 25.h),
              children: [
                ImagePickerFormFieldWidget(
                    onSaved: _onSaveImagePickerWidget,
                    items: PickedImageWidgetItem(value: groupModel.image),
                    validator: _validateImagePickerWidget),
                SizedBox(height: 15.h),
                _textWithAsterisk(translate(LocalizationKeys.groupName)!),
                SizedBox(height: 8.h),
                TextFormFieldCustom(
                    hintText: translate(LocalizationKeys.enterGroupName)!,
                    textInputAction: TextInputAction.done,
                    secureText: false,
                    textInputType: TextInputType.text,
                    onChange: _onChangeGroupName),
                SizedBox(height: 15.h),
                _textWithAsterisk(translate(LocalizationKeys.type)!),
                SizedBox(height: 8.h),
                NewGroupTypeItemsListFormFieldWidget(
                    onSaved: _typesItemsList,
                    items: _getCurrentTypesItemsList(),
                    validator: _typesItemsListValidator),
                SizedBox(height: 15.h),
                _textWithAsterisk(translate(LocalizationKeys.addParticipants)!),
                _addParticipants(),
                _textWithAsterisk(translate(LocalizationKeys.typeOfSplit)!),
                NewGroupTypeItemsListFormFieldWidget(
                    onSaved: _onSaveTypeOfSplitItem,
                    items: _getCurrentTypesOfSplitItemsList(),
                    validator: _newGroupTypeOfSplitItemsValidator),
                SizedBox(height: 15.h),
                _textWithAsterisk(translate(LocalizationKeys.currency)!),
                SizedBox(height: 8.h),
                CurrencyPickerFormFieldWidget(
                    onSaved: _onSaveCurrencyPickerWidget,
                    items: _getCurrencyPickerItemsList(),
                    validator: _currencyPickerValidator),
                SizedBox(height: 15.h),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: AppTextWidget(
                      text: translate(LocalizationKeys.description)!,
                      boxFit: BoxFit.scaleDown,
                      alignment: AlignmentDirectional.center,
                      style: textTheme.bodyMedium!
                          .copyWith(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
                SizedBox(height: 8.h),
                TextFormFieldCustom(
                    onChange: _onChangeGroupDescription,
                    hintText: translate(LocalizationKeys.writeDescription)!,
                    textInputAction: TextInputAction.done,
                    secureText: false,
                    maxLines: 6,
                    textInputType: TextInputType.text),
                SizedBox(height: 25.h),
                _createAndCancelButtons(),
              ],
            ),
          );
        },
      ),
    ));
  }

  /// //////////////////////////////////////////////////////////////////
  /// //////////////////////Helper Widgets /////////////////////////////
  /// //////////////////////////////////////////////////////////////////
  Widget _textWithAsterisk(String text) => TextWithAsterisk(
      style: textTheme.bodyMedium!
          .copyWith(fontSize: 12, fontWeight: FontWeight.w600),
      labelText: text);

  Widget _addParticipants() => InkWell(
        onTap: () {
          _addParticipantsOnTap();
        },
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16.w, 25.h, 0, 25.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Flexible(
                  flex: 1,
                  child: Icon(
                    AppIcons.addParticipant,
                    size: 16,
                    weight: 400,
                  )),
              SizedBox(width: 10.w),
              Flexible(
                flex: 2,
                child: AppTextWidget(
                    alignment: AlignmentDirectional.center,
                    boxFit: BoxFit.scaleDown,
                    text: translate(LocalizationKeys.addParticipants)!,
                    style: textTheme.bodyLarge!
                        .copyWith(fontWeight: FontWeight.w600, fontSize: 16)),
              )
            ],
          ),
        ),
      );

  Widget _createAndCancelButtons() => Row(
        children: [
          Expanded(
              child: HomeElevatedButtonCustom(
                  text: translate(LocalizationKeys.create)!,
                  onPressed: () {
                    _onCreatePressed();
                  },
                  buttonHeight: 40.h,
                  alignment: AlignmentDirectional.center)),
          SizedBox(width: 12.w),
          Expanded(
              child: HomeElevatedButtonCustom(
                  textStyle: textTheme.bodySmall!
                      .copyWith(fontWeight: FontWeight.w600, fontSize: 16),
                  text: translate(LocalizationKeys.cancel)!,
                  onPressed: () {
                    _onCancelPressed();
                  },
                  buttonColor: AppColors.homeScreenCancelButton,
                  buttonHeight: 40.h,
                  alignment: AlignmentDirectional.center)),
        ],
      );

  /// //////////////////////////////////////////////////////////////////
  /// //////////////////////Helper Methods /////////////////////////////
  /// //////////////////////////////////////////////////////////////////
  void _onCreatePressed() {
    BlocProvider.of<HomeScreenBloc>(context)
        .add(ValidateFormFieldsEvent(formKey: formKey));
  }

  void _onCancelPressed() {
    debugPrint("cancel Pressed");
  }

  void _onValidationDoneSuccessfully() {
    hideLoading();
    BlocProvider.of<HomeScreenBloc>(context)
        .add(CreateNewGroupEvent(newGroup: groupModel));
  }

  void _newGroupCreatedSuccessfully() {
    hideLoading();
  }

  /// image picker methods
  String? _validateImagePickerWidget(pickedImageWidgetItem) {
    if (pickedImageWidgetItem == null) {
      return translate(LocalizationKeys.required);
    }
    return null;
  }

  void _onSaveImagePickerWidget(pickedImageWidgetItem) {
    groupModel.image = pickedImageWidgetItem!.value!;
  }

  /// new group type methods
  List<NewGroupTypeItem> _getCurrentTypesItemsList() =>
      homeScreenHelper.typeListStrings
          .map((e) => NewGroupTypeItem(
              value: translate(e)!,
              key: e,
              icon: homeScreenHelper
                  .typeListIcons[homeScreenHelper.typeListStrings.indexOf(e)]))
          .toList();
  void _typesItemsList(newGroupType) {
    groupModel.type = newGroupType!.value;
  }

  String? _typesItemsListValidator(newGroupType) {
    if (newGroupType == null) {
      return translate(LocalizationKeys.required);
    }
    return null;
  }

  /// new group type of split methods
  void _onSaveTypeOfSplitItem(newGroupSplitType) {
    groupModel.typeOfSplit = newGroupSplitType!.value;
  }

  List<NewGroupTypeItem> _getCurrentTypesOfSplitItemsList() => homeScreenHelper
      .typeOfSplitListStrings
      .map((e) => NewGroupTypeItem(value: translate(e)!, key: e, icon: null))
      .toList();

  String? _newGroupTypeOfSplitItemsValidator(typeOfSplitItem) {
    if (typeOfSplitItem == null) {
      return translate(LocalizationKeys.required);
    }
    return null;
  }

  /// currency picker methods
  void _onSaveCurrencyPickerWidget(currentCurrency) {
    groupModel.currency = currentCurrency!.value;
  }

  List<CurrencyPickerWidgetItem> _getCurrencyPickerItemsList() =>
      homeScreenHelper.currencyListItems
          .map((e) => CurrencyPickerWidgetItem(value: e, key: e))
          .toList();

  String? _currencyPickerValidator(selectableWidgetItem) {
    if (selectableWidgetItem == null) {
      return translate(LocalizationKeys.required);
    }
    return null;
  }

  /// textFormFields methods
  void _onChangeGroupName(String? value) {
    groupModel.groupName = value ?? "";
  }

  void _onChangeGroupDescription(String? value) {
    groupModel.discription = value ?? "";
  }

  void _addParticipantsOnTap() {
    debugPrint("add participant Pressed");
  }

  void _errorCaughtHomeScreenState() {
    hideLoading();
  }

  void _loadingHomeScreenState() {
    showLoading();
  }
}