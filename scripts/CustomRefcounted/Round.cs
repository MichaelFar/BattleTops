using Godot;
using Godot.Collections;
using System;
using System.Collections.Generic;

[GlobalClass]
public partial class Round : Resource
{
    [Export]
    public Vector2 staminaVector = new Vector2(1,1);
    [Export]
    public Vector2 sturdinessVector = new Vector2(1, 1);
    [Export]
    public Vector2 spinforceVector = new Vector2(1, 1);

    [Export]
    public int round;
}
