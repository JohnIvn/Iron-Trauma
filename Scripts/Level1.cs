using Godot;
using System;

public partial class Level1 : Node2D
{
	private Submarine submarine; // Reference to the submarine

	public override void _Ready()
	{
		// Get the reference to the Submarine node (assuming it's a child of the Level1 node)
		submarine = GetNode<Submarine>("Submarine");
	}

	public override void _Process(double delta)
	{
		// You can update environmental effects here, like water visibility or tint based on depth
		if (submarine != null)
		{
			// For example, check the submarine's depth and apply some effect or behavior in the level.
			float depth = submarine.GetDepth();
			GD.Print("Submarine Depth in Level1: " + depth);
		}
	}
}
