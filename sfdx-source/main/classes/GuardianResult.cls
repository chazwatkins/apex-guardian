public abstract class GuardianResult {
  public List<Object> validSubjects { get; private set; }
  public List<Guardian.Invalid> invalidSubjects { get; private set; }
  public Boolean hasInvalid {
    get {
      return !this.invalidSubjects.isEmpty();
    }
    private set;
  }

  public GuardianResult() {
    this.validSubjects = new List<Object>();
    this.invalidSubjects = new List<Guardian.Invalid>();
  }

  public void addValidRecord(Object subject) {
    this.validSubjects.add(subject);
  }

  public void addInvalidRecord(Guardian.Invalid record) {
    this.invalidSubjects.add(record);
  }
}