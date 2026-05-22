import '../../data/models/business.dart';
import '../../data/models/user.dart';
import '../../data/repositories/user_repository.dart';

class BusinessMenuViewModel {
  BusinessMenuViewModel({
    required this.business,
    UserRepository? userRepository,
  }) : _userRepository = userRepository ?? UserRepository();

  final Business business;
  final UserRepository _userRepository;

  User? get currentUser => _userRepository.getCurrentSession()?.user;

  bool get isOwner => currentUser?.id == business.owner.id;
}
