import 'package:flutter/material.dart';
import '../../../../constants/string_extension.dart';
import '../../../../manager/preferences_manager.dart';
import '../../../network/shared_preferences/shared_preferences.dart';
import '../../../widget/text_widget.dart';

class CountrySelectionScreen extends StatefulWidget {
  const CountrySelectionScreen({super.key});

  @override
  State<CountrySelectionScreen> createState() => _CountrySelectionScreenState();
}

class _CountrySelectionScreenState extends State<CountrySelectionScreen> {
  final List<Map<String, String>> countries = [
    {'name': 'Cambodia', 'flag': '🇰🇭', 'currency': 'USD(\$)'},
    {'name': 'Japan', 'flag': '🇯🇵', 'currency': 'USD(\$)'},
    {'name': 'Malaysia', 'flag': '🇲🇾', 'currency': 'USD(\$)'},
    {'name': 'Philippines', 'flag': '🇵🇭', 'currency': 'USD(\$)'},
    {'name': 'South Korea', 'flag': '🇰🇷', 'currency': 'USD(\$)'},
    {'name': 'United Kingdom', 'flag': '🇬🇧', 'currency': 'USD(\$)'},
  ];

  String _selectedCountry = '';

  @override
  void initState() {
    super.initState();
    _loadSelectedCountry();
  }

  Future<void> _loadSelectedCountry() async {
    final savedCountry = await PreferencesManager().setGetString(PrefKey.country);
    if (savedCountry.isNotEmpty) {
      setState(() {
        _selectedCountry = savedCountry;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? theme.scaffoldBackgroundColor : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: isDark ? Colors.white : Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextWidget(
          'Country'.tr,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextWidget(
              'Personalize your shopping with your location preferences.'.tr,
              fontSize: 14,
              textAlign: TextAlign.center,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: countries.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final country = countries[index];
                final isSelected = _selectedCountry == country['name'];

                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedCountry = country['name']!;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        TextWidget(country['flag']!, fontSize: 24),
                        const SizedBox(width: 15),
                        Expanded(
                          child: TextWidget(
                            '${country['name']} - ${country['currency']}',
                            fontSize: 16,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? Colors.black : (isDark ? Colors.white24 : Colors.black26),
                              width: 1,
                            ),
                          ),
                          child: isSelected
                              ? Center(
                                  child: Container(
                                    width: 14,
                                    height: 14,
                                    decoration: const BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _selectedCountry.isEmpty
                    ? null
                    : () async {
                        await PreferencesManager().setGetString(PrefKey.country,
                            _selectedCountry);
                        if (context.mounted) Navigator.pop(context, true);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: TextWidget(
                  'Continue'.tr,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
