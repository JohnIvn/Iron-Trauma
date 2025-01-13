using Godot;
using System;

public partial class Submarine : Node2D
{
	public const float Speed = 200.0f; // Movement speed (though we won't use it here)
	public const float DepthChangeRate = 10.0f; // Rate at which the submarine changes depth
	private float depth = 0.0f; // Track the depth of the submarine

	// Getter for depth if you need to access it elsewhere
	public float GetDepth()
	{
		return depth;
	}

	public override void _Ready()
	{
		// Initialize any values or set up components.
	}

	public override void _Process(double delta)
	{
		// Vector to represent the vertical direction of movement
		float direction = 0.0f;

		// Move up when "Q" is pressed
		if (Input.IsActionPressed("move_up")) 
		{
			direction -= 1; // Move up (decrease depth)
		}

		// Move down when "E" is pressed
		if (Input.IsActionPressed("move_down")) 
		{
			direction += 1; // Move down (increase depth)
		}

		// Only update the depth if there is any input
		if (direction != 0)
		{
			depth += (float)delta * DepthChangeRate * direction;
		}

		// Log the current depth (for debugging purposes)
		GD.Print("Depth: " + depth);
	}
}
