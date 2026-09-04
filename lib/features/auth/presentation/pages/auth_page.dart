import 'package:firebase_auth/firebase_auth.dart';
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

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      switch (_mode) {
        case AuthMode.signIn:
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          break;

        case AuthMode.signUp:
          final credential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password);

          final user = credential.user;

          if (user != null) {
            await user.updateDisplayName(_nameController.text.trim());
            await user.reload();
            await AppSession.instance.saveUserProfile(
              displayName: _nameController.text.trim(),
            );
          }
          break;

        case AuthMode.forgotPassword:
          await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
          break;
      }

      if (!mounted) {
        return;
      }

      if (_mode == AuthMode.forgotPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'If an account exists for that email, reset instructions have been sent.',
            ),
          ),
        );
        _changeMode(AuthMode.signIn);
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _mode == AuthMode.signIn
                ? 'Signed in successfully.'
                : 'Account created successfully.',
          ),
        ),
      );

      Navigator.of(context).pop();
    } on FirebaseAuthException catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_authErrorMessage(error.code))));
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong. Please try again.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _submitting = false;
        });
      }
    }
  }

  String _authErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'An account already exists for this email address.';
      case 'invalid-email':
        return 'Enter a valid email address.';
      case 'weak-password':
        return 'Use a stronger password with at least 6 characters.';
      case 'invalid-credential':
      case 'user-not-found':
      case 'wrong-password':
        return 'The email address or password is incorrect.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Wait a moment and try again.';
      case 'network-request-failed':
        return 'Check your internet connection and try again.';
      default:
        return 'Authentication failed. Please try again.';
    }
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
          icon: Icon(Icons.arrow_back_rounded),
        ),
        title: Text(_pageTitle, style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 500),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeading(),
                      SizedBox(height: 28),
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
                        SizedBox(height: 16),
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
                        SizedBox(height: 16),
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
                        SizedBox(height: 16),
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
                            child: Text('Forgot password?'),
                          ),
                        ),
                      ] else
                        SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _submitting ? null : _submit,
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 17),
                          ),
                          child: _submitting
                              ? SizedBox(
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
                      SizedBox(height: 18),
                      _buildBottomAction(),
                      if (_mode == AuthMode.signIn) ...[
                        SizedBox(height: 24),
                        Divider(),
                        SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'You can continue as a guest and take every '
                                'exam. Sign in is only required to save your '
                                'progress, history, bookmarks and scores.',
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
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
        SizedBox(height: 18),
        Text(
          _heading,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 30,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 9),
        Text(
          _description,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
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
            Text(
              'Don’t have an account?',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            TextButton(
              onPressed: () {
                _changeMode(AuthMode.signUp);
              },
              child: Text('Create account'),
            ),
          ],
        );

      case AuthMode.signUp:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Already have an account?',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            TextButton(
              onPressed: () {
                _changeMode(AuthMode.signIn);
              },
              child: Text('Sign in'),
            ),
          ],
        );

      case AuthMode.forgotPassword:
        return Center(
          child: TextButton.icon(
            onPressed: () {
              _changeMode(AuthMode.signIn);
            },
            icon: Icon(Icons.arrow_back_rounded),
            label: Text('Return to sign in'),
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
      fillColor: Theme.of(context).scaffoldBackgroundColor,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
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
