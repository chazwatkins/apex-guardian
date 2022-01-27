public without sharing class GuardianSelector {
  public static Set<System.Type> selectValidationRuleSets() {
    List<ApexClass> apexClasses = selectApexClassesByParentName(
      'Guardian.ValidationRuleSet'
    );

    return getTypesFromApexClasses(apexClasses);
  }

  public static Set<System.Type> selectValidationRules() {
    List<ApexClass> apexClasses = selectApexClassesByInterfaceName(
      'Guardian.IValidationRule'
    );

    return getTypesFromApexClasses(apexClasses);
  }

  private static Set<System.Type> getTypesFromApexClasses(
    List<ApexClass> apexClasses
  ) {
    Set<System.Type> classTypes = new Set<System.Type>();
    for (ApexClass cls : apexClasses) {
      System.Type classType = Type.forName(cls.Name);
      classTypes.add(classType);
    }

    return classTypes;
  }

  private static List<ApexClass> selectApexClassesByParentName(
    String parentName
  ) {
    return selectApexClasses('"extends ' + parentName + '"');
  }

  private static List<ApexClass> selectApexClassesByInterfaceName(
    String interfaceName
  ) {
    return selectApexClasses('"implements ' + interfaceName + '"');
  }

  private static List<ApexClass> selectApexClasses(String findBy) {
    if (Test.isRunningTest()) {
      findBy += ' AND @isTest';
    } else {
      findBy += ' AND NOT @isTest';
    }

    return [FIND :findBy RETURNING ApexClass(Name)][0];
  }
}
