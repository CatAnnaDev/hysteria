class PBRuleNodeBase extends Object
    abstract
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object);

struct native PBRuleLink
{
    var() export editinline PBRuleNodeBase NextRule;
    var() name LinkName;
    var editoronly int DrawY;
};

var editfixedsize array<PBRuleLink> NextRules;
var() editoronly string Comment;
var editoronly int RulePosX;
var editoronly int RulePosY;
var editoronly int InDrawY;
var editoronly int DrawWidth;
var editoronly int DrawHeight;

defaultproperties
{
    NextRules(0)=(NextRule="None",LinkName="Next",DrawY=0)
}
