import 'package:flutter/material.dart';
//potsu dan
void main() {
  runApp(const BudgetTrackerApp());
}

class BudgetTrackerApp extends StatelessWidget {
  const BudgetTrackerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget Tracker',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const BudgetTrackerHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BudgetTrackerHome extends StatefulWidget {
  const BudgetTrackerHome({Key? key}) : super(key: key);

  @override
  State<BudgetTrackerHome> createState() => _BudgetTrackerHomeState();
}

class _BudgetTrackerHomeState extends State<BudgetTrackerHome> {
  // Variables and Data Types demonstration
  double initialBudget = 0.0;
  double totalExpenses = 0.0;
  String expenseName = '';
  int numberOfExpenses = 0;
  bool isBudgetExceeded = false;
  bool isBudgetSet = false;

  List<Map<String, dynamic>> expenses = [];

  // Controllers - initialized in initState to avoid null issues
  late TextEditingController budgetController;
  late TextEditingController expenseNameController;
  late TextEditingController expenseAmountController;

  String selectedCategory = 'Food';

  @override
  void initState() {
    super.initState();
    // Initialize controllers properly
    budgetController = TextEditingController();
    expenseNameController = TextEditingController();
    expenseAmountController = TextEditingController();
  }

  // Method to set initial budget
  void setInitialBudget() {
    final parsedBudget = double.tryParse(budgetController.text);

    // Validate budget input
    if (parsedBudget == null || parsedBudget <= 0) {
      _showErrorDialog('Please enter a valid budget amount greater than 0.');
      return;
    }

    if (!mounted) return;

    setState(() {
      initialBudget = parsedBudget;
      isBudgetSet = true;
    });
  }

  // Method to add expense with operators demonstration
  void addExpense() {
    final name = expenseNameController.text.trim();
    final amount = double.tryParse(expenseAmountController.text);

    // Using relational and logical operators for validation
    if (name.isEmpty || amount == null || amount <= 0) {
      _showErrorDialog('Please enter valid expense name and amount.');
      return;
    }

    // Check if widget is still mounted before updating state
    if (!mounted) return;

    setState(() {
      // Arithmetic operators in use
      totalExpenses += amount;
      numberOfExpenses++;

      expenses.add({
        'name': name,
        'amount': amount,
        'category': selectedCategory,
      });

      // Relational operator
      isBudgetExceeded = totalExpenses > initialBudget;

      // Clear input fields
      expenseNameController.clear();
      expenseAmountController.clear();
    });
  }

  // Helper method to show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Invalid Input'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Calculate remaining budget using arithmetic operators
  double getRemainingBudget() {
    return initialBudget - totalExpenses;
  }

  // Get budget status message using control structures
  String getBudgetStatus() {
    // Prevent division by zero
    if (initialBudget == 0) return 'Set Budget First';

    final percentageUsed = (totalExpenses / initialBudget) * 100;

    // if-else control structure
    if (isBudgetExceeded) {
      return 'Over Budget!';
    } else if (percentageUsed >= 80) {
      return 'Budget Almost Exhausted!';
    } else if (percentageUsed >= 50) {
      return 'Budget Half Used';
    } else {
      return 'Budget OK';
    }
  }

  // Get category icon using switch control structure
  IconData getCategoryIcon(String category) {
    // switch control structure demonstration
    switch (category) {
      case 'Food':
        return Icons.restaurant;
      case 'Transport':
        return Icons.directions_car;
      case 'Entertainment':
        return Icons.movie;
      case 'Shopping':
        return Icons.shopping_bag;
      case 'Bills':
        return Icons.receipt;
      case 'Others':
        return Icons.attach_money;
      default:
        return Icons.attach_money;
    }
  }

  // Get category color using switch
  Color getCategoryColor(String category) {
    switch (category) {
      case 'Food':
        return Colors.orange;
      case 'Transport':
        return Colors.blue;
      case 'Entertainment':
        return Colors.purple;
      case 'Shopping':
        return Colors.pink;
      case 'Bills':
        return Colors.red;
      case 'Others':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Tracker'),
        centerTitle: true,
      ),
      body: !isBudgetSet ? buildBudgetSetup() : buildBudgetTracker(),
    );
  }

  // Budget setup screen
  Widget buildBudgetSetup() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.account_balance_wallet,
              size: 80, color: Colors.green),
          const SizedBox(height: 20),
          const Text(
            'Set Your Initial Budget',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          TextField(
            controller: budgetController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Enter Budget Amount',
              prefixIcon: Icon(Icons.money),
              border: OutlineInputBorder(),
              hintText: 'e.g., 5000',
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: setInitialBudget,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                child: Text('Start Tracking', style: TextStyle(fontSize: 18)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Main budget tracker screen
  Widget buildBudgetTracker() {
    final remaining = getRemainingBudget();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Budget Overview Card
            Card(
              elevation: 4,
              color: isBudgetExceeded ? Colors.red[50] : Colors.green[50],
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      'Initial Budget',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    Text(
                      '₱${initialBudget.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                    const Divider(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text('Spent',
                                style: TextStyle(color: Colors.grey[700])),
                            Text(
                              '₱${totalExpenses.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.red[700],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text('Remaining',
                                style: TextStyle(color: Colors.grey[700])),
                            Text(
                              '₱${remaining.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: remaining < 0
                                    ? Colors.red
                                    : Colors.green[700],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      getBudgetStatus(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            isBudgetExceeded ? Colors.red : Colors.green[800],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Add Expense Section
            const Text(
              'Add New Expense',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: expenseNameController,
              decoration: const InputDecoration(
                labelText: 'Expense Name',
                prefixIcon: Icon(Icons.edit),
                border: OutlineInputBorder(),
                hintText: '',
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: expenseAmountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixIcon: Icon(Icons.money),
                border: OutlineInputBorder(),
                hintText: '',
              ),
            ),
            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),
              items: [
                'Food',
                'Transport',
                'Entertainment',
                'Shopping',
                'Bills',
                'Others'
              ]
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedCategory = value;
                  });
                }
              },
            ),
            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: addExpense,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Text('Add Expense', style: TextStyle(fontSize: 16)),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Expenses List Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Expense History',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Total: $numberOfExpenses',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Using for loop to display expenses
            expenses.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Icon(Icons.inbox, size: 60, color: Colors.grey[400]),
                          const SizedBox(height: 10),
                          const Text(
                            'No expenses yet',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      // Using for loop concept through ListView
                      final expense = expenses[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                getCategoryColor(expense['category']),
                            child: Icon(
                              getCategoryIcon(expense['category']),
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            expense['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(expense['category']),
                          trailing: Text(
                            '₱${expense['amount'].toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[700],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Properly dispose controllers to prevent memory leaks
    budgetController.dispose();
    expenseNameController.dispose();
    expenseAmountController.dispose();
    super.dispose();
  }
}
