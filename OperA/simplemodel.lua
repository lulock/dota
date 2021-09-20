local x = [[{
	"norms": [
		{
                  "name" : "farm",
                  "behaviour" : "DE-FarmLane",
                  "operator" : "PERMITTED"
            },
            {
                  "name" : "ward",
                  "behaviour" : "DE-WardDefensive",
                  "operator" : "OBLIGED"
		}
	],
	"scenes": [
		{
                  "name" : "wardingTime",
                  "roles" : [],
                  "landmarks" : [
				{
					"name": "IsWardingTime",
					"value": "1",
					"comparator": "bool"
				}
			],
                  "results" : [
				{
					"name": "IsWardingTime",
					"value": "0",
					"comparator": "bool"
				}
                  ],
                  "norms" : [
                        {
                              "name" : "ward"
                        }
                  ]
		},
		{
                  "name" : "farmingTime",
                  "roles" : [],
                  "landmarks" : [
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
			],
                  "results" : [
				{
					"name": "IsFarmingTime",
					"value": "0",
					"comparator": "bool"
				}
                  ],
                  "norms" : [
                        {
                              "name" : "farm"
                        }
                  ]
		}
	]
}]]

return x