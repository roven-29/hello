class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Simple in-memory storage for demo purposes
  final Map<String, String> _users = {};
  String? _currentUser;

  // Sign up a new user
  bool signUp(String email, String password, Map<String, dynamic> userDetails) {
    if (_users.containsKey(email)) {
      return false; // User already exists
    }
    
    _users[email] = password;
    _currentUser = email;
    return true;
  }

  // Sign in an existing user
  bool signIn(String email, String password) {
    if (_users.containsKey(email) && _users[email] == password) {
      _currentUser = email;
      return true;
    }
    return false;
  }

  // Sign out current user
  void signOut() {
    _currentUser = null;
  }

  // Check if user is signed in
  bool get isSignedIn => _currentUser != null;

  // Get current user email
  String? get currentUser => _currentUser;

  // Check if user exists
  bool userExists(String email) {
    return _users.containsKey(email);
  }
}
