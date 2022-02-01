@IsTest
private class GuardianMultiTest {

  @IsTest
  static void whenNoRuleSetsAreProvidedThenAnExceptionIsThrown() {
    try {
      new Guardian.Multi(new Map<System.Type, List<Object>>());
      System.assert(false);
    } catch(GuardianMulti.NoValidationRuleSetsException e) {
      System.assert(true);
    }
  }

  @IsTest
  static void multiRunsAllRuleSets() {

    List<Object> testRecords = new List<Object>{
        GuardianTestHelper.INVALID_SUBJECT
    };

    System.Type validationRuleSetOne =
        GuardianTestHelper.TestRuleSetWithValidationRulesNoArgs.class;

    System.Type validationRuleSetTwo =
        GuardianTestHelper.TestRuleSetWithValidationRules.class;

    Map<System.Type, List<Object>> ruleSets =
        new Map<System.Type, List<Object>>{
            validationRuleSetOne => testRecords,
            validationRuleSetTwo => testRecords
        };

    Guardian.Multi multiGuardian = new Guardian.Multi(ruleSets);
    Map<System.Type, Guardian.Result> results =
        multiGuardian.validate(GuardianTestHelper.TEST_ARGS);

    Guardian.Result validationRuleSetOneResults = results.get
        (validationRuleSetOne);

    Guardian.Result validationRuleSetTwoResults = results.get
        (validationRuleSetTwo);

    System.assertEquals(1, validationRuleSetOneResults.invalidSubjects.size());
    System.assertEquals(1, validationRuleSetTwoResults.invalidSubjects.size());
  }
}