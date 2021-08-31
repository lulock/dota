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
	"CompetenceElements": [
		{
			"name": "CE-GoToCorrectLane",
			"Senses": [

			],
			"element": "C-GoToLane"
		},
		{
			"name": "CE-GoToCreepWave",
			"Senses": [

			],
			"element": ""
		},
		{
			"name": "CE-LastHit",
			"Senses": [

			],
			"element": ""
		}

	],
	"Competences": [
		{
			"name": "C-lastHitFarm",
			"goals": [

			],
			"elements": [
				{
					"name" : "CE-GoToCorrectLane"
				},
				{
					"name" : "CE-GoToCreepWave"
				},
				{
					"name" : "CE-LastHit"
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