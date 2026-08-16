class HelloWeb extends WebApplication
    notplaceable;

event Query(WebRequest Request, WebResponse Response)
{
    local int I;
    
    LogInternal("Query received" @ string(Request) @ string(Response));
    if (Request.UserName != "test" || Request.Password != "test")
    {
        Response.FailAuthentication("HelloWeb");
        return;
    }
    switch (Request.URI)
    {
        case "/form.html":
            Response.SendText("<form method=post action=submit.html>");
            Response.SendText("<input type=edit name=TestEdit>");
            Response.SendText("<p><select multiple name=selecter>");
            Response.SendText("<option value=\"one\">Number One");
            Response.SendText("<option value=\"two\">Number Two");
            Response.SendText("<option value=\"three\">Number Three");
            Response.SendText("<option value=\"four\">Number Four");
            Response.SendText("</select><p>");
            Response.SendText("<input type=submit name=Submit value=Submit>");
            Response.SendText("</form>");
            break;
        case "/submit.html":
            Response.SendText("Thanks for submitting the form.<br>");
            Response.SendText("TestEdit was \"" $ Request.GetVariable("TestEdit") $ "\"<p>");
            Response.SendText("You selected these items:<br>");
            for (I = Request.GetVariableCount("selecter") - 1; I >= 0; I--)
            {
                Response.SendText("\"" $ Request.GetVariableNumber("selecter", I) $ "\"<br>");
            }
            break;
        case "/include.html":
            Response.Subst("variable1", "This is variable 1");
            Response.Subst("variable2", "This is variable 2");
            Response.Subst("variable3", "This is variable 3");
            Response.IncludeUHTM("testinclude.html");
            break;
        default:
            Response.SendText("Hello web!  The current level is " $ WorldInfo.Title);
            Response.SendText("<br>Click <a href=\"form.html\">this link</a> to go to a test form");
            break;
    }
}

function Init()
{
    LogInternal("HelloWeb INIT");
}

defaultproperties
{
}
