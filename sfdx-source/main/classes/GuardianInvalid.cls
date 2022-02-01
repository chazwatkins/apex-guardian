public abstract class GuardianInvalid {
  public Object subject { get; private set; }
  public List<String> errors { get; private set; }

  public GuardianInvalid(Object subject, List<String> errors) {
    this.subject = subject;
    this.errors = errors;
  }
}