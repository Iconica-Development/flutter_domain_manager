/// Configuration for the DomainManager.
/// domain: The base domain for the application. Used for validation and redirection.
/// debugCompany: A company to use for debugging purposes in development mode.
/// allowedCompanies: A list of companies that are allowed to access the application.
/// company: The current company set for the application. Should be set by the DomainManager.
class DomainManagerConfig {
  /// A company to use for debugging purposes in development mode.
  final String? debugCompany;

  /// A list of companies that are allowed to access the application.
  final List<String>? allowedCompanies;

  /// The base domain for the application. Used for validation and redirection. e.g. 'https://app.iconica.nl'
  final String domain;

  /// The current company set for the application. Should be set by the DomainManager.
  String? company;

  /// Configuration for the DomainManager.
  /// domain: The base domain for the application. Used for validation and redirection.
  /// debugCompany: A company to use for debugging purposes in development mode.
  /// allowedCompanies: A list of companies that are allowed to access the application.
  /// company: The current company set for the application. Should be set by the DomainManager.
  DomainManagerConfig({
    required this.domain,
    this.debugCompany,
    this.company,
    this.allowedCompanies,
  }) : assert(
         company == null,
         '''Company should be empty, but the value is: $company. It will get filled by the DomainManager.
         For debugging purposes, you can set a debugCompany to use in development.''',
       );

  /// DON'T USE THIS CONSTRUCTOR DIRECTLY.
  /// Internal constructor for the DomainManagerConfig.
  /// This constructor is used internally to create a copy of the configuration
  DomainManagerConfig.internal({
    required this.domain,
    this.debugCompany,
    this.company,
    this.allowedCompanies,
  });

  /// Creates a copy of the DomainManagerConfig with optional overrides.
  DomainManagerConfig copyWith({
    String? domain,
    String? debugCompany,
    String? company,
    List<String>? allowedCompanies,
  }) {
    return DomainManagerConfig.internal(
      allowedCompanies: allowedCompanies ?? this.allowedCompanies,
      domain: domain ?? this.domain,
      debugCompany: debugCompany ?? this.debugCompany,
      company: company ?? this.company,
    );
  }

  /// Sets the company for the DomainManagerConfig.
  /// If the company is not in the allowedCompanies list, it will set the company to null and call onInvalid.
  /// If allowedCompanies is null, it will not validate the company.
  void setCompany(String comp, Function? onInvalid) {
    if (allowedCompanies != null && !allowedCompanies!.contains(comp)) {
      company = null;
      onInvalid?.call();
    }

    company = comp;
  }
}
