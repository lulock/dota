local x = [[{
	"ActionPatterns": [
		{
			"name": "AP-EvadeAttack",
			"actions": [
				{
					"name": "EvadeAttack"
				}
			]
		},
		{
			"name": "AP-GoToSafeLocation",
			"actions": [
				{
					"name": "SelectSafeLocation"
				},
				{
					"name": "GoToLocation"
				}
			]
		},
		{
			"name": "AP-Idle",
			"actions": [
				{
					"name": "Idle"
				}
			]
		},
		{
			"name": "AP-BuyHealItem",
			"actions": [
				{
					"name": "BuyHealItem"
				},
				{
					"name": "CourierStashedItems"
				}
			]
		},
		{
			"name": "AP-HealItem",
			"actions": [
				{
					"name": "HealItem"
				}
			]
		},
		{
			"name": "AP-HealAbility",
			"actions": [
				{
					"name": "HealAbility"
				}
			]
		},
		{
			"name": "AP-GoToLane",
			"actions": [
				{
					"name": "GoToCreepWave"
				}
			]
		},
		{
			"name": "AP-Follow",
			"actions": [
				{
					"name": "GoToPartner"
				}
			]
		},
		{
			"name": "AP-Heal",
			"actions": [
				{
					"name": "HealSelf"
				}
			]
		},
		{
			"name": "AP-TeleportToLaneTower",
			"actions": [
				{
					"name": "SelectLaneTowerLocation"
				},
				{
					"name": "TpToLocation"
				}
			]
		},
		{
			"name": "AP-TeleportToBase",
			"actions": [
				{
					"name": "SelectSafeLocation"
				},
				{
					"name": "TpToLocation"
				}
			]
		},
		{
			"name": "AP-RightClickAttack",
			"actions": [
				{
					"name": "SelectTarget"
				},
				{
					"name": "RightClickAttack"
				}
			]
		},
		{
			"name": "AP-RightClickAttackHero",
			"actions": [
				{
					"name": "SelectHeroTarget"
				},
				{
					"name": "RightClickAttack"
				}
			]
		},
		{
			"name": "AP-CastAbilityAttack",
			"actions": [
				{
					"name": "SelectHeroTarget"
				},
				{
					"name": "SelectAbility"
				},
				{
					"name": "CastAbility"
				}
			]
		}
	],
	"Competences": [
		{
			"name": "C-Heal",
			"goals": [
				{
					"name": "Health",
					"value": "80",
					"comparator": ">"
				}
			],
			"elements": [
				{
					"name": "CE-UseHealingAbility",
					"Senses": [
						{
							"name": "IsAbilityAvailable",
							"value": "1",
							"comparator": "bool",
							"arg": "witch_doctor_voodoo_restoration"
						}
					],
					"element": "AP-HealAbility"
				},
				{
					"name": "CE-UseHealingItem",
					"Senses": [
						{
							"name": "IsItemAvailable",
							"value": "1",
							"comparator": "bool",
							"arg": "item_flask"
						}
					],
					"element": "AP-HealItem"
				},
				{
					"name": "CE-BuyHealingItem",
					"Senses": [
						{
							"name": "EnoughGoldForItem",
							"value": "1",
							"comparator": "bool",
							"arg": "item_flask"
						},
						{
							"name": "IsItemStashed",
							"value": "0",
							"comparator": "bool",
							"arg": "item_flask"
						},
						{
							"name": "CourierAvailable",
							"value": "1",
							"comparator": "bool"
						}
					],
					"element": "AP-BuyHealItem"
				},
				{
					"name": "CE-Retreat",
					"Senses": [
						{
							"name": "IsWalkableDistance",
							"value": "1",
							"comparator": "bool"
						}
					],
					"element": "AP-GoToSafeLocation"
				}
			]
		},
		{
			"name": "C-GoToLane",
			"goals": [
				{
					"name": "IsCorrectLane",
					"value": "1",
					"comparator": "bool"
				}
			],
			"elements": [
				{
					"name": "CE-Walk",
					"Senses": [
						{
							"name": "IsWalkableDistance",
							"value": "1",
							"comparator": "bool"
						}
					],
					"element": "AP-GoToLane"
				},
				{
					"name": "CE-Teleport",
					"Senses": [
						{
							"name": "IsScrollAvailable",
							"value": "1",
							"comparator": "bool"
						}
					],
					"element": "AP-TeleportToLaneTower"
				}
			]
		},
		{
			"name": "C-LastHitAttack",
			"goals": [
				{
					"name": "IsLastHit",
					"value": "1",
					"comparator": "bool"
				}
			],
			"elements": [
				{
					"name": "CE-RightClick",
					"Senses": [
						{
							"name": "CreepWithinRightClickRange",
							"value": "1",
							"comparator": "bool"
						},
						{
							"name": "CreepCanBeLastHit",
							"value": "1",
							"comparator": "bool"
						}
					],
					"element": "AP-RightClickAttack"
				},
				{
					"name": "CE-Teleport",
					"Senses": [
						{
							"name": "IsScrollAvailable",
							"value": "1",
							"comparator": "bool"
						}
					],
					"element": "AP-TeleportToLaneTower"
				}
			]
		},
		{
			"name": "C-Harass",
			"goals": [
				{
					"name": "FarmLaneDesire",
					"value": "0",
					"comparator": "bool"
				}
			],
			"elements": [
				{
					"name": "CE-GoToCorrectLane",
					"Senses": [
						{
							"name": "IsCorrectLane",
							"value": "0",
							"comparator": "bool"
						}
					],
					"element": "C-GoToLane"
				},
				{
					"name": "CE-EnemyAbility",
					"Senses": [
						{
							"name": "EnemyNearby",
							"value": "1",
							"comparator": "bool"
						},
						{
							"name": "IsAbilityCastable",
							"value": "1",
							"comparator": "bool"
						}
					],
					"element": "AP-CastAbilityAttack"
				},
				{
					"name": "CE-EnemyRightClick",
					"Senses": [
						{
							"name": "EnemyNearby",
							"value": "1",
							"comparator": "bool"
						}
					],
					"element": "AP-RightClickAttackHero"
				}
			]
		},
		{
			"name": "C-LastHitFarm",
			"goals": [
				{
					"name": "FarmLaneDesire",
					"value": "0",
					"comparator": "bool"
				}
			],
			"elements": [
				{
					"name": "CE-GoToCorrectLane",
					"Senses": [
						{
							"name": "IsCorrectLane",
							"value": "0",
							"comparator": "bool"
						}
					],
					"element": "C-GoToLane"
				},
				{
					"name": "CE-LastHit",
					"Senses": [
						{
							"name": "EnemyCreepNearby",
							"value": "1",
							"comparator": "bool"
						}
					],
					"element": "AP-RightClickAttack"
				},
				{
					"name": "CE-GoToCreepWave",
					"Senses": [
						{
							"name": "IsCorrectLane",
							"value": "0",
							"comparator": "bool"
						}
					],
					"element": "C-GoToLane"
				}
			]
		},
		{
			"name": "C-Retreat",
			"goals": [
				{
					"name": "Health",
					"value": "0.8",
					"comparator": ">"
				}
			],
			"elements": [
				{
					"name": "CE-TpRetreat",
					"Senses": [
						{
							"name": "IsScrollAvailable",
							"value": "1",
							"comparator": "bool"
						},
						{
							"name": "IsUnderAttack",
							"value": "1",
							"comparator": "bool"
						}
					],
					"element": "AP-TeleportToBase"
				},
				{
					"name": "CE-Retreat",
					"Senses": [
						{
							"name": "IsWalkableDistance",
							"value": "1",
							"comparator": "bool"
						}
					],
					"element": "AP-GoToSafeLocation"
				}
			]
		}
	],
	"DriveElements": [
		{
			"name": "DE-Heal",
			"element": 
			{
				"name": "C-Heal"
			},
			"checkTime": "0",
			"Senses": [
				{
					"name": "Health",
					"value": "0.8",
					"comparator": "<"
				}
			]
		},
		{
			"name": "DE-Retreat",
			"element":
			{
				"name": "C-Retreat"
			},
			"checkTime": "0",
			"Senses": [
				{
					"name": "Health",
					"value": "0.8",
					"comparator": "<"
				},
				{
					"name": "RecentlyUnderAttack",
					"value": "1",
					"comparator": "bool",
					"arg": "10"
				}
			]
		},
		{
			"name": "DE-Harass",
			"element": 
			{
				"name": "C-Harass"
			},
			"checkTime": "0",
			"Senses": [
				{
					"name": "EnemyNearby",
					"value": "1",
					"comparator": "bool"
				}
			]
		},
		{
			"name": "DE-FarmLane",
			"element": 
			{
				"name": "C-LastHitFarm"
			},
			"checkTime": "0",
			"Senses": [
				{
					"name": "IsFarmingTime",
					"value": "1",
					"comparator": "bool"
				},
				{
					"name": "IsSafeToFarm",
					"value": "1",
					"comparator": "bool"
				}
			]
		},
		{
			"name": "DE-Idle",
			"element": 
			{
				"name": "AP-Idle"
			},
			"checkTime": "0",
			"Senses": [
				{
					"name": "EnemyNearby",
					"value": "0",
					"comparator": "bool"
				}
			]
		},
		{
			"name": "DE-Support",
			"element":
			{
				"name": "AP-Follow"
			},
			"checkTime": "0",
			"Senses": [
				{
					"name": "IsFarFromPartner",
					"value": "1",
					"comparator": "bool"
				}
			]
		},
	]
}]]

return x