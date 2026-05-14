class Session {
  final String _token;
  final bool _active;

  Session(this._token, this._active);

  bool isValid() {
    return _active && _token.isNotEmpty;
  }
}
