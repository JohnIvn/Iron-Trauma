using Godot;
using System;

public partial class Player : CharacterBody2D
{
	public const float Speed = 300.0f;

	private AnimationPlayer _animationPlayer;

	public override void _Ready()
	{
		// Ensure the path matches the node's actual location in the scene
		_animationPlayer = GetNode<AnimationPlayer>("WalkingAnimation");

		if (_animationPlayer == null)
		{
			GD.PrintErr("AnimationPlayer node not found in player.tscn. Check the node path or structure.");
		}
	}

	public override void _PhysicsProcess(double delta)
	{
		Vector2 velocity = Velocity;

		// Get movement input
		Vector2 direction = Input.GetVector("move_left", "move_right", "move_up", "move_down");

		if (direction != Vector2.Zero)
		{
			direction = direction.Normalized();
		}

		velocity = direction * Speed;

		if (_animationPlayer != null)
		{
			if (direction.X > 0) 
			{
				_animationPlayer.Play("walking_right");
			}
			else if (direction.X < 0) 
			{
				_animationPlayer.Play("walking_left");
			}
		}

		Velocity = velocity;
		MoveAndSlide();
	}
}
