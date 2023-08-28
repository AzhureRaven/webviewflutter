import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../../utilities/constants.dart';
import '../../utilities/localization.dart';
import '../widgets/boxes.dart';
import '../widgets/buttons.dart';
import '../widgets/cards.dart';
import '../widgets/labels.dart';
import '../widgets/misc.dart';
import 'scan_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/account/login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey <FormState>();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalization.of(context).translate("login").toString()),
        ),
        body: PaddingBox(
          ver: "regular",
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  ColoredLabel(text: AppLocalization.of(context).translate("login").toString(), font: "large", fontWeight: FontWeight.bold,),
                  const Gap(height: "small"),
                  formFieldWrap(
                    TextFormField(
                      controller: _usernameController,
                      textInputAction: TextInputAction.next,
                      textAlign: TextAlign.center,
                      validator: (data) {
                        if (data != null && data != "") {
                          return null;
                        } else {
                          return AppLocalization.of(context).translate("required_field").toString();
                        }
                      },
                      decoration: InputDecoration(
                          hintText: AppLocalization.of(context).translate("username").toString(),
                          prefixIcon: const SizedBox(),
                          suffixIcon: const SizedBox(),
                          border: InputBorder.none
                      ),
                    ),
                  ),
                  formFieldWrap(
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_passwordVisible,
                      textAlign: TextAlign.center,
                      validator: (data) {
                        if (data != null && data != "") {
                          return null;
                        } else {
                          return AppLocalization.of(context).translate("required_field").toString();
                        }
                      },
                      decoration: InputDecoration(
                          hintText: AppLocalization.of(context).translate("password").toString(),
                          prefixIcon: const SizedBox(),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                            child: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
                          ),
                          border: InputBorder.none
                      ),
                    ),
                  ),
                  const Gap(height: "regular"),
                  ColoredTextButton(
                      text: AppLocalization.of(context).translate("login").toString(),
                      font: "regular",
                      height: 40,
                      width: 120,
                      radius: "large",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                            return const ScanScreen();
                          }));
                          //doLogin(_usernameController.text, _passwordController.text, context);
                        }
                      }
                  )
                ],
              )
          ),
        )
    );
  }

  /*void doLogin(String username, String password, BuildContext context){
    context.loaderOverlay.show();
    Map<String, String> data = {
      'user_name': username,
      'user_pass': password
    };
    HttpApi http = HttpApi(url: "https://sindo.co.id/api/v1.0/login", data: data);
    Future<String> result = http.postStringData();
    result.then((response){
      context.loaderOverlay.hide();
      try{
        Account account = parseAccount(response);
        Provider.of<SecuredStorage>(context, listen: false).setSession(username, password, account);
        if(FirebaseMsg.token != "") updateFCMToken(username, password, FirebaseMsg.token, context);
        Navigator.pushReplacementNamed(context, AccountScreen.routeName);
      }catch(e){
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(BasicSnackBar(AppLocalization.of(context).translate("login_fail").toString()));
      }
    }).catchError((e){
      context.loaderOverlay.hide();
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(BasicSnackBar(AppLocalization.of(context).translate("check_internet").toString()));
    });
  }

  void updateFCMToken(String username, String password, String token, BuildContext context){
    Map<String, String> data = {
      'user_name': username,
      'user_pass': password,
      'token_cfm': token
    };
    HttpApi http = HttpApi(url: "https://sindo.co.id/api/v1.0/token_cfm", data: data);
    Future<String> result = http.postStringData();
    result.then((response){
      try{
        print("sukses update token");
      }catch(e){
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(BasicSnackBar(AppLocalization.of(context).translate("token_fail").toString()));
      }
    }).catchError((e){
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(BasicSnackBar(AppLocalization.of(context).translate("token_fail").toString()));
    });
  }*/

  Widget formFieldWrap(Widget child){
    return BasicCard(
      radius: "large",
      child: PaddingBox2(
        child: child,
      ),
    );
  }
}