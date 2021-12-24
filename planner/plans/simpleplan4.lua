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
				},
				{
					"name": "SelectTarget"
				},
				{
					"name": "RightClickAttack"
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
			"name": "DE-GoToLane",
			"element":
			{
				"name": "AP-GoToLane"
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
	]
}]]

return x