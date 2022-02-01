@IsTest
private class GuardianTest {
  static Map<String, Object> testArgs = new Map<String, Object>{
    'nameList' => new List<String>{ 'Name 0', 'Name 3' }
  };

  @IsTest
  static void multiRunsAllRuleSets() {
    Map<String, Object> testRecord = new Map<String, Object>{
        'Name' => 'Name Random',
        'Age' => 19
    };

    List<Object> testRecords = new List<Object>{testRecord};

    System.Type validationRuleSetOne = TestRuleSetWithValidationRulesNoArgs.class;
    System.Type validationRuleSetTwo = TestRuleSetWithValidationRules.class;

    Map<System.Type, List<Object>> ruleSets = new Map<System.Type, List<Object>>{
        validationRuleSetOne => testRecords,
        validationRuleSetTwo => testRecords
    };

    Guardian.Multi multiGuardian = new Guardian.Multi(ruleSets);
    Map<System.Type, Guardian.Result> results = multiGuardian.validate();

    Guardian.Result validationRuleSetOneResults = results.get
        (validationRuleSetOne);

    Guardian.Result validationRuleSetTwoResults = results.get
        (validationRuleSetTwo);

    System.assertEquals(1, validationRuleSetOneResults.invalidSubjects.size());
    System.assertEquals(1, validationRuleSetTwoResults.invalidSubjects.size());
  }

  @IsTest
  static void subjectWithoutArgsFailingOneValidationReturnsAsInvalidWithOneError() {
    Map<String, Object> testRecord = new Map<String, Object>{
      'Name' => 'Name Random',
      'Age' => 19
    };

    Guardian.RuleSet testGuardian = new TestRuleSetWithValidationRulesNoArgs();
    Guardian.Result result = testGuardian.validate(testRecord);

    System.assertEquals(1, result.invalidSubjects[0].errors.size());
  }

  @IsTest
  static void multipleSubjectsWithoutArgsFailingOneValidationReturnsAsInvalidWithOneError() {
    Map<String, Object> testRecord = new Map<String, Object>{
      'Name' => 'Name Random',
      'Age' => 19
    };

    Guardian.RuleSet testGuardian = new TestRuleSetWithValidationRulesNoArgs();
    Guardian.Result result = testGuardian.validate(
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

    Guardian.RuleSet testGuardian = new TestRuleSetWithValidationRules();
    Guardian.Result result = testGuardian.validate(
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

    Guardian.RuleSet testGuardian = new TestRuleSetWithValidationRules();
    Guardian.Result result = testGuardian.validate(
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

    Guardian.RuleSet testGuardian = new TestRuleSetWithValidationRules();
    Guardian.Result result = testGuardian.validate(
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
      Guardian.RuleSet testGuardian = new TestRuleSetEmpty();
      testGuardian.validate(testRecord, testArgs);
    } catch (GuardianRuleSet.NoValidationRulesException e) {
      exceptionThrown = true;
    }

    System.assert(exceptionThrown);
  }

  class TestRuleSetEmpty extends Guardian.RuleSet {
    override Set<System.Type> getValidationRules() {
      return new Set<System.Type>{};
    }
  }

  class TestRuleSetWithValidationRulesNoArgs extends Guardian.RuleSet {
    override Set<System.Type> getValidationRules() {
      return new Set<System.Type>{ MustBeOlderThan20ValidationRule.class };
    }
  }

  class TestRuleSetWithValidationRules extends Guardian.RuleSet {
    override Set<System.Type> getValidationRules() {
      return new Set<System.Type>{
        MustBeOlderThan20ValidationRule.class,
        NameMustBeInTheNameList.class
      };
    }
  }

  class MustBeOlderThan20ValidationRule implements Guardian.IRule {
    public String getErrorMessage() {
      return 'Must be older than 20';
    }

    public Boolean validate(Object subject, Map<String, Object> args) {
      Map<String, Object> subjectRecord = (Map<String, Object>) subject;

      Integer subjectAge = (Integer) subjectRecord.get('Age');

      return subjectAge >= 20;
    }
  }

  class NameMustBeInTheNameList implements Guardian.IRule {
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
