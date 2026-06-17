import 'package:flutter/material.dart';

void main() {
  runApp(const CoupleFitApp());
}

class CoupleFitApp extends StatelessWidget {
  const CoupleFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CoupleFit',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const HomePage(),
    );
  }
}

class PersonProfile {
  final String name;
  final Color mainColor;
  final List<String> supplements;
  final int waterGoalOz;

  PersonProfile({
    required this.name,
    required this.mainColor,
    required this.supplements,
    required this.waterGoalOz,
  });
}

final anthony = PersonProfile(
  name: 'Anthony',
  mainColor: const Color(0xFF1F5E3B), // forest green
  waterGoalOz: 128,
  supplements: [
    'Take shilajit',
    'Take creatine',
    'Take magnesium',
    'Take zinc',
  ],
);

final aspen = PersonProfile(
  name: 'Aspen',
  mainColor: const Color(0xFF009E9A), // blue green
  waterGoalOz: 128,
  supplements: [
    'Take creatine',
    'Take magnesium',
    'Take L-Citrulline',
  ],
);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class DailyState {
  int waterOz = 0;
  bool weightLogged = false;
  double? weight;
  final Map<String, bool> supplementStatus = {};
}

class _HomePageState extends State<HomePage> {
  PersonProfile selectedPerson = anthony;

  final Map<String, DailyState> dailyStates = {
    'Anthony': DailyState(),
    'Aspen': DailyState(),
  };

  final List<String> quotes = [
    'Small wins still count. Keep going.',
    'Drink your water, nerd.',
    'Consistency beats motivation.',
    'Future you is watching. Make them proud.',
    'One good day at a time.',
    'Creatine is not going to take itself.',
  ];

  int get quoteIndex => DateTime.now().day % quotes.length;

  DailyState get currentState => dailyStates[selectedPerson.name]!;

  void selectPerson(PersonProfile person) {
    setState(() {
      selectedPerson = person;
      for (final supplement in selectedPerson.supplements) {
        currentState.supplementStatus.putIfAbsent(supplement, () => false);
      }
    });
  }

  void addWater(int amount) {
    setState(() {
      currentState.waterOz += amount;
      if (currentState.waterOz > selectedPerson.waterGoalOz) {
        currentState.waterOz = selectedPerson.waterGoalOz;
      }
    });
  }

  void removeWater(int amount) {
    setState(() {
      currentState.waterOz -= amount;
      if (currentState.waterOz < 0) {
        currentState.waterOz = 0;
      }
    });
  }

