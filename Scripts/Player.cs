using Godot;
using System;

public partial class Player : CharacterBody2D
{
	public const float Speed = 300.0f;

	public override void _PhysicsProcess(double delta)
	{
		Vector2 velocity = Velocity;

		// Get the input direction for movement (left, right, up, down)
		Vector2 direction = Input.GetVector("ui_left", "ui_right", "ui_up", "ui_down");

		// Normalize the direction vector to avoid faster diagonal movement
		if (direction != Vector2.Zero)
		{
			direction = direction.Normalized();
		}

		// Update velocity based on input direction
		velocity = direction * Speed;

		// Apply the velocity to the character's movement
		Velocity = velocity;
		MoveAndSlide();
	}
}
