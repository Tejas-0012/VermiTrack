import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:monitor/models/chat_response.dart';
import 'package:monitor/utils/constants.dart';

class ChatService {
  // Mock sensor data (in real app, get from provider)
  final Map<String, dynamic> _sensorData = {
    'moisture': 65.2,
    'temperature': 28.5,
    'ph': 7.2,
    'compostDay': 15,
    'compostHealth': 'Healthy',
  };

  // Knowledge base - Rule-based responses
  final Map<String, Map<String, dynamic>> _knowledgeBase = {
    'greeting': {
      'patterns': [
        'hello',
        'hi',
        'hey',
        'namaste',
        'good morning',
        'good afternoon',
      ],
      'responses': [
        'Namaste Farmer! 👨‍🌾 How can I help you today?',
        'Hello! I am your Digital Krushi Mitra. Ask me anything about vermicomposting.',
        'Hi there! Ready to help with your compost questions.',
      ],
    },
    'moisture': {
      'patterns': ['moisture', 'water', 'dry', 'wet', 'sprinkle', 'watering'],
      'responses': {
        'low':
            'Current moisture is \${moisture}% which is low. Please sprinkle water for 20 seconds.',
        'optimal':
            'Current moisture is \${moisture}% which is perfect. No watering needed today.',
        'high':
            'Current moisture is \${moisture}% which is high. Please stop watering for 2-3 days.',
      },
      'suggestions': ['Check moisture', 'Water now', 'Stop watering'],
    },
    'compost_ready': {
      'patterns': ['ready', 'harvest', 'complete', 'finished', 'done'],
      'responses': {
        'early':
            'Compost is on Day \${day} of 45. Still \${remaining} days to go. Continue regular maintenance.',
        'almost':
            'Compost is on Day \${day} of 45. It will be ready in \${remaining} days. Start preparing for harvest.',
        'ready':
            'Congratulations! 🎉 Compost is ready for harvest on Day \${day}. Follow the harvest guide.',
      },
      'suggestions': ['View harvest guide', 'Check compost progress'],
    },
    'smell': {
      'patterns': ['smell', 'odor', 'stink', 'bad smell', 'foul'],
      'responses': [
        'Bad smell usually indicates excess moisture or lack of oxygen. Reduce watering and improve aeration.',
        'Unpleasant odor may be due to overfeeding. Reduce kitchen waste and turn the bed gently.',
        'Foul smell often means anaerobic conditions. Add dry leaves or cocopeat and aerate the bed.',
      ],
      'suggestions': ['Reduce watering', 'Improve aeration', 'Check feeding'],
    },
    'temperature': {
      'patterns': ['temperature', 'hot', 'cold', 'heat', 'cool'],
      'responses': {
        'low':
            'Current temperature is \${temperature}°C which is low. Keep the bed in a warmer place.',
        'optimal':
            'Current temperature is \${temperature}°C which is perfect for worms.',
        'high':
            'Current temperature is \${temperature}°C which is high. Move bed to a cooler, shaded area.',
      },
      'suggestions': ['Check temperature', 'Move bed location'],
    },
    'feeding': {
      'patterns': ['feed', 'food', 'waste', 'kitchen', 'add food'],
      'responses': [
        'Add 250g kitchen waste daily. Avoid onion, garlic, citrus, and oily foods.',
        'Feed worms vegetable scraps, fruit peels, coffee grounds, and crushed eggshells.',
        'Cut food into small pieces for faster decomposition. Bury food under bedding.',
      ],
      'suggestions': ['View feeding schedule', 'Foods to avoid'],
    },
    'ph': {
      'patterns': ['ph', 'acid', 'alkaline', 'neutral'],
      'responses': {
        'low':
            'pH is \${ph} which is acidic. Add crushed eggshells or garden lime.',
        'optimal':
            'pH is \${ph} which is perfect. Maintain current conditions.',
        'high':
            'pH is \${ph} which is alkaline. Add more vegetable scraps or coffee grounds.',
      },
      'suggestions': ['Check pH level', 'Balance pH'],
    },
    'default': {
      'responses': [
        'I am not sure about that. You can ask about moisture, temperature, feeding, or compost readiness.',
        'That\'s a good question! For specific compost advice, check the Guide section.',
        'I specialize in vermicomposting. Try asking about your compost bed conditions.',
      ],
      'suggestions': ['Check moisture', 'Is compost ready?', 'Guide section'],
    },
  };

