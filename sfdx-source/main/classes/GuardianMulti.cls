public abstract class GuardianMulti {
  public Map<Guardian.RuleSet, List<Object>> ruleSets =
      new Map<Guardian.RuleSet, List<Object>>();

  private Map<Guardian.RuleSet, System.Type> ruleSetTypeByInstance =
      new Map<Guardian.RuleSet, System.Type>();

  public GuardianMulti(Map<System.Type, List<Object>> ruleSets) {
    Set<System.Type> ruleSetTypes = ruleSets.keySet();

    if(ruleSetTypes.isEmpty()) {
      throw new NoValidationRuleSetsException();
    }

    for(System.Type ruleSetCls : ruleSetTypes) {
      Guardian.RuleSet ruleSetInstance =
          (Guardian.RuleSet) ruleSetCls.newInstance();

      List<Object> subjects = ruleSets.get(ruleSetCls);
      this.ruleSets.put(ruleSetInstance, subjects);
      this.ruleSetTypeByInstance.put(ruleSetInstance, ruleSetCls);
    }
  }

  public Map<System.Type, Guardian.Result> validate() {
    return this.validate(new Map<String, Object>());
  }

  public Map<System.Type, Guardian.Result> validate(Map<String, Object> args) {
    Map<System.Type, Guardian.Result> results =
        new Map<System.Type, Guardian.Result>();

    for(Guardian.RuleSet ruleSet : ruleSets.keySet()) {
      List<Object> subjects = ruleSets.get(ruleSet);
      Guardian.Result result = ruleSet.validate(subjects, args);
      System.Type ruleSetType = this.ruleSetTypeByInstance.get(ruleSet);
      results.put(ruleSetType, result);
    }

    return results;
  }

  public class NoValidationRuleSetsException extends Exception {
    public override String getMessage() {
      return 'No ValidationRuleSets provided.';
    }
  }
}