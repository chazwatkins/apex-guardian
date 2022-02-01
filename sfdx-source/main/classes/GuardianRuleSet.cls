public abstract class GuardianRuleSet {
  Boolean hasValidationRules {
    get {
      return !this.getValidationRules().isEmpty();
    }
    private set;
  }

  @TestVisible
  abstract Set<System.Type> getValidationRules();

  public Guardian.Result validate(Object recordToValidate) {
    return this.validate(recordToValidate, new Map<String, Object>());
  }

  public Guardian.Result validate(
      Object recordToValidate,
      Map<String, Object> args
  ) {
    return this.validate(new List<Object>{ recordToValidate }, args);
  }

  public Guardian.Result validate(List<Object> recordsToValidate) {
    return this.validate(recordsToValidate, new Map<String, Object>());
  }

  public Guardian.Result validate(
      List<Object> subjects,
      Map<String, Object> args
  ) {
    if (!this.hasValidationRules) {
      throw new NoValidationRulesException();
    }

    Guardian.Result validationResult = new Guardian.Result();
    Set<Guardian.IRule> validationRuleInstances =
        this.validationRulesInstances;

    for (Object subject : subjects) {
      GuardianSubject validation = new GuardianSubject(
          subject
      );
      validation.runValidations(args, validationRuleInstances);

      if (validation.hasErrors) {
        Guardian.Invalid invalidSubject = new Guardian.Invalid(
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

  private Set<Guardian.IRule> validationRulesInstances {
    get {
      Set<Guardian.IRule> rules = new Set<Guardian.IRule>();
      for (System.Type ruleType : this.getValidationRules()) {
        Guardian.IRule rule = (Guardian.IRule) ruleType.newInstance();
        rules.add(rule);
      }

      return rules;
    }
    private set;
  }

  public class NoValidationRulesException extends Exception {
    public override String getMessage() {
      return 'No ValidationRules provided.';
    }
  }
}