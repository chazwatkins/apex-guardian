# Guardian

Simple validation library that allows you to centralize all Apex validations for an Object.

## `Guardian.IRule`

```apex
public class AgeMustBe20OrGreater implements Guardian.IRule {
  String getErrorMessage() {
    return 'Age must be >= 20';
  }

  Boolean validate(Object subject, Map<String, Object> args) {
    Map<String, Object> subjectRecord = (Map<String, Object>) subject;
    Integer subjectAge = (Integer) subjectRecord.get('Age');

    return subjectAge >= 20;
  }
}
```

## `Guardian.RuleSet`

```apex
public class SuperValidationRuleSet extends Guardian.RuleSet {
  Set<System.Type> getValidationRules() {
    return new Set<System.Type>{
            AgeMustBe20OrGreater.class
    };
  }
}
```

### Run your validations with the `Guardian.RuleSet`'s `validate` method

#### Arguments
* Object subject - The object to be validated
* Map<String, Object> args - Key/Value args that will be passed into every `Guardian.IRule`.  
  Only required if a `Guardian.IRule` depends on it.

#### Returns
* `Guardian.Result`
  * `hasInvalid` - Boolean
  * `validSubjects` - List of subjects that passed every `Guardian.IRule`
  * `invalidSubjects` - List of subjects that failed one or more `Guardian.IRule`
    * Each subject is wrapped in the `Guardian.Invalid` object that provides the validation error 
      messages

#### Method Variations

* `validate(Object subject)`

* `validate(Object subject, Map<String, Object> args)`

* `validate(List<Object> subjects)`

* `validate(List<Object>, Map<String, Object> args)`

### How to use

```apex
public class RandomCaller {
  public static void awesomeMethod(List<SObject> records) {
    Guardian.RuleSet ruleSet = new SuperValidationRuleSet();
    Guardian.Result validationResult = ruleSet.validate(records);

    SomeOtherClass.processValidRecords(validationResult.validSubjects);

    if (validationResult.hasInvalid) {
      List<Guardian.Invalid> invalidSubjects = validationResult.invalidSubjects;

      for (Guardian.Invalid invalidSubject : invalidSubjects) {
        System.debug(invalidSubject.errors)
      }
    }

  }
}
```

## `Guardian.Multi` - Run validations for multiple object types

```apex
List<Account> myAccounts = ...;
List<Opportunity> myOpps = ...;


Map<System.Type, List<Object>> ruleSets =
  new Map<System.Type, List<Object>>{
    AccountRuleSet.class => myAccounts,
    OpportunityRuleSet.class => myOpps
  };

Guardian.Multi multiGuardian = new Guardian.Multi(ruleSets);

Map<String, Object> args = new Map<String, Object>{
  'validAccountNames' => new Set<String>{'Acme'},
  'validOpportunityStageNames' => new Set<String>{'New', 'Closed'}
};

Map<System.Type, Guardian.Result> results = multiGuardian.validate(args);

Guardian.Result accountResults = results.get(AccountRuleSet.class);

List<Account> validAccounts = (List<Account>)accountResults.validSubjects;
List<Guardian.Invalid> invalidAccounts = accountResults.invalidSubjects;
```
