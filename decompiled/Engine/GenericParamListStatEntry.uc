class GenericParamListStatEntry extends Object
    native
    notplaceable;

var native transient Pointer StatEvent;
var transient GameplayEventsWriter Writer;

native function CommitToDisk()
{
}

native function bool GetString(name ParamName, out string out_string)
{
    ParamName;
    out_string;
}

native function bool GetVector(name ParamName, out Vector out_vector)
{
    ParamName;
    out_vector;
}

native function bool GetInt(name ParamName, out int out_int)
{
    ParamName;
    out_int;
}

native function bool GetFloat(name ParamName, out float out_Float)
{
    ParamName;
    out_Float;
}

native function AddString(name ParamName, coerce string Value)
{
    ParamName;
    Value;
}

native function AddVector(name ParamName, Vector Value)
{
    ParamName;
    Value;
}

native function AddInt(name ParamName, int Value)
{
    ParamName;
    Value;
}

native function AddFloat(name ParamName, float Value)
{
    ParamName;
    Value;
}

defaultproperties
{
}
