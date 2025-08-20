import 'package:flutter/material.dart';

/// Purple gradient search box widget matching the design
class SearchBox extends StatefulWidget {
  final Function(String) onSearchChanged;
  
  const SearchBox({
    super.key,
    required this.onSearchChanged,
  });

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
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
            color: const Color(0xFF4A148C).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(1), 
        decoration: BoxDecoration(
          color: const Color(0xFF3D1A5B), 
          borderRadius: BorderRadius.circular(19),
        ),
        child: TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: 'Search',
            border: InputBorder.none,
            contentPadding:  EdgeInsets.all(16),
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 16, right: 12),
              child: Icon(
                Icons.search_rounded,
                color: Color(0xFF9C7DB5), 
                size: 24,
              ),
            ),
            prefixIconConstraints: BoxConstraints(
              minWidth: 52,
              minHeight: 24,
            ),
            hintStyle:  TextStyle(
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
          onChanged: widget.onSearchChanged,
        ),
      ),
    );
  }
}


