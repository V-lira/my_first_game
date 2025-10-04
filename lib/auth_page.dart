import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPage extends StatefulWidget {
  @override
  State<AuthPage> createState() => _AuthPageState();
}
class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isRegistration = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nicknameController = TextEditingController();
  int _selectedSkin = 0;
  String? _errorMessage;
  bool _skritPassword = true;
  bool _skritConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }
  Future<void> _register() async {
    final prefs = await SharedPreferences.getInstance();
    String email = _emailController.text.trim();
    String password = _passwordController.text;
    String skritPassword = _confirmPasswordController.text;
    String nickname = _nicknameController.text.trim();
    if (email.isEmpty || password.isEmpty || skritPassword.isEmpty || nickname.isEmpty) {
      setState(() => _errorMessage = 'Заполните все поля');
      return;
    }
    if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(email)) 
    {
      setState(() => _errorMessage = 'Введите корректный email');
      return;
    }
    if (password != skritPassword)
    {
      setState(() => _errorMessage = 'Пароли не совпадают');
      return;
    }
    final savedEmail = prefs.getString('email');
    if (savedEmail != null && savedEmail == email) 
    {
      setState(() => _errorMessage = 'Пользователь с таким email уже существует! Войдите');
      return;
    }
    await prefs.setString('email', email);
    await prefs.setString('password', password);
    await prefs.setString('nickname', nickname);
    await prefs.setInt('skin', _selectedSkin);
    setState(() => _errorMessage = null);
    _goToMenu();
  }
  Future<void> _login() async {
    final prefs = await SharedPreferences.getInstance();
    String email = _emailController.text.trim();
    String password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) 
    {
      setState(() => _errorMessage = 'Введите email и пароль');
      return;
    }
    final savedEmail = prefs.getString('email');
    final savedPassword = prefs.getString('password');
    if (savedEmail == null || savedPassword == null) {
      setState(() => _errorMessage = 'Пользователь не найден. Зарегистрируйтесь.');
      return;
    }
    if (email != savedEmail || password != savedPassword) {
      setState(() => _errorMessage = 'Неверный email или пароль');
      return;
    }
    setState(() => _errorMessage = null);
    String? nickname = prefs.getString('nickname');
    int? skin = prefs.getInt('skin');
    _goToMenu();
  }
  void _goToMenu() {
    Navigator.of(context).pop(true);
  }
  Widget _buildSkinSelector() {
    final skins = ['🐴', '🦄'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(skins.length, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedSkin = index;
            });
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                color: _selectedSkin == index 
                ? const Color.fromARGB(255, 151, 39, 173) 
                : Colors.grey,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              skins[index],
              style: TextStyle(fontSize: 32),
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isRegistration 
        ? 'Регистрация' 
        : 'Вход'),
        backgroundColor: _isRegistration 
        ? const Color.fromARGB(255, 151, 39, 173)
        : const Color.fromARGB(255, 151, 39, 173),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 10),
              //пароль с кнопкой показа/скрытия
              //+ требует повторение пароля
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Пароль',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _skritPassword 
                      ? Icons.visibility_off 
                      : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _skritPassword = !_skritPassword;
                      });
                    },
                  ),
                ),
                obscureText: _skritPassword,
              ),
              SizedBox(height: 10),
              if (_isRegistration)
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Подтвердите пароль',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _skritConfirmPassword 
                        ? Icons.visibility_off 
                        : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _skritConfirmPassword = !_skritConfirmPassword;
                        });
                      },
                    ),
                  ),
                  obscureText: _skritConfirmPassword,
                ),
              if (_isRegistration) SizedBox(height: 10),
              if (_isRegistration)
                TextFormField(
                  controller: _nicknameController,
                  decoration: InputDecoration(labelText: 'Никнэйм'),
                ),
              if (_isRegistration) 
              SizedBox(height: 20),
              if (_isRegistration) 
              _buildSkinSelector(),
              if (_errorMessage != null) ...[
                SizedBox(height: 15),
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_isRegistration)
                  {
                    _register();
                  } 
                  else 
                  {
                    _login();
                  }
                },
                child: Text(_isRegistration
                ? 'Создать аккаунт' 
                : 'Войти'),),
              TextButton(
                onPressed: () 
                {
                  setState(() {
                    _isRegistration = !_isRegistration;
                    _errorMessage = null;
                  });
                },
                child: Text(_isRegistration
                    ? 'Войти в существующий аккаунт'
                    : 'Зарегистрироваться'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
