local x = [[{
	"ActionPatterns": [
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
			"name": "AP-PlaceWardInLane",
			"actions": [
				{
					"name": "SelectWardLocation"
				},
				{
					"name": "GoToLocation"
				},
				{
					"name": "PlaceObserverWard"
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
					"name": "GoToCore"
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
					"name": "TeleportToLocation"
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
		},
		{
			"name": "AP-HealAlly",
			"actions": [
				{
					"name": "CastHealingAbility"
				}
			]
		}
	],
	"Competences": [
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
		}
	],
	"DriveElements": [
		{
			"name": "DE-Heal",
			"element":
			{
				"name": "AP-HealAlly"
			},
			"checkTime": "0",
			"Senses": [
				{
					"name": "NearbyAllyHasLowHealth",
					"value": "1",
					"comparator": "bool"
				}
			]
		},
		{
			"name": "DE-Retreat",
			"element":
			{
				"name": "AP-GoToSafeLocation"
			},
			"checkTime": "0",
			"Senses": [
				{
					"name": "HasLowHealth",
					"value": "1",
					"comparator": "bool"
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
		}
	]
}]]

return x