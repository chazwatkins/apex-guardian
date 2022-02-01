@IsTest
public class GuardianTestHelper {
  public static Map<String, Object> VALID_SUBJECT = new Map<String, Object>{
      'Name' => 'Name 0',
      'Age' => 21
  };

  public static Map<String, Object> INVALID_SUBJECT = new Map<String, Object>{
      'Name' => 'Name Random',
      'Age' => 19
  };

  public static Set<Guardian.IRule> TEST_RULES = new Set<Guardian.IRule>{
      new MustBeOlderThan20ValidationRule(),
      new NameMustBeInTheNameList()
  };

  public static Map<String, Object> TEST_ARGS = new Map<String, Object>{
      'nameList' => new List<String>{ 'Name 0', 'Name 3' }
  };

  public class TestRuleSetEmpty extends Guardian.RuleSet {
    override Set<System.Type> getValidationRules() {
      return new Set<System.Type>{};
    }
  }

  public class TestRuleSetWithValidationRulesNoArgs extends Guardian.RuleSet {
    override Set<System.Type> getValidationRules() {
      return new Set<System.Type>{ MustBeOlderThan20ValidationRule.class };
    }
  }

  public class TestRuleSetWithValidationRules extends Guardian.RuleSet {
    override Set<System.Type> getValidationRules() {
      return new Set<System.Type>{
          MustBeOlderThan20ValidationRule.class,
          NameMustBeInTheNameList.class
      };
    }
  }

  public class MustBeOlderThan20ValidationRule implements Guardian.IRule {
    public String getErrorMessage() {
      return 'Must be older than 20';
    }

    public Boolean validate(Object subject, Map<String, Object> args) {
      Map<String, Object> subjectRecord = (Map<String, Object>) subject;

      Integer subjectAge = (Integer) subjectRecord.get('Age');

      return subjectAge >= 20;
    }
  }

  public class NameMustBeInTheNameList implements Guardian.IRule {
    public String getErrorMessage() {
      return 'Name isn\'t on the List';
    }

    public Boolean validate(Object subject, Map<String, Object> args) {
      Map<String, Object> subjectRecord = (Map<String, Object>) subject;
      String subjectName = (String) subjectRecord.get('Name');

      List<String> nameList = (List<String>) args.get('nameList');

      return nameList.contains(subjectName);
    }
  }
}