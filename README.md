# Guardian

Simple validation library that allows you to centralize all validations for an Object.

## ValidationRule


```apex
public class AgeMustBe20OrGreater implements Guardian.IValidationRule {
  String getErrorMessage() {
    return 'Age must be >= 20';
  }
  
  Boolean validate(Object subject, Map<String, Object> args) {
    Map<String, Object> subjectRecord = (Map<String, Object>)subject;
    Integer subjectAge = (Integer)subjectRecord.get('Age');
    
    return subjectAge >= 20;
  }
}
```

## ValidationRuleSet

```apex
public class SuperValidationRuleSet extends Guardian.ValidationRuleSet {
  Set<System.Type> getValidationRules() {
    return new Set<System.Type>{
        AgeMustBe20OrGreater.class
    };
  }
}
```

### Run your validations with the `ValidationRuleSet.validate` method

#### Arguments
* Object subject - The object to be validated
* Map<String, Object> args - Key/Value args that will be passed into every `ValidationRule`.  
  Only required if a `ValiationRule` depends on it.

#### Returns
* `Guardian.ValidationResult`
  * `hasInvalid` - Boolean
  * `validSubjects` - List of subjects that passed every `ValidationRule`
  * `invalidSubjects` - List of subjects that failed one or more `ValidationRule`
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
    Guardian.ValidationRuleSet ruleSet = new SuperValidationRuleSet();
    Guardian.ValidationResult validationResult = ruleSet.validate(records);
    
    SomeOtherClass.processValidRecords(validationResult.validSubjects);
    
    if(validationResult.hasInvalid) {
      List<Guardian.Invalid> invalidSubjects = validationResult.invalidSubjects;
      
      for(Guardian.Invalid invalidSubject : invalidSubjects) {
        System.debug(invalidSubject.errors)
      }
    }
    
  }
}
```