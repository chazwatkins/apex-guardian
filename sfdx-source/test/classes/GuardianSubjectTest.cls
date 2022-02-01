@IsTest
private class GuardianSubjectTest {
  @IsTest
  static void runValidationsWithValidSubjectPassesTest() {
    GuardianSubject subject = new GuardianSubject(
        GuardianTestHelper.VALID_SUBJECT
    );

    subject.runValidations(
        GuardianTestHelper.TEST_ARGS,
        GuardianTestHelper.TEST_RULES
    );

    System.assertEquals(false, subject.hasErrors);
  }

  @IsTest
  static void runValidationsWithInvalidSubjectHasErrorsTest() {
    GuardianSubject subject = new GuardianSubject(
        GuardianTestHelper.INVALID_SUBJECT
    );

    subject.runValidations(
        GuardianTestHelper.TEST_ARGS,
        GuardianTestHelper.TEST_RULES
    );

    System.assertEquals(true, subject.hasErrors);
  }

  @IsTest
  static void runValidationsWithInvalidSubjectHasErrorStringsTest() {
    GuardianSubject subject = new GuardianSubject(
        GuardianTestHelper.INVALID_SUBJECT
    );

    subject.runValidations(
        GuardianTestHelper.TEST_ARGS,
        GuardianTestHelper.TEST_RULES
    );

    System.assertEquals(2, subject.errors.size());
  }
}