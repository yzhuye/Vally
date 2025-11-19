import 'package:vally_app/domain/entities/course.dart';
import '../../../domain/repositories/group_repository.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GroupRepositoryImpl implements GroupRepository {
  static const storage = FlutterSecureStorage();
  static const baseUrl =
      "https://roble-api.openlab.uninorte.edu.co/database/vally_e89f74b54e";

  @override
  Future<List<Group>> getGroupsByCategory(String categoryId) async {
    final token = await storage.read(key: "accessToken");
    if (token == null) throw Exception("No access token found");

    final url = Uri.parse("$baseUrl/read").replace(queryParameters: {
      "tableName": "groups",
      "categoryId": categoryId,
    });

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;

      final groups = data.map((json) => Group.fromJson(json)).toList();

      // Obtener miembros para cada grupo
      final List<Group> groupsWithMembers = [];
      for (int i = 0; i < groups.length; i++) {
        final group = groups[i];

        // Obtener miembros del grupo
        final members = await _getGroupMembers(group.id);
        final groupWithMembers = Group(
          id: group.id,
          name: group.name,
          maxCapacity: group.maxCapacity,
          currentCapacity: group.currentCapacity,
          members: members,
          categoryId: group.categoryId,
        );

        groupsWithMembers.add(groupWithMembers);
      }

      return groupsWithMembers;
    } else {
      throw Exception(
          "Error obteniendo grupos: ${response.statusCode} ${response.body}");
    }
  }

  // Método privado para resolver un userId (email, _id o username)
  Future<String> resolveUserId(String candidate) async {
    try {
      final token = await storage.read(key: "accessToken");
      if (token == null) throw Exception("No access token found");

      // Caso 1: si contiene @ → buscar por email
      if (candidate.contains("@")) {
        final url = Uri.parse("$baseUrl/read").replace(queryParameters: {
          "tableName": "users",
          "email": candidate,
        });

        final resp = await http.get(
          url,
          headers: {"Authorization": "Bearer $token"},
        );

        if (resp.statusCode == 200) {
          final users = jsonDecode(resp.body);

          if (users is List && users.isNotEmpty) {
            return users[0]["_id"].toString();
          }
        }

        throw Exception("User not found by email");
      }

      // Caso 2: buscar por _id
      final byIdUrl = Uri.parse("$baseUrl/read").replace(queryParameters: {
        "tableName": "users",
        "_id": candidate,
      });

      final byIdResp = await http.get(
        byIdUrl,
        headers: {"Authorization": "Bearer $token"},
      );

      if (byIdResp.statusCode == 200) {
        final users = jsonDecode(byIdResp.body);
        if (users is List && users.isNotEmpty) {
          return users[0]["_id"].toString();
        }
      }

      // Caso 3: fallback → buscar por username
      final byUsernameUrl =
          Uri.parse("$baseUrl/read").replace(queryParameters: {
        "tableName": "users",
        "username": candidate,
      });

      final byUsernameResp = await http.get(
        byUsernameUrl,
        headers: {"Authorization": "Bearer $token"},
      );

      if (byUsernameResp.statusCode == 200) {
        final users = jsonDecode(byUsernameResp.body);
        if (users is List && users.isNotEmpty) {
          return users[0]["_id"].toString();
        }
      }

      throw Exception("User not found by id/username");
    } catch (e) {
      throw Exception("Unable to resolve user id: $e");
    }
  }

  // Método privado para obtener los miembros de un grupo
  Future<List<String>> _getGroupMembers(String groupId) async {
    final token = await storage.read(key: "accessToken");
    if (token == null) throw Exception("No access token found");

    final url = Uri.parse("$baseUrl/read").replace(queryParameters: {
      "tableName": "user_groups",
      "group_id": groupId,
    });

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      final List<String> members = [];

      for (var item in data) {
        final userId = item['user_id']?.toString() ?? '';
        if (userId.isNotEmpty) {
          // Convertir user_id a email si es necesario
          final email = await _convertUserIdToEmail(userId);
          members.add(email);
        }
      }

      return members;
    } else {
      return [];
    }
  }

  // Método privado para convertir user_id a email
  Future<String> _convertUserIdToEmail(String userId) async {
    // Si ya es un email, devolverlo tal como está
    if (userId.contains('@')) {
      return userId;
    }

    // Si es un nombre, buscar el email en la tabla users
    try {
      final token = await storage.read(key: "accessToken");
      if (token == null) throw Exception("No access token found");

      final url = Uri.parse("$baseUrl/read").replace(queryParameters: {
        "tableName": "users",
        "username": userId,
      });

      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        if (data.isNotEmpty) {
          final email = data.first['email']?.toString() ?? userId;
          return email;
        }
      }
    } catch (e) {}

    // Si no se puede convertir, devolver el valor original
    return userId;
  }

  @override
  Future<Group?> addGroup(
      String name, int maxCapacity, String categoryId) async {
    final token = await storage.read(key: "accessToken");
    if (token == null) throw Exception("No access token found");

    final url = Uri.parse("$baseUrl/insert");

    final body = {
      "tableName": "groups",
      "records": [
        {
          "name": name,
          "maxCapacity": maxCapacity,
          "currentCapacity": 0, // Inicializar en 0
          "categoryId": categoryId,
        }
      ]
    };

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);

      // Handle both List and Map responses
      if (data is List && data.isNotEmpty) {
        return Group.fromJson(data.first);
      } else if (data is Map && data.isNotEmpty) {
        return Group.fromJson(Map<String, dynamic>.from(data));
      } else {
        return null;
      }
    } else {
      throw Exception(
          "Error creando grupo: ${response.statusCode} ${response.body}");
    }
  }

  @override
  Future<bool> joinGroup({
    required String userId,
    required String groupId,
  }) async {
    // Asegurar que userId sea un userId válido
    final emailUserId = await resolveUserId(userId);

    final token = await storage.read(key: "accessToken");
    if (token == null) throw Exception("No access token found");

    final getGroupUrl = Uri.parse("$baseUrl/read").replace(queryParameters: {
      "tableName": "groups",
      "_id": groupId,
    });

    final groupResponse = await http.get(
      getGroupUrl,
      headers: {"Authorization": "Bearer $token"},
    );

    if (groupResponse.statusCode != 200) {
      throw Exception("Error al obtener grupo: ${groupResponse.statusCode}");
    }
    final groupData = jsonDecode(groupResponse.body);

    if (groupData.isEmpty) {
      throw Exception("El grupo no existe");
    }

    final group = groupData.first;
    final int maxCapacity = int.tryParse(group["maxCapacity"].toString()) ?? 0;
    final int currentCapacity =
        int.tryParse(group["currentCapacity"].toString()) ?? 0;

    if (currentCapacity >= maxCapacity) {
      return false;
    }

    final insertUrl = Uri.parse("$baseUrl/insert");
    final insertBody = {
      "tableName": "user_groups",
      "records": [
        {
          "user_id": emailUserId,
          "group_id": groupId,
        }
      ]
    };

    final insertResponse = await http.post(
      insertUrl,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode(insertBody),
    );

    if (insertResponse.statusCode != 200 && insertResponse.statusCode != 201) {
      throw Exception(
          "Error insertando en user_groups: ${insertResponse.statusCode}");
    }

    final updateUrl = Uri.parse("$baseUrl/update");
    final newCapacity = currentCapacity + 1;
    final updateBody = {
      "tableName": "groups",
      "idColumn": "_id",
      "idValue": groupId,
      "updates": {
        "currentCapacity": newCapacity,
      }
    };

    final updateResponse = await http.put(
      updateUrl,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode(updateBody),
    );

    final success = updateResponse.statusCode == 200;

    return success;
  }

  @override
  Future<bool> leaveGroup({
    required String userId,
    required String groupId,
  }) async {
    final token = await storage.read(key: "accessToken");
    if (token == null) throw Exception("No access token found");

    // Asegurar que userId sea un email
    final emailUserId = await resolveUserId(userId);

    final getGroupUrl = Uri.parse("$baseUrl/read").replace(queryParameters: {
      "tableName": "groups",
      "_id": groupId,
    });
    final groupResponse = await http.get(
      getGroupUrl,
      headers: {"Authorization": "Bearer $token"},
    );
    if (groupResponse.statusCode != 200) {
      throw Exception("Error al obtener grupo: ${groupResponse.statusCode}");
    }
    final groupData = jsonDecode(groupResponse.body) as List<dynamic>;
    if (groupData.isEmpty) {
      throw Exception("El grupo no existe");
    }

    final group = groupData.first;
    final int currentCapacity =
        int.tryParse(group["currentCapacity"].toString()) ?? 0;
    final int newCapacity = (currentCapacity > 0) ? currentCapacity - 1 : 0;
    final readUrl = Uri.parse("$baseUrl/read").replace(queryParameters: {
      "tableName": "user_groups",
      "user_id": emailUserId,
      "group_id": groupId,
    });
    final readResponse = await http.get(
      readUrl,
      headers: {"Authorization": "Bearer $token"},
    );
    if (readResponse.statusCode != 200) {
      throw Exception(
          "Error buscando relación user_group: ${readResponse.statusCode}");
    }
    final userGroupData = jsonDecode(readResponse.body);
    if (userGroupData.isEmpty) {
      return false;
    }
    final String relationId = userGroupData.first["_id"];

    final deleteUrl = Uri.parse("$baseUrl/delete");
    final deleteBody = {
      "tableName": "user_groups",
      "idColumn": "_id",
      "idValue": relationId,
    };
    final deleteResponse = await http.delete(
      deleteUrl,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode(deleteBody),
    );
    if (deleteResponse.statusCode != 200 && deleteResponse.statusCode != 201) {
      throw Exception(
          "Error eliminando relación user_group: ${deleteResponse.statusCode}");
    }
    final updateUrl = Uri.parse("$baseUrl/update");
    final updateBody = {
      "tableName": "groups",
      "idColumn": "_id",
      "idValue": groupId,
      "updates": {
        "currentCapacity": newCapacity,
      }
    };
    final updateResponse = await http.put(
      updateUrl,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode(updateBody),
    );

    return updateResponse.statusCode == 200;
  }

  @override
  Future<void> createGroupsForCategory(String categoryId, int groupCount,
      int studentsPerGroup, String? categoryName) async {
    for (int i = 1; i <= groupCount; i++) {
      final group = Group(
        id: '${categoryId}_group_$i',
        name: categoryName != null ? '$categoryName - Grupo $i' : 'Grupo $i',
        maxCapacity: studentsPerGroup,
        members: [],
        categoryId: categoryId,
      );

      await addGroup(group.name, group.maxCapacity, group.categoryId);
    }
  }

  @override
  Future<bool> assignStudentToGroup(String userId, String newGroupId) async {
    final token = await storage.read(key: "accessToken");
    if (token == null) throw Exception("No access token found");

    try {
      // Asegurar que userId sea un email
      final emailUserId = await resolveUserId(userId);
      final getGroupUrl = Uri.parse("$baseUrl/read").replace(queryParameters: {
        "tableName": "groups",
        "_id": newGroupId,
      });
      final groupResponse = await http.get(
        getGroupUrl,
        headers: {"Authorization": "Bearer $token"},
      );
      if (groupResponse.statusCode != 200) {
        throw Exception(
            "Error obteniendo grupo nuevo: ${groupResponse.statusCode}");
      }
      final groupData = jsonDecode(groupResponse.body) as List<dynamic>;
      if (groupData.isEmpty) throw Exception("El grupo nuevo no existe");

      final newGroup = groupData.first;
      final String categoryId = newGroup["categoryId"];
      final readUserGroupsUrl =
          Uri.parse("$baseUrl/read").replace(queryParameters: {
        "tableName": "user_groups",
        "user_id": emailUserId,
      });
      final userGroupsResponse = await http.get(
        readUserGroupsUrl,
        headers: {"Authorization": "Bearer $token"},
      );
      if (userGroupsResponse.statusCode != 200) {
        throw Exception(
            "Error buscando grupos del usuario: ${userGroupsResponse.statusCode}");
      }
      final userGroups = jsonDecode(userGroupsResponse.body) as List<dynamic>;

      String? oldGroupId;
      for (final userGroup in userGroups) {
        final groupId = userGroup["group_id"];
        final getRelatedGroupUrl =
            Uri.parse("$baseUrl/read").replace(queryParameters: {
          "tableName": "groups",
          "_id": groupId,
        });
        final relatedGroupResponse = await http.get(
          getRelatedGroupUrl,
          headers: {"Authorization": "Bearer $token"},
        );
        if (relatedGroupResponse.statusCode == 200) {
          final relatedGroupData = jsonDecode(relatedGroupResponse.body);
          if (relatedGroupData.isNotEmpty) {
            final relatedGroup = relatedGroupData.first;
            if (relatedGroup["categoryId"] == categoryId) {
              oldGroupId = groupId;
              break;
            }
          }
        }
      }

      if (oldGroupId != null) {
        final left = await leaveGroup(userId: emailUserId, groupId: oldGroupId);
        if (!left) {
          return false;
        }
      }

      final joined = await joinGroup(userId: emailUserId, groupId: newGroupId);
      return joined;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Group?> findStudentGroup(String categoryId, String studentId) async {
    final token = await storage.read(key: "accessToken");
    if (token == null) throw Exception("No access token found");

    // Convertir studentId a email si es necesario
    final emailStudentId = await resolveUserId(studentId);

    // Fetch all groups for the category (single request)
    final groups = await getGroupsByCategory(categoryId);
    if (groups.isEmpty) return null;

    // Fetch all user_groups relations for this user
    final readUserGroupsUrl =
        Uri.parse("$baseUrl/read").replace(queryParameters: {
      "tableName": "user_groups",
      "user_id": emailStudentId,
    });
    final userGroupsResponse = await http.get(
      readUserGroupsUrl,
      headers: {"Authorization": "Bearer $token"},
    );
    if (userGroupsResponse.statusCode != 200) {
      throw Exception(
          "Error buscando grupos del usuario: ${userGroupsResponse.statusCode}");
    }
    final userGroups = jsonDecode(userGroupsResponse.body) as List<dynamic>;
    if (userGroups.isEmpty) return null;

    // Collect group_ids the user belongs to
    final userGroupIds = userGroups
        .map((ug) => ug["group_id"]) // dynamic
        .where((id) => id != null)
        .map((id) => id.toString())
        .toSet();

    // Return the first group from the category that the user belongs to
    for (final group in groups) {
      if (userGroupIds.contains(group.id)) {
        return group;
      }
    }

    return null;
  }
}