  Future<ChatResponse> sendMessage(String message) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Check if it's a greeting
    if (_isGreeting(message)) {
      return _handleGreeting();
    }

    // Find matching intent
    final intent = _findIntent(message.toLowerCase());

    // Generate response based on intent
    final response = _generateResponse(intent, message);

    return response;
  }

  bool _isGreeting(String message) {
    final greetings = [
      'hello',
      'hi',
      'hey',
      'namaste',
      'good morning',
      'good afternoon',
    ];
    return greetings.any(
      (greeting) => message.toLowerCase().contains(greeting),
    );
  }

  ChatResponse _handleGreeting() {
    final responses = _knowledgeBase['greeting']!['responses'] as List<String>;
    final randomResponse =
        responses[DateTime.now().millisecondsSinceEpoch % responses.length];

    return ChatResponse(
      reply: randomResponse,
      suggestions: ['Check moisture', 'Is compost ready?', 'Feeding schedule'],
    );
  }

  String _findIntent(String message) {
    for (final entry in _knowledgeBase.entries) {
      if (entry.key == 'greeting' || entry.key == 'default') continue;

      final patterns = entry.value['patterns'] as List<String>;
      if (patterns.any((pattern) => message.contains(pattern))) {
        return entry.key;
      }
    }
    return 'default';
  }

  ChatResponse _generateResponse(String intent, String originalMessage) {
    final knowledge = _knowledgeBase[intent] ?? _knowledgeBase['default']!;

    String reply;
    List<String>? suggestions;

    if (intent == 'default') {
      final responses = knowledge['responses'] as List<String>;
      reply =
          responses[DateTime.now().millisecondsSinceEpoch % responses.length];
      suggestions = knowledge['suggestions'] as List<String>?;
    } else {
      // Handle dynamic responses with sensor data
      if (knowledge['responses'] is Map<String, dynamic>) {
        final responses = knowledge['responses'] as Map<String, dynamic>;
        final condition = _evaluateCondition(intent);
        reply = _replacePlaceholders(responses[condition] as String);
      } else {
        final responses = knowledge['responses'] as List<String>;
        reply =
            responses[DateTime.now().millisecondsSinceEpoch % responses.length];
      }

      suggestions = knowledge['suggestions'] as List<String>?;
    }

    return ChatResponse(reply: reply, suggestions: suggestions);
  }

  String _evaluateCondition(String intent) {
    switch (intent) {
      case 'moisture':
        final moisture = _sensorData['moisture'] as double;
        if (moisture < 55) return 'low';
        if (moisture > 70) return 'high';
        return 'optimal';

      case 'compost_ready':
        final day = _sensorData['compostDay'] as int;
        if (day < 30) return 'early';
        if (day < 40) return 'almost';
        return 'ready';

      case 'temperature':
        final temp = _sensorData['temperature'] as double;
        if (temp < 25) return 'low';
        if (temp > 35) return 'high';
        return 'optimal';

      case 'ph':
        final ph = _sensorData['ph'] as double;
        if (ph < 6.5) return 'low';
        if (ph > 7.5) return 'high';
        return 'optimal';

      default:
        return 'optimal';
    }
  }

  String _replacePlaceholders(String template) {
    return template
        .replaceAll('\${moisture}', _sensorData['moisture'].toString())
        .replaceAll('\${temperature}', _sensorData['temperature'].toString())
        .replaceAll('\${ph}', _sensorData['ph'].toString())
        .replaceAll('\${day}', _sensorData['compostDay'].toString())
        .replaceAll(
          '\${remaining}',
          (45 - _sensorData['compostDay']).toString(),
        )
        .replaceAll('\${health}', _sensorData['compostHealth'].toString());
  }

  // For future API integration
  Future<ChatResponse> _callBackendAPI(String message) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/chat'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'message': message,
          'userId': 'demo_user',
          'sensorData': _sensorData,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ChatResponse.fromJson(data);
      } else {
        throw Exception('Failed to get response');
      }
    } catch (e) {
      // Fallback to rule-based
      return sendMessage(message);
    }
  }
}
