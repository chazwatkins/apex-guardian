public class GuardianSubject {
  public Object subject { get; private set; }
  public List<String> errors { get; private set; }
  public Boolean hasErrors {
    get {
      return !this.errors.isEmpty();
    }
    private set;
  }

  public GuardianSubject(Object subject) {
    this.subject = subject;
    this.errors = new List<String>();
  }

  public void runValidations(Map<String, Object> args, Set<Guardian.IRule> rules) {
    for (Guardian.IRule rule : rules) {
      Boolean isValid = rule.validate(this.subject, args);

      if (!isValid) {
        this.errors.add(rule.getErrorMessage());
      }
    }
  }
}