import 'package:flutter/material.dart';


class AddTaskField extends StatefulWidget {
  final Function(String) onAddTask;
  
  const AddTaskField({
    super.key,
    required this.onAddTask,
  });

  @override
  State<AddTaskField> createState() => _AddTaskFieldState();
}

class _AddTaskFieldState extends State<AddTaskField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String? _errorText;

  void _addTask() {
    final title = _controller.text.trim();
    
    if (title.isEmpty) {
      setState(() {
        _errorText = 'Task title cannot be empty';
      });
      return;
    }

    widget.onAddTask(title);
    _controller.clear();
    _focusNode.unfocus();
    
    setState(() {
      _errorText = null;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: _errorText != null 
                    ? const LinearGradient(
                        colors: [Color(0xFFD32F2F), Color(0xFFE57373)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : const LinearGradient(
                        colors: [
                          Color(0xFF4A148C), 
                          Color(0xFF6A1B9A),
                          Color(0xFF8E24AA), 
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4A148C).withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Container(
                  margin: const EdgeInsets.all(1), 
                  decoration: BoxDecoration(
                    color: const Color(0xFF3D1A5B),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    decoration: const InputDecoration(
                      hintText: 'Add Task',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      hintStyle: TextStyle(
                        color: Color(0xFF9C7DB5), 
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    cursorColor: const Color(0xFFB39DDB),
                    onSubmitted: (_) => _addTask(),
                    onChanged: (_) {
                      if (_errorText != null) {
                        setState(() {
                          _errorText = null;
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF3D1A5B), 
                    Color(0xFF9C27B0), 
                  
                  ],
                
                ),
                borderRadius: BorderRadius.circular(20),
               
              ),
              child: Material(
                color: const Color.fromARGB(0, 192, 39, 39),
                child: InkWell(
                  onTap: _addTask,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: const Text(
                      'Add',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (_errorText != null) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              _errorText!,
              style: const TextStyle(
                color: Color(0xFFEF5350),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
