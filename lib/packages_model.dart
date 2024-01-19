class Packages {
  late List<Result> result;
  late String message;

  Packages({required this.result, required this.message});

  Packages.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result.add(Result.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result.map((v) => v.toJson()).toList();
    data['message'] = message;
    return data;
  }
}

class Result {
  late String id;
  late String archiveType;
  late String distribution;
  late int majorVersion;
  late String javaVersion;
  late String distributionVersion;
  late int jdkVersion;
  late bool latestBuildAvailable;
  late String releaseStatus;
  late String termOfSupport;
  late String operatingSystem;
  late String libCType;
  late String architecture;
  late String fpu;
  late String packageType;
  late bool javafxBundled;
  late bool directlyDownloadable;
  late String filename;
  late Links links;
  late bool freeUseInProduction;
  late String tckTested;
  late String tckCertUri;
  late String aqavitCertified;
  late String aqavitCertUri;
  late int size;
  late List<Feature> feature;

  Result({
    required this.id,
    required this.archiveType,
    required this.distribution,
    required this.majorVersion,
    required this.javaVersion,
    required this.distributionVersion,
    required this.jdkVersion,
    required this.latestBuildAvailable,
    required this.releaseStatus,
    required this.termOfSupport,
    required this.operatingSystem,
    required this.libCType,
    required this.architecture,
    required this.fpu,
    required this.packageType,
    required this.javafxBundled,
    required this.directlyDownloadable,
    required this.filename,
    required this.links,
    required this.freeUseInProduction,
    required this.tckTested,
    required this.tckCertUri,
    required this.aqavitCertified,
    required this.aqavitCertUri,
    required this.size,
    required this.feature,
  });

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    archiveType = json['archive_type'];
    distribution = json['distribution'];
    majorVersion = json['major_version'];
    javaVersion = json['java_version'];
    distributionVersion = json['distribution_version'];
    jdkVersion = json['jdk_version'];
    latestBuildAvailable = json['latest_build_available'];
    releaseStatus = json['release_status'];
    termOfSupport = json['term_of_support'];
    operatingSystem = json['operating_system'];
    libCType = json['lib_c_type'];
    architecture = json['architecture'];
    fpu = json['fpu'];
    packageType = json['package_type'];
    javafxBundled = json['javafx_bundled'];
    directlyDownloadable = json['directly_downloadable'];
    filename = json['filename'];
    links = (json['links'] != null ? Links.fromJson(json['links']) : null)!;
    freeUseInProduction = json['free_use_in_production'];
    tckTested = json['tck_tested'];
    tckCertUri = json['tck_cert_uri'];
    aqavitCertified = json['aqavit_certified'];
    aqavitCertUri = json['aqavit_cert_uri'];
    size = json['size'];
    if (json['feature'] != null) {
      feature = <Feature>[];
      json['feature'].forEach((v) {
        feature.add(Feature.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['archive_type'] = archiveType;
    data['distribution'] = distribution;
    data['major_version'] = majorVersion;
    data['java_version'] = javaVersion;
    data['distribution_version'] = distributionVersion;
    data['jdk_version'] = jdkVersion;
    data['latest_build_available'] = latestBuildAvailable;
    data['release_status'] = releaseStatus;
    data['term_of_support'] = termOfSupport;
    data['operating_system'] = operatingSystem;
    data['lib_c_type'] = libCType;
    data['architecture'] = architecture;
    data['fpu'] = fpu;
    data['package_type'] = packageType;
    data['javafx_bundled'] = javafxBundled;
    data['directly_downloadable'] = directlyDownloadable;
    data['filename'] = filename;
    data['links'] = links.toJson();
    data['free_use_in_production'] = freeUseInProduction;
    data['tck_tested'] = tckTested;
    data['tck_cert_uri'] = tckCertUri;
    data['aqavit_certified'] = aqavitCertified;
    data['aqavit_cert_uri'] = aqavitCertUri;
    data['size'] = size;
    data['feature'] = feature.map((v) => v.toJson()).toList();
    return data;
  }
}

class Links {
  late String pkgInfoUri;
  late String pkgDownloadRedirect;

  Links({required this.pkgInfoUri, required this.pkgDownloadRedirect});

  Links.fromJson(Map<String, dynamic> json) {
    pkgInfoUri = json['pkg_info_uri'];
    pkgDownloadRedirect = json['pkg_download_redirect'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pkg_info_uri'] = pkgInfoUri;
    data['pkg_download_redirect'] = pkgDownloadRedirect;
    return data;
  }
}

class Feature {
  late String name;
  late String uiString;
  late String apiString;

  Feature(
      {required this.name, required this.uiString, required this.apiString});

  Feature.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    uiString = json['ui_string'];
    apiString = json['api_string'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['ui_string'] = uiString;
    data['api_string'] = apiString;
    return data;
  }
}
