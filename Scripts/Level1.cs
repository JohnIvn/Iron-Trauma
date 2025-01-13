using Godot;
using System;

public partial class Level1 : Node2D
{
	private Submarine submarine; // Reference to the submarine
	private Sprite2D background; // Reference to the Sprite2D node for background

	public override void _Ready()
	{
		// Get the reference to the Submarine node (assuming it's a child of the Level1 node)
		submarine = GetNode<Submarine>("Submarine");

		// Get the reference to the Sprite2D node directly by name
		background = GetNode<Sprite2D>("Sprite2D");  // Ensure this path matches your scene structure
	}

	public override void _Process(double delta)
	{
		if (submarine != null && background != null)
		{
			float depth = submarine.GetDepth();
			GD.Print("Submarine Depth in Level1: " + depth);

			// Normalize the depth to a range (example: 0 to 1 based on the maximum depth)
			float normalizedDepth = Mathf.Clamp(depth / 500.0f, 0.0f, 1.0f);

			// Darken the blue as the depth increases (adjust these values as needed)
			float blueIntensity = Mathf.Lerp(0.6f, 0.1f, normalizedDepth);  // The blue color gets darker with depth

			// Apply the modulate effect using the background sprite's color
			Color depthColor = new Color(0.0f, 0.0f, blueIntensity);  // RGB values (R, G, B)

			// Set the modulate color to darken the sprite's color
			background.Modulate = depthColor;
		}
	}
}
