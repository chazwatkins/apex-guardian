@IsTest
private class GuardianRuleSetTest {
  @IsTest
  static void subjectWithoutArgsFailingOneValidationReturnsAsInvalidWithOneError() {
    Map<String, Object> testRecord = new Map<String, Object>{
        'Name' => 'Name Random',
        'Age' => 19
    };

    Guardian.RuleSet testGuardian =
        new GuardianTestHelper.TestRuleSetWithValidationRulesNoArgs();
    Guardian.Result result = testGuardian.validate(testRecord);

    System.assertEquals(1, result.invalidSubjects[0].errors.size());
  }

  @IsTest
  static void multipleSubjectsWithoutArgsFailingOneValidationReturnsAsInvalidWithOneError() {
    Map<String, Object> testRecord = new Map<String, Object>{
        'Name' => 'Name Random',
        'Age' => 19
    };

    Guardian.RuleSet testGuardian =
        new GuardianTestHelper.TestRuleSetWithValidationRulesNoArgs();
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

    Guardian.RuleSet testGuardian =
        new GuardianTestHelper.TestRuleSetWithValidationRules();
    Guardian.Result result = testGuardian.validate(
        testRecord,
        GuardianTestHelper.TEST_ARGS
    );

    System.assertEquals(1, result.invalidSubjects[0].errors.size());
  }

  @IsTest
  static void subjectFailingMultipleValidationReturnsAsInvalidWithMultipleErrors() {
    Map<String, Object> testRecord = new Map<String, Object>{
        'Name' => 'Name Random',
        'Age' => 19
    };

    Guardian.RuleSet testGuardian =
        new GuardianTestHelper.TestRuleSetWithValidationRules();
    Guardian.Result result = testGuardian.validate(
        testRecord,
        GuardianTestHelper.TEST_ARGS
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

    Guardian.RuleSet testGuardian =
        new GuardianTestHelper.TestRuleSetWithValidationRules();
    Guardian.Result result = testGuardian.validate(
        testRecord,
        GuardianTestHelper.TEST_ARGS
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
      Guardian.RuleSet testGuardian =
          new GuardianTestHelper.TestRuleSetEmpty();
      testGuardian.validate(testRecord, GuardianTestHelper.TEST_ARGS);
    } catch (GuardianRuleSet.NoValidationRulesException e) {
      exceptionThrown = true;
    }

    System.assert(exceptionThrown);
  }
}