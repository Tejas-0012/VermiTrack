import 'package:flutter/material.dart';
import 'package:monitor/utils/colors.dart';
import 'package:monitor/models/day_step.dart';
import 'package:monitor/widgets/day_card.dart';

class GuideScreen extends StatefulWidget {
  const GuideScreen({super.key});

  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  final Map<String, bool> _expandedPhases = {
    'setup': false,
    'active': false,
    'maturation': false,
    'harvest': false,
  };

  String _selectedPhase = 'setup';

  final List<Map<String, dynamic>> _compostPhases = [
    {
      'id': 'setup',
      'title': 'Initial Setup (Day 1-7)',
      'color': AppColors.info,
      'icon': Icons.settings,
      'description': 'Prepare bed and introduce worms',
      'completed': true,
    },
    {
      'id': 'active',
      'title': 'Active Composting (Day 8-30)',
      'color': AppColors.primary,
      'icon': Icons.autorenew,
      'description': 'Regular feeding and moisture',
      'completed': true,
      'current': true,
    },
    {
      'id': 'maturation',
      'title': 'Maturation (Day 31-40)',
      'color': AppColors.warning,
      'icon': Icons.timelapse,
      'description': 'Reduce feeding, let mature',
      'completed': false,
    },
    {
      'id': 'harvest',
      'title': 'Harvest (Day 41-45)',
      'color': AppColors.success,
      'icon': Icons.agriculture,
      'description': 'Harvest and prepare next cycle',
      'completed': false,
    },
  ];

