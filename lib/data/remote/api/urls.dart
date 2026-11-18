// https://openrouter.ai/api/v1  :- this is our domin
class Urls {
  static const String BASE_URL = "https://openrouter.ai/api/v1/";
  static const String CHAT_COMPELETION_API = "\chat/completions";
  static const String CHAT_COMPELETION_API_KEY = String.fromEnvironment(
    'CHAT_COMPELETION_API_KEY',
    defaultValue: '',
  );

  static const String IMAGE_COMPELETION_API_KEY = String.fromEnvironment(
    'IMAGE_COMPELETION_API_KEY',
    defaultValue: '',
  );

  static const String VIDEO_COMPELETION_API_KEY = String.fromEnvironment(
    'VIDEO_COMPELETION_API_KEY',
    defaultValue: '',
  );
}
