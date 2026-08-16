#ifndef COOP_OFFSETS_H
#define COOP_OFFSETS_H

#define O_OBJ_INDEX         0x04
#define O_UOBJ_OUTER        0x28
#define O_UOBJ_NAMEIDX      0x2c
#define O_UOBJ_NAMENUM      0x30
#define O_UOBJ_CLASS        0x34

#define O_ACTOR_FLAGS0      0x3c
#define   F_bStatic             0x00000008u
#define   F_bHidden             0x00000010u
#define   F_bDeleteMe           0x00000080u
#define   F_bPushedByEncroachers 0x00008000u
#define   F_bCanStepUpOn        0x00200000u
#define O_ACTOR_FLAGS1      0x40
#define   F_bCanBeDamaged       0x10000000u
#define O_ACTOR_FLAGS2      0x44
#define   F_bProjTarget         0x00000100u
#define   F_bCollideActors      0x00000010u
#define   F_bCollideWorld       0x00000020u
#define   F_bBlockActors        0x00000080u
#define O_ACTOR_COMPONENTS  0x4c
#define O_LOCATION          0x64
#define O_DRAWSCALE         0x7c
#define O_ROTATION          0x70
#define O_PHYSICS           0xa0
#define O_REMOTEROLE        0xa1
#define O_ROLE              0xa2
#define O_OWNER             0xa8
#define O_WORLDINFO         0x134
#define O_LIFESPAN          0x138
#define O_LASTRENDERTIME    0x140
#define O_VELOCITY          0x188
#define O_ACCELERATION      0x194

#define O_PAWN_MAXSTEPHEIGHT 0x228
#define O_PAWN_CONTROLLER   0x238
#define O_PAWN_FLAGS0       0x24c
#define   F_bIsWalking          0x00000002u
#define   F_bIsCrouched         0x00000008u
#define   F_bAvoidLedges        0x00008000u
#define   F_bIgnoreForces       0x00040000u
#define   F_bCanWalkOffLedges   0x00080000u
#define O_PAWN_FLAGS1       0x250
#define   F_bRollToDesired      0x00000100u
#define   F_bDontPossess        0x00000040u
#define   F_bRunPhysicsWithNoController 0x00008000u
#define   F_bDesiredRotationSet 0x00400000u
#define   F_bLockDesiredRotation 0x00800000u
#define O_PAWN_FLAGS2       0x254
#define   F_bCanBeLockedOn      0x00000002u
#define O_PAWN_STOPATLEDGES 0x268
#define O_PAWN_LEDGETYPE    0x28c
#define O_PAWN_GROUNDSPEED  0x2f8
#define O_PAWN_ACCELRATE    0x308
#define O_PAWN_JUMPZ        0x30c
#define O_PAWN_MAXFALLSPEED 0x324
#define O_PAWN_HEALTH       0x350
#define O_PAWN_HEALTHMAX    0x354
#define O_PAWN_MESH         0x3f4
#define O_PAWN_CYLINDER     0x3f8
#define O_PAWN_DESIREDROT   0x420
#define O_PAWN_WEAPON       0x440

#define O_AGP_BLOCKA        0x5ec
#define   AGP_BLOCKA_LEN    18
#define O_AGP_FLAGS0        0x658
#define O_AGP_FLAGS1        0x65c
#define   F_bForceDesiredRotation 0x00000800u
#define O_AGP_SMFLAGS       0x67c
#define O_AGP_MAXWALK       0x6a4
#define O_AGP_MAXRUN        0x6a8

#define O_AP_F99C           0x99c
#define   F_bInLondon           0x00000200u
#define   F_bStopUpdating       0x40000000u
#define O_AP_F9A0           0x9a0
#define   F_bHoldingWatch       0x00000002u
#define   F_bShouldBeHide       0x00002000u
#define O_AP_F9A4           0x9a4
#define O_AP_BLOCKB         0xa60
#define   AP_BLOCKB_LEN     10
#define   BLKB_ARCHETYPE    5
#define   BLKB_DRESS        7
#define   BLKB_PENDINGDRESS 8
#define O_AP_CURHEALTHLEVEL 0x2190
#define O_AP_NBATTACHEDNPC  0x23dc
#define O_AP_HYSTERIALEFT   0x23f0

#define O_CTRL_PAWN         0x22c
#define O_PC_PLAYERCAMERA   0x3c8
#define O_PC_MYHUD          0x42c
#define O_APC_MYALICEPAWN   0x614

#define O_CAM_FLAGS         0x238
#define   F_bNonGamePlayCamera 0x00000020u
#define O_CAM_POV           0x36c
#define O_CAM_ASPECT        0x3a8