  void showNudge(String task) {
    final otherPerson = selectedPerson.name == 'Anthony' ? 'Aspen' : 'Anthony';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '❤️ Nudge sent to $otherPerson: "$task, nerd."',
        ),
        backgroundColor: selectedPerson.mainColor,
      ),
    );
  }

  void showWeightDialog() {
    final controller = TextEditingController(
      text: currentState.weight?.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Log ${selectedPerson.name}\'s Weight'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Weight',
              suffixText: 'lbs',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: selectedPerson.mainColor,
              ),
              onPressed: () {
                setState(() {
                  currentState.weight = double.tryParse(controller.text);
                  currentState.weightLogged = currentState.weight != null;
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    for (final supplement in selectedPerson.supplements) {
      currentState.supplementStatus.putIfAbsent(supplement, () => false);
    }

    final waterProgress =
        currentState.waterOz / selectedPerson.waterGoalOz;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F7),
      appBar: AppBar(
        title: const Text(
          'CoupleFit',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: selectedPerson.mainColor,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          personSelector(),
          const SizedBox(height: 16),
          quoteCard(),
          const SizedBox(height: 16),
          progressSummaryCard(),
          const SizedBox(height: 16),
          waterCard(waterProgress),
          const SizedBox(height: 16),
          supplementsCard(),
          const SizedBox(height: 16),
          weightCard(),
          const SizedBox(height: 16),
          weightChartPreviewCard(),
        ],
      ),
    );
  }

  Widget personSelector() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          selectorButton(anthony),
          selectorButton(aspen),
        ],
      ),
    );
  }

  Widget selectorButton(PersonProfile person) {
    final isSelected = selectedPerson.name == person.name;

    return Expanded(
      child: GestureDetector(
        onTap: () => selectPerson(person),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? person.mainColor : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            person.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget quoteCard() {
    return card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${selectedPerson.name}\'s Daily Motivation',
            style: sectionTitle(),
          ),
          const SizedBox(height: 8),
          Text(
            '“${quotes[quoteIndex]}”',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: selectedPerson.mainColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget progressSummaryCard() {
    final completedSupplements = currentState.supplementStatus.values
        .where((completed) => completed)
        .length;

    final totalSupplements = selectedPerson.supplements.length;

    return card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Today\'s Progress', style: sectionTitle()),
          const SizedBox(height: 12),
          summaryRow(
            'Supplements',
            '$completedSupplements / $totalSupplements complete',
          ),
          summaryRow(
            'Water',
            '${currentState.waterOz} / ${selectedPerson.waterGoalOz} oz',
          ),
          summaryRow(
            'Weight',
            currentState.weightLogged
                ? '${currentState.weight} lbs logged'
                : 'Not logged yet',
          ),
        ],
      ),
    );
  }

  Widget waterCard(double progress) {
    return card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          habitHeader(
            title: 'Water',
            subtitle: '${currentState.waterOz} / ${selectedPerson.waterGoalOz} oz',
            nudgeTask: 'Drink your water',
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            minHeight: 12,
            color: selectedPerson.mainColor,
            backgroundColor: selectedPerson.mainColor.withOpacity(0.18),
            borderRadius: BorderRadius.circular(20),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              waterButton('-8 oz', () => removeWater(8)),
              const SizedBox(width: 8),
              waterButton('+8 oz', () => addWater(8)),
              const SizedBox(width: 8),
              waterButton('+16 oz', () => addWater(16)),
              const SizedBox(width: 8),
              waterButton('+24 oz', () => addWater(24)),
            ],
          ),
        ],
      ),
    );
  }

  Widget supplementsCard() {
    return card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Supplements', style: sectionTitle()),
          const SizedBox(height: 8),
          ...selectedPerson.supplements.map((supplement) {
            final isDone = currentState.supplementStatus[supplement] ?? false;

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDone
                    ? selectedPerson.mainColor.withOpacity(0.10)
                    : Colors.black.withOpacity(0.035),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Checkbox(
                    value: isDone,
                    activeColor: selectedPerson.mainColor,
                    onChanged: (value) {
                      setState(() {
                        currentState.supplementStatus[supplement] =
                            value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      supplement,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => showNudge(supplement),
                    icon: Icon(
                      Icons.favorite,
                      color: selectedPerson.mainColor,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget weightCard() {
    return card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          habitHeader(
            title: 'Daily Weight',
            subtitle: currentState.weightLogged
                ? '${currentState.weight} lbs'
                : 'Not logged yet',
            nudgeTask: 'Log your weight',
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Checkbox(
                value: currentState.weightLogged,
                activeColor: selectedPerson.mainColor,
                onChanged: (_) => showWeightDialog(),
              ),
              Expanded(
                child: Text(
                  currentState.weightLogged
                      ? 'Weight logged for today'
                      : 'Tap to log today\'s weight',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: selectedPerson.mainColor,
                ),
                onPressed: showWeightDialog,
                child: const Text('Log'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget weightChartPreviewCard() {
    return card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Weight Over Time', style: sectionTitle()),
          const SizedBox(height: 12),
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: selectedPerson.mainColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selectedPerson.mainColor.withOpacity(0.25),
              ),
            ),
            child: Center(
              child: Text(
                'Chart will go here after we add history data',
                style: TextStyle(
                  color: selectedPerson.mainColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget habitHeader({
    required String title,
    required String subtitle,
    required String nudgeTask,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: sectionTitle()),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => showNudge(nudgeTask),
          icon: Icon(
            Icons.favorite,
            color: selectedPerson.mainColor,
          ),
        ),
      ],
    );
  }

  Widget waterButton(String label, VoidCallback onPressed) {
    return Expanded(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: selectedPerson.mainColor,
          side: BorderSide(color: selectedPerson.mainColor),
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }

  Widget summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text(value),
        ],
      ),
    );
  }

  TextStyle sectionTitle() {
    return const TextStyle(
      fontSize: 19,
      fontWeight: FontWeight.bold,
    );
  }

  Widget card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}
