import 'dart:io';

import 'package:flutter/foundation.dart';

/// 检查未使用的图片资源.注意找出来的不一定百分百正确，需要自己手动再次确认。例如有些图片名称是动态拼接的，就会被误识别为没有使用的图片（app_guide_x.png）。
/// 如果代码中有引用图片资源，被注释掉，或者相关代码不会再调用，这种情况需要相关代码删除才能检测出来。
/// 使用方法: 在项目根目录下，在终端中执行 dart run check_unused_images.dart
void main() {
  final pubspecFile = File('pubspec.yaml');
  if (!pubspecFile.existsSync()) {
    debugPrint('Error: pubspec.yaml not found in the current directory.');
    return;
  }

  // 读取 pubspec.yaml 中的 assets 声明
  final pubspecContent = pubspecFile.readAsStringSync();
  final assetDirs = RegExp(r'asset\/[^\s:]+\/?').allMatches(pubspecContent).map((match) => match.group(0)!).toSet();

  if (assetDirs.isEmpty) {
    debugPrint('No asset directories found in pubspec.yaml.');
    return;
  }

  // 获取所有 Dart 文件
  final dartFiles = Directory('lib').listSync(recursive: true).where((entity) {
    return entity is File && entity.path.endsWith('.dart');
  });

  // 扫描资源目录，获取所有图片文件的文件名
  final supportedExtensions = ['.png', '.riv', '.jpg', '.jpeg'];
  final allAssets = <String>{};

  for (var dir in assetDirs) {
    final assetDir = Directory(dir);
    if (!assetDir.existsSync()) {
      debugPrint('Warning: Asset directory "$dir" does not exist.');
      continue;
    }

    final files = assetDir.listSync(recursive: true).where((entity) {
      return entity is File && supportedExtensions.any((ext) => entity.path.endsWith(ext));
    });

    // 提取文件名并加入集合
    allAssets.addAll(files.map((file) => file.uri.pathSegments.last)); // 提取文件名部分
  }

  if (allAssets.isEmpty) {
    debugPrint('No image assets found in the specified directories.');
    return;
  }

  // 检查哪些资源在代码中被引用（只匹配文件名）
  final usedAssets = <String>{};
  for (var file in dartFiles) {
    final content = (file as File).readAsStringSync();
    for (var asset in allAssets) {
      /// 获取不包含后缀的文件名
      var assetName = asset.split('.').first;
      if (content.contains(assetName)) {
        usedAssets.add(asset);
      }
    }
  }

  // 找到未使用的资源
  final unusedAssets = allAssets.difference(usedAssets);

  // 动态关键词数组
  final dynamicKeywords = [
    '_dark',
    'app_guide_',
    'battery_icon',
    'gate_sn_location_',
    'generator_wiring_tips_l1l2',
    '_onboarding_guide',
    'smart_circuit',
    'generator_wiring_tips_ct_',
    '_onboarding_guide',
    'span_result_',
    'tab_',
    'generator_module',
    'smart_load_installed_explain',
    'smart_load_explain',
    'smart_voltage',
    'wifi',
    'screen_shot',
    'generator_shadow',
    'statistics_arrow'
  ]; // 根据实际情况调整

  // 按动态关键词分组未使用资源
  final unusedWithKeywords = <String>{};
  final unusedWithoutKeywords = <String>{};

  for (var asset in unusedAssets) {
    if (dynamicKeywords.any((keyword) => asset.contains(keyword))) {
      unusedWithKeywords.add(asset);
    } else {
      unusedWithoutKeywords.add(asset);
    }
  }

  // 输出未使用的资源
  if (unusedAssets.isEmpty) {
    debugPrint('All image assets are used.');
  } else {
    debugPrint('May be unused image assets (contain dynamic keywords), count: ${unusedWithKeywords.length}:');
    // unusedWithKeywords.forEach(print);

    debugPrint('\nUnused image assets (do not contain dynamic keywords), count: ${unusedWithoutKeywords.length}:');
    unusedWithoutKeywords.forEach(debugPrint);
  }
}