#define O_WI_KILLZ          0x228
#define O_WI_TIMEDILATION   0x3e0
#define O_WI_TIMESECONDS    0x3e8
#define O_WI_DELTASECONDS   0x3f4
#define O_WI_PAUSER         0x408
#define O_WI_NETMODE        0x448
#define O_WI_GAME           0x470

#define O_GI_CACHEDARCHE    0x3d0
#define O_GI_ARCHETYPEID    0x560

#define O_ACOMP_FLAGS       0x50
#define   F_bNeedsUpdateTransform 0x00000008u
#define O_PRIM_FLAGS        0x128
#define   F_HiddenGame          0x00000004u
#define O_PRIM_TRANSLATION  0x1a0
#define O_PRIM_ROTATION     0x1ac
#define O_PRIM_LASTRENDER   0x1cc
#define O_CYL_HEIGHT        0x1d4
#define O_CYL_RADIUS        0x1d8
#define O_SKEL_ANIMATIONS   0x1fc
#define O_SKEL_ANIMSETS     0x284
#define O_SKEL_FORCEREFPOSE 0x33c
#define O_SKEL_NOSKELUPDATE 0x344
#define   F_bNoSkeletonUpdate   0x00000001u
#define O_SKEL_IGNORECTRL   0x358
#define O_SKEL_FLAGS_B      0x3b0
#define   F_bSkipAllUpdateWhenPhysicsAsleep 0x00000001u
#define   F_bUpdateSkelWhenNotRendered      0x00000004u
#define   F_bIgnoreControllersWhenNotRendered 0x00000008u
#define   F_bUpdateJointsFromAnimation      0x00020000u
#define   F_bPauseAnims                     0x10000000u
#define O_SKEL_CLOTHFLAGS   0x3c0
#define   F_bEnableClothSimulation          0x00000001u
#define   F_bClothFrozen                    0x00000004u
#define   F_bAutoFreezeClothWhenNotRendered 0x00000008u
#define   F_bClothWindRelativeToOwner       0x00000800u
#define O_SKEL_CLOTHFORCE   0x3fc
#define O_SKEL_CLOTHWIND    0x408
#define O_SKEL_CLOTHBLEND   0x420
#define O_SKEL_MINCLOTHRESET 0x4e4
#define O_SKEL_LASTCLOTHLOC 0x4e8
#define O_SKEL_ROOTMOTIONMODE 0x5dc
#define   RMM_IGNORE            2

#define O_ABLEND_CHILDREN   0xe0
#define O_ABLEND_CHILDNUM   0xe4
#define   ABCHILD_STRIDE    0x48
#define   ABCHILD_ANIM      0x08
#define   ABCHILD_WEIGHT    0x0c
#define O_ASEQ_NAME         0xe0
#define O_ASEQ_RATE         0xe8
#define O_ASEQ_FLAGS        0xec
#define   F_ASEQ_bPlaying       0x00000001u
#define   F_ASEQ_bLooping       0x00000002u
#define   F_ASEQ_bCauseActorAnimEnd  0x00000004u
#define   F_ASEQ_bCauseActorAnimPlay 0x00000008u
#define   F_ASEQ_bNoNotifies    0x00000080u
#define O_ASEQ_CURTIME      0xf0
#define O_ASEQ_PREVTIME     0xf4
#define O_ASEQ_ANIMSEQ      0xf8
#define O_ASEQ_LINKUP       0xfc
#define O_AGBLEND_FLAGS     0xf4
#define   F_AGB_bIsPlayingCustomAnim 0x00000008u
#define O_AGBLEND_BLENDTTG  0x104
#define O_AGBLEND_ACTIVE    0x108
#define O_AGBLEND_FLAGS2    0x10c
#define   F_AGB_bPlayActiveChild        0x00000001u
#define   F_AGB_bSkipBlendWhenNotRendered 0x00000004u
#define O_AGBLEND_CURDYN    0x114

#define O_ANIMSEQ_NAME      0x3c

#define O_SKACTOR_COMPONENT 0x22c

#define O_PICKUP_FLAGS      0x300
#define   F_bPickupHidden       0x00000002u
#define   F_bRespawnPaused      0x00000010u
#define O_APICKUP_FLAGS     0x31c
#define   F_bIsDisabled         0x00000010u
#define   F_bIsRespawning       0x00000080u
#define O_BREAK_FLAGS       0x32c
#define   F_bDestoryed          0x00000040u
#define   F_bSaveDestroyed      0x00000080u
#define O_BREAK_CURSTEP     0x3a0
#define O_CTX_FLAGS         0x250
#define   F_bContextActionStarted 0x00004000u
#define   F_bInTriggerArea      0x00010000u

#define O_ACTOR_GENEVENTS   0x208