  final Map<String, List<DayStep>> _phaseSteps = {
    'setup': [
      DayStep(
        day: 1,
        title: 'Prepare Bedding',
        description: 'Cocopeat, dry leaves, newspaper strips',
        imageUrl: 'assets/images/bedding.jpg',
        duration: '30 min',
        materials: ['Cocopeat', 'Dry leaves', 'Newspaper', 'Water'],
      ),
      DayStep(
        day: 2,
        title: 'Moisten Bedding',
        description: 'Make moist like wrung-out sponge',
        imageUrl: 'assets/images/moisture.jpg',
        duration: '15 min',
        materials: ['Water', 'Spray'],
        tip: '60-70% moisture',
      ),
      DayStep(
        day: 3,
        title: 'Introduce Worms',
        description: 'Add 500-1000 earthworms',
        imageUrl: 'assets/images/worms.jpg',
        duration: '20 min',
        materials: ['Earthworms', 'Bedding'],
        warning: 'Avoid sun',
      ),
      DayStep(
        day: 4,
        title: 'First Feeding',
        description: 'Small vegetable scraps',
        imageUrl: 'assets/images/feeding.jpg',
        duration: '10 min',
        materials: ['Veg scraps', 'Fruit peels'],
        tip: 'Cut small',
      ),
      DayStep(
        day: 5,
        title: 'Cover Bed',
        description: 'Cover with gunny bag',
        imageUrl: 'assets/images/cover.jpg',
        duration: '5 min',
        materials: ['Gunny bag'],
      ),
      DayStep(
        day: 6,
        title: 'Check Moisture',
        description: 'Test moisture level',
        imageUrl: 'assets/images/check_moisture.jpg',
        duration: '5 min',
      ),
      DayStep(
        day: 7,
        title: 'Observe Worms',
        description: 'Check worm activity',
        imageUrl: 'assets/images/observation.jpg',
        duration: '10 min',
      ),
    ],
    'active': [
      DayStep(
        day: 8,
        title: 'Daily Feeding',
        description: '250g kitchen waste daily',
        imageUrl: 'assets/images/daily_feeding.jpg',
        duration: '5 min',
        materials: ['Kitchen waste'],
        tip: 'No onion, garlic',
      ),
      DayStep(
        day: 15,
        title: 'Turn Bed',
        description: 'Gently aerate top layer',
        imageUrl: 'assets/images/turn_bed.jpg',
        duration: '10 min',
      ),
      DayStep(
        day: 22,
        title: 'Check Temperature',
        description: 'Keep 25-30°C',
        imageUrl: 'assets/images/temperature.jpg',
        duration: '5 min',
      ),
      DayStep(
        day: 30,
        title: 'Mid-cycle Check',
        description: 'Check progress',
        imageUrl: 'assets/images/assessment.jpg',
        duration: '15 min',
      ),
    ],
    'maturation': [
      DayStep(
        day: 31,
        title: 'Reduce Feeding',
        description: 'Half quantity',
        imageUrl: 'assets/images/reduce_feeding.jpg',
        duration: '5 min',
      ),
      DayStep(
        day: 35,
        title: 'Check pH',
        description: 'Keep pH 6.5-7.5',
        imageUrl: 'assets/images/ph_check.jpg',
        duration: '10 min',
      ),
      DayStep(
        day: 40,
        title: 'Stop Feeding',
        description: 'Complete stop',
        imageUrl: 'assets/images/stop_feeding.jpg',
        duration: '2 min',
      ),
    ],
    'harvest': [
      DayStep(
        day: 41,
        title: 'Prepare Area',
        description: 'Get containers ready',
        imageUrl: 'assets/images/prepare_harvest.jpg',
        duration: '15 min',
        materials: ['Containers', 'Sieve'],
      ),
      DayStep(
        day: 42,
        title: 'Separate Worms',
        description: 'Use light method',
        imageUrl: 'assets/images/separate_worms.jpg',
        duration: '30 min',
      ),
      DayStep(
        day: 43,
        title: 'Collect Compost',
        description: 'Take dark compost',
        imageUrl: 'assets/images/collect_compost.jpg',
        duration: '45 min',
      ),
      DayStep(
        day: 44,
        title: 'Store',
        description: 'Airtight containers',
        imageUrl: 'assets/images/store_compost.jpg',
        duration: '20 min',
      ),
      DayStep(
        day: 45,
        title: 'Restart',
        description: 'Fresh bedding',
        imageUrl: 'assets/images/restart.jpg',
        duration: '30 min',
      ),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            title: const Text(
              'Compost Guide',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            backgroundColor: AppColors.primaryDark,
            elevation: 0,
            floating: true,
            snap: true,
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.search, size: 22),
                onPressed: _searchGuide,
              ),
            ],
          ),

          // Main Content
          SliverPadding(
            padding: const EdgeInsets.all(12.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Welcome (Compact)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.menu_book, color: AppColors.primary, size: 32),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Vermicompost Guide',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Step-by-step instructions',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Phase Timeline (Compact)
                Text(
                  'Compost Phases',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                ..._compostPhases.map((phase) {
                  final isSelected = _selectedPhase == phase['id'];
                  final isCurrent = phase['current'] == true;
                  final isCompleted = phase['completed'] == true;

                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            _selectedPhase = phase['id'];
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (phase['color'] as Color).withOpacity(0.1)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? (phase['color'] as Color)
                                  : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: phase['color'] as Color,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  phase['icon'] as IconData,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          phase['title'] as String,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: phase['color'] as Color,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (isCurrent) ...[
                                          const Spacer(),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.success,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              'NOW',
                                              style: const TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      phase['description'] as String,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (isCompleted)
                                Icon(
                                  Icons.check_circle,
                                  color: AppColors.success,
                                  size: 18,
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  );
                }),
                const SizedBox(height: 20),

                // Current Phase Details (Compact)
                _buildCurrentPhaseDetails(),
                const SizedBox(height: 20),

                // Step-by-Step Guide (Compact)
                Text(
                  'Instructions',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                ..._getCurrentSteps().map((step) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    'D${step.day}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      step.title,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      step.description,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    if (step.tip != null ||
                                        step.duration != null) ...[
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Container(
                                            padding:
                                                const EdgeInsets.symmetric(
                                                  horizontal: 6,
                                                  vertical: 2,
                                                ),
                                            decoration: BoxDecoration(
                                              color: AppColors.info
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              step.duration!,
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: AppColors.info,
                                              ),
                                            ),
                                          ),
                                          if (step.tip != null) ...[
                                            const SizedBox(width: 6),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: AppColors.success
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.lightbulb,
                                                    size: 10,
                                                    color: AppColors.success,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    'Tip',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: AppColors.success,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (step.materials != null &&
                            step.materials!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                            child: Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: step.materials!.map((material) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.background,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    material,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 8),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentPhaseDetails() {
    final currentPhase = _compostPhases.firstWhere(
      (phase) => phase['id'] == _selectedPhase,
    );
    final steps = _phaseSteps[_selectedPhase] ?? [];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                currentPhase['title'] as String,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: currentPhase['color'] as Color,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: currentPhase['color'] as Color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${steps.length} steps',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Requirements:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Column(
            children: _getRequirements(_selectedPhase).map((req) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check, size: 14, color: AppColors.success),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        req,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _getExpectations(_selectedPhase),
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _getRequirements(String phase) {
    switch (phase) {
      case 'setup':
        return [
          'Vermi bed container',
          'Cocopeat/dry leaves',
          '500-1000 worms',
          'Water source',
          'Cover material',
        ];
      case 'active':
        return [
          'Daily kitchen waste',
          'Water for moisture',
          'Thermometer',
          'Bedding top-up',
        ];
      case 'maturation':
        return ['Reduced feeding', 'pH test', 'Moisture check', 'Patience'];
      case 'harvest':
        return [
          'Containers',
          'Sieve',
          'Gloves',
          'Storage containers',
          'Fresh bedding',
        ];
      default:
        return [];
    }
  }

  String _getExpectations(String phase) {
    switch (phase) {
      case 'setup':
        return 'Worms settle in new environment. Keep bedding moist.';
      case 'active':
        return 'Rapid decomposition. Worm population increases.';
      case 'maturation':
        return 'Compost darkens. Earthy smell develops.';
      case 'harvest':
        return 'Dark, crumbly compost ready for use.';
      default:
        return '';
    }
  }

  List<DayStep> _getCurrentSteps() {
    return _phaseSteps[_selectedPhase] ?? [];
  }

  void _searchGuide() {
    showSearch(context: context, delegate: _GuideSearchDelegate());
  }
}

class _GuideSearchDelegate extends SearchDelegate<String> {
  final List<String> _searchTerms = [
    'Moisture',
    'Feeding',
    'Temperature',
    'pH',
    'Harvest',
    'Worms',
    'Bed',
    'Odor',
    'Pests',
    'Troubleshoot',
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear, size: 20),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, size: 20),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = _searchTerms
        .where((term) => term.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index]),
          leading: Icon(Icons.search, size: 20, color: AppColors.primary),
          onTap: () => close(context, results[index]),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? _searchTerms
        : _searchTerms
              .where((term) => term.toLowerCase().contains(query.toLowerCase()))
              .toList();

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index]),
          leading: Icon(Icons.search, size: 20, color: AppColors.primary),
          onTap: () {
            query = suggestions[index];
            showResults(context);
          },
        );
      },
    );
  }
}
