class SpeechRecognition extends Object
    native
    notplaceable
    collapsecategories
    hidecategories(Object);

struct native RecogUserData
{
    var int ActiveVocabularies;
    var array<byte> UserData;
};

struct native RecogVocabulary
{
    var() array<RecognisableWord> WhoDictionary;
    var() array<RecognisableWord> WhatDictionary;
    var() array<RecognisableWord> WhereDictionary;
    var string VocabName;
    var array<byte> VocabData;
    var array<byte> WorkingVocabData;
};

struct native RecognisableWord
{
    var() int Id;
    var() string ReferenceWord;
    var() string PhoneticWord;
};

var() string Language;
var() float ConfidenceThreshhold;
var() array<RecogVocabulary> Vocabularies;
var array<byte> VoiceData;
var array<byte> WorkingVoiceData;
var array<byte> UserData;
var RecogUserData InstanceData[4];
var transient duplicatetransient bool bDirty;
var transient duplicatetransient bool bInitialised;
var const native duplicatetransient Pointer FnxVoiceData;

defaultproperties
{
    Language="INT"
    ConfidenceThreshhold=50.0
}
