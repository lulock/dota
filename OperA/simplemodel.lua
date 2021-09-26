local x = [[{
	"norms": [
		{
                  "name" : "farm",
                  "behaviour" : "DE-FarmLane",
                  "operator" : "PERMITTED"
            },
            {
                  "name" : "support",
                  "behaviour" : "DE-Support",
                  "operator" : "OBLIGED"
		}
	],
	"scenes": [
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
                            "name" : "support"
                        }
                  ]
		}
	]
}]]

return x