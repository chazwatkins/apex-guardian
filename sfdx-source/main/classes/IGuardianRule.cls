public interface IGuardianRule {
  String getErrorMessage();
  Boolean validate(Object subject, Map<String, Object> args);
}