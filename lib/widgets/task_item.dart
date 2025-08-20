import 'package:flutter/material.dart';
import 'package:pockettask/models/tasks.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  
  const TaskItem({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red.shade400,
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
          size: 28,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF2C003E), 
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.only(left: 10,right: 16,bottom: 16,top:10),
            child: Row(
              children: [
                
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: task.done
                          ? const Color(0xFF4CAF50) // green when done
                          : Colors.purpleAccent.withOpacity(0.7), // purple-ish border
                      width: 3,
                    ),
                    color: 
                     
                         Colors.transparent,
                  ),
                  child: task.done
                      ? const Icon(
                              Icons.check,
                              color: Color(0xFF4CAF50),
                              size: 23,
                              weight: 700,
                             
                           
                        )
                      : null,
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: Text(
                    task.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      decoration: task.done
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      decorationColor: Colors.white
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
