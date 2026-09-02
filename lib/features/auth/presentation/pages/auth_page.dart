import 'package:flutter/material.dart';
import 'package:newsllm/core/session/app_session.dart';
import 'package:newsllm/core/theme/app_colors.dart';

enum AuthMode { signIn, signUp, forgotPassword }

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  AuthMode _mode = AuthMode.signIn;
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;
  bool _submitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _changeMode(AuthMode mode) {
    setState(() {
      _mode = mode;
      _formKey.currentState?.reset();
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _submitting = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    setState(() {
      _submitting = false;
    });

    if (_mode == AuthMode.forgotPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Frontend complete. Password reset will work after backend setup.',
          ),
        ),
      );
      return;
    }
    AppSession.instance.signIn(
      name: _mode == AuthMode.signUp
          ? _nameController.text
          : _emailController.text.split('@').first,
      email: _emailController.text,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _mode == AuthMode.signIn
              ? 'Frontend sign-in successful.'
              : 'Frontend account created.',
        ),
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        surfaceTintColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(
          _pageTitle,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeading(),
                      const SizedBox(height: 28),
                      if (_mode == AuthMode.signUp) ...[
                        TextFormField(
                          controller: _nameController,
                          textInputAction: TextInputAction.next,
                          decoration: _inputDecoration(
                            label: 'Full name',
                            icon: Icons.person_outline_rounded,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().length < 2) {
                              return 'Enter your full name.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: _mode == AuthMode.forgotPassword
                            ? TextInputAction.done
                            : TextInputAction.next,
                        decoration: _inputDecoration(
                          label: 'Email address',
                          icon: Icons.email_outlined,
                        ),
                        validator: (value) {
                          final email = value?.trim() ?? '';

                          if (email.isEmpty ||
                              !email.contains('@') ||
                              !email.contains('.')) {
                            return 'Enter a valid email address.';
                          }

                          return null;
                        },
                      ),
                      if (_mode != AuthMode.forgotPassword) ...[
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _hidePassword,
                          textInputAction: _mode == AuthMode.signUp
                              ? TextInputAction.next
                              : TextInputAction.done,
                          decoration: _inputDecoration(
                            label: 'Password',
                            icon: Icons.lock_outline_rounded,
                            suffix: IconButton(
                              onPressed: () {
                                setState(() {
                                  _hidePassword = !_hidePassword;
                                });
                              },
                              icon: Icon(
                                _hidePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.length < 6) {
                              return 'Password must contain at least 6 characters.';
                            }
                            return null;
                          },
                        ),
                      ],
                      if (_mode == AuthMode.signUp) ...[
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _hideConfirmPassword,
                          textInputAction: TextInputAction.done,
                          decoration: _inputDecoration(
                            label: 'Confirm password',
                            icon: Icons.lock_reset_rounded,
                            suffix: IconButton(
                              onPressed: () {
                                setState(() {
                                  _hideConfirmPassword = !_hideConfirmPassword;
                                });
                              },
                              icon: Icon(
                                _hideConfirmPassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match.';
                            }
                            return null;
                          },
                        ),
                      ],
                      if (_mode == AuthMode.signIn) ...[
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              _changeMode(AuthMode.forgotPassword);
                            },
                            child: const Text('Forgot password?'),
                          ),
                        ),
                      ] else
                        const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _submitting ? null : _submit,
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 17),
                          ),
                          child: _submitting
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(_submitLabel),
                        ),
                      ),
                      const SizedBox(height: 18),
                      _buildBottomAction(),
                      if (_mode == AuthMode.signIn) ...[
                        const SizedBox(height: 24),
                        const Divider(),
                        const SizedBox(height: 16),
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: AppColors.textSecondary,
                              size: 20,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'You can continue as a guest and take every '
                                'exam. Sign in is only required to save your '
                                'progress, history, bookmarks and scores.',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(_headingIcon, color: AppColors.primary, size: 36),
        const SizedBox(height: 18),
        Text(
          _heading,
          style: const TextStyle(
            color: AppColors.darkNavy,
            fontSize: 30,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 9),
        Text(
          _description,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 15,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomAction() {
    switch (_mode) {
      case AuthMode.signIn:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Don’t have an account?',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            TextButton(
              onPressed: () {
                _changeMode(AuthMode.signUp);
              },
              child: const Text('Create account'),
            ),
          ],
        );

      case AuthMode.signUp:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Already have an account?',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            TextButton(
              onPressed: () {
                _changeMode(AuthMode.signIn);
              },
              child: const Text('Sign in'),
            ),
          ],
        );

      case AuthMode.forgotPassword:
        return Center(
          child: TextButton.icon(
            onPressed: () {
              _changeMode(AuthMode.signIn);
            },
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text('Return to sign in'),
          ),
        );
    }
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      suffixIcon: suffix,
      filled: true,
      fillColor: AppColors.background,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.border),
      ),
    );
  }

  String get _pageTitle {
    switch (_mode) {
      case AuthMode.signIn:
        return 'Sign in';
      case AuthMode.signUp:
        return 'Create account';
      case AuthMode.forgotPassword:
        return 'Reset password';
    }
  }

  String get _heading {
    switch (_mode) {
      case AuthMode.signIn:
        return 'Welcome back';
      case AuthMode.signUp:
        return 'Create your profile';
      case AuthMode.forgotPassword:
        return 'Reset your password';
    }
  }

  String get _description {
    switch (_mode) {
      case AuthMode.signIn:
        return 'Sign in to save your learning progress and exam results.';
      case AuthMode.signUp:
        return 'Create an account to track scores, bookmarks and progress.';
      case AuthMode.forgotPassword:
        return 'Enter your email address to receive password-reset instructions.';
    }
  }

  String get _submitLabel {
    switch (_mode) {
      case AuthMode.signIn:
        return 'Sign in';
      case AuthMode.signUp:
        return 'Create account';
      case AuthMode.forgotPassword:
        return 'Send reset instructions';
    }
  }

  IconData get _headingIcon {
    switch (_mode) {
      case AuthMode.signIn:
        return Icons.login_rounded;
      case AuthMode.signUp:
        return Icons.person_add_alt_1_rounded;
      case AuthMode.forgotPassword:
        return Icons.lock_reset_rounded;
    }
  }
}
