
import 'package:flutter/material.dart';

class SetTimerWidget extends StatefulWidget {
  const SetTimerWidget(this.updateIntervalCallback,{super.key});


  final Function(String) updateIntervalCallback;

  @override
  State<SetTimerWidget> createState() => _SetTimerWidgetState();
}

class _SetTimerWidgetState extends State<SetTimerWidget> {
  final TextEditingController _intervalController = TextEditingController();

  final defaultInterval = 5;

  @override
  void initState() {
    _intervalController.text = defaultInterval.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Set Timer (seconds): '),
                  SizedBox(
                    width: 50,
                    child: TextField(
                      controller: _intervalController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: widget.updateIntervalCallback, // Update interval on submitting
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      widget.updateIntervalCallback(_intervalController.text);
                    },
                    child: const Text('Set'),
                  ),
                ],
              );
  }

  @override
  void dispose() {
    _intervalController.dispose();
    super.dispose();
  }
}