#define O_SEQOP_FLAGS       0x8c
#define   F_SEQ_bActive         0x00000001u
#define   F_SEQ_bLatentExec     0x00000002u
#define   F_SEQ_bAutoActivateOut 0x00000004u
#define O_SEQOP_INPUTLINKS  0x90
#define O_SEQOP_OUTPUTLINKS 0x9c
#define O_SEQOP_ACTIVATECNT 0xc8
#define   SEQ_INLINK_STRIDE 0x28
#define   IL_BHASIMPULSE    0x0c
#define   IL_QUEUED         0x10
#define   SEQ_OUTLINK_STRIDE 0x30
#define   OL_BHASIMPULSE    0x18

#define O_SEQEVT_ORIGINATOR 0xdc
#define O_SEQEVT_INSTIGATOR 0xe0
#define O_SEQEVT_ACTIVATIONT 0xe4
#define O_SEQEVT_TRIGCOUNT  0xe8
#define O_SEQEVT_MAXTRIGGER 0xec
#define O_SEQEVT_RETRIGDELAY 0xf0
#define O_SEQEVT_FLAGS      0xf4
#define   F_SE_bEnabled         0x00000001u
#define   F_SE_bPlayerOnly      0x00000002u
#define   F_SE_bRegistered      0x00000004u
#define   F_SE_bClientSideOnly  0x00000008u

#define O_TOUCHEVT_FLAGS    0x118
#define   F_TE_bForceOverlap    0x00000001u
#define O_TOUCHEVT_LIST     0x11c

#define O_CTX_MAXTRIGGER    0x294
#define O_CTX_ALICE         0x2e8
#define O_CTX_APC           0x2ec

#define O_PAD_CURTRANSZ     0x2b0
#define O_PAD_FLAGS         0x2bc
#define   F_PAD_IsActived       0x00000001u
#define   F_PAD_IsTouched       0x00000002u
#define   F_PAD_IsEventTrigged  0x00000004u

#define O_BAL_WEIGHT        0x290
#define O_BAL_DESIREHEIGHT  0x294
#define O_BAL_HEIGHT        0x298
#define O_BAL_FLAGS         0x2a4
#define   F_BAL_bRotateOwner    0x00000001u
#define   F_BAL_bAliceOn        0x00000002u
#define   F_BAL_bAliceShrink    0x00000004u

#define O_MEMFRAG_FLAGS     0x464
#define   F_MF_bPickUped        0x00000001u
#define   F_MF_bPickUpedPdata   0x00000002u
#define   F_MF_bMustInteract    0x00000008u
#define O_MEMFRAG_TYPE      0x474

#define O_WPICK_CLASS       0x3f8
#define O_WPICK_FLAGS       0x3fc
#define   F_WP_bWeaponStay      0x00000001u
#define   F_WP_bIsActive        0x00000002u

#define O_HUPICK_FLAGS      0x45c
#define   F_HU_bPickUped        0x00000001u
#define   F_HU_bPickedInPdata   0x00000002u

#define O_GI_FLAGS          0x228
#define   F_GI_bLevelChange     0x00000800u
#define   F_GI_bCheckpointLoad  0x00100000u
#define O_GI_CPMANAGER      0x2f8
#define O_GI_SPEECHMANAGER  0x3f4
#define O_GI_HUDMENU        0x3fc

#define O_CPM_MAPNAME       0x228
#define O_CPM_CHAPTERNAME   0x570
#define O_CPM_LOCKSTATE     0x8b8
#define O_CPM_LASTCHECKPOINT 0x9d0
#define   CPM_CHAPTERS      70
#define   CPM_FSTRING       12

#define O_PC_CINEFLAGS      0x3d8
#define   F_PC_bCinematicMode   0x00080000u
#define O_PC_PLAYER         0x3c4
#define O_APC_FLAGS61C      0x61c
#define   F_APC_bConfirmToRespawn 0x00000080u
#define O_APC_RESPAWNLEVEL  0x6c8

#define O_AGE_PENDINGACTION 0x6e8
#define O_AGE_PENDINGFLAG   0x6e9
#define O_AGE_STARTSTATE    0x700

#define O_INTERP_PLAYRATE   0x170
#define O_INTERP_POSITION   0x174
#define O_INTERP_FLAGS      0x17c
#define   F_MAT_bIsPlaying      0x00000001u
#define   F_MAT_bPaused         0x00000002u
#define   F_MAT_bLooping        0x00000008u
#define   F_MAT_bRewindOnPlay   0x00000010u
#define   F_MAT_bReversePlayback 0x00000080u
#define   F_MAT_bIsSkippable    0x00001000u
#define O_INTERP_DATA       0x18c
#define O_INTERPDATA_LENGTH 0x94

#define O_BINK_MOVIENAME    0xf8
#define O_BINK_FLAGS        0x104
#define   F_BINK_bSkippable     0x00000001u
#define   F_BINK_bIsPlaying     0x00000002u
#define   F_BINK_bPaused        0x00000004u

#define O_CHAPTERPT_NAME    0xf8

#endif
