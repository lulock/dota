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
		}
	],
	"Competences": [
		{
			"name": "C-GoToLane",
			"goals": [],
			"elements": [
				{
					"name": "CE-GoToCorrectLane",
					"Senses": [
						{
							"name": "IsFarmingTime",
							"value": "1",
							"comparator": "bool"
						}
					],
					"element": "AP-PlaceWardInLane"
				},
				{
					"name": "CE-GoToCreepWave",
					"Senses": [],
					"element": ""
				},
				{
					"name": "CE-LastHit",
					"Senses": [],
					"element": ""
				}
			]
		},
		{
			"name": "C-lastHitFarm",
			"goals": [],
			"elements": [
				{
					"name": "C-GoToLane"
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
					"name": "EnemyNearby",
					"value": "1",
					"comparator": "bool"
				}
			]
		},
		{
			"name": "DE-WardDefensive",
			"element":
			{
				"name": "AP-PlaceWardInLane"
			},
			"checkTime": "0",
			"Senses": [
				{
					"name": "HasObserverWard",
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