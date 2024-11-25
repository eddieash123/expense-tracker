import 'package:expense_tracker/widget/charts/chart.dart';
import 'package:expense_tracker/widget/expenses_list/expense_list.dart';
import 'package:expense_tracker/model/expense.dart';
import 'package:expense_tracker/widget/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget{
  const Expenses({super.key});
  
  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses>{
  
  void _openAddExpenseOverlay(){
    showModalBottomSheet(
      isScrollControlled: true,
      context: context, 
      builder: (ctx) =>  NewExpense(onAddExpense: _addExpense),
    );
  }

  void _addExpense(Expense expense){
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration:const  Duration(seconds: 3),
        content:const Text('Expense Deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: (){
            setState(() {
              _registeredExpenses.insert(
              _registeredExpenses.length, expense //when undone, added to the bottom of the list
            );
            });
          },
        ),
      )
    );
  }

  final List<Expense> _registeredExpenses = [
    Expense(
        title: 'Cheeseburger',
        amount:11.99, 
        date: DateTime.now(),
        category: Category.food
      ),
    Expense(
        title: 'Plane Ticket',
        amount: 250.37,
        date: DateTime.now(),
        category: Category.travel
      ),
  ];

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('No Expenses found. Click + to add one!'),
    );
    if(_registeredExpenses.isNotEmpty){
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
          onPressed: _openAddExpenseOverlay,
          icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Column(
        children: [
          Chart(expenses: _registeredExpenses ),
          Expanded(
            child: mainContent,
          )
        ],
      ),
    );
  }
}

class ExpenseBucket {
  const ExpenseBucket({
    required this.category,
    required this.expenses,
  });

  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;
    for (final expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }

  ExpenseBucket.forCategory(
    List<Expense> allExpenses, this.category
  ) : expenses = allExpenses.where((expense) => expense.category == category).toList();


}