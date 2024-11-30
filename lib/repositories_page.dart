import 'package:flutter/material.dart';
import 'api_service.dart';

class RepositoriesPage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const RepositoriesPage({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  _RepositoriesPageState createState() => _RepositoriesPageState();
}

class _RepositoriesPageState extends State<RepositoriesPage> {
  final Map<int, int> _likes = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Repositórios'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return FutureBuilder(
      future: ApiService.getRepositories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Erro ao carregar repositórios.',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }

          var repositories = snapshot.data;
          return ListView.separated(
            itemCount: repositories.length,
            itemBuilder: (context, index) {
              var repository = repositories[index];
              _likes.putIfAbsent(index, () => 0);

              // Cores para o fundo e texto (ajustados para suavizar)
              Color backgroundColor = widget.isDarkMode
                  ? Colors.purple.shade700 // tom mais suave de roxo no dark mode
                  : Colors.purple.shade100; // tom mais suave de roxo no light mode
              Color textColor = widget.isDarkMode ? Colors.white : Colors.black;
              Color subtitleColor = widget.isDarkMode ? Colors.grey[400]! : Colors.grey[700]!;

              return ListTile(
                dense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                title: Text(
                  repository!.name.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: textColor,
                  ),
                ),
                subtitle: Text(
                  repository!.description.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: subtitleColor,
                  ),
                ),
                leading: CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage(repository?.avatar),
                  backgroundColor: widget.isDarkMode
                      ? Colors.grey.shade800
                      : Colors.grey.shade200,
                ),
                tileColor: backgroundColor, // Fundo mais suave
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.thumb_up, color: Colors.grey), // Ícone de like em cinza
                      onPressed: () {
                        setState(() {
                          _likes[index] = _likes[index]! + 1;
                        });
                      },
                    ),
                    Text(
                      '${_likes[index]}',
                      style: TextStyle(
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                color: widget.isDarkMode
                    ? Colors.grey[600]
                    : Colors.deepPurple.withOpacity(0.5), // Divider suave
                thickness: 1,
                indent: 16.0,
                endIndent: 16.0,
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.deepPurple,
            ),
          );
        }
      },
    );
  }
}
