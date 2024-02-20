import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flappy_bird_game/game/assets.dart';
import 'package:flappy_bird_game/game/configuration.dart';
import 'package:flappy_bird_game/game/flappy_bird_game.dart';
import 'package:flappy_bird_game/game/pipe_position.dart';
import 'package:flappy_bird_game/components/pipe.dart';
import 'package:flutter/material.dart';

class PipeGroup extends PositionComponent with HasGameRef<FlappyBirdGame> {
  PipeGroup();

  final _random = Random();
  final _valid = Random();

  @override
  Future<void> onLoad() async {
    position.x = gameRef.size.x;

    bool isValid = false;
    final heightMinusGround = gameRef.size.y - Config.groundHeight;
    final spacing = 100 + _random.nextDouble() * (heightMinusGround / 4);
    final centerY =
        spacing + _random.nextDouble() * (heightMinusGround - spacing);

    final int randomNumber = _valid.nextInt(100);
    if (randomNumber % 2 == 0){
      print('this is valid');
      isValid = true;
    }

    final textPaint = TextPaint(style: TextStyle(fontSize: 24.0, color: Colors.white, fontFamily: 'Arial'));
    final textComponent = TextComponent(
      text: isValid ? 'VALID' : 'INVALID',
      textRenderer: textPaint,
      // Position the text relative to the sprite's position
      position: Vector2(10.0, 10.0), // Adjust these values as needed
    );



    addAll([
      //Pipe(pipePosition: PipePosition.top, height: centerY - spacing / 2),
      Pipe(
          pipePosition: PipePosition.bottom,
          height: heightMinusGround - (centerY + spacing / 2),
          isValid: isValid),
          textComponent
      ]);
  }

  void updateScore() {
    gameRef.bird.score += 1;
    FlameAudio.play(Assets.point);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= Config.gameSpeed * dt;

    if (position.x < -10) {
      removeFromParent();
      updateScore();
    }

    if (gameRef.isHit) {
      removeFromParent();
      gameRef.isHit = false;
    }
  }
}