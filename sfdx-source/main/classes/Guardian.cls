public class Guardian {
  public class NoValidationRulesException extends Exception {
    public override String getMessage() {
      return 'No ValidationRules provided.  Everything is welcome.';
    }
  }

  public abstract class ValidationRuleSet {
    Boolean hasValidationRules {
      get {
        return !this.getValidationRules().isEmpty();
      }
      private set;
    }

    @TestVisible
    abstract Set<System.Type> getValidationRules();

    public ValidationResult validate(Object recordToValidate) {
      return this.validate(recordToValidate, new Map<String, Object>());
    }

    public ValidationResult validate(
      Object recordToValidate,
      Map<String, Object> args
    ) {
      return this.validate(new List<Object>{ recordToValidate }, args);
    }

    public ValidationResult validate(List<Object> recordsToValidate) {
      return this.validate(recordsToValidate, new Map<String, Object>());
    }

    public ValidationResult validate(
      List<Object> subjects,
      Map<String, Object> args
    ) {
      if (!this.hasValidationRules) {
        throw new NoValidationRulesException();
      }

      ValidationResult validationResult = new ValidationResult();
      Set<IValidationRule> validationRuleInstances = this.validationRulesInstances;

      for (Object subject : subjects) {
        SubjectValidationResult validation = new SubjectValidationResult(
          subject
        );
        validation.runValidations(args, validationRuleInstances);

        if (validation.hasErrors) {
          Invalid invalidSubject = new Invalid(
            validation.subject,
            validation.errors
          );
          validationResult.addInvalidRecord(invalidSubject);
        } else {
          validationResult.addValidRecord(subject);
        }
      }

      return validationResult;
    }

    private Set<IValidationRule> validationRulesInstances {
      get {
        Set<IValidationRule> rules = new Set<IValidationRule>();
        for (System.Type ruleType : this.getValidationRules()) {
          IValidationRule rule = (IValidationRule) ruleType.newInstance();
          rules.add(rule);
        }

        return rules;
      }
      private set;
    }
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

    void addValidRecord(Object subject) {
      this.validSubjects.add(subject);
    }

    void addInvalidRecord(Invalid record) {
      this.invalidSubjects.add(record);
    }
  }

  private class SubjectValidationResult {
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

    void runValidations(Map<String, Object> args, Set<IValidationRule> rules) {
      for (IValidationRule rule : rules) {
        Boolean isValid = rule.validate(this.subject, args);

        if (!isValid) {
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
    Boolean validate(Object subject, Map<String, Object> args);
  }
}
