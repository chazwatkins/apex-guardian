@IsTest
private class GuardianResultTest {
  @IsTest
  static void addValidRecord() {
    Guardian.Result result = new Guardian.Result();
    String testSubject = 'Test Subject';

    result.addValidRecord(testSubject);

    List<Object> expectedValidSubjects = new List<Object>{testSubject};
    System.assertEquals(expectedValidSubjects, result.validSubjects);
  }

  @IsTest
  static void WhenInvalidSubjectsIsEmptyThenHasInvalidIsFalse() {
    Guardian.Result result = new Guardian.Result();

    System.assertEquals(false, result.hasInvalid);
  }

  @IsTest
  static void addInvalidRecord() {
    Guardian.Result result = new Guardian.Result();
    String testSubject = 'Test Subject';

    Guardian.Invalid invalidSubject =
        new Guardian.Invalid(
            testSubject,
            new List<String>{
                'test error'
            }
        );

    result.addInvalidRecord(invalidSubject);

    List<Object> expectedInvalidSubjects = new List<Guardian.Invalid>{invalidSubject};
    System.assertEquals(expectedInvalidSubjects, result.invalidSubjects);
  }

  @IsTest
  static void addInvalidRecordHasInvalidIsTrue() {
    Guardian.Result result = new Guardian.Result();
    String testSubject = 'Test Subject';

    Guardian.Invalid invalidSubject =
        new Guardian.Invalid(
            testSubject,
            new List<String>{
                'test error'
            }
        );

    result.addInvalidRecord(invalidSubject);

    System.assertEquals(true, result.hasInvalid);

  }
}