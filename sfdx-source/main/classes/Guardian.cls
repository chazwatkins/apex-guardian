public abstract class Guardian {

  abstract Set<System.Type> getValidationRules();

  public Set<System.Type> validationRules {
    get {
      return getValidationRules();
    }
    private set;
  }

  Set<IValidationRule> validationRulesInstances {
    get {
      Set<IValidationRule> rules = new Set<IValidationRule>();
      for(System.Type ruleType : this.getValidationRules()) {
        IValidationRule rule = (IValidationRule) ruleType.newInstance();
        rules.add(rule);
      }

      return rules;
    }
    private set;
  }

  public ValidationResult validate(Object recordToValidate) {
    return this.validate(recordToValidate, null);
  }

  public ValidationResult validate(Object recordToValidate, Object args) {
    return this.validate(new List<Object>{recordToValidate}, args);
  }

  public ValidationResult validate(List<Object> recordsToValidate) {
    return this.validate(recordsToValidate, null);
  }

  public ValidationResult validate(List<Object> subjects, Object args) {
    ValidationResult validationResult = new ValidationResult();
    Set<IValidationRule> validationRuleInstances = this.validationRulesInstances;

    for(Object subject : subjects) {
      SubjectValidationResult validation = new SubjectValidationResult(subject);
      validation.runValidations(args, validationRuleInstances);

      if(validation.hasErrors) {
        Invalid invalidSubject = new Invalid(validation.subject, validation.errors);
        validationResult.addInvalidRecord(invalidSubject);
      } else {
        validationResult.addValidRecord(subject);
      }
    }

    return validationResult;
  }

  public class ValidationResult {
    public List<Object> validSubjects { get; private set; }
    public List<Invalid> invalidSubjects { get; private set; }
    public Boolean hasInvalid {
      get {
        return !this.invalidSubjects.isEmpty();
      }
      private set;
    }

    public ValidationResult() {
      this.validSubjects = new List<Object>();
      this.invalidSubjects = new List<Invalid>();
    }

    public void addValidRecord(Object subject) {
      this.validSubjects.add(subject);
    }

    public void addInvalidRecord(Invalid record) {
      this.invalidSubjects.add(record);
    }
  }

  class SubjectValidationResult {
    public Object subject { get; private set; }
    public List<String> errors { get; private set; }
    Boolean hasErrors {
      get {
        return !this.errors.isEmpty();
      }
      private set;
    }

    SubjectValidationResult(Object subject) {
      this.subject = subject;
      this.errors = new List<String>();
    }

    void runValidations(Object args, Set<IValidationRule> rules) {
      for(IValidationRule rule : rules) {
        Boolean isValid = rule.validate(this.subject, args);

        if(!isValid) {
          this.errors.add(rule.getErrorMessage());
        }
      }
    }

  }

  public class Invalid {
    public Object subject { get; private set; }
    public List<String> errors { get; private set; }

    public Invalid(Object subject, List<String> errors) {
      this.subject = subject;
      this.errors = errors;
    }
  }

  public interface IValidationRule {
    String getErrorMessage();
    Boolean validate(Object subject, Object args);
  }
  public class GuardianException extends Exception {}
}