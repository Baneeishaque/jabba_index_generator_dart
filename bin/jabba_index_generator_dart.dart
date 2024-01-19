import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:jabba_index_generator_dart/packages_model.dart';
import 'package:pub_semver/pub_semver.dart';

Future<void> main() async {
  final http.Response response = await http.get(Uri.parse(
      'https://api.foojay.io/disco/v3.0/packages/jdks?operating_system=windows&architecture=amd64&distribution=oracle_open_jdk&archive_type=zip&release_status=ea&version=%3E21'));

  if (response.statusCode == 200) {
    final Packages packages = Packages.fromJson(json.decode(response.body));

    // {
    //    operatingSystem : {
    //      architecture : {
    //        packageType@distribution : {
    //          javaVersion : archiveType+pkgDownloadRedirectUrl,
    //          javaVersionN : archiveTypeN+pkgDownloadRedirectUrlN
    //        }
    //      }
    //    }
    // }
    Map<String, Map<String, Map<String, Map<String, String>>>> indexJson = {};

    for (int i = 0; i < packages.result.length; i++) {
      Result result = packages.result[i];

      try {
        if (result.javaVersion.contains('+')) {
          List<String> versionParts = result.javaVersion.split('+');
          if (versionParts[0].contains('-')) {
            List<String> preReleaseParts = versionParts[0].split('-');
            List<String> preReleaseIdentifier = preReleaseParts[1].split('.');
            result.javaVersion = Version(
              int.parse(preReleaseParts[0]),
              0,
              0,
              pre: preReleaseIdentifier[0],
              build: versionParts.length > 1 ? versionParts[1] : null,
            ).toString();
            Version.parse(result.javaVersion);

            String pkgDownloadRedirectUrlWithArchiveType =
                '${result.archiveType}+${result.links.pkgDownloadRedirect}';
            var packageTypeWithDistribution =
                '${result.packageType}@${result.distribution}';

            if (indexJson.containsKey(result.operatingSystem)) {
              Map<String, Map<String, Map<String, String>>>
                  operatingSystemKeyValue = indexJson[result.operatingSystem]!;
              if (operatingSystemKeyValue.containsKey(result.architecture)) {
                Map<String, Map<String, String>> architectureKeyValue =
                    operatingSystemKeyValue[result.architecture]!;
                if (architectureKeyValue
                    .containsKey(packageTypeWithDistribution)) {
                  Map<String, String> packageTypeWithDistributionValue =
                      architectureKeyValue[packageTypeWithDistribution]!;
                  if (packageTypeWithDistributionValue
                      .containsKey(result.javaVersion)) {
                    print('duplicate key');
                  } else {
                    packageTypeWithDistributionValue[result.javaVersion] =
                        pkgDownloadRedirectUrlWithArchiveType;
                    indexJson[result.operatingSystem]![result.architecture]![
                            packageTypeWithDistribution] =
                        packageTypeWithDistributionValue;
                  }
                } else {
                  architectureKeyValue[packageTypeWithDistribution] = {
                    result.javaVersion: pkgDownloadRedirectUrlWithArchiveType
                  };
                  indexJson[result.operatingSystem]![result.architecture] =
                      architectureKeyValue;
                }
              } else {
                operatingSystemKeyValue[result.architecture] = {
                  packageTypeWithDistribution: {
                    result.javaVersion: pkgDownloadRedirectUrlWithArchiveType
                  }
                };
                indexJson[result.operatingSystem] = operatingSystemKeyValue;
              }
            } else {
              indexJson[result.operatingSystem] = {
                result.architecture: {
                  packageTypeWithDistribution: {
                    result.javaVersion: pkgDownloadRedirectUrlWithArchiveType
                  }
                }
              };
            }
          } else {
            print('Handle this...');
          }
        } else {
          print('Handle this...');
        }
      } catch (e) {
        continue;
      }
    }

    if (indexJson.containsKey('windows')) {
      if (indexJson['windows']!.containsKey('x64')) {
        indexJson['windows']!['amd64'] = indexJson['windows']!['x64']!;
      }
    }

    File('index.json').writeAsStringSync(json.encode(indexJson));
  } else {
    print('Failed to load data: ${response.statusCode}');
  }
}
