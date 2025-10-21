import 'package:vally_app/domain/entities/course.dart';
import 'package:vally_app/data/datasources/evaluation/evaluation_datasource.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Remote implementation of the evaluation data source
/// This is a placeholder for future API integration
class EvaluationDataSourceRemote implements EvaluationDataSource {
  final baseUrl = "https://roble-api.openlab.uninorte.edu.co/database/vally_e89f74b54e";
  final storage = FlutterSecureStorage();

  @override
  Future<Evaluation?> createEvaluation(Evaluation evaluation) async {
    final token = await storage.read(key: "accessToken");
    if (token == null) throw Exception("No access token found");

    final url = Uri.parse("$baseUrl/insert");

    final body = {
      "tableName": "evaluations",
      "records": [
        {
          "activityId": evaluation.activityId,
          "evaluatorId": evaluation.evaluatorId,
          "evaluatedId": evaluation.evaluatedId,
          "punctuality": evaluation.punctuality,
          "contributions": evaluation.contributions,
          "commitment": evaluation.commitment,
          "attitude": evaluation.attitude,
          "createdAt": evaluation.createdAt.toIso8601String(),
        }
      ]
    };

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);

      if (data["inserted"] != null && data["inserted"].isNotEmpty) {
        final inserted = data["inserted"].first;
        return Evaluation(
          id: inserted["_id"],
          activityId: inserted["activityId"],
          evaluatorId: inserted["evaluatorId"],
          evaluatedId: inserted["evaluatedId"],
          punctuality: inserted["punctuality"],
          contributions: inserted["contributions"],
          commitment: inserted["commitment"],
          attitude: inserted["attitude"],
          createdAt: DateTime.parse(inserted["createdAt"]),
        );
      }
    }

    throw Exception(
      "Error creando evaluación: ${response.statusCode} ${response.body}",
    );
  }

  @override
  Future<List<Evaluation>> getEvaluationsByActivity(String activityId) async {
    final token = await storage.read(key: "accessToken");
    if (token == null) throw Exception("No access token found");

    final url = Uri.parse("$baseUrl/read").replace(queryParameters: {
      "tableName": "evaluations",
      "activityId": activityId,
    });

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      throw Exception("Error obteniendo evaluaciones: ${response.statusCode}");
    }

    final data = jsonDecode(response.body);

    if (data is! List) {
      throw Exception("Formato de respuesta inesperado al obtener evaluaciones");
    }

    return data.map<Evaluation>((e) {
      return Evaluation(
        id: e["_id"],
        activityId: e["activityId"],
        evaluatorId: e["evaluatorId"],
        evaluatedId: e["evaluatedId"],
        punctuality: e["punctuality"],
        contributions: e["contributions"],
        commitment: e["commitment"],
        attitude: e["attitude"],
        createdAt: DateTime.parse(e["createdAt"]),
      );
    }).toList();
  }

  @override
  Future<List<Evaluation>> getEvaluationsByEvaluator(String evaluatorId) async {
    final token = await storage.read(key: "accessToken");
    if (token == null) throw Exception("No access token found");

    final url = Uri.parse("$baseUrl/read").replace(queryParameters: {
      "tableName": "evaluations",
      "evaluatorId": evaluatorId,
    });

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      throw Exception("Error obteniendo evaluaciones: ${response.statusCode}");
    }

    final data = jsonDecode(response.body);

    if (data is! List) {
      throw Exception("Formato de respuesta inesperado al obtener evaluaciones");
    }

    return data.map<Evaluation>((e) {
      return Evaluation(
        id: e["_id"],
        activityId: e["activityId"],
        evaluatorId: e["evaluatorId"],
        evaluatedId: e["evaluatedId"],
        punctuality: e["punctuality"],
        contributions: e["contributions"],
        commitment: e["commitment"],
        attitude: e["attitude"],
        createdAt: DateTime.parse(e["createdAt"]),
      );
    }).toList();
  }

  @override
  Future<List<Evaluation>> getEvaluationsForStudent(String studentId) async {
    final token = await storage.read(key: "accessToken");
    if (token == null) throw Exception("No access token found");

    final url = Uri.parse("$baseUrl/read").replace(queryParameters: {
      "tableName": "evaluations",
      "evaluatedId": studentId,
    });

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      throw Exception("Error obteniendo evaluaciones: ${response.statusCode}");
    }

    final data = jsonDecode(response.body);

    if (data is! List) {
      throw Exception("Formato de respuesta inesperado al obtener evaluaciones");
    }

    return data.map<Evaluation>((e) {
      return Evaluation(
        id: e["_id"],
        activityId: e["activityId"],
        evaluatorId: e["evaluatorId"],
        evaluatedId: e["evaluatedId"],
        punctuality: e["punctuality"],
        contributions: e["contributions"],
        commitment: e["commitment"],
        attitude: e["attitude"],
        createdAt: DateTime.parse(e["createdAt"]),
      );
    }).toList();
  }

  @override
  Future<Evaluation?> getEvaluationById(String evaluationId) async {
    final token = await storage.read(key: "accessToken");
    if (token == null) throw Exception("No access token found");

    final url = Uri.parse("$baseUrl/read").replace(queryParameters: {
      "tableName": "evaluations",
      "_id": evaluationId,
    });

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      throw Exception("Error obteniendo evaluación: ${response.statusCode}");
    }

    final data = jsonDecode(response.body);

    return Evaluation(
      id: data["_id"],
      activityId: data["activityId"],
      evaluatorId: data["evaluatorId"],
      evaluatedId: data["evaluatedId"],
      punctuality: data["punctuality"],
      contributions: data["contributions"],
      commitment: data["commitment"],
      attitude: data["attitude"],
      createdAt: DateTime.parse(data["createdAt"]),
    );
  }

  @override
  Future<Evaluation?> updateEvaluation(Evaluation evaluation) async {
    final token = await storage.read(key: "accessToken");
    if (token == null) throw Exception("No access token found");

    final url = Uri.parse("$baseUrl/update");

    final body = {
      "tableName": "evaluations",
      "idColumn": "_id",
      "idValue": evaluation.id,
      "updates": {
        "activityId": evaluation.activityId,
        "evaluatorId": evaluation.evaluatorId,
        "evaluatedId": evaluation.evaluatedId,
        "punctuality": evaluation.punctuality,
        "contributions": evaluation.contributions,
        "commitment": evaluation.commitment,
        "attitude": evaluation.attitude,
      }
    };

    final response = await http.put(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      if (data!= null && data.isNotEmpty) {
        return Evaluation(
          id: data["_id"],
          activityId: data["activityId"],
          evaluatorId: data["evaluatorId"],
          evaluatedId: data["evaluatedId"],
          punctuality: data["punctuality"],
          contributions: data["contributions"],
          commitment: data["commitment"],
          attitude: data["attitude"],
          createdAt: DateTime.parse(data["createdAt"]),
        );
      }
    }

    throw Exception(
      "Error actualizando evaluación: ${response.statusCode} ${response.body}",
    );
  }

  @override
  Future<void> deleteEvaluation(String evaluationId) async {
    final token = await storage.read(key: "accessToken");
    if (token == null) throw Exception("No access token found");

    final url = Uri.parse("$baseUrl/delete");

    final body = {
      "tableName": "evaluations",
      "idColumn": "_id",
      "idValue": evaluationId,
    };

    final response = await http.delete(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception("Error eliminando evaluación: ${response.statusCode}");
    }
  }

  @override
  Future<bool> hasEvaluated(String activityId, String evaluatorId, String evaluatedId) async {
    // TODO: Implement API call to check if evaluation exists
    // return await _evaluationApiService.hasEvaluated(activityId, evaluatorId, evaluatedId);

    throw UnimplementedError('Remote implementation not yet available. '
        'This will be implemented when the backend API is ready.');
  }

  @override
  Future<double> getAverageRatingForStudent(String activityId, String studentId) async {
    // TODO: Implement API call to get average rating
    // return await _evaluationApiService.getAverageRatingForStudent(activityId, studentId);

    throw UnimplementedError('Remote implementation not yet available. '
        'This will be implemented when the backend API is ready.');
  }

  @override
  Future<Map<String, dynamic>> getActivityEvaluationStats(String activityId) async {
    // TODO: Implement API call to get activity evaluation stats
    // return await _evaluationApiService.getActivityEvaluationStats(activityId);

    throw UnimplementedError('Remote implementation not yet available. '
        'This will be implemented when the backend API is ready.');
  }
}
