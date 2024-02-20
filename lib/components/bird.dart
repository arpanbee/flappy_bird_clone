import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flappy_bird_game/game/bird_movement.dart';
import 'package:flappy_bird_game/game/assets.dart';
import 'package:flappy_bird_game/game/configuration.dart';
import 'package:flappy_bird_game/game/flappy_bird_game.dart';
import 'package:flutter/material.dart';

class Bird extends SpriteGroupComponent<BirdMovement>
    with HasGameRef<FlappyBirdGame>, CollisionCallbacks {
  Bird();

  int score = 0;

  @override
  Future<void> onLoad() async {
    final birdMidFlap = await gameRef.loadSprite(Assets.birdMidFlap);
    final birdUpFlap = await gameRef.loadSprite(Assets.birdUpFlap);
    final birdDownFlap = await gameRef.loadSprite(Assets.birdDownFlap);

    gameRef.bird;

    size = Vector2(50, 40);
    //position = Vector2(50, gameRef.size.y / 2 - size.y / 2);
    position = Vector2(50, gameRef.size.y - Config.groundHeight - size.y - 5);
    current = BirdMovement.middle;
    sprites = {
      BirdMovement.middle: birdMidFlap,
      BirdMovement.up: birdUpFlap,
      BirdMovement.down: birdDownFlap,
    };

    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (current == BirdMovement.middle) {
      print('dont do anything');
    } else if (position.y > gameRef.size.y - Config.groundHeight - size.y - 5){
      print('dont do anything');
      current = BirdMovement.middle;
    } else {
      position.y += Config.birdVelocity * dt;
    }
    if (position.y < 1) {
      gameOver();
    }
  }

  void fly() {
    if (current == BirdMovement.up || current == BirdMovement.down){
      print('test');
    } else {
      add(
        MoveByEffect(
          Vector2(0, Config.gravity),
          EffectController(duration: 0.2, curve: Curves.decelerate),
          onComplete: () => current = BirdMovement.down,
        ),
      );
      FlameAudio.play(Assets.flying);
      current = BirdMovement.up;
    }

  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    //gameOver();
     updateScore();
  }

  void reset() {
    Vector2(50, gameRef.size.y - Config.groundHeight - size.y - 5);
    score = 0;
  }

  void gameOver() {
    FlameAudio.play(Assets.collision);
    game.isHit = true;
    gameRef.overlays.add('gameOver');
    gameRef.pauseEngine();
  }

  void updateScore() {
    gameRef.bird.score += 1;
    FlameAudio.play(Assets.point);
  }
}
