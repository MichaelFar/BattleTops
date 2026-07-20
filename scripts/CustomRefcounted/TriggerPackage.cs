using Godot;
using System;

[GlobalClass]
public partial class TriggerPackage : Resource
{
    [Export]
    public Callable triggerMethod;
    [Export]
    public int requestedSignalEnum;
}
