import "package:flutter/foundation.dart";
import "package:flutter_domain_manager/src/models/domain_manager_config.dart";
import "package:web/web.dart";

/// A singleton class that manages the subdomain for the application.
class DomainManager {
  /// The configuration for the DomainManager.
  DomainManagerConfig? config;

  DomainManager._({required this.config});
  static DomainManager? _instance;

  /// Returns the singleton instance of DomainManager.
  static DomainManager get instance {
    if (_instance == null) {
      throw Exception(
        "DomainManager is not initialized. Call DomainManager.register() first.",
      );
    }
    return _instance!;
  }

  /// The current company set for the application.
  String? get company => config!.company;

  /// Registers the DomainManager with the given configuration.
  DomainManager.register({required this.config}) {
    var configuration = config;

    if (kDebugMode) {
      configuration = config!.copyWith(company: config!.debugCompany);
    }
    _instance ??= DomainManager._(config: configuration);

    DomainManager instance = _instance!;

    if (kDebugMode) {
      debugPrint(
        "DOMAIN_MANAGER: DomainManager initialized for DEVELOPMENT using debugCompany",
      );
      debugPrint("SETTING COMPANY: ${DomainManager.instance.company}");
    } else {
      instance._check();
    }
  }

  void _check() {
    final uri = window.location.hostname;
    final domain = config!.domain;

    var company = _getDifferingSubdomain(uri, domain, () {
      debugPrint(
        "DOMAIN_MANAGER: Invalid subdomain '$uri' for domain '$domain'. Redirecting to default domain.",
      );
      _redirect(config!.domain);
    });

    if (company == null || company.isEmpty) {
      return;
    } else {
      config!.setCompany(company, () {
        debugPrint(
          "DOMAIN_MANAGER: Invalid company '$company' for domain '$domain'. Redirecting to default domain.",
        );

        _redirect(config!.domain);
      });
    }
  }

  _redirect(String uri) {
    window.location.href = uri;
  }

  String? _getDifferingSubdomain(
    String domainA,
    String domainB,
    Function onInvalid,
  ) {
    domainA = domainA.replaceAll(RegExp(r'^(https?://)?(www\.)?'), '');
    domainB = domainB.replaceAll(RegExp(r'^(https?://)?(www\.)?'), '');

    var aParts = domainA.split('.').reversed.toList();
    var bParts = domainB.split('.').reversed.toList();

    if (aParts.length == bParts.length) {
      return null;
    }

    if ((aParts.length - bParts.length).abs() > 1) {
      onInvalid.call();
      return null;
    }

    var biggerParts = aParts.length > bParts.length ? aParts : bParts;

    return biggerParts.last;
  }
}
