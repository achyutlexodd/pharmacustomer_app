import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../onboarding/profile_setup.dart';

class Otp extends StatefulWidget {
  final String? phoneNumber;
  const Otp({super.key, this.phoneNumber});

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool hasError = false;
  int _secondsLeft = 48;
  Timer? _timer;

  // ponytail: demo default valid OTP is '123456'
  static const String _validOtp = '123456';

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = 48);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        setState(() => _secondsLeft--);
      } else {
        timer.cancel();
      }
    });
  }

  void _resendOtp() {
    if (_secondsLeft == 0) {
      _startTimer();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New OTP sent to your number')),
      );
    }
  }

  void _verifyOtp() {
    final code = _otpController.text.trim();
    if (code == _validOtp) {
      setState(() => hasError = false);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileSetup(phoneNumber: widget.phoneNumber ?? '')),
      );
    } else {
      setState(() => hasError = true);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final raw = widget.phoneNumber ?? '9876543210';
    // Show only last 3 digits: +91 XXXXXXX543
    final masked = '+91 ${raw.substring(0, raw.length > 3 ? raw.length - 3 : 0).replaceAll(RegExp(r'\d'), 'X')}${raw.substring(raw.length > 3 ? raw.length - 3 : 0)}';
    final phoneDisplay = raw.isNotEmpty ? masked : '+91 XXXXXXX210';
    final timerText = '00:${_secondsLeft.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: AppTheme.text),
        title: hasError ? const Text('Verification', style: TextStyle(color: AppTheme.text, fontSize: 16)) : null,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (!hasError) ...[
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
                  ),
                  child: const Center(child: Text('✉️', style: TextStyle(fontSize: 24))),
                ),
                const SizedBox(height: 24),
              ],
              const Text('Verify Mobile Number', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.text)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Code sent to ', style: TextStyle(color: Colors.grey)),
                  Text(phoneDisplay, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.edit, size: 16, color: AppTheme.primary),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(6, (index) {
                            final text = _otpController.text;
                            final char = index < text.length ? text[index] : (index == text.length ? '|' : '•');
                            return Container(
                              width: 42,
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: hasError
                                      ? AppTheme.error
                                      : (index <= text.length ? AppTheme.primary : Colors.grey.shade300),
                                ),
                                borderRadius: BorderRadius.circular(8),
                                color: hasError ? AppTheme.error.withValues(alpha: 0.05) : Colors.white,
                              ),
                              child: Text(
                                char,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: hasError ? AppTheme.error : AppTheme.text,
                                ),
                              ),
                            );
                          }),
                        ),
                        if (hasError) ...[
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.error.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Invalid OTP. The code entered does not match.',
                              style: TextStyle(color: AppTheme.error, fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ] else ...[
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.teal.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.chat, size: 14, color: AppTheme.primary),
                                SizedBox(width: 8),
                                Text('Auto-reading OTP from SMS...', style: TextStyle(fontSize: 12, color: AppTheme.primary)),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Invisible input layer for native numeric keyboard
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.0,
                      child: TextField(
                        controller: _otpController,
                        focusNode: _focusNode,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        autofocus: true,
                        onChanged: (val) {
                          setState(() => hasError = false);
                          if (val.length == 6) _verifyOtp();
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (hasError) ...[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          hasError = false;
                          _otpController.clear();
                        });
                        _focusNode.requestFocus();
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.refresh, size: 16, color: AppTheme.error),
                          SizedBox(width: 4),
                          Text('Clear & Try Again', style: TextStyle(color: AppTheme.error, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const Spacer(),
                  ],
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  const Text('Resend in ', style: TextStyle(color: Colors.grey)),
                  Text(timerText, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary)),
                ],
              ),
              const SizedBox(height: 12),
              if (hasError)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _resendOtp,
                      child: Text(
                        'Resend via SMS',
                        style: TextStyle(
                          color: _secondsLeft == 0 ? AppTheme.primary : Colors.grey,
                          fontWeight: _secondsLeft == 0 ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.chat, size: 16, color: AppTheme.primary),
                    const SizedBox(width: 4),
                    const Text('Get OTP via WhatsApp', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold)),
                  ],
                )
              else
                GestureDetector(
                  onTap: _resendOtp,
                  child: Text(
                    'Resend OTP',
                    style: TextStyle(
                      color: _secondsLeft == 0 ? AppTheme.primary : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _verifyOtp,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Verify & Continue'),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
