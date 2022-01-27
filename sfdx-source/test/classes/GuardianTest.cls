@IsTest
private class GuardianTest {
  static Map<String, Object> testArgs = new Map<String, Object>{
    'nameList' => new List<String>{ 'Name 0', 'Name 3' }
  };

  @IsTest
  static void subjectWithoutArgsFailingOneValidationReturnsAsInvalidWithOneError() {
    Map<String, Object> testRecord = new Map<String, Object>{
      'Name' => 'Name Random',
      'Age' => 19
    };

    Guardian.ValidationRuleSet testGuardian = new TestRuleSetWithValidationRulesNoArgs();
    Guardian.ValidationResult result = testGuardian.validate(testRecord);

    System.assertEquals(1, result.invalidSubjects[0].errors.size());
  }

  @IsTest
  static void multipleSubjectsWithoutArgsFailingOneValidationReturnsAsInvalidWithOneError() {
    Map<String, Object> testRecord = new Map<String, Object>{
      'Name' => 'Name Random',
      'Age' => 19
    };

    Guardian.ValidationRuleSet testGuardian = new TestRuleSetWithValidationRulesNoArgs();
    Guardian.ValidationResult result = testGuardian.validate(
      new List<Object>{ testRecord }
    );

    System.assertEquals(1, result.invalidSubjects[0].errors.size());
  }

  @IsTest
  static void subjectFailingOneValidationReturnsAsInvalidWithOneError() {
    Map<String, Object> testRecord = new Map<String, Object>{
      'Name' => 'Name Random',
      'Age' => 20
    };

    Guardian.ValidationRuleSet testGuardian = new TestRuleSetWithValidationRules();
    Guardian.ValidationResult result = testGuardian.validate(
      testRecord,
      testArgs
    );

    System.assertEquals(1, result.invalidSubjects[0].errors.size());
  }

  @IsTest
  static void subjectFailingMultipleValidationReturnsAsInvalidWithMultipleErrors() {
    Map<String, Object> testRecord = new Map<String, Object>{
      'Name' => 'Name Random',
      'Age' => 19
    };

    Guardian.ValidationRuleSet testGuardian = new TestRuleSetWithValidationRules();
    Guardian.ValidationResult result = testGuardian.validate(
      testRecord,
      testArgs
    );

    Integer expectedFailures = testGuardian.getValidationRules().size();
    Integer actualFailures = result.invalidSubjects[0].errors.size();
    System.assertEquals(expectedFailures, actualFailures);
  }

  @IsTest
  static void subjectPassingAllValidationsReturnsAsValid() {
    Map<String, Object> testRecord = new Map<String, Object>{
      'Name' => 'Name 0',
      'Age' => 25
    };

    Guardian.ValidationRuleSet testGuardian = new TestRuleSetWithValidationRules();
    Guardian.ValidationResult result = testGuardian.validate(
      testRecord,
      testArgs
    );

    System.assertEquals((Object) testRecord, result.validSubjects[0]);
  }

  @IsTest
  static void ruleSetWithoutValidationRulesThrowsException() {
    Map<String, Object> testRecord = new Map<String, Object>{
      'Name' => 'Name 0',
      'Age' => 25
    };

    Boolean exceptionThrown = false;

    try {
      Guardian.ValidationRuleSet testGuardian = new TestRuleSetEmpty();
      testGuardian.validate(testRecord, testArgs);
    } catch (Guardian.NoValidationRulesException e) {
      exceptionThrown = true;
    }

    System.assert(exceptionThrown);
  }

  class TestRuleSetEmpty extends Guardian.ValidationRuleSet {
    override Set<System.Type> getValidationRules() {
      return new Set<System.Type>{};
    }
  }

  class TestRuleSetWithValidationRulesNoArgs extends Guardian.ValidationRuleSet {
    override Set<System.Type> getValidationRules() {
      return new Set<System.Type>{ MustBeOlderThan20ValidationRule.class };
    }
  }

  class TestRuleSetWithValidationRules extends Guardian.ValidationRuleSet {
    override Set<System.Type> getValidationRules() {
      return new Set<System.Type>{
        MustBeOlderThan20ValidationRule.class,
        NameMustBeInTheNameList.class
      };
    }
  }

  class MustBeOlderThan20ValidationRule implements Guardian.IValidationRule {
    public String getErrorMessage() {
      return 'Must be older than 20';
    }

    public Boolean validate(Object subject, Map<String, Object> args) {
      Map<String, Object> subjectRecord = (Map<String, Object>) subject;

      Integer subjectAge = (Integer) subjectRecord.get('Age');

      return subjectAge >= 20;
    }
  }

  class NameMustBeInTheNameList implements Guardian.IValidationRule {
    public String getErrorMessage() {
      return 'Name isn\'t on the List';
    }

    public Boolean validate(Object subject, Map<String, Object> args) {
      Map<String, Object> subjectRecord = (Map<String, Object>) subject;
      String subjectName = (String) subjectRecord.get('Name');

      List<String> nameList = (List<String>) args.get('nameList');

      return nameList.contains(subjectName);
    }
  }
}
