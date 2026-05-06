class Session {
  String _token;
  bool _active;

  Session(this._token, this._active);

  bool isValid() {
    return _active && _token.isNotEmpty;
  }
}