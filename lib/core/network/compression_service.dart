import 'dart:convert';
import 'dart:typed_data';
import 'package:injectable/injectable.dart';

@singleton
class CompressionService {
  // Compress JSON data
  Map<String, dynamic> compressJson(Map<String, dynamic> data) {
    return _compressMap(data);
  }

  // Decompress JSON data
  Map<String, dynamic> decompressJson(Map<String, dynamic> compressedData) {
    return _decompressMap(compressedData);
  }

  // Compress a map recursively
  Map<String, dynamic> _compressMap(Map<String, dynamic> map) {
    final compressed = <String, dynamic>{};

    for (final entry in map.entries) {
      final key = _compressString(entry.key);
      dynamic value = entry.value;

      if (value is Map<String, dynamic>) {
        value = _compressMap(value);
      } else if (value is List) {
        value = _compressList(value);
      } else if (value is String) {
        value = _compressString(value);
      }

      compressed[key] = value;
    }

    return compressed;
  }

  // Decompress a map recursively
  Map<String, dynamic> _decompressMap(Map<String, dynamic> map) {
    final decompressed = <String, dynamic>{};

    for (final entry in map.entries) {
      final key = _decompressString(entry.key);
      dynamic value = entry.value;

      if (value is Map<String, dynamic>) {
        value = _decompressMap(value);
      } else if (value is List) {
        value = _decompressList(value);
      } else if (value is String) {
        value = _decompressString(value);
      }

      decompressed[key] = value;
    }

    return decompressed;
  }

  // Compress a list
  List<dynamic> _compressList(List<dynamic> list) {
    return list.map((item) {
      if (item is Map<String, dynamic>) {
        return _compressMap(item);
      } else if (item is List) {
        return _compressList(item);
      } else if (item is String) {
        return _compressString(item);
      }
      return item;
    }).toList();
  }

  // Decompress a list
  List<dynamic> _decompressList(List<dynamic> list) {
    return list.map((item) {
      if (item is Map<String, dynamic>) {
        return _decompressMap(item);
      } else if (item is List) {
        return _decompressList(item);
      } else if (item is String) {
        return _decompressString(item);
      }
      return item;
    }).toList();
  }

  // Simple string compression (placeholder - would use actual compression library)
  String _compressString(String input) {
    // This is a placeholder implementation
    // In a real app, you would use a compression library like gzip
    try {
      // Simple base64 encoding to simulate compression
      final bytes = utf8.encode(input);
      return base64.encode(bytes);
    } catch (e) {
      return input;
    }
  }

  // Simple string decompression
  String _decompressString(String input) {
    // This is a placeholder implementation
    try {
      final bytes = base64.decode(input);
      return utf8.decode(bytes);
    } catch (e) {
      return input;
    }
  }

  // Compress binary data
  Uint8List compressBytes(Uint8List data) {
    // Placeholder implementation
    // In a real app, you would use a compression library
    return data;
  }

  // Decompress binary data
  Uint8List decompressBytes(Uint8List compressedData) {
    // Placeholder implementation
    return compressedData;
  }

  // Get compression ratio
  double getCompressionRatio(int originalSize, int compressedSize) {
    if (originalSize == 0) return 0.0;
    return (originalSize - compressedSize) / originalSize;
  }

  // Estimate compressed size (rough estimation)
  int estimateCompressedSize(Map<String, dynamic> data) {
    try {
      final jsonString = jsonEncode(data);
      final compressed = _compressString(jsonString);
      return compressed.length;
    } catch (e) {
      return jsonEncode(data).length;
    }
  }
}