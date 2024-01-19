import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:jabba_index_generator_dart/packages_model.dart';

Future<void> main() async {
  final http.Response response = await http
      .get(Uri.parse('https://api.foojay.io/disco/v3.0/packages/all'));

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

      String pkgDownloadRedirectUrlWithArchiveType =
          '${result.archiveType}+${result.links.pkgDownloadRedirect}';
      var javaVersionWithOrWithoutFx =
          '${result.javaVersion}${result.javafxBundled ? '-fx' : ''}-${result.libCType}-${result.archiveType}-${result.size}${result.filename.contains('rpm') ? '-rpm' : ''}-${result.id}';
      var packageTypeWithDistribution =
          '${result.packageType}@${result.distribution}';

      if (indexJson.containsKey(result.operatingSystem)) {
        Map<String, Map<String, Map<String, String>>> operatingSystemKeyValue =
            indexJson[result.operatingSystem]!;
        if (operatingSystemKeyValue.containsKey(result.architecture)) {
          Map<String, Map<String, String>> architectureKeyValue =
              operatingSystemKeyValue[result.architecture]!;
          if (architectureKeyValue.containsKey(packageTypeWithDistribution)) {
            Map<String, String> packageTypeWithDistributionValue =
                architectureKeyValue[packageTypeWithDistribution]!;
            if (packageTypeWithDistributionValue
                .containsKey(javaVersionWithOrWithoutFx)) {
              print('duplicate key');
            } else {
              packageTypeWithDistributionValue[javaVersionWithOrWithoutFx] =
                  pkgDownloadRedirectUrlWithArchiveType;
              indexJson[result.operatingSystem]![result.architecture]![
                      packageTypeWithDistribution] =
                  packageTypeWithDistributionValue;
            }
          } else {
            architectureKeyValue[packageTypeWithDistribution] = {
              javaVersionWithOrWithoutFx: pkgDownloadRedirectUrlWithArchiveType
            };
            indexJson[result.operatingSystem]![result.architecture] =
                architectureKeyValue;
          }
        } else {
          operatingSystemKeyValue[result.architecture] = {
            packageTypeWithDistribution: {
              javaVersionWithOrWithoutFx: pkgDownloadRedirectUrlWithArchiveType
            }
          };
          indexJson[result.operatingSystem] = operatingSystemKeyValue;
        }
      } else {
        indexJson[result.operatingSystem] = {
          result.architecture: {
            packageTypeWithDistribution: {
              javaVersionWithOrWithoutFx: pkgDownloadRedirectUrlWithArchiveType
            }
          }
        };
      }
    }

    File('index.json').writeAsStringSync(json.encode(indexJson));
  } else {
    print('Failed to load data: ${response.statusCode}');
  }
}
