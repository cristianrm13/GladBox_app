import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CommentScreen extends StatefulWidget {
  final String complaintId;

  const CommentScreen({super.key, required this.complaintId});

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  late Future<List<dynamic>> _futureComments;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    print('Complaint ID: ${widget.complaintId}');
    _futureComments = fetchComments();
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception('Token no encontrado. Por favor, inicia sesión nuevamente.');
    }
    return token;
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await getToken();
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  Future<List<dynamic>> fetchComments() async {
    final url = Uri.parse(
        'http://gladboxapi.integrador.xyz:3000/api/v1/comentarios/${widget.complaintId}');
    try {
      final headers = await _getHeaders();
      final response = await http.get(url, headers: headers);
print('URL para fetchComments: $url');
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final error = json.decode(response.body)['error'] ?? 'Error desconocido';
        throw Exception('Error al obtener comentarios: $error');
      }
    } catch (e) {
      throw Exception('Ha ocurrido un error inesperado: $e');
    }
  }

  Future<void> addComment(String comment) async {
    final url = Uri.parse(
        'http://gladboxapi.integrador.xyz:3000/api/v1/comentarios/${widget.complaintId}');
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({'content': comment}),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comentario agregado exitosamente')),
        );
        setState(() {
          _futureComments = fetchComments();
        });
        _commentController.clear();
      } else {
        final error = json.decode(response.body)['error'] ?? 'Error desconocido';
        throw Exception('Error al agregar comentario: $error');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isSending = false);
    }
  }

  void showError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comentarios'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _futureComments,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else {
                  final comments = snapshot.data ?? [];
                  return ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      return ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(comment['content']),
                        subtitle: Text(comment['userId']?['nombre'] ?? 'Usuario desconocido'),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Escribe un comentario...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.green),
                  onPressed: () {
                    if (_commentController.text.trim().isNotEmpty) {
                      if (_isSending) return;
                      setState(() => _isSending = true);
                      addComment(_commentController.text.trim());
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
