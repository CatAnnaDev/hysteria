class WebRequest extends Object
    native
    notplaceable;

enum ERequestType
{
    Request_GET,
    Request_POST,
};

var string RemoteAddr;
var string URI;
var string UserName;
var string Password;
var int ContentLength;
var string ContentType;
var ERequestType RequestType;
var const native Map_Mirror HeaderMap;
var const native Map_Mirror VariableMap;

function int GetHexDigit(string D)
{
    switch (Caps(D))
    {
        case "0":
            return 0;
        case "1":
            return 1;
        case "2":
            return 2;
        case "3":
            return 3;
        case "4":
            return 4;
        case "5":
            return 5;
        case "6":
            return 6;
        case "7":
            return 7;
        case "8":
            return 8;
        case "9":
            return 9;
        case "A":
            return 10;
        case "B":
            return 11;
        case "C":
            return 12;
        case "D":
            return 13;
        case "E":
            return 14;
        case "F":
            return 15;
        default:
            return -1;
    }
}

function DecodeFormData(string Data)
{
    local string Token[2], ch;
    local int I, H1, H2, Limit, T;
    
    T = 0;
    for (I = 0; I < Len(Data); I++)
    {
        if (Limit > class'WebConnection'.default.default.MaxValueLength || I > class'WebConnection'.default.default.MaxLineLength)
        {
            break;
        }
        ch = Mid(Data, I, 1);
        switch (ch)
        {
            case "+":
                Token[T] $= " ";
                Limit++;
                continue;
            case "&":
            case "?":
                if (Token[0] != "")
                {
                    AddVariable(Token[0], Token[1]);
                }
                Token[0] = "";
                Token[1] = "";
                T = 0;
                Limit = 0;
                continue;
            case "=":
                if (T == 0)
                {
                    Limit = 0;
                    T = 1;
                }
                else
                {
                    Token[1] $= "=";
                    Limit++;
                }
                continue;
            case "%":
                H1 = GetHexDigit(Mid(Data, ++I, 1));
                if (H1 != -1)
                {
                    Limit++;
                    H1 *= float(16);
                    H2 = GetHexDigit(Mid(Data, ++I, 1));
                    if (H2 != -1)
                    {
                        Token[T] $= Chr(H1 + H2);
                    }
                }
                Limit++;
                continue;
            default:
                Token[T] $= ch;
                Limit++;
        }
    }
    if (Token[0] != "")
    {
        AddVariable(Token[0], Token[1]);
    }
}

function ProcessHeaderString(string S)
{
    local int I;
    
    if (Left(S, 21) ~= "Authorization: Basic ")
    {
        S = DecodeBase64(Mid(S, 21));
        I = InStr(S, ":");
        if (I != -1)
        {
            UserName = Left(S, I);
            Password = Mid(S, I + 1);
        }
    }
    else if (Left(S, 16) ~= "Content-Length: ")
    {
        ContentLength = int(Mid(S, 16, 64));
    }
    else if (Left(S, 14) ~= "Content-Type: ")
    {
        ContentType = Mid(S, 14);
    }
    I = InStr(S, ":");
    if (I > -1)
    {
        AddHeader(Left(S, I), Mid(S, I + 2));
    }
}

native final function Dump()
{
}

native final function GetVariables(out array<string> varNames)
{
    varNames;
}

native final function string GetVariableNumber(string VariableName, int Number, optional string DefaultValue)
{
    VariableName;
    Number;
    DefaultValue;
}

native final function int GetVariableCount(string VariableName)
{
    VariableName;
}

native final function string GetVariable(string VariableName, optional string DefaultValue)
{
    VariableName;
    DefaultValue;
}

native final function AddVariable(string VariableName, coerce string Value)
{
    VariableName;
    Value;
}

native final function GetHeaders(out array<string> headers)
{
    headers;
}

native final function string GetHeader(string HeaderName, optional string DefaultValue)
{
    HeaderName;
    DefaultValue;
}

native final function AddHeader(string HeaderName, coerce string Value)
{
    HeaderName;
    Value;
}

native final function string EncodeBase64(string Decoded)
{
    Decoded;
}

native final function string DecodeBase64(string Encoded)
{
    Encoded;
}

defaultproperties
{
}
