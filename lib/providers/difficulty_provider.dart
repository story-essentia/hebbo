import '../repositories/i_difficulty_repository.dart';

class DifficultyProvider {
  final IDifficultyRepository difficultyRepository;

  DifficultyProvider({
    required this.difficultyRepository,
  });
}
