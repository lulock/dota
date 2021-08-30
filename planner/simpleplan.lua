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
	"CompetenceElements": [],
	"Competences": [],
	"DriveElements": [
		{
			"name": "DE-Retreat",
			"triggers": [
				{
					"name": "AP-GoToSafeLocation"
				}
			],
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
			"triggers": [
				{
					"name": "AP-PlaceWardInLane"
				}
			],
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
			"triggers": [
				{
					"name": "AP-Idle"
				}
			],
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