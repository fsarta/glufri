// lib/features/onboarding/presentation/providers/onboarding_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

// Un provider che dice all'app se l'onboarding è stato completato
final onboardingCompletedProvider = StateProvider<bool>((ref) => false);
