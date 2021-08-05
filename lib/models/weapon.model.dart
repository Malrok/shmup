class Weapon {
  double damage;
  double _fps; // fires per second
  double _lastFireTimestamp = 0;

  Weapon(this.damage, this._fps);

  bool shouldTrigger(double dt) {
    if (_lastFireTimestamp <= 0) {
      _lastFireTimestamp = 1 / _fps;
      return true;
    }
    _lastFireTimestamp -= dt;
    return false;
  }
}
