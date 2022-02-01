public class Guardian {

  public interface IRule extends IGuardianRule {}

  public abstract class RuleSet extends GuardianRuleSet {}

  public class Invalid extends GuardianInvalid {

    public Invalid(Object subject, List<String> errors) {
      super(subject, errors);
    }

  }

  public class Result extends GuardianResult {}

  public class Multi extends GuardianMulti {

    public Multi(Map<System.Type, List<Object>> ruleSets) {
      super(ruleSets);
    }

  }
}
