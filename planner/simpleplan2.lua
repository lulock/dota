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
					"name": "EnemyNearby",
					"value": "0",
					"comparator": "bool"
				}
			],
			"elements": [
				{
					"name": "CE-EnemyRightClick",
					"Senses": [
						{
							"name": "EnemyHeroNearby",
							"value": "1",
							"comparator": "bool"
						}
					],
					"element": "AP-RightClickAttack"
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
							"name": "HasHighestPriorityAround",
							"value": "1",
							"comparator": "bool"
						},
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
					"name": "IsFarFromCarry",
					"value": "1",
					"comparator": "bool"
				}
			]
		},
	]
}]]

return x