import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/branding.dart';
import '../../theme/app_dimens.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/indicators.dart';
import '../../widgets/surfaces.dart';

/// Version, privacy summary and licences.
class AboutScreen extends ConsumerStatefulWidget {
  const AboutScreen({super.key});

  @override
  ConsumerState<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends ConsumerState<AboutScreen> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() => _version = '${info.version} (${info.buildNumber})');
      }
    } on Object catch (_) {
      if (mounted) setState(() => _version = 'unknown');
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return AppScreen(
      title: 'About',
      padded: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          Gap.screenH,
          Gap.lg,
          Gap.screenH,
          Gap.giant,
        ),
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: c.brandGradient,
                    borderRadius: BorderRadius.circular(Radii.lg),
                  ),
                  child: Icon(
                    Icons.local_fire_department_rounded,
                    size: 42,
                    color: c.accentContrast,
                  ),
                ),
                const SizedBox(height: Gap.lg),
                GradientText(Branding.appName, style: AppTypography.displayS),
                const SizedBox(height: Gap.xs),
                Text(
                  Branding.tagline,
                  style: AppTypography.body.copyWith(color: c.textSecondary),
                ),
                const SizedBox(height: Gap.sm),
                Text(
                  _version.isEmpty ? 'Loading version…' : 'Version $_version',
                  style: AppTypography.caption.copyWith(color: c.textTertiary),
                ),
              ],
            ),
          ),
          const SizedBox(height: Gap.xxxl),

          const SectionHeader(title: 'Privacy'),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Point(
                  icon: Icons.phone_android_rounded,
                  text:
                      'Everything you log stays in a database on this device. '
                      'There is no account and no sync.',
                ),
                _Point(
                  icon: Icons.cloud_off_rounded,
                  text:
                      '${Branding.appName} does not send your training data '
                      'anywhere. It works fully offline.',
                ),
                _Point(
                  icon: Icons.notifications_none_rounded,
                  text:
                      'Notification permission is used only for the reminders '
                      'you switch on yourself.',
                ),
                _Point(
                  icon: Icons.sensors_rounded,
                  text:
                      'The proximity sensor is read only while a workout is '
                      'open, and only if you choose that counting mode.',
                  isLast: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: Gap.md),
          AppCard(
            padding: const EdgeInsets.symmetric(vertical: Gap.sm),
            child: Column(
              children: [
                AppListTile(
                  title: 'Privacy policy',
                  subtitle: Branding.privacyPolicyUrl,
                  leadingIcon: Icons.policy_outlined,
                  leadingColor: c.info,
                  trailing: IconButton(
                    tooltip: 'Copy link',
                    icon: const Icon(Icons.copy_rounded, size: 18),
                    onPressed: () => _copy(Branding.privacyPolicyUrl),
                  ),
                  showChevron: false,
                ),
                AppListTile(
                  title: 'Contact',
                  subtitle: Branding.supportEmail,
                  leadingIcon: Icons.mail_outline_rounded,
                  trailing: IconButton(
                    tooltip: 'Copy address',
                    icon: const Icon(Icons.copy_rounded, size: 18),
                    onPressed: () => _copy(Branding.supportEmail),
                  ),
                  showChevron: false,
                ),
                AppListTile(
                  title: 'Source code',
                  subtitle: Branding.sourceUrl,
                  leadingIcon: Icons.code_rounded,
                  leadingColor: c.success,
                  trailing: IconButton(
                    tooltip: 'Copy link',
                    icon: const Icon(Icons.copy_rounded, size: 18),
                    onPressed: () => _copy(Branding.sourceUrl),
                  ),
                  showChevron: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: Gap.xl),

          const SectionHeader(title: 'Credits'),
          AppCard(
            padding: const EdgeInsets.symmetric(vertical: Gap.sm),
            child: Column(
              children: [
                AppListTile(
                  title: 'Open source licences',
                  subtitle: 'Packages and fonts used by this app',
                  leadingIcon: Icons.description_outlined,
                  onTap: () => showLicensePage(
                    context: context,
                    applicationName: Branding.appName,
                    applicationVersion: _version,
                    applicationLegalese:
                        'Outfit typeface © The Outfit Project Authors, '
                        'used under the SIL Open Font License 1.1.',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Gap.xxl),

          Center(
            child: Text(
              'Built for people who show up.',
              style: AppTypography.caption.copyWith(color: c.textTertiary),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _copy(String value) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
  }
}

class _Point extends StatelessWidget {
  const _Point({required this.icon, required this.text, this.isLast = false});

  final IconData icon;
  final String text;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : Gap.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: c.success),
          const SizedBox(width: Gap.md),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodySmall.copyWith(color: c.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